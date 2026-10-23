import 'package:app_agenda/data/database.dart';
import 'package:app_agenda/data/providers.dart';
import 'package:app_agenda/main.dart';
import 'package:app_agenda/notificacoes/agendador.dart';
import 'package:app_agenda/ui/item_form_page.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('cria uma tarefa pela tela e ela aparece na lista', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const AgendaApp(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma tarefa ainda.\nToque em + para criar.'), findsOneWidget);

    await tester.tap(find.byTooltip('Nova tarefa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Título'), 'Estudar Flutter');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Estudar Flutter'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('Concluídas (1)'), findsOneWidget);

    await tester.tap(find.text('Calendário'));
    await tester.pumpAndSettle();
    expect(find.text('Nada marcado para este dia.'), findsOneWidget);

    // Desmonta o app para fechar os streams do banco antes do fim do teste.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets('cria uma tarefa com lembrete que se repete e ele é agendado', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final agendador = AgendadorDeTeste();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), agendadorProvider.overrideWithValue(agendador)],
        child: const AgendaApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nova tarefa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Título'), 'Beber água');
    await tester.tap(find.text('Lembrete'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Não repetir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('De hora em hora').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, '1'), '2');
    await tester.pumpAndSettle();
    expect(find.text('horas'), findsOneWidget);

    await tester.ensureVisible(find.text('Salvar'));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Beber água'), findsOneWidget);
    expect(find.byIcon(Icons.repeat), findsOneWidget);
    final agendado = agendador.sincronizados.single.lembrete;
    expect(agendado.frequencia, Frequencia.horas);
    expect(agendado.intervalo, 2);
    expect(agendado.sonecaMinutos, 10);

    // Concluir a tarefa tira o lembrete da lista de agendados.
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(agendador.sincronizados, isEmpty);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('lembrete de evento avisa um dia antes e acompanha o início', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final daquiUmMes = DateTime.now().add(const Duration(days: 30));

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db), agendadorProvider.overrideWithValue(AgendadorDeTeste())],
      child: MaterialApp(home: ItemFormPage(tipo: TipoItem.evento, diaInicial: daquiUmMes)),
    ));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Título'), 'Consulta');
    await tester.tap(find.text('Lembrete'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Na hora'));
    await tester.pumpAndSettle();
    expect(find.text('2 horas antes'), findsOneWidget);
    expect(find.text('1 semana antes'), findsOneWidget);
    await tester.tap(find.text('1 dia antes').last);
    await tester.pumpAndSettle();

    // No dia inteiro o aviso passa para as 9h do dia anterior.
    await tester.tap(find.text('Dia inteiro'));
    await tester.pumpAndSettle();
    expect(find.text('1 dia antes'), findsOneWidget);

    await tester.ensureVisible(find.text('Salvar'));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    final item = (await db.select(db.itens).get()).single;
    final lembrete = (await db.lembreteDoItem(item.id))!;
    final vespera = item.inicio!.subtract(const Duration(days: 1));
    expect(lembrete.quando, DateTime(vespera.year, vespera.month, vespera.day, 9));

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
