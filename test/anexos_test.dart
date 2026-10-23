import 'package:app_agenda/anexos/midia.dart';
import 'package:app_agenda/data/database.dart';
import 'package:app_agenda/data/providers.dart';
import 'package:app_agenda/main.dart';
import 'package:app_agenda/ui/item_form_page.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  group('banco', () {
    late AppDatabase db;

    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    AnexosCompanion anexo(TipoAnexo tipo, String arquivo) =>
        AnexosCompanion.insert(itemId: 0, tipo: tipo, arquivo: arquivo);

    test('o lembrete leva a primeira foto e avisa que tem recado de voz', () async {
      final id = await db.criar(ItensCompanion.insert(tipo: TipoItem.tarefa, titulo: 'Remédio'));
      await db.definirLembrete(id, LembretesCompanion.insert(itemId: id, quando: DateTime(2026, 11, 1, 8)));
      var ativos = await db.watchLembretesAtivos().first;
      expect(ativos.single.imagem, isNull);
      expect(ativos.single.temAudio, isFalse);

      await db.definirAnexos(id, [
        anexo(TipoAnexo.audio, 'voz.m4a'),
        anexo(TipoAnexo.imagem, 'caixa.jpg'),
        anexo(TipoAnexo.imagem, 'outra.jpg'),
      ]);
      ativos = await db.watchLembretesAtivos().first;
      expect(ativos.single.imagem, 'caixa.jpg');
      expect(ativos.single.temAudio, isTrue);
    });

    test('anexos são trocados de uma vez e apagados junto com o item', () async {
      final id = await db.criar(ItensCompanion.insert(tipo: TipoItem.tarefa, titulo: 'Remédio'));
      await db.definirAnexos(id, [anexo(TipoAnexo.imagem, 'a.jpg'), anexo(TipoAnexo.imagem, 'b.jpg')]);
      await db.definirAnexos(id, [
        AnexosCompanion.insert(itemId: 0, tipo: TipoAnexo.audio, arquivo: 'c.m4a', duracaoMs: const Value(3000)),
      ]);

      final lista = await db.anexosDoItem(id);
      expect(lista.single.arquivo, 'c.m4a');
      expect(lista.single.duracaoMs, 3000);
      expect(await db.arquivosEmUso(), {'c.m4a'});
      expect((await db.watchAnexosPorItem().first)[id]!.length, 1);

      await db.excluir(id);
      expect(await db.arquivosEmUso(), isEmpty);
    });
  });

  Widget app(AppDatabase db, MidiaDeTeste midia, {Widget? home}) => ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), midiaProvider.overrideWithValue(midia)],
        child: home == null ? const AgendaApp() : MaterialApp(home: home),
      );

  // O botão Salvar flutua sobre o fim do formulário; rola até o fim.
  Future<void> rolarAteOFim(WidgetTester tester) async {
    await tester.drag(find.byType(ListView).last, const Offset(0, -2000));
    await tester.pumpAndSettle();
  }

  Future<void> desmontar(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('cria uma tarefa com foto e recado de voz', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final midia = MidiaDeTeste();

    await tester.pumpWidget(app(db, midia));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nova tarefa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Título'), 'Comprar remédio');

    await rolarAteOFim(tester);
    await tester.tap(find.text('Foto'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Escolher da galeria'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remover foto'), findsOneWidget);

    await rolarAteOFim(tester);
    await tester.tap(find.text('Gravar voz'));
    await tester.pump();
    expect(find.text('Gravando 0:00'), findsOneWidget);
    await tester.tap(find.text('Parar'));
    await tester.pumpAndSettle();
    await rolarAteOFim(tester);
    expect(find.text('Recado de voz'), findsOneWidget);
    expect(find.text('0:05'), findsOneWidget);

    await rolarAteOFim(tester);
    await tester.tap(find.byTooltip('Ouvir'));
    await tester.pump();
    expect(midia.tocados, ['voz2.m4a']);
    expect(find.byTooltip('Parar'), findsOneWidget);

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Comprar remédio'), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byIcon(Icons.mic_none), findsOneWidget);
    expect(await db.arquivosEmUso(), {'foto1.jpg', 'voz2.m4a'});
    expect(midia.apagados, isEmpty);

    // Ao editar, remover a foto só apaga o arquivo depois de salvar.
    await tester.tap(find.text('Comprar remédio'));
    await tester.pumpAndSettle();
    await rolarAteOFim(tester);
    await tester.tap(find.byTooltip('Remover foto'));
    await tester.pumpAndSettle();
    expect(midia.apagados, isEmpty);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(midia.apagados, ['foto1.jpg']);
    expect(find.byIcon(Icons.image_outlined), findsNothing);

    await desmontar(tester);
  });

  testWidgets('sair sem salvar apaga a gravação nova', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final midia = MidiaDeTeste();

    await tester.pumpWidget(app(db, midia));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Nova tarefa'));
    await tester.pumpAndSettle();
    await rolarAteOFim(tester);
    await tester.tap(find.text('Gravar voz'));
    await tester.pump();
    await tester.tap(find.text('Parar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(midia.apagados, ['voz1.m4a']);
    expect(await db.arquivosEmUso(), isEmpty);

    await desmontar(tester);
  });

  testWidgets('sem permissão do microfone, avisa e não grava', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final midia = MidiaDeTeste()..permitirMicrofone = false;

    await tester.pumpWidget(app(db, midia, home: const ItemFormPage(tipo: TipoItem.tarefa)));
    await tester.pumpAndSettle();
    await rolarAteOFim(tester);
    await tester.tap(find.text('Gravar voz'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Sem permissão do microfone'), findsOneWidget);
    expect(find.textContaining('Gravando'), findsNothing);

    await desmontar(tester);
  });

  testWidgets('aberto pela notificação, toca o recado de voz', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final midia = MidiaDeTeste();
    final id = await db.criar(ItensCompanion.insert(tipo: TipoItem.tarefa, titulo: 'Ligar para a mãe'));
    await db.definirAnexos(id, [AnexosCompanion.insert(itemId: id, tipo: TipoAnexo.audio, arquivo: 'recado.m4a')]);
    final item = (await db.itemPorId(id))!;

    await tester.pumpWidget(app(db, midia, home: ItemFormPage(tipo: item.tipo, item: item, tocarAudio: true)));
    await tester.pumpAndSettle();
    expect(midia.tocados, ['recado.m4a']);

    await desmontar(tester);
  });
}
