import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
import '../../whatsapp/whatsapp.dart';
import 'dialogos.dart';

/// Uma lista de compras: marcar o que já foi comprado e adicionar produtos.
class ListaPage extends ConsumerStatefulWidget {
  const ListaPage({super.key, required this.listaId});

  final int listaId;

  @override
  ConsumerState<ListaPage> createState() => _ListaPageState();
}

enum _Acao { renomear, desmarcar, limpar, excluir }

class _ListaPageState extends ConsumerState<ListaPage> {
  final _novo = TextEditingController();
  final _foco = FocusNode();

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _novo.dispose();
    _foco.dispose();
    super.dispose();
  }

  Future<void> _adicionar() async {
    final nome = _novo.text.trim();
    if (nome.isEmpty) return;
    _novo.clear();
    // Mantém o teclado aberto para digitar o próximo produto.
    _foco.requestFocus();
    await _db.adicionarProduto(widget.listaId, nome);
  }

  Future<void> _executar(_Acao acao, ListaCompras lista) async {
    switch (acao) {
      case _Acao.renomear:
        final nome = await pedirTexto(context, titulo: 'Renomear lista', rotulo: 'Nome', inicial: lista.nome);
        if (nome != null) await _db.renomearLista(lista.id, nome);
      case _Acao.desmarcar:
        await _db.desmarcarTodos(lista.id);
      case _Acao.limpar:
        final n = await _db.limparComprados(lista.id);
        if (mounted) _avisar(n == 1 ? '1 produto removido' : '$n produtos removidos');
      case _Acao.excluir:
        final ok = await confirmar(
          context,
          titulo: 'Excluir lista?',
          mensagem: 'A lista "${lista.nome}" e todos os produtos dela serão apagados.',
          acao: 'Excluir',
        );
        if (!ok) return;
        await _db.excluirLista(lista.id);
        if (mounted) Navigator.of(context).pop();
    }
  }

  void _avisar(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    final lista = ref.watch(listaProvider(widget.listaId)).value;
    final produtos = ref.watch(produtosProvider(widget.listaId));

    return Scaffold(
      appBar: AppBar(
        title: Text(lista?.nome ?? ''),
        actions: [
          if (lista != null)
            IconButton(
              tooltip: 'Enviar pelo WhatsApp',
              icon: const Icon(Icons.share_outlined),
              onPressed: () => abrirWhatsApp(
                linkDoWhatsApp(textoDaLista(lista, produtos.value ?? const [])),
                context: context,
              ),
            ),
          if (lista != null)
            PopupMenuButton<_Acao>(
              tooltip: 'Mais opções',
              onSelected: (a) => _executar(a, lista),
              itemBuilder: (_) => const [
                PopupMenuItem(value: _Acao.renomear, child: Text('Renomear')),
                PopupMenuItem(value: _Acao.desmarcar, child: Text('Desmarcar todos')),
                PopupMenuItem(value: _Acao.limpar, child: Text('Remover comprados')),
                PopupMenuItem(value: _Acao.excluir, child: Text('Excluir lista')),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: produtos.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
              data: (lista) {
                if (lista.isEmpty) {
                  return const Center(child: Text('Lista vazia.\nDigite um produto abaixo.', textAlign: TextAlign.center));
                }
                final faltam = lista.where((p) => !p.comprado).toList();
                final comprados = lista.where((p) => p.comprado).toList();
                return ListView(
                  children: [
                    for (final p in faltam) _ProdutoTile(produto: p),
                    if (comprados.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Text('No carrinho (${comprados.length})', style: Theme.of(context).textTheme.titleSmall),
                      ),
                      for (final p in comprados) _ProdutoTile(produto: p),
                    ],
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _novo,
                      focusNode: _foco,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(labelText: 'Adicionar produto', border: OutlineInputBorder()),
                      onSubmitted: (_) => _adicionar(),
                    ),
                  ),
                  IconButton(tooltip: 'Adicionar', icon: const Icon(Icons.add_circle), onPressed: _adicionar),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProdutoTile extends ConsumerWidget {
  const _ProdutoTile({required this.produto});

  final Produto produto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final quantidade = produto.quantidade;

    return Dismissible(
      key: ValueKey(produto.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) {
        db.excluirProduto(produto.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('"${produto.nome}" removido'),
            action: SnackBarAction(label: 'Desfazer', onPressed: () => db.recriarProduto(produto)),
          ));
      },
      child: ListTile(
        leading: Checkbox(value: produto.comprado, onChanged: (_) => db.alternarComprado(produto)),
        title: Text(
          produto.nome,
          style: produto.comprado ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
        ),
        subtitle: quantidade == null || quantidade.isEmpty ? null : Text(quantidade),
        onTap: () => db.alternarComprado(produto),
        onLongPress: () => _editar(context, db),
        trailing: IconButton(
          tooltip: 'Editar',
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: () => _editar(context, db),
        ),
      ),
    );
  }

  Future<void> _editar(BuildContext context, AppDatabase db) async {
    final novo = await showDialog<({String nome, String quantidade})>(
      context: context,
      builder: (_) => _EditarProduto(produto: produto),
    );
    if (novo == null || novo.nome.isEmpty) return;
    await db.atualizarProduto(
      produto.id,
      ProdutosCompanion(
        nome: Value(novo.nome),
        quantidade: Value(novo.quantidade.isEmpty ? null : novo.quantidade),
      ),
    );
  }
}

class _EditarProduto extends StatefulWidget {
  const _EditarProduto({required this.produto});

  final Produto produto;

  @override
  State<_EditarProduto> createState() => _EditarProdutoState();
}

class _EditarProdutoState extends State<_EditarProduto> {
  late final _nome = TextEditingController(text: widget.produto.nome);
  late final _quantidade = TextEditingController(text: widget.produto.quantidade);

  @override
  void dispose() {
    _nome.dispose();
    _quantidade.dispose();
    super.dispose();
  }

  void _salvar() => Navigator.pop(context, (nome: _nome.text.trim(), quantidade: _quantidade.text.trim()));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar produto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nome,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Produto'),
          ),
          TextField(
            controller: _quantidade,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Quantidade', hintText: 'Ex.: 2 kg, 1 caixa'),
            onSubmitted: (_) => _salvar(),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _salvar, child: const Text('Salvar')),
      ],
    );
  }
}
