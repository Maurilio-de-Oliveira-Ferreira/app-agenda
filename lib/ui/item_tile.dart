import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../notificacoes/repeticao.dart';
import '../util/datas.dart';
import 'item_form_page.dart';

/// Linha de lista usada tanto para tarefas quanto para eventos.
class ItemTile extends ConsumerWidget {
  const ItemTile({super.key, required this.item, this.diaDaLista});

  final Item item;

  /// Quando a lista mostra um único dia, o horário basta e a data é omitida.
  final DateTime? diaDaLista;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final lembrete = ref.watch(lembretesPorItemProvider).value?[item.id];
    final tarefa = item.tipo == TipoItem.tarefa;
    final riscado = tarefa && item.concluida;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) {
        // O lembrete é apagado junto com o item; o "Desfazer" recria os dois.
        db.excluir(item.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('"${item.titulo}" excluído'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () async {
                await db.criar(item.toCompanion(true));
                if (lembrete != null) {
                  await db.definirLembrete(item.id, lembrete.toCompanion(true));
                }
              },
            ),
          ));
      },
      child: ListTile(
        leading: tarefa
            ? Checkbox(
                value: item.concluida,
                onChanged: (_) => db.alternarConcluida(item),
              )
            : const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.event),
              ),
        title: Text(
          item.titulo,
          style: riscado
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: _subtitulo(),
        trailing: lembrete == null || riscado
            ? null
            : Tooltip(
                message: 'Lembrete: ${formatarPrazo(lembrete.quando)}, '
                    '${descreverRepeticao(lembrete.frequencia, lembrete.intervalo).toLowerCase()}',
                child: Icon(
                  lembrete.frequencia == Frequencia.nenhuma ? Icons.notifications_active_outlined : Icons.repeat,
                  size: 20,
                ),
              ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ItemFormPage(tipo: item.tipo, item: item),
        )),
      ),
    );
  }

  Widget? _subtitulo() {
    final inicio = item.inicio;
    if (inicio == null) {
      final d = item.descricao;
      return d == null || d.isEmpty ? null : Text(d, maxLines: 1);
    }
    if (item.diaInteiro) {
      return Text(diaDaLista != null ? 'Dia inteiro' : formatarPrazo(inicio, mostrarHora: false));
    }
    final fim = item.fim;
    final textoInicio =
        diaDaLista != null && mesmoDia(inicio, diaDaLista!) ? formatarHora(inicio) : formatarPrazo(inicio);
    if (fim == null) return Text(textoInicio);
    final textoFim = mesmoDia(inicio, fim) ? formatarHora(fim) : formatarPrazo(fim);
    return Text('$textoInicio – $textoFim');
  }
}
