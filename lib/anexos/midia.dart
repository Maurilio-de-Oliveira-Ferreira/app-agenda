import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Pasta onde ficam as fotos e gravações. É criada se ainda não existir.
Future<String> pastaDosAnexos() async {
  final documentos = await getApplicationDocumentsDirectory();
  final pasta = Directory(p.join(documentos.path, 'anexos'));
  await pasta.create(recursive: true);
  return pasta.path;
}

/// Uma gravação terminada: o nome do arquivo e quanto tempo ela tem.
typedef Gravacao = ({String arquivo, Duration duracao});

/// Câmera, galeria, microfone e alto-falante.
///
/// Os testes usam [MidiaDeTeste], que não fala com o Android.
abstract class Midia {
  /// Caminho completo de um arquivo da pasta de anexos.
  String caminho(String arquivo);

  /// Tira uma foto ou escolhe uma da galeria e guarda uma cópia na pasta de
  /// anexos. Devolve o nome do arquivo, ou nulo se a pessoa desistir.
  Future<String?> escolherImagem({required bool camera});

  /// Começa a gravar. Devolve falso se não houver permissão do microfone.
  Future<bool> iniciarGravacao();

  /// Termina a gravação e devolve o arquivo, ou nulo se nada foi gravado.
  Future<Gravacao?> pararGravacao();

  Future<void> cancelarGravacao();

  /// Toca uma gravação. Só uma toca de cada vez.
  Future<void> tocar(String arquivo);

  Future<void> pararDeTocar();

  /// Nome do arquivo que está tocando agora, ou nulo.
  ValueListenable<String?> get tocando;

  Future<void> apagar(String arquivo);

  /// Apaga da pasta os arquivos que nenhum item usa mais.
  Future<void> apagarSobras(Set<String> emUso);
}

class MidiaLocal implements Midia {
  MidiaLocal(this.pasta) {
    _player.onPlayerComplete.listen((_) => _tocando.value = null);
  }

  final String pasta;
  final _picker = ImagePicker();
  final _gravador = AudioRecorder();
  final _player = AudioPlayer();
  final _tocando = ValueNotifier<String?>(null);
  final _relogio = Stopwatch();
  String? _gravando;

  static String _novoNome(String extensao) => '${DateTime.now().microsecondsSinceEpoch}.$extensao';

  @override
  String caminho(String arquivo) => p.join(pasta, arquivo);

  @override
  Future<String?> escolherImagem({required bool camera}) async {
    final foto = await _picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      // Fotos de celular são enormes; isto basta para a tela e a notificação.
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (foto == null) return null;
    final extensao = p.extension(foto.path).replaceFirst('.', '');
    final nome = _novoNome(extensao.isEmpty ? 'jpg' : extensao);
    await foto.saveTo(caminho(nome));
    return nome;
  }

  @override
  Future<bool> iniciarGravacao() async {
    if (!await _gravador.hasPermission()) return false;
    await pararDeTocar();
    final nome = _novoNome('m4a');
    await _gravador.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: caminho(nome));
    _gravando = nome;
    _relogio
      ..reset()
      ..start();
    return true;
  }

  @override
  Future<Gravacao?> pararGravacao() async {
    final nome = _gravando;
    _gravando = null;
    _relogio.stop();
    final caminhoFinal = await _gravador.stop();
    if (nome == null || caminhoFinal == null) return null;
    return (arquivo: nome, duracao: _relogio.elapsed);
  }

  @override
  Future<void> cancelarGravacao() async {
    _gravando = null;
    _relogio.stop();
    await _gravador.cancel();
  }

  @override
  ValueListenable<String?> get tocando => _tocando;

  @override
  Future<void> tocar(String arquivo) async {
    await _player.stop();
    _tocando.value = arquivo;
    try {
      await _player.play(DeviceFileSource(caminho(arquivo)));
    } catch (e) {
      debugPrint('Não foi possível tocar $arquivo: $e');
      _tocando.value = null;
    }
  }

  @override
  Future<void> pararDeTocar() async {
    _tocando.value = null;
    await _player.stop();
  }

  @override
  Future<void> apagar(String arquivo) async {
    final f = File(caminho(arquivo));
    if (await f.exists()) await f.delete();
  }

  @override
  Future<void> apagarSobras(Set<String> emUso) async {
    await for (final f in Directory(pasta).list()) {
      if (f is File && !emUso.contains(p.basename(f.path))) await f.delete();
    }
  }
}

/// Mídia dos testes: devolve arquivos inventados e guarda o que foi pedido.
class MidiaDeTeste implements Midia {
  var _contador = 0;
  final apagados = <String>[];
  final tocados = <String>[];
  bool permitirMicrofone = true;
  final _tocando = ValueNotifier<String?>(null);

  @override
  String caminho(String arquivo) => '/teste/$arquivo';

  @override
  Future<String?> escolherImagem({required bool camera}) async => 'foto${++_contador}.jpg';

  @override
  Future<bool> iniciarGravacao() async => permitirMicrofone;

  @override
  Future<Gravacao?> pararGravacao() async => (arquivo: 'voz${++_contador}.m4a', duracao: const Duration(seconds: 5));

  @override
  Future<void> cancelarGravacao() async {}

  @override
  ValueListenable<String?> get tocando => _tocando;

  @override
  Future<void> tocar(String arquivo) async {
    tocados.add(arquivo);
    _tocando.value = arquivo;
  }

  @override
  Future<void> pararDeTocar() async => _tocando.value = null;

  @override
  Future<void> apagar(String arquivo) async => apagados.add(arquivo);

  @override
  Future<void> apagarSobras(Set<String> emUso) async {}
}
