import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../data/database.dart';
import 'midia.dart';

/// Um anexo ainda não salvo no banco, enquanto a tela de edição está aberta.
typedef Rascunho = ({TipoAnexo tipo, String arquivo, Duration? duracao});

/// Parte do formulário com as fotos e os recados de voz do item.
class EditorDeAnexos extends StatefulWidget {
  const EditorDeAnexos({
    super.key,
    required this.midia,
    required this.anexos,
    required this.onAdicionar,
    required this.onRemover,
  });

  final Midia midia;
  final List<Rascunho> anexos;
  final ValueChanged<Rascunho> onAdicionar;
  final ValueChanged<Rascunho> onRemover;

  @override
  State<EditorDeAnexos> createState() => _EditorDeAnexosState();
}

class _EditorDeAnexosState extends State<EditorDeAnexos> {
  bool _gravando = false;
  Duration _tempo = Duration.zero;
  Timer? _timer;

  Midia get _midia => widget.midia;

  @override
  void dispose() {
    _timer?.cancel();
    if (_gravando) _midia.cancelarGravacao();
    super.dispose();
  }

  void _avisar(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _foto() async {
    final camera = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.pop(context, true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
    if (camera == null) return;
    try {
      final arquivo = await _midia.escolherImagem(camera: camera);
      if (arquivo != null) widget.onAdicionar((tipo: TipoAnexo.imagem, arquivo: arquivo, duracao: null));
    } catch (e) {
      _avisar('Não foi possível abrir a ${camera ? 'câmera' : 'galeria'}.');
    }
  }

  Future<void> _comecarGravacao() async {
    final ok = await _midia.iniciarGravacao();
    if (!mounted) return;
    if (!ok) {
      _avisar('Sem permissão do microfone. Ative em Configurações > Apps > Agenda > Permissões.');
      return;
    }
    final inicio = DateTime.now();
    setState(() {
      _gravando = true;
      _tempo = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _tempo = DateTime.now().difference(inicio));
    });
  }

  Future<void> _pararGravacao({bool descartar = false}) async {
    _timer?.cancel();
    setState(() => _gravando = false);
    if (descartar) {
      await _midia.cancelarGravacao();
      return;
    }
    final g = await _midia.pararGravacao();
    if (g != null) widget.onAdicionar((tipo: TipoAnexo.audio, arquivo: g.arquivo, duracao: g.duracao));
  }

  @override
  Widget build(BuildContext context) {
    final fotos = widget.anexos.where((a) => a.tipo == TipoAnexo.imagem).toList();
    final audios = widget.anexos.where((a) => a.tipo == TipoAnexo.audio).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.attach_file),
          title: Text('Foto e voz'),
          subtitle: Text('A foto aparece na notificação; o recado de voz toca ao abrir o lembrete'),
        ),
        if (fotos.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in fotos)
                _Miniatura(
                  caminho: _midia.caminho(f.arquivo),
                  onAbrir: () => abrirFoto(context, _midia.caminho(f.arquivo)),
                  onRemover: () => widget.onRemover(f),
                ),
            ],
          ),
        for (final a in audios)
          ValueListenableBuilder(
            valueListenable: _midia.tocando,
            builder: (context, tocando, _) {
              final esteToca = tocando == a.arquivo;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton.filledTonal(
                  tooltip: esteToca ? 'Parar' : 'Ouvir',
                  icon: Icon(esteToca ? Icons.stop : Icons.play_arrow),
                  onPressed: () => esteToca ? _midia.pararDeTocar() : _midia.tocar(a.arquivo),
                ),
                title: const Text('Recado de voz'),
                subtitle: a.duracao == null ? null : Text(formatarDuracao(a.duracao!)),
                trailing: IconButton(
                  tooltip: 'Remover gravação',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (esteToca) _midia.pararDeTocar();
                    widget.onRemover(a);
                  },
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        if (_gravando)
          Row(
            children: [
              Icon(Icons.fiber_manual_record, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              Text('Gravando ${formatarDuracao(_tempo)}'),
              const Spacer(),
              TextButton(onPressed: () => _pararGravacao(descartar: true), child: const Text('Descartar')),
              FilledButton.icon(
                onPressed: _pararGravacao,
                icon: const Icon(Icons.stop),
                label: const Text('Parar'),
              ),
            ],
          )
        else
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _foto,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Foto'),
              ),
              OutlinedButton.icon(
                onPressed: _comecarGravacao,
                icon: const Icon(Icons.mic_none),
                label: const Text('Gravar voz'),
              ),
            ],
          ),
      ],
    );
  }
}

String formatarDuracao(Duration d) {
  final segundos = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '${d.inMinutes}:$segundos';
}

/// Mostra a foto na tela inteira, com zoom.
void abrirFoto(BuildContext context, String caminho) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: Image.file(File(caminho), errorBuilder: (_, _, _) => const _FotoQuebrada(cor: Colors.white)),
        ),
      ),
    ),
  ));
}

class _Miniatura extends StatelessWidget {
  const _Miniatura({required this.caminho, required this.onAbrir, required this.onRemover});

  final String caminho;
  final VoidCallback onAbrir;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onAbrir,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(caminho),
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              cacheWidth: 264,
              errorBuilder: (_, _, _) => const SizedBox(width: 88, height: 88, child: _FotoQuebrada()),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: IconButton.filledTonal(
            tooltip: 'Remover foto',
            visualDensity: VisualDensity.compact,
            iconSize: 16,
            icon: const Icon(Icons.close),
            onPressed: onRemover,
          ),
        ),
      ],
    );
  }
}

class _FotoQuebrada extends StatelessWidget {
  const _FotoQuebrada({this.cor});

  final Color? cor;

  @override
  Widget build(BuildContext context) => Icon(Icons.broken_image_outlined, color: cor);
}
