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
    final anexos = ref.watch(anexosPorItemProvider).value?[item.id] ?? const <Anexo>[];
    final temFoto = anexos.any((a) => a.tipo == TipoAnexo.imagem);
    final temVoz = anexos.any((a) => a.tipo == TipoAnexo.audio);
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
        // Lembrete e anexos são apagados junto com o item; o "Desfazer"
        // recria tudo (os arquivos só são limpos quando o app abre de novo).
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
                if (anexos.isNotEmpty) {
                  await db.definirAnexos(item.id, [for (final a in anexos) a.toCompanion(true)]);
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
        trailing: _icones(lembrete: riscado ? null : lembrete, temFoto: temFoto, temVoz: temVoz),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ItemFormPage(tipo: item.tipo, item: item),
        )),
      ),
    );
  }

  /// Sininho do lembrete e ícones de foto e voz, quando houver.
  Widget? _icones({Lembrete? lembrete, required bool temFoto, required bool temVoz}) {
    if (lembrete == null && !temFoto && !temVoz) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        if (temFoto) const Tooltip(message: 'Tem foto', child: Icon(Icons.image_outlined, size: 20)),
        if (temVoz) const Tooltip(message: 'Tem recado de voz', child: Icon(Icons.mic_none, size: 20)),
        if (lembrete != null)
          Tooltip(
                message: 'Lembrete: ${formatarPrazo(lembrete.quando)}, '
                    '${descreverRepeticao(lembrete.frequencia, lembrete.intervalo).toLowerCase()}',
                child: Icon(
                  lembrete.frequencia == Frequencia.nenhuma ? Icons.notifications_active_outlined : Icons.repeat,
                  size: 20,
                ),
              ),
      ],
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
