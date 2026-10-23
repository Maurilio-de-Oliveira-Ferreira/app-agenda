import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../anexos/editor_de_anexos.dart';
import '../anexos/midia.dart';
import '../data/database.dart';
import '../data/providers.dart';
import '../notificacoes/repeticao.dart';
import '../util/datas.dart';

/// Tela para criar ou editar uma tarefa ou um evento.
class ItemFormPage extends ConsumerStatefulWidget {
  const ItemFormPage({
    super.key,
    required this.tipo,
    this.item,
    this.diaInicial,
    this.tocarAudio = false,
  });

  final TipoItem tipo;

  /// Item a editar. Quando nulo, a tela cria um item novo.
  final Item? item;

  /// Dia sugerido para um evento novo (o dia selecionado no calendário).
  final DateTime? diaInicial;

  /// Toca o recado de voz assim que a tela abre (ao tocar na notificação).
  final bool tocarAudio;

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

  bool _lembrar = false;
  late DateTime _quando;

  /// Minutos de antecedência do aviso em relação ao prazo ou início.
  /// Nulo quando a pessoa escolheu um horário que não bate com as opções.
  int? _antecedencia = 0;
  Frequencia _frequencia = Frequencia.nenhuma;
  final _intervalo = TextEditingController(text: '1');
  int _soneca = 10;

  /// Anexos como estão na tela, como estavam no banco e os arquivos criados
  /// nesta edição (apagados se a pessoa sair sem salvar).
  final _anexos = <Rascunho>[];
  final _anexosOriginais = <Rascunho>[];
  final _arquivosNovos = <String>{};
  bool _salvo = false;
  late final Midia _midia = ref.read(midiaProvider);

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

