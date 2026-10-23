import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/database.dart';
import '../util/datas.dart';

/// Link que abre o WhatsApp com [texto] já escrito.
///
/// Com [numero], abre a conversa com essa pessoa. Sem número, o próprio
/// WhatsApp pede para escolher o contato ou grupo.
Uri linkDoWhatsApp(String texto, {String? numero}) {
  final telefone = numero == null ? null : numeroParaWhatsApp(numero);
  return Uri.https('wa.me', telefone == null ? '/' : '/$telefone', {'text': texto});
}

/// Deixa só os dígitos do telefone e põe o 55 do Brasil quando falta.
///
/// "(11) 98765-4321" vira "5511987654321". Devolve nulo se não parecer um
/// telefone, para o link abrir sem contato escolhido.
String? numeroParaWhatsApp(String numero) {
  var digitos = numero.replaceAll(RegExp(r'\D'), '');
  // Número com 0 da operadora ou do DDD, como 011 98765-4321.
  digitos = digitos.replaceFirst(RegExp(r'^0+'), '');
  if (digitos.length == 10 || digitos.length == 11) digitos = '55$digitos';
  return digitos.length >= 12 && digitos.length <= 15 ? digitos : null;
}

/// Mensagem com o título, o horário e a descrição da tarefa ou do evento.
String textoDoItem(Item item) {
  final linhas = <String>[item.tipo == TipoItem.evento ? '📅 *${item.titulo}*' : '✅ *${item.titulo}*'];
  final inicio = item.inicio;
  if (inicio != null) {
    if (item.tipo == TipoItem.tarefa) {
      linhas.add('Prazo: ${formatarData(inicio)} às ${formatarHora(inicio)}');
    } else if (item.diaInteiro) {
      // No banco o fim de um evento de dia inteiro é o início do dia seguinte.
      final ultimoDia = item.fim?.subtract(const Duration(days: 1));
      linhas.add(
        ultimoDia == null || mesmoDia(ultimoDia, inicio)
            ? formatarData(inicio)
            : '${formatarData(inicio)} até ${formatarData(ultimoDia)}',
      );
    } else {
      final fim = item.fim;
      if (fim == null) {
        linhas.add('${formatarData(inicio)} às ${formatarHora(inicio)}');
      } else if (mesmoDia(fim, inicio)) {
        linhas.add('${formatarData(inicio)}, das ${formatarHora(inicio)} às ${formatarHora(fim)}');
      } else {
        linhas.add(
          'De ${formatarData(inicio)} ${formatarHora(inicio)} '
          'até ${formatarData(fim)} ${formatarHora(fim)}',
        );
      }
    }
  }
  final descricao = item.descricao;
  if (descricao != null && descricao.isNotEmpty) linhas.add(descricao);
  return linhas.join('\n');
}

/// Link do botão "Enviar no WhatsApp" da notificação, ou nulo se o lembrete
/// não usa o WhatsApp.
Uri? linkDoLembrete(LembreteComItem l) {
  final lembrete = l.lembrete;
  if (!lembrete.whatsapp) return null;
  final mensagem = lembrete.whatsappMensagem?.trim();
  return linkDoWhatsApp(
    mensagem == null || mensagem.isEmpty ? textoDoItem(l.item) : mensagem,
    numero: lembrete.whatsappNumero,
  );
}

/// Mensagem com os produtos que faltam comprar, um por linha.
String textoDaLista(ListaCompras lista, List<Produto> produtos) {
  final faltam = produtos.where((p) => !p.comprado).toList();
  final linhas = <String>['🛒 *${lista.nome}*'];
  if (faltam.isEmpty) {
    linhas.add('Nada para comprar.');
  } else {
    for (final p in faltam) {
      final qtd = p.quantidade;
      linhas.add(qtd == null || qtd.isEmpty ? '• ${p.nome}' : '• ${p.nome} ($qtd)');
    }
  }
  return linhas.join('\n');
}

/// Abre o WhatsApp. Se não der (WhatsApp não instalado, por exemplo), avisa
/// na tela quando houver um [context].
Future<void> abrirWhatsApp(Uri link, {BuildContext? context}) async {
  var abriu = false;
  try {
    abriu = await launchUrl(link, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Erro ao abrir o WhatsApp: $e');
  }
  if (!abriu && context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')));
  }
}
