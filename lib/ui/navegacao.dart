import 'package:flutter/material.dart';

import '../data/database.dart';
import 'item_form_page.dart';

/// Permite abrir uma tela a partir do toque numa notificação.
final navigatorKey = GlobalKey<NavigatorState>();

/// Abre a tela de edição da tarefa ou do evento [id], se ele ainda existir.
/// Como vem de uma notificação, já toca o recado de voz, se houver.
Future<void> abrirItem(AppDatabase db, int id) async {
  final item = await db.itemPorId(id);
  if (item == null) return;
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => ItemFormPage(tipo: item.tipo, item: item, tocarAudio: true),
    ),
  );
}
