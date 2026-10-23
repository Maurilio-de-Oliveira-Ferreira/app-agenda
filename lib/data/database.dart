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

/// Um lembrete junto com a tarefa ou o evento a que pertence.
typedef LembreteComItem = ({Lembrete lembrete, Item item});

@DriftDatabase(tables: [Itens, Lembretes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'agenda'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, de, para) async {
          if (de < 2) await m.createTable(lembretes);
        },
        beforeOpen: (_) async {
          // Necessário para apagar os lembretes junto com o item.
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
}
