import 'package:app_agenda/data/database.dart';
import 'package:app_agenda/data/providers.dart';
import 'package:app_agenda/main.dart';
import 'package:app_agenda/notificacoes/agendador.dart';
import 'package:app_agenda/whatsapp/whatsapp.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  Item item(TipoItem tipo, {DateTime? inicio, DateTime? fim, bool diaInteiro = false, String? descricao}) => Item(
        id: 1,
        tipo: tipo,
        titulo: 'Dentista',
        descricao: descricao,
        inicio: inicio,
        fim: fim,
        diaInteiro: diaInteiro,
        concluida: false,
        criadoEm: DateTime(2026, 10, 1),
      );

  test('telefone vira só dígitos com o 55 do Brasil', () {
    expect(numeroParaWhatsApp('(11) 98765-4321'), '5511987654321');
    expect(numeroParaWhatsApp('011 3333-4444'), '551133334444');
    expect(numeroParaWhatsApp('+55 21 99999-0000'), '5521999990000');
    expect(numeroParaWhatsApp('1234'), isNull);
  });

  test('link com e sem contato', () {
    expect(linkDoWhatsApp('Oi, tudo bem?').toString(), 'https://wa.me/?text=Oi%2C+tudo+bem%3F');
    expect(linkDoWhatsApp('Oi', numero: '11 98765-4321').toString(), 'https://wa.me/5511987654321?text=Oi');
    expect(linkDoWhatsApp('Oi', numero: 'abc').toString(), 'https://wa.me/?text=Oi');
  });

  test('texto de tarefas e eventos', () {
    expect(textoDoItem(item(TipoItem.tarefa)), '✅ *Dentista*');
    expect(
      textoDoItem(item(TipoItem.evento, inicio: DateTime(2026, 11, 5, 14), fim: DateTime(2026, 11, 5, 15), descricao: 'Levar exames')),
      '📅 *Dentista*\nqui., 5 nov. 2026, das 14:00 às 15:00\nLevar exames',
    );
    expect(
      textoDoItem(item(TipoItem.evento, inicio: DateTime(2026, 11, 5), fim: DateTime(2026, 11, 6), diaInteiro: true)),
      '📅 *Dentista*\nqui., 5 nov. 2026',
    );
  });

  test('a lista leva só o que falta comprar', () {
    final lista = ListaCompras(id: 1, nome: 'Mercado', criadoEm: DateTime(2026));
    Produto p(String nome, {String? qtd, bool comprado = false}) =>
        Produto(id: 1, listaId: 1, nome: nome, quantidade: qtd, comprado: comprado, criadoEm: DateTime(2026));
    expect(
      textoDaLista(lista, [p('Arroz', qtd: '2 kg'), p('Leite', comprado: true), p('Café')]),
      '🛒 *Mercado*\n• Arroz (2 kg)\n• Café',
    );
    expect(textoDaLista(lista, []), '🛒 *Mercado*\nNada para comprar.');
  });

  test('o lembrete guarda o WhatsApp e monta o link da notificação', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final id = await db.criar(ItensCompanion.insert(tipo: TipoItem.tarefa, titulo: 'Remédio da mãe'));
    await db.definirLembrete(id, LembretesCompanion.insert(itemId: id, quando: DateTime(2026, 11, 1, 8)));
    expect(linkDoLembrete((await db.watchLembretesAtivos().first).single), isNull);

    await db.definirLembrete(
      id,
      LembretesCompanion.insert(
        itemId: id,
        quando: DateTime(2026, 11, 1, 8),
        whatsapp: const Value(true),
        whatsappNumero: const Value('11987654321'),
      ),
    );
    var link = linkDoLembrete((await db.watchLembretesAtivos().first).single)!;
    expect(link.path, '/5511987654321');
    expect(link.queryParameters['text'], '✅ *Remédio da mãe*');

    await db.definirLembrete(
      id,
      LembretesCompanion.insert(
        itemId: id,
        quando: DateTime(2026, 11, 1, 8),
        whatsapp: const Value(true),
        whatsappMensagem: const Value('Mãe, hora do remédio!'),
      ),
    );
    link = linkDoLembrete((await db.watchLembretesAtivos().first).single)!;
    expect(link.path, '/');
    expect(link.queryParameters['text'], 'Mãe, hora do remédio!');
  });

  testWidgets('cria um lembrete com mensagem no WhatsApp pela tela', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final agendador = AgendadorDeTeste();

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db), agendadorProvider.overrideWithValue(agendador)],
      child: const AgendaApp(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nova tarefa'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Enviar pelo WhatsApp'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Título'), 'Ligar para a vó');
    await tester.tap(find.text('Lembrete'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Mensagem no WhatsApp'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Mensagem no WhatsApp'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Telefone com DDD (opcional)'), '(11) 98765-4321');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    final l = agendador.sincronizados.single;
    expect(l.lembrete.whatsapp, isTrue);
    expect(l.lembrete.whatsappNumero, '(11) 98765-4321');
    expect(linkDoLembrete(l)!.path, '/5511987654321');

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
