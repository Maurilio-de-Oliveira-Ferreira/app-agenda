import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final tarefasProvider = StreamProvider<List<Item>>((ref) {
  return ref.watch(databaseProvider).watchTarefas();
});

typedef Periodo = ({DateTime inicio, DateTime fim});

final itensNoPeriodoProvider =
    StreamProvider.autoDispose.family<List<Item>, Periodo>((ref, periodo) {
  return ref
      .watch(databaseProvider)
      .watchItensEntre(periodo.inicio, periodo.fim);
});
