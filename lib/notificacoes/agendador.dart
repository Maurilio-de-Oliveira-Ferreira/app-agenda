import 'dart:convert';
import 'dart:io';
import 'dart:ui' show DartPluginRegistrant;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';
import '../util/datas.dart';
import '../whatsapp/whatsapp.dart';
import 'repeticao.dart';

/// Agenda e cancela as notificações dos lembretes.
///
/// Os testes usam [AgendadorDeTeste], que só guarda o que seria agendado.
abstract class Agendador {
  /// [aoAbrirWhatsApp] recebe o link do botão "Enviar no WhatsApp".
  Future<void> iniciar({void Function(int itemId)? aoAbrirItem, void Function(Uri link)? aoAbrirWhatsApp});

  /// Pede ao Android permissão para mostrar notificações. Devolve se pode.
  Future<bool> pedirPermissao();

  /// Deixa agendadas exatamente as notificações de [lembretes].
  Future<void> sincronizar(List<LembreteComItem> lembretes);

  /// Item da notificação que abriu o app, se ele foi aberto por uma.
  /// Se foi pelo botão do WhatsApp, abre o WhatsApp e devolve nulo.
  Future<int?> itemQueAbriuOApp();
}

/// Ações dos botões da notificação.
const _acaoAdiar = 'adiar';
const _acaoConcluir = 'concluir';
const _acaoWhatsApp = 'whatsapp';

/// Cada lembrete usa um bloco de ids de notificação: os primeiros para as
/// próximas ocorrências e o último para a soneca.
const _idsPorLembrete = 32;
const _ocorrenciasPorLembrete = 30;
const _idSoneca = _idsPorLembrete - 1;

/// O Android aceita cerca de 500 alarmes por app; fica uma folga.
const _maximoAgendado = 400;

int _idNotificacao(int lembreteId, int indice) => lembreteId * _idsPorLembrete + indice;

class AgendadorLocal implements Agendador {
  AgendadorLocal({required this.pastaAnexos});

  /// Onde estão as fotos que aparecem nas notificações.
  final String pastaAnexos;

  final _plugin = FlutterLocalNotificationsPlugin();

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  void Function(Uri link)? _aoAbrirWhatsApp;

  @override
  Future<void> iniciar({void Function(int itemId)? aoAbrirItem, void Function(Uri link)? aoAbrirWhatsApp}) async {
    _aoAbrirWhatsApp = aoAbrirWhatsApp;
    await _prepararPlugin(
      _plugin,
      aoTocar: (resposta) async {
        final dados = _Dados.ler(resposta.payload);
        if (dados == null) return;
        switch (resposta.actionId) {
          // Toque na notificação (sem botão): abre a tarefa ou o evento.
          case null:
            aoAbrirItem?.call(dados.itemId);
          case _acaoWhatsApp:
            final link = dados.whatsapp;
            if (link != null) aoAbrirWhatsApp?.call(link);
        }
      },
    );
  }

