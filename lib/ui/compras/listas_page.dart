import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
import 'dialogos.dart';
import 'lista_page.dart';

/// Aba com todas as listas de compras.
class ListasPage extends ConsumerWidget {
  const ListasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listas = ref.watch(listasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Listas de compras')),
      body: listas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('Nenhuma lista ainda.\nToque em + para criar.', textAlign: TextAlign.center));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [for (final r in lista) _ListaTile(resumo: r)],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        tooltip: 'Nova lista',
        onPressed: () => _novaLista(context, ref.read(databaseProvider)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _novaLista(BuildContext context, AppDatabase db) async {
    final nome = await pedirTexto(context, titulo: 'Nova lista', rotulo: 'Nome', exemplo: 'Mercado');
    if (nome == null) return;
    final id = await db.criarLista(nome);
    if (context.mounted) abrirLista(context, id);
  }
}

void abrirLista(BuildContext context, int id) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListaPage(listaId: id)));
}

class _ListaTile extends StatelessWidget {
  const _ListaTile({required this.resumo});

  final ResumoLista resumo;

  @override
  Widget build(BuildContext context) {
    final (:lista, :total, :comprados) = resumo;
    final completa = total > 0 && comprados == total;
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(completa ? Icons.shopping_cart : Icons.shopping_cart_outlined),
      ),
      title: Text(lista.nome),
      subtitle: Text(_resumo(total, comprados)),
      trailing: total == 0 ? null : _Progresso(valor: comprados / total),
      onTap: () => abrirLista(context, lista.id),
    );
  }

  static String _resumo(int total, int comprados) {
    if (total == 0) return 'Vazia';
    if (comprados == total) return total == 1 ? '1 produto, tudo comprado' : '$total produtos, tudo comprado';
    final faltam = total - comprados;
    return faltam == 1 ? 'Falta 1 de $total' : 'Faltam $faltam de $total';
  }
}

class _Progresso extends StatelessWidget {
  const _Progresso({required this.valor});

  final double valor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(value: valor, strokeWidth: 3, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest),
    );
  }
}
