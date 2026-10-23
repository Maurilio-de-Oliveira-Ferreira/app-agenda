import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import 'item_form_page.dart';
import 'item_tile.dart';

class TarefasPage extends ConsumerWidget {
  const TarefasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefas = ref.watch(tarefasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: tarefas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa ainda.\nToque em + para criar.', textAlign: TextAlign.center));
          }
          final pendentes = lista.where((t) => !t.concluida).toList();
          final concluidas = lista.where((t) => t.concluida).toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              for (final t in pendentes) ItemTile(item: t),
              if (concluidas.isNotEmpty)
                ExpansionTile(
                  title: Text('Concluídas (${concluidas.length})'),
                  children: [for (final t in concluidas) ItemTile(item: t)],
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        tooltip: 'Nova tarefa',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ItemFormPage(tipo: TipoItem.tarefa),
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