  @override
  Future<bool> pedirPermissao() async {
    final android = _android;
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  @override
  Future<int?> itemQueAbriuOApp() async {
    final detalhes = await _plugin.getNotificationAppLaunchDetails();
    if (detalhes == null || !detalhes.didNotificationLaunchApp) return null;
    final resposta = detalhes.notificationResponse;
    final dados = _Dados.ler(resposta?.payload);
    if (resposta?.actionId == _acaoWhatsApp) {
      final link = dados?.whatsapp;
      if (link != null) _aoAbrirWhatsApp?.call(link);
      return null;
    }
    return dados?.itemId;
  }

  /// Uma sincronização de cada vez, na ordem em que foram pedidas.
  Future<void> _fila = Future.value();

  @override
  Future<void> sincronizar(List<LembreteComItem> lembretes) {
    return _fila = _fila
        .then((_) => _sincronizar(lembretes))
        .catchError((Object e) => debugPrint('Erro ao agendar notificações: $e'));
  }

  Future<void> _sincronizar(List<LembreteComItem> lembretes) async {
    final agora = DateTime.now();

    // Junta as próximas ocorrências de todos os lembretes e fica com as mais
    // próximas, para não passar do limite de alarmes do Android.
    final planejadas = <({int id, DateTime quando, LembreteComItem l})>[];
    for (final l in lembretes) {
      final datas = proximasOcorrencias(l.lembrete, agora: agora, maximo: _ocorrenciasPorLembrete);
      for (var i = 0; i < datas.length; i++) {
        planejadas.add((id: _idNotificacao(l.lembrete.id, i), quando: datas[i], l: l));
      }
    }
    planejadas.sort((a, b) => a.quando.compareTo(b.quando));
    final agendar = planejadas.take(_maximoAgendado).toList();

    // Cancela o que não vale mais. Sonecas continuam, a menos que o lembrete
    // tenha sido apagado ou a tarefa concluída.
    final ativos = {for (final l in lembretes) l.lembrete.id};
    final novos = {for (final a in agendar) a.id};
    for (final pendente in await _plugin.pendingNotificationRequests()) {
      final id = pendente.id;
      final soneca = id % _idsPorLembrete == _idSoneca;
      final manter = soneca ? ativos.contains(id ~/ _idsPorLembrete) : novos.contains(id);
      if (!manter) await _plugin.cancel(id: id);
    }

    final modo = await _modoDeAgendamento(_android);
    for (final a in agendar) {
      await _agendar(_plugin, a.id, a.quando, _Dados.de(a.l, pastaAnexos), modo);
    }
  }
}

/// Configura fuso horário e callbacks do plugin. Usado no app e no isolate
/// de segundo plano que trata os botões das notificações.
Future<void> _prepararPlugin(
  FlutterLocalNotificationsPlugin plugin, {
  DidReceiveNotificationResponseCallback? aoTocar,
}) async {
  tz.initializeTimeZones();
  try {
    final fuso = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(fuso.identifier));
  } catch (e) {
    debugPrint('Fuso horário não encontrado, usando America/Sao_Paulo: $e');
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
  }

  await plugin.initialize(
    settings: const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    onDidReceiveNotificationResponse: aoTocar,
    onDidReceiveBackgroundNotificationResponse: tratarBotaoEmSegundoPlano,
  );
}

Future<AndroidScheduleMode> _modoDeAgendamento(AndroidFlutterLocalNotificationsPlugin? android) async {
  final exato = await android?.canScheduleExactNotifications() ?? true;
  return exato ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;
}

Future<void> _agendar(
  FlutterLocalNotificationsPlugin plugin,
  int id,
  DateTime quando,
  _Dados dados,
  AndroidScheduleMode modo,
) {
  // Se a foto tiver sumido, a notificação sai só com o texto.
  final imagem = dados.imagem;
  final foto = imagem != null && File(imagem).existsSync() ? FilePathAndroidBitmap(imagem) : null;
  return plugin.zonedSchedule(
    id: id,
    title: dados.titulo,
    body: dados.texto,
    scheduledDate: tz.TZDateTime.from(quando, tz.local),
    androidScheduleMode: modo,
    payload: dados.json(),
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        'lembretes',
        'Lembretes',
        channelDescription: 'Avisos no horário dos lembretes de tarefas e eventos',
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        when: quando.millisecondsSinceEpoch,
        largeIcon: foto,
        styleInformation: foto == null
            ? null
            : BigPictureStyleInformation(foto, summaryText: dados.texto, hideExpandedLargeIcon: true),
        actions: [
          AndroidNotificationAction(_acaoAdiar, 'Adiar ${dados.sonecaMinutos} min'),
          if (dados.tarefa) const AndroidNotificationAction(_acaoConcluir, 'Concluir'),
          // Precisa abrir o app para ele poder abrir o WhatsApp.
          if (dados.whatsapp != null)
            const AndroidNotificationAction(_acaoWhatsApp, 'Enviar no WhatsApp', showsUserInterface: true),
        ],
      ),
    ),
  );
}

