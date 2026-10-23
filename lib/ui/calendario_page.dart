import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../util/datas.dart';
import 'item_form_page.dart';
import 'item_tile.dart';

class CalendarioPage extends ConsumerStatefulWidget {
  const CalendarioPage({super.key});

  @override
  ConsumerState<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends ConsumerState<CalendarioPage> {
  DateTime _mesVisivel = inicioDoDia(DateTime.now());
  DateTime _diaSelecionado = inicioDoDia(DateTime.now());
  CalendarFormat _formato = CalendarFormat.month;

  /// Mês visível com uma semana de folga em cada lado, para marcar os dias
  /// dos meses vizinhos que aparecem na grade.
  Periodo get _periodoDoMes => (
        inicio: DateTime(_mesVisivel.year, _mesVisivel.month, 1 - 7),
        fim: DateTime(_mesVisivel.year, _mesVisivel.month + 1, 1 + 7),
      );

  @override
  Widget build(BuildContext context) {
    final doMes = ref.watch(itensNoPeriodoProvider(_periodoDoMes)).value ?? const <Item>[];
    final doDia = ref.watch(itensNoPeriodoProvider(
        (inicio: _diaSelecionado, fim: fimDoDia(_diaSelecionado))));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
        actions: [
          IconButton(
            tooltip: 'Hoje',
            icon: const Icon(Icons.today),
            onPressed: () => setState(() {
              _diaSelecionado = inicioDoDia(DateTime.now());
              _mesVisivel = _diaSelecionado;
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Item>(
            locale: 'pt_BR',
            firstDay: DateTime(2000),
            lastDay: DateTime(2100, 12, 31),
            focusedDay: _mesVisivel,
            calendarFormat: _formato,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mês',
              CalendarFormat.twoWeeks: '2 semanas',
              CalendarFormat.week: 'Semana',
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            selectedDayPredicate: (d) => isSameDay(d, _diaSelecionado),
            eventLoader: (dia) => _itensDoDia(doMes, dia),
            onDaySelected: (selecionado, focado) => setState(() {
              _diaSelecionado = inicioDoDia(selecionado);
              _mesVisivel = focado;
            }),
            onFormatChanged: (f) => setState(() => _formato = f),
            onPageChanged: (focado) => setState(() => _mesVisivel = focado),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(formatarData(_diaSelecionado),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          Expanded(
            child: doDia.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
              data: (lista) => lista.isEmpty
                  ? const Center(child: Text('Nada marcado para este dia.'))
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 88),
                      children: [
                        for (final i in lista)
                          ItemTile(item: i, diaDaLista: _diaSelecionado),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        tooltip: 'Novo evento',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ItemFormPage(
            tipo: TipoItem.evento,
            diaInicial: _diaSelecionado,
          ),
        )),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Item> _itensDoDia(List<Item> itens, DateTime dia) {
    final inicio = inicioDoDia(dia);
    final fim = fimDoDia(dia);
    return itens.where((i) {
      final ini = i.inicio!;
      if (!ini.isBefore(fim)) return false;
      final f = i.fim;
      return !ini.isBefore(inicio) || (f != null && f.isAfter(inicio));
    }).toList();
  }
}
