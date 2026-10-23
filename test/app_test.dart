import 'package:app_agenda/data/database.dart';
import 'package:app_agenda/data/providers.dart';
import 'package:app_agenda/main.dart';
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
}
