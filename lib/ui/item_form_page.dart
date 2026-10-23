import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../util/datas.dart';

/// Tela para criar ou editar uma tarefa ou um evento.
class ItemFormPage extends ConsumerStatefulWidget {
  const ItemFormPage({
    super.key,
    required this.tipo,
    this.item,
    this.diaInicial,
  });

  final TipoItem tipo;

  /// Item a editar. Quando nulo, a tela cria um item novo.
  final Item? item;

  /// Dia sugerido para um evento novo (o dia selecionado no calendário).
  final DateTime? diaInicial;

  @override
  ConsumerState<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends ConsumerState<ItemFormPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descricao;

  late bool _temPrazo;
  late bool _diaInteiro;
  late DateTime _inicio;
  late DateTime _fim;

  bool get _evento => widget.tipo == TipoItem.evento;
  bool get _editando => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titulo = TextEditingController(text: item?.titulo);
    _descricao = TextEditingController(text: item?.descricao);
    _diaInteiro = item?.diaInteiro ?? false;
    _temPrazo = item?.inicio != null;

    _inicio = item?.inicio ?? _proximaHoraCheia(widget.diaInicial);
    _fim = item?.fim ?? _inicio.add(const Duration(hours: 1));
    if (_diaInteiro && item?.fim != null) {
      // No banco o fim de um evento de dia inteiro é o início do dia seguinte.
      _fim = _fim.subtract(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    super.dispose();
  }

  static DateTime _proximaHoraCheia(DateTime? dia) {
    final agora = DateTime.now();
    final base = dia ?? agora;
    return DateTime(base.year, base.month, base.day, agora.hour + 1);
  }

  @override
  Widget build(BuildContext context) {
    final nome = _evento ? 'evento' : 'tarefa';
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar $nome' : (_evento ? 'Novo evento' : 'Nova tarefa')),
        actions: [
          if (_editando)
            IconButton(
              tooltip: 'Excluir',
              icon: const Icon(Icons.delete_outline),
              onPressed: _excluir,
            ),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              autofocus: !_editando,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
              validator: (v) => v == null || v.trim().isEmpty ? 'Informe um título' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricao,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Descrição (opcional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            if (_evento) ..._camposEvento() else ..._camposTarefa(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: _salvar,
        icon: const Icon(Icons.check),
        label: const Text('Salvar'),
      ),
    );
  }

  List<Widget> _camposTarefa() => [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Definir prazo'),
          value: _temPrazo,
          onChanged: (v) => setState(() => _temPrazo = v),
        ),
        if (_temPrazo)
          _SeletorDataHora(
            rotulo: 'Prazo',
            valor: _inicio,
            onChanged: (v) => setState(() => _inicio = v),
          ),
      ];

  List<Widget> _camposEvento() => [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dia inteiro'),
          value: _diaInteiro,
          onChanged: (v) => setState(() => _diaInteiro = v),
        ),
        _SeletorDataHora(
          rotulo: 'Início',
          valor: _inicio,
          mostrarHora: !_diaInteiro,
          onChanged: (v) => setState(() {
            // Mantém a duração do evento ao mudar o início.
            final duracao = _fim.difference(_inicio);
            _inicio = v;
            _fim = v.add(duracao);
          }),
        ),
        _SeletorDataHora(
          rotulo: 'Fim',
          valor: _fim,
          mostrarHora: !_diaInteiro,
          onChanged: (v) => setState(() => _fim = v),
        ),
      ];

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;

    DateTime? inicio;
    DateTime? fim;
    if (_evento) {
      inicio = _diaInteiro ? inicioDoDia(_inicio) : _inicio;
      fim = _diaInteiro ? fimDoDia(_fim) : _fim;
      if (fim.isBefore(inicio)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O fim precisa ser depois do início.')),
        );
        return;
      }
    } else if (_temPrazo) {
      inicio = _inicio;
    }

    final descricao = _descricao.text.trim();
    final dados = ItensCompanion(
      tipo: Value(widget.tipo),
      titulo: Value(_titulo.text.trim()),
      descricao: Value(descricao.isEmpty ? null : descricao),
      inicio: Value(inicio),
      fim: Value(fim),
      diaInteiro: Value(_evento && _diaInteiro),
    );

    final db = ref.read(databaseProvider);
    if (_editando) {
      await db.atualizar(widget.item!.id, dados);
    } else {
      await db.criar(dados);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _excluir() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('"${widget.item!.titulo}" será excluído.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmar != true) return;
    await ref.read(databaseProvider).excluir(widget.item!.id);
    if (mounted) Navigator.of(context).pop();
  }
}

class _SeletorDataHora extends StatelessWidget {
  const _SeletorDataHora({
    required this.rotulo,
    required this.valor,
    required this.onChanged,
    this.mostrarHora = true,
  });

  final String rotulo;
  final DateTime valor;
  final bool mostrarHora;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 56, child: Text(rotulo)),
        Expanded(
          child: TextButton(
            onPressed: () async {
              final data = await showDatePicker(
                context: context,
                initialDate: valor,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100, 12, 31),
              );
              if (data != null) {
                onChanged(DateTime(data.year, data.month, data.day, valor.hour, valor.minute));
              }
            },
            child: Text(formatarData(valor)),
          ),
        ),
        if (mostrarHora)
          TextButton(
            onPressed: () async {
              final hora = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(valor),
              );
              if (hora != null) {
                onChanged(DateTime(valor.year, valor.month, valor.day, hora.hour, hora.minute));
              }
            },
            child: Text(formatarHora(valor)),
          ),
      ],
    );
  }
}
