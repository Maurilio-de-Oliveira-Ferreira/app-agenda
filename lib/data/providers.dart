import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../anexos/midia.dart';
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

final listasProvider = StreamProvider<List<ResumoLista>>((ref) {
  return ref.watch(databaseProvider).watchListas();
});

final listaProvider = StreamProvider.autoDispose.family<ListaCompras?, int>((ref, id) {
  return ref.watch(databaseProvider).watchLista(id);
});

final produtosProvider = StreamProvider.autoDispose.family<List<Produto>, int>((ref, listaId) {
  return ref.watch(databaseProvider).watchProdutos(listaId);
});

/// Substituído em `main` pela câmera, galeria e microfone de verdade.
final midiaProvider = Provider<Midia>((ref) => MidiaDeTeste());

final anexosPorItemProvider = StreamProvider<Map<int, List<Anexo>>>((ref) {
  return ref.watch(databaseProvider).watchAnexosPorItem();
});
