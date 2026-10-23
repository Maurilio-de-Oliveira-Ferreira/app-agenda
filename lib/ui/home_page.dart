import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import 'calendario_page.dart';
import 'compras/listas_page.dart';
import 'navegacao.dart';
import 'tarefas_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with WidgetsBindingObserver {
  int _aba = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _abrirItemDaNotificacao();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Se o app foi aberto pelo toque numa notificação, mostra o item dela.
  Future<void> _abrirItemDaNotificacao() async {
    final id = await ref.read(agendadorProvider).itemQueAbriuOApp();
    if (id != null && mounted) await abrirItem(ref.read(databaseProvider), id);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // O botão "Concluir" da notificação grava no banco por fora do app;
      // isto faz as listas lerem de novo e reagenda os próximos avisos.
      final db = ref.read(databaseProvider);
      db.markTablesUpdated([db.itens, db.lembretes]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mantém as notificações em dia com os lembretes enquanto o app está aberto.
    ref.watch(sincronizarLembretesProvider);

    return Scaffold(
      body: IndexedStack(
        index: _aba,
        children: const [TarefasPage(), CalendarioPage(), ListasPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aba,
        onDestinationSelected: (i) => setState(() => _aba = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Tarefas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
        ],
      ),
    );
  }
}
