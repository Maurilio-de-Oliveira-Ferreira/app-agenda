import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Um item da agenda pode ser uma tarefa ou um evento.
enum TipoItem { tarefa, evento }

/// De quanto em quanto tempo um lembrete se repete.
enum Frequencia { nenhuma, minutos, horas, dias, semanas, meses }

/// Tarefas e eventos ficam na mesma tabela, como definido no escopo.
///
/// Para uma tarefa, [inicio] é o prazo (opcional) e [fim] fica vazio.
/// Para um evento, [inicio] e [fim] são obrigatórios.
@DataClassName('Item')
class Itens extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tipo => intEnum<TipoItem>()();
  TextColumn get titulo => text().withLength(min: 1, max: 200)();
  TextColumn get descricao => text().nullable()();
  DateTimeColumn get inicio => dateTime().nullable()();
  DateTimeColumn get fim => dateTime().nullable()();
  BoolColumn get diaInteiro => boolean().withDefault(const Constant(false))();
  BoolColumn get concluida => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
}

/// Um lembrete dispara uma notificação em [quando] e, se tiver repetição,
/// de novo a cada [intervalo] unidades de [frequencia].
///
/// Cada lembrete pertence a uma tarefa ou evento e é apagado junto com ele.
class Lembretes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Itens, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get quando => dateTime()();
  IntColumn get frequencia => intEnum<Frequencia>().withDefault(const Constant(0))();
  IntColumn get intervalo => integer().withDefault(const Constant(1))();

  /// Quantos minutos o botão "Adiar" da notificação espera.
  IntColumn get sonecaMinutos => integer().withDefault(const Constant(10))();
}

/// Uma lista de compras, como "Mercado" ou "Farmácia".
@DataClassName('ListaCompras')
class Listas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 100)();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
}

/// Um produto de uma lista de compras. É apagado junto com a lista.
@DataClassName('Produto')
class Produtos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listaId => integer().references(Listas, #id, onDelete: KeyAction.cascade)();
  TextColumn get nome => text().withLength(min: 1, max: 200)();

  /// Texto livre, como "2 kg" ou "1 caixa".
  TextColumn get quantidade => text().nullable()();
  BoolColumn get comprado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get criadoEm => dateTime().withDefault(currentDateAndTime)();
}

/// Uma lista com quantos produtos tem e quantos já foram comprados.
typedef ResumoLista = ({ListaCompras lista, int total, int comprados});

/// Um lembrete junto com a tarefa ou o evento a que pertence.
typedef LembreteComItem = ({Lembrete lembrete, Item item});

