import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notificacoes/agendador.dart';
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

/// Substituído em `main` pelo agendador real e nos testes por um falso.
final agendadorProvider = Provider<Agendador>((ref) => AgendadorDeTeste());

final lembretesPorItemProvider = StreamProvider<Map<int, Lembrete>>((ref) {
  return ref.watch(databaseProvider).watchLembretesPorItem();
});

/// Mantém as notificações agendadas iguais aos lembretes do banco: qualquer
/// mudança em tarefas, eventos ou lembretes reagenda tudo.
final sincronizarLembretesProvider = Provider<void>((ref) {
  final agendador = ref.watch(agendadorProvider);
  final sub = ref.watch(databaseProvider).watchLembretesAtivos().listen(
        agendador.sincronizar,
        onError: (Object e) => debugPrint('Erro ao ler lembretes: $e'),
      );
  ref.onDispose(sub.cancel);
});
