import 'package:app_agenda/data/database.dart';
import 'package:app_agenda/notificacoes/repeticao.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Lembrete lembrete(DateTime quando, [Frequencia f = Frequencia.nenhuma, int intervalo = 1]) =>
      Lembrete(id: 1, itemId: 1, quando: quando, frequencia: f, intervalo: intervalo, sonecaMinutos: 10);

  final agora = DateTime(2026, 10, 23, 12, 0);

  test('lembrete sem repetição toca uma vez, só se ainda não passou', () {
    expect(proximasOcorrencias(lembrete(DateTime(2026, 10, 23, 15)), agora: agora), [DateTime(2026, 10, 23, 15)]);
    expect(proximasOcorrencias(lembrete(DateTime(2026, 10, 23, 9)), agora: agora), isEmpty);
  });

  test('a cada 2 horas, a partir de um início no passado', () {
    final l = lembrete(DateTime(2026, 10, 20, 8), Frequencia.horas, 2);
    expect(proximasOcorrencias(l, agora: agora, maximo: 3), [
      DateTime(2026, 10, 23, 14),
      DateTime(2026, 10, 23, 16),
      DateTime(2026, 10, 23, 18),
    ]);
  });

  test('a cada 15 minutos com início muito antigo continua certo', () {
    final l = lembrete(DateTime(2020, 1, 1, 0, 5), Frequencia.minutos, 15);
    expect(proximasOcorrencias(l, agora: agora, maximo: 2), [
      DateTime(2026, 10, 23, 12, 5),
      DateTime(2026, 10, 23, 12, 20),
    ]);
  });

  test('todo dia e toda semana mantêm o horário', () {
    expect(proximasOcorrencias(lembrete(DateTime(2026, 10, 1, 7, 30), Frequencia.dias), agora: agora, maximo: 2), [
      DateTime(2026, 10, 24, 7, 30),
      DateTime(2026, 10, 25, 7, 30),
    ]);
    expect(proximasOcorrencias(lembrete(DateTime(2026, 10, 2, 20), Frequencia.semanas), agora: agora, maximo: 1), [
      DateTime(2026, 10, 23, 20),
    ]);
  });

  test('todo mês no dia 31 cai no último dia dos meses curtos', () {
    final l = lembrete(DateTime(2027, 1, 31, 9), Frequencia.meses);
    expect(proximasOcorrencias(l, agora: agora, maximo: 4), [
      DateTime(2027, 1, 31, 9),
      DateTime(2027, 2, 28, 9),
      DateTime(2027, 3, 31, 9),
      DateTime(2027, 4, 30, 9),
    ]);
  });

  test('descreve a repetição em português', () {
    expect(descreverRepeticao(Frequencia.nenhuma, 1), 'Não se repete');
    expect(descreverRepeticao(Frequencia.dias, 1), 'Todo dia');
    expect(descreverRepeticao(Frequencia.horas, 2), 'A cada 2 horas');
    expect(descreverRepeticao(Frequencia.meses, 3), 'A cada 3 meses');
  });
}