@DriftDatabase(tables: [Itens, Lembretes, Listas, Produtos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'agenda'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, de, para) async {
          if (de < 2) await m.createTable(lembretes);
          if (de < 3) {
            await m.createTable(listas);
            await m.createTable(produtos);
          }
        },
        beforeOpen: (_) async {
          // Necessário para apagar lembretes e produtos junto com o dono.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Tarefas pendentes primeiro, ordenadas pelo prazo (sem prazo no fim).
  Stream<List<Item>> watchTarefas() {
    return (select(itens)
          ..where((t) => t.tipo.equalsValue(TipoItem.tarefa))
          ..orderBy([
            (t) => OrderingTerm(expression: t.concluida),
            (t) => OrderingTerm(expression: t.inicio, nulls: NullsOrder.last),
            (t) => OrderingTerm(expression: t.criadoEm),
          ]))
        .watch();
  }

  /// Eventos e tarefas com prazo que acontecem no período [inicio, fim).
  ///
  /// Um evento que começou antes do período mas ainda não terminou também
  /// entra, para que eventos de vários dias apareçam em todos eles.
  Stream<List<Item>> watchItensEntre(DateTime inicio, DateTime fim) {
    return (select(itens)
          ..where((t) =>
              t.inicio.isSmallerThanValue(fim) &
              (t.inicio.isBiggerOrEqualValue(inicio) |
                  t.fim.isBiggerThanValue(inicio)))
          ..orderBy([
            (t) => OrderingTerm(expression: t.diaInteiro, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.inicio),
          ]))
        .watch();
  }

  Future<int> criar(ItensCompanion item) => into(itens).insert(item);

  Future<void> atualizar(int id, ItensCompanion item) {
    return (update(itens)..where((t) => t.id.equals(id))).write(item);
  }

  Future<void> excluir(int id) {
    return (delete(itens)..where((t) => t.id.equals(id))).go();
  }

  Future<void> alternarConcluida(Item item) {
    return atualizar(item.id, ItensCompanion(concluida: Value(!item.concluida)));
  }

  Future<Item?> itemPorId(int id) {
    return (select(itens)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// O lembrete de um item, se houver. Na tela cada item tem no máximo um.
  Future<Lembrete?> lembreteDoItem(int itemId) {
    return (select(lembretes)..where((l) => l.itemId.equals(itemId))).get().then((l) => l.firstOrNull);
  }

  /// Troca o lembrete do item por [lembrete], ou só remove se for nulo.
  Future<void> definirLembrete(int itemId, LembretesCompanion? lembrete) {
    return transaction(() async {
      await (delete(lembretes)..where((l) => l.itemId.equals(itemId))).go();
      if (lembrete != null) {
        await into(lembretes).insert(lembrete.copyWith(itemId: Value(itemId)));
      }
    });
  }

  /// Lembretes por item, para mostrar o sininho nas listas.
  Stream<Map<int, Lembrete>> watchLembretesPorItem() {
    return select(lembretes).watch().map((lista) => {for (final l in lista) l.itemId: l});
  }

  /// Lembretes que ainda devem tocar: os de tarefas já concluídas ficam de fora.
  Stream<List<LembreteComItem>> watchLembretesAtivos() {
    final consulta = select(lembretes).join([
      innerJoin(itens, itens.id.equalsExp(lembretes.itemId)),
    ])
      ..where(itens.concluida.equals(false));
    return consulta.watch().map((linhas) => [
          for (final l in linhas) (lembrete: l.readTable(lembretes), item: l.readTable(itens)),
        ]);
  }

  /// Listas de compras em ordem alfabética, com a contagem de produtos.
  Stream<List<ResumoLista>> watchListas() {
    final total = produtos.id.count();
    final comprados = produtos.id.count(filter: produtos.comprado.equals(true));
    final consulta = select(listas).join([
      leftOuterJoin(produtos, produtos.listaId.equalsExp(listas.id)),
    ])
      ..addColumns([total, comprados])
      ..groupBy([listas.id])
      ..orderBy([OrderingTerm(expression: listas.nome.collate(Collate.noCase))]);
    return consulta.watch().map((linhas) => [
          for (final l in linhas)
            (lista: l.readTable(listas), total: l.read(total)!, comprados: l.read(comprados)!),
        ]);
  }

  Stream<ListaCompras?> watchLista(int id) {
    return (select(listas)..where((l) => l.id.equals(id))).watchSingleOrNull();
  }

  Future<int> criarLista(String nome) => into(listas).insert(ListasCompanion.insert(nome: nome));

  Future<void> renomearLista(int id, String nome) {
    return (update(listas)..where((l) => l.id.equals(id))).write(ListasCompanion(nome: Value(nome)));
  }

  Future<void> excluirLista(int id) {
    return (delete(listas)..where((l) => l.id.equals(id))).go();
  }

  /// Produtos que faltam comprar primeiro, na ordem em que foram adicionados.
  Stream<List<Produto>> watchProdutos(int listaId) {
    return (select(produtos)
          ..where((p) => p.listaId.equals(listaId))
          ..orderBy([
            (p) => OrderingTerm(expression: p.comprado),
            (p) => OrderingTerm(expression: p.criadoEm),
            (p) => OrderingTerm(expression: p.id),
          ]))
        .watch();
  }

  Future<int> adicionarProduto(int listaId, String nome, {String? quantidade}) {
    return into(produtos).insert(ProdutosCompanion.insert(
      listaId: listaId,
      nome: nome,
      quantidade: Value(quantidade),
    ));
  }

  Future<int> recriarProduto(Produto produto) => into(produtos).insert(produto.toCompanion(true));

  Future<void> atualizarProduto(int id, ProdutosCompanion produto) {
    return (update(produtos)..where((p) => p.id.equals(id))).write(produto);
  }

  Future<void> alternarComprado(Produto produto) {
    return atualizarProduto(produto.id, ProdutosCompanion(comprado: Value(!produto.comprado)));
  }

  Future<void> excluirProduto(int id) {
    return (delete(produtos)..where((p) => p.id.equals(id))).go();
  }

  /// Apaga os produtos já comprados e devolve quantos eram.
  Future<int> limparComprados(int listaId) {
    return (delete(produtos)..where((p) => p.listaId.equals(listaId) & p.comprado.equals(true))).go();
  }

  /// Desmarca todos os produtos, para reaproveitar a lista na próxima compra.
  Future<void> desmarcarTodos(int listaId) {
    return (update(produtos)..where((p) => p.listaId.equals(listaId)))
        .write(const ProdutosCompanion(comprado: Value(false)));
  }
}