    _quando = _horarioSugerido();
    if (item != null) {
      _carregarLembrete(item.id);
      _carregarAnexos(item.id);
    }
  }

  Future<void> _carregarAnexos(int itemId) async {
    final lista = await ref.read(databaseProvider).anexosDoItem(itemId);
    if (!mounted) return;
    final rascunhos = [
      for (final a in lista)
        (
          tipo: a.tipo,
          arquivo: a.arquivo,
          duracao: a.duracaoMs == null ? null : Duration(milliseconds: a.duracaoMs!),
        ),
    ];
    setState(() {
      _anexos.addAll(rascunhos);
      _anexosOriginais.addAll(rascunhos);
    });
    final voz = rascunhos.where((a) => a.tipo == TipoAnexo.audio).firstOrNull;
    if (widget.tocarAudio && voz != null) await _midia.tocar(voz.arquivo);
  }

  Future<void> _carregarLembrete(int itemId) async {
    final l = await ref.read(databaseProvider).lembreteDoItem(itemId);
    if (l == null || !mounted) return;
    setState(() {
      _lembrar = true;
      _quando = l.quando;
      _antecedencia = _antecedenciaDe(l.quando);
      _frequencia = l.frequencia;
      _intervalo.text = '${l.intervalo}';
      _soneca = l.sonecaMinutos;
    });
  }

  /// Horário inicial do lembrete: o prazo da tarefa ou o início do evento.
  DateTime _horarioSugerido() {
    if (_evento && _diaInteiro) {
      return DateTime(_inicio.year, _inicio.month, _inicio.day, 9);
    }
    if (_evento || _temPrazo) return _inicio;
    return _proximaHoraCheia(null);
  }

  bool get _temReferencia => _evento || _temPrazo;

  int? _antecedenciaDe(DateTime quando) {
    if (!_temReferencia) return null;
    final diferenca = _horarioSugerido().difference(quando);
    final minutos = diferenca.inMinutes;
    return diferenca == Duration(minutes: minutos) && _antecedencias.contains(minutos) ? minutos : null;
  }

  /// Recalcula o aviso depois de mudar o prazo ou o início, mantendo a antecedência.
  void _ajustarLembrete() {
    if (_temReferencia && _antecedencia != null) {
      _quando = _horarioSugerido().subtract(Duration(minutes: _antecedencia!));
    }
  }

  String _nomeDaAntecedencia(int m) => switch (m) {
        0 => _evento && _diaInteiro ? 'No dia, às 9h' : 'Na hora',
        < 60 => '$m minutos antes',
        60 => '1 hora antes',
        < 1440 => '${m ~/ 60} horas antes',
        1440 => '1 dia antes',
        10080 => '1 semana antes',
        _ => '${m ~/ 1440} dias antes',
      };

  @override
  void dispose() {
    _midia.pararDeTocar();
    if (!_salvo) {
      for (final arquivo in _arquivosNovos) {
        _midia.apagar(arquivo);
      }
    }
    _titulo.dispose();
    _descricao.dispose();
    _intervalo.dispose();
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
            const Divider(height: 32),
            ..._camposLembrete(),
            const Divider(height: 32),
            EditorDeAnexos(
              midia: _midia,
              anexos: _anexos,
              onAdicionar: (a) => setState(() {
                _anexos.add(a);
                _arquivosNovos.add(a.arquivo);
              }),
              onRemover: (a) {
                setState(() => _anexos.remove(a));
                // Um arquivo que já estava salvo só é apagado ao salvar.
                if (_arquivosNovos.remove(a.arquivo)) _midia.apagar(a.arquivo);
              },
            ),
            const SizedBox(height: 72),
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
          onChanged: (v) => setState(() {
            _temPrazo = v;
            _ajustarLembrete();
          }),
        ),
        if (_temPrazo)
          _SeletorDataHora(
            rotulo: 'Prazo',
            valor: _inicio,
            onChanged: (v) => setState(() {
              _inicio = v;
              _ajustarLembrete();
            }),
          ),
      ];

  List<Widget> _camposEvento() => [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dia inteiro'),
          value: _diaInteiro,
          onChanged: (v) => setState(() {
            _diaInteiro = v;
            _ajustarLembrete();
          }),
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
            _ajustarLembrete();
          }),
        ),
        _SeletorDataHora(
          rotulo: 'Fim',
          valor: _fim,
          mostrarHora: !_diaInteiro,
          onChanged: (v) => setState(() => _fim = v),
        ),
      ];

  List<Widget> _camposLembrete() => [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.notifications_outlined),
          title: const Text('Lembrete'),
          subtitle: const Text('Avisar com uma notificação'),
          value: _lembrar,
          onChanged: (v) async {
            setState(() {
              _lembrar = v;
              if (v) {
                _antecedencia = 0;
                _quando = _horarioSugerido();
              }
            });
            if (v && !await ref.read(agendadorProvider).pedirPermissao() && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Sem permissão de notificações, o lembrete não vai aparecer. '
                    'Ative em Configurações > Apps > Agenda > Notificações.'),
              ));
            }
          },
        ),
        if (_lembrar) ...[
          if (_temReferencia) ...[
            DropdownButtonFormField<int?>(
              key: ValueKey(_antecedencia),
              initialValue: _antecedencia,
              decoration: const InputDecoration(labelText: 'Quando avisar', border: OutlineInputBorder()),
              items: [
                for (final m in _antecedencias) DropdownMenuItem(value: m, child: Text(_nomeDaAntecedencia(m))),
                const DropdownMenuItem(value: null, child: Text('Outro horário')),
              ],
              onChanged: (m) => setState(() {
                _antecedencia = m;
                _ajustarLembrete();
              }),
            ),
            const SizedBox(height: 8),
          ],
          _SeletorDataHora(
            rotulo: 'Avisar',
            valor: _quando,
            onChanged: (v) => setState(() {
              _quando = v;
              _antecedencia = _antecedenciaDe(v);
            }),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Frequencia>(
            initialValue: _frequencia,
            decoration: const InputDecoration(labelText: 'Repetir', border: OutlineInputBorder()),
            items: [
              for (final f in Frequencia.values)
                DropdownMenuItem(
                  value: f,
                  child: Text(switch (f) {
                    Frequencia.nenhuma => 'Não repetir',
                    Frequencia.minutos => 'De minutos em minutos',
                    Frequencia.horas => 'De hora em hora',
                    Frequencia.dias => 'Diariamente',
                    Frequencia.semanas => 'Semanalmente',
                    Frequencia.meses => 'Mensalmente',
                  }),
                ),
            ],
            onChanged: (f) => setState(() => _frequencia = f!),
          ),
          if (_frequencia != Frequencia.nenhuma) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('A cada'),
                const SizedBox(width: 12),
                SizedBox(
                  width: 72,
                  child: TextFormField(
                    controller: _intervalo,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return n == null || n < 1 || n > 999 ? '1 a 999' : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(nomeDaUnidade(_frequencia, int.tryParse(_intervalo.text) ?? 2)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _soneca,
            decoration: const InputDecoration(labelText: 'Soneca (botão "Adiar")', border: OutlineInputBorder()),
            items: [
              for (final m in const [5, 10, 15, 30, 60])
                DropdownMenuItem(value: m, child: Text(m == 60 ? '1 hora' : '$m minutos')),
            ],
            onChanged: (m) => setState(() => _soneca = m!),
          ),
        ],
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

    final intervalo = int.tryParse(_intervalo.text) ?? 1;
    if (_lembrar && _frequencia == Frequencia.nenhuma && !_quando.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O horário do lembrete já passou.')),
      );
      return;
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
    final int id;
    if (_editando) {
      id = widget.item!.id;
      await db.atualizar(id, dados);
    } else {
      id = await db.criar(dados);
    }
    await db.definirLembrete(
      id,
      _lembrar
          ? LembretesCompanion.insert(
              itemId: id,
              quando: _quando,
              frequencia: Value(_frequencia),
              intervalo: Value(_frequencia == Frequencia.nenhuma ? 1 : intervalo),
              sonecaMinutos: Value(_soneca),
            )
          : null,
    );
    await db.definirAnexos(id, [
      for (final a in _anexos)
        AnexosCompanion.insert(
          itemId: id,
          tipo: a.tipo,
          arquivo: a.arquivo,
          duracaoMs: Value(a.duracao?.inMilliseconds),
        ),
    ]);
    _salvo = true;
    for (final a in _anexosOriginais) {
      if (!_anexos.contains(a)) await _midia.apagar(a.arquivo);
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

/// Opções de antecedência do aviso, em minutos (1440 = 1 dia, 10080 = 1 semana).
const _antecedencias = [0, 5, 10, 30, 60, 120, 1440, 10080];

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
