import 'package:intl/intl.dart';

DateTime inicioDoDia(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime fimDoDia(DateTime d) => DateTime(d.year, d.month, d.day + 1);

bool mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

final _data = DateFormat('EEE, d MMM y', 'pt_BR');
final _dataCurta = DateFormat('d MMM', 'pt_BR');
final _hora = DateFormat.Hm('pt_BR');

String formatarData(DateTime d) => _data.format(d);

String formatarHora(DateTime d) => _hora.format(d);

/// Texto curto como "hoje 14:30", "amanhã" ou "5 nov 09:00".
String formatarPrazo(DateTime d, {bool mostrarHora = true, DateTime? agora}) {
  final hoje = inicioDoDia(agora ?? DateTime.now());
  final dia = inicioDoDia(d);
  final String texto;
  if (dia == hoje) {
    texto = 'hoje';
  } else if (dia == hoje.add(const Duration(days: 1))) {
    texto = 'amanhã';
  } else if (dia == hoje.subtract(const Duration(days: 1))) {
    texto = 'ontem';
  } else {
    texto = _dataCurta.format(d);
  }
  return mostrarHora ? '$texto ${_hora.format(d)}' : texto;
}
