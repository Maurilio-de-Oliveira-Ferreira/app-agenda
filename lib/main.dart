import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'anexos/midia.dart';
import 'data/providers.dart';
import 'notificacoes/agendador.dart';
import 'ui/home_page.dart';
import 'ui/navegacao.dart';
import 'whatsapp/whatsapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';

  final pasta = await pastaDosAnexos();
  final container = ProviderContainer(overrides: [
    agendadorProvider.overrideWithValue(AgendadorLocal(pastaAnexos: pasta)),
    midiaProvider.overrideWithValue(MidiaLocal(pasta)),
  ]);
  await container.read(agendadorProvider).iniciar(
        aoAbrirItem: (id) => abrirItem(container.read(databaseProvider), id),
        aoAbrirWhatsApp: abrirWhatsApp,
      );

  // Fotos e gravações de itens que já foram excluídos.
  final emUso = await container.read(databaseProvider).arquivosEmUso();
  container.read(midiaProvider).apagarSobras(emUso).ignore();

  runApp(UncontrolledProviderScope(container: container, child: const AgendaApp()));
}

class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
