import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Um item da agenda pode ser uma tarefa ou um evento.
enum TipoItem { tarefa, evento }

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

@DriftDatabase(tables: [Itens])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'agenda'));

  @override
  int get schemaVersion => 1;

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
}