/// Trata "Adiar" e "Concluir" sem abrir o app. Roda num isolate separado,
/// por isso abre o próprio acesso ao banco e ao plugin.
@pragma('vm:entry-point')
Future<void> tratarBotaoEmSegundoPlano(NotificationResponse resposta) async {
  DartPluginRegistrant.ensureInitialized();
  final dados = _Dados.ler(resposta.payload);
  if (dados == null) return;

  final plugin = FlutterLocalNotificationsPlugin();
  await _prepararPlugin(plugin);

  switch (resposta.actionId) {
    case _acaoAdiar:
      final quando = DateTime.now().add(Duration(minutes: dados.sonecaMinutos));
      await _agendar(
        plugin,
        _idNotificacao(dados.lembreteId, _idSoneca),
        quando,
        dados,
        await _modoDeAgendamento(
          plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>(),
        ),
      );
    case _acaoConcluir:
      final db = AppDatabase();
      try {
        final item = await db.itemPorId(dados.itemId);
        if (item != null && !item.concluida) await db.alternarConcluida(item);
      } finally {
        await db.close();
      }
      // A tarefa está feita: não precisa avisar de novo.
      for (var i = 0; i < _idsPorLembrete; i++) {
        await plugin.cancel(id: _idNotificacao(dados.lembreteId, i));
      }
  }
}

/// O que a notificação carrega para os botões funcionarem sem o banco.
class _Dados {
  _Dados({
    required this.itemId,
    required this.lembreteId,
    required this.titulo,
    required this.texto,
    required this.tarefa,
    required this.sonecaMinutos,
    this.imagem,
    this.whatsapp,
  });

  factory _Dados.de(LembreteComItem l, String pastaAnexos) {
    final item = l.item;
    final descricao = item.descricao;
    final String texto;
    if (l.temAudio) {
      texto = 'Toque para ouvir o recado de voz';
    } else if (descricao != null && descricao.isNotEmpty) {
      texto = descricao;
    } else if (item.tipo == TipoItem.evento && item.inicio != null) {
      texto = item.diaInteiro
          ? 'Evento ${formatarPrazo(item.inicio!, mostrarHora: false)}'
          : 'Evento ${formatarPrazo(item.inicio!)}';
    } else {
      texto = 'Lembrete da tarefa';
    }
    return _Dados(
      itemId: item.id,
      lembreteId: l.lembrete.id,
      titulo: item.titulo,
      texto: texto,
      tarefa: item.tipo == TipoItem.tarefa,
      sonecaMinutos: l.lembrete.sonecaMinutos,
      imagem: l.imagem == null ? null : '$pastaAnexos/${l.imagem}',
      whatsapp: linkDoLembrete(l),
    );
  }

  static _Dados? ler(String? payload) {
    if (payload == null) return null;
    try {
      final m = jsonDecode(payload) as Map<String, dynamic>;
      return _Dados(
        itemId: m['item'] as int,
        lembreteId: m['lembrete'] as int,
        titulo: m['titulo'] as String,
        texto: m['texto'] as String,
        tarefa: m['tarefa'] as bool,
        sonecaMinutos: m['soneca'] as int,
        imagem: m['imagem'] as String?,
        whatsapp: m['whatsapp'] == null ? null : Uri.parse(m['whatsapp'] as String),
      );
    } catch (_) {
      return null;
    }
  }

  final int itemId;
  final int lembreteId;
  final String titulo;
  final String texto;
  final bool tarefa;
  final int sonecaMinutos;

  /// Caminho completo da foto mostrada na notificação.
  final String? imagem;

  /// Link do botão "Enviar no WhatsApp", se o lembrete tiver um.
  final Uri? whatsapp;

  String json() => jsonEncode({
    'item': itemId,
    'lembrete': lembreteId,
    'titulo': titulo,
    'texto': texto,
    'tarefa': tarefa,
    'soneca': sonecaMinutos,
    'imagem': imagem,
    'whatsapp': whatsapp?.toString(),
  });
}

/// Agendador dos testes: não fala com o Android, só guarda a última lista.
class AgendadorDeTeste implements Agendador {
  List<LembreteComItem> sincronizados = [];

  @override
  Future<void> iniciar({void Function(int itemId)? aoAbrirItem, void Function(Uri link)? aoAbrirWhatsApp}) async {}

  @override
  Future<bool> pedirPermissao() async => true;

  @override
  Future<int?> itemQueAbriuOApp() async => null;

  @override
  Future<void> sincronizar(List<LembreteComItem> lembretes) async {
    sincronizados = lembretes;
  }
}
