import '../data/database.dart';

/// Soma [vezes] intervalos de [frequencia] a [data].
///
/// Dias, semanas e meses são somados no calendário, então o horário se mantém
/// mesmo com horário de verão. Em meses mais curtos, o dia 31 vira o último
/// dia do mês.
DateTime somarIntervalo(DateTime data, Frequencia frequencia, int vezes) {
  switch (frequencia) {
    case Frequencia.nenhuma:
      return data;
    case Frequencia.minutos:
      return data.add(Duration(minutes: vezes));
    case Frequencia.horas:
      return data.add(Duration(hours: vezes));
    case Frequencia.dias:
      return DateTime(data.year, data.month, data.day + vezes, data.hour, data.minute);
    case Frequencia.semanas:
      return DateTime(data.year, data.month, data.day + 7 * vezes, data.hour, data.minute);
    case Frequencia.meses:
      final ultimoDia = DateTime(data.year, data.month + vezes + 1, 0).day;
      final dia = data.day > ultimoDia ? ultimoDia : data.day;
      return DateTime(data.year, data.month + vezes, dia, data.hour, data.minute);
  }
}

/// As próximas vezes, depois de [agora], em que o lembrete deve tocar.
///
/// Um lembrete sem repetição toca no máximo uma vez. Um lembrete que se
/// repete devolve até [maximo] ocorrências.
List<DateTime> proximasOcorrencias(Lembrete lembrete, {required DateTime agora, int maximo = 30}) {
  final inicio = lembrete.quando;
  final passo = lembrete.intervalo < 1 ? 1 : lembrete.intervalo;

  if (lembrete.frequencia == Frequencia.nenhuma) {
    return inicio.isAfter(agora) ? [inicio] : [];
  }

  // Pula direto para perto de "agora" em vez de somar de um em um desde o
  // início, que pode estar muito no passado.
  var n = 0;
  if (!inicio.isAfter(agora)) {
    final minutos = agora.difference(inicio).inMinutes;
    final aproximado = switch (lembrete.frequencia) {
      Frequencia.minutos => minutos ~/ passo,
      Frequencia.horas => minutos ~/ (60 * passo),
      Frequencia.dias => minutos ~/ (60 * 24 * passo),
      Frequencia.semanas => minutos ~/ (60 * 24 * 7 * passo),
      Frequencia.meses => minutos ~/ (60 * 24 * 31 * passo),
      Frequencia.nenhuma => 0,
    };
    n = aproximado > 1 ? aproximado - 1 : 0;
  }

  final ocorrencias = <DateTime>[];
  while (ocorrencias.length < maximo) {
    // Sempre a partir do início, para o dia 31 não "escorregar" mês a mês.
    final data = somarIntervalo(inicio, lembrete.frequencia, n * passo);
    if (data.isAfter(agora)) ocorrencias.add(data);
    n++;
  }
  return ocorrencias;
}

/// Texto como "Não se repete", "Todo dia" ou "A cada 2 horas".
String descreverRepeticao(Frequencia frequencia, int intervalo) {
  if (frequencia == Frequencia.nenhuma) return 'Não se repete';
  if (intervalo <= 1) {
    return switch (frequencia) {
      Frequencia.minutos => 'A cada minuto',
      Frequencia.horas => 'A cada hora',
      Frequencia.dias => 'Todo dia',
      Frequencia.semanas => 'Toda semana',
      Frequencia.meses => 'Todo mês',
      Frequencia.nenhuma => 'Não se repete',
    };
  }
  return 'A cada $intervalo ${nomeDaUnidade(frequencia, intervalo)}';
}

/// "minuto"/"minutos", "mês"/"meses" etc.
String nomeDaUnidade(Frequencia frequencia, int quantidade) {
  final plural = quantidade != 1;
  return switch (frequencia) {
    Frequencia.minutos => plural ? 'minutos' : 'minuto',
    Frequencia.horas => plural ? 'horas' : 'hora',
    Frequencia.dias => plural ? 'dias' : 'dia',
    Frequencia.semanas => plural ? 'semanas' : 'semana',
    Frequencia.meses => plural ? 'meses' : 'mês',
    Frequencia.nenhuma => '',
  };
}
