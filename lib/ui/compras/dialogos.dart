import 'package:flutter/material.dart';

/// Pede um texto numa caixa de diálogo. Devolve nulo se a pessoa cancelar
/// ou deixar o campo vazio.
Future<String?> pedirTexto(
  BuildContext context, {
  required String titulo,
  required String rotulo,
  String? inicial,
  String? exemplo,
  String confirmar = 'Salvar',
}) async {
  final texto = await showDialog<String>(
    context: context,
    builder: (_) => _DialogoTexto(titulo: titulo, rotulo: rotulo, inicial: inicial, exemplo: exemplo, confirmar: confirmar),
  );
  final limpo = texto?.trim();
  return limpo == null || limpo.isEmpty ? null : limpo;
}

class _DialogoTexto extends StatefulWidget {
  const _DialogoTexto({required this.titulo, required this.rotulo, this.inicial, this.exemplo, required this.confirmar});

  final String titulo;
  final String rotulo;
  final String? inicial;
  final String? exemplo;
  final String confirmar;

  @override
  State<_DialogoTexto> createState() => _DialogoTextoState();
}

class _DialogoTextoState extends State<_DialogoTexto> {
  late final _controle = TextEditingController(text: widget.inicial);

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: TextField(
        controller: _controle,
        autofocus: true,
        maxLength: 100,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: widget.rotulo, hintText: widget.exemplo),
        onSubmitted: (t) => Navigator.pop(context, t),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(context, _controle.text), child: Text(widget.confirmar)),
      ],
    );
  }
}

/// Pergunta antes de uma ação que não dá para desfazer.
Future<bool> confirmar(BuildContext context, {required String titulo, required String mensagem, required String acao}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(acao)),
      ],
    ),
  );
  return ok ?? false;
}
