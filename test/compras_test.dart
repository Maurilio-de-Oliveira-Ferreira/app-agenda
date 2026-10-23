import 'package:app_agenda/data/database.dart';
import 'package:app_agenda/data/providers.dart';
import 'package:app_agenda/main.dart';
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

    test('conta produtos e comprados de cada lista, em ordem alfabética', () async {
      final mercado = await db.criarLista('Mercado');
      await db.criarLista('farmácia');
      await db.adicionarProduto(mercado, 'Arroz', quantidade: '5 kg');
      final feijao = await db.adicionarProduto(mercado, 'Feijão');
      await db.atualizarProduto(feijao, const ProdutosCompanion(comprado: Value(true)));

      final listas = await db.watchListas().first;
      expect(listas.map((r) => r.lista.nome), ['farmácia', 'Mercado']);
      expect(listas[0].total, 0);
      expect(listas[1].total, 2);
      expect(listas[1].comprados, 1);
    });

    test('mostra primeiro o que falta comprar', () async {
      final id = await db.criarLista('Mercado');
      await db.adicionarProduto(id, 'Leite');
      await db.adicionarProduto(id, 'Pão');
      await db.adicionarProduto(id, 'Café');
      final leite = (await db.watchProdutos(id).first).first;
      await db.alternarComprado(leite);

      final nomes = (await db.watchProdutos(id).first).map((p) => p.nome);
      expect(nomes, ['Pão', 'Café', 'Leite']);
    });

    test('remove comprados, desmarca todos e apaga produtos junto com a lista', () async {
      final id = await db.criarLista('Mercado');
      await db.adicionarProduto(id, 'Leite');
      await db.adicionarProduto(id, 'Pão');
      await db.adicionarProduto(id, 'Café');
      final produtos = await db.watchProdutos(id).first;
      await db.alternarComprado(produtos[0]);
      await db.alternarComprado(produtos[1]);

      expect(await db.limparComprados(id), 2);
      expect((await db.watchProdutos(id).first).single.nome, 'Café');

      await db.alternarComprado((await db.watchProdutos(id).first).single);
      await db.desmarcarTodos(id);
      expect((await db.watchProdutos(id).first).single.comprado, isFalse);

      await db.excluirLista(id);
      expect(await db.watchListas().first, isEmpty);
      expect(await db.select(db.produtos).get(), isEmpty);
    });
  });

  testWidgets('cria uma lista, adiciona produtos e marca como comprado', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const AgendaApp(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Compras'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma lista ainda.\nToque em + para criar.'), findsOneWidget);

    await tester.tap(find.byTooltip('Nova lista'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Nome'), 'Mercado');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    // Abre direto a lista nova.
    expect(find.text('Lista vazia.\nDigite um produto abaixo.'), findsOneWidget);
    for (final nome in ['Arroz', 'Leite']) {
      await tester.enterText(find.widgetWithText(TextField, 'Adicionar produto'), nome);
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pumpAndSettle();
    }
    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('Leite'), findsOneWidget);

    await tester.tap(find.text('Arroz'));
    await tester.pumpAndSettle();
    expect(find.text('No carrinho (1)'), findsOneWidget);

    await tester.tap(find.byTooltip('Editar').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Quantidade'), '2 litros');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('2 litros'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Mercado'), findsOneWidget);
    expect(find.text('Falta 1 de 2'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
