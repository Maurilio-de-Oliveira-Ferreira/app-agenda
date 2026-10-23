import 'package:app_agenda/data/database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  ItensCompanion tarefa(String titulo, {DateTime? prazo}) => ItensCompanion.insert(
        tipo: TipoItem.tarefa,
        titulo: titulo,
        inicio: Value(prazo),
      );

  ItensCompanion evento(String titulo, DateTime inicio, DateTime fim) => ItensCompanion.insert(
        tipo: TipoItem.evento,
        titulo: titulo,
        inicio: Value(inicio),
        fim: Value(fim),
      );

  test('cria, edita e exclui uma tarefa', () async {
    final id = await db.criar(tarefa('Comprar pão'));
    await db.atualizar(id, const ItensCompanion(titulo: Value('Comprar pão e leite')));

    var lista = await db.watchTarefas().first;
    expect(lista.single.titulo, 'Comprar pão e leite');

    await db.excluir(id);
    lista = await db.watchTarefas().first;
    expect(lista, isEmpty);
  });

  test('lista tarefas pendentes antes das concluídas, por prazo', () async {
    await db.criar(tarefa('Sem prazo'));
    await db.criar(tarefa('Depois', prazo: DateTime(2026, 11, 2)));
    final id = await db.criar(tarefa('Antes', prazo: DateTime(2026, 11, 1)));
    final feita = await db.watchTarefas().first.then((l) => l.firstWhere((t) => t.id == id));
    await db.alternarConcluida(feita);

    final titulos = (await db.watchTarefas().first).map((t) => t.titulo);
    expect(titulos, ['Depois', 'Sem prazo', 'Antes']);
  });

  test('busca eventos e tarefas com prazo dentro de um dia', () async {
    final dia = DateTime(2026, 11, 10);
    final fimDia = DateTime(2026, 11, 11);
    await db.criar(evento('Reunião', DateTime(2026, 11, 10, 14), DateTime(2026, 11, 10, 15)));
    await db.criar(evento('Viagem', DateTime(2026, 11, 8), DateTime(2026, 11, 12)));
    await db.criar(evento('Ontem', DateTime(2026, 11, 9, 10), DateTime(2026, 11, 9, 11)));
    await db.criar(evento('Termina meia-noite', DateTime(2026, 11, 9, 23), dia));
    await db.criar(tarefa('Pagar conta', prazo: DateTime(2026, 11, 10, 9)));
    await db.criar(tarefa('Sem prazo'));

    final titulos = (await db.watchItensEntre(dia, fimDia).first).map((i) => i.titulo);
    expect(titulos, ['Viagem', 'Pagar conta', 'Reunião']);
  });
  test('lembrete some quando a tarefa é concluída ou excluída', () async {
    final id = await db.criar(tarefa('Tomar remédio'));
    await db.definirLembrete(
      id,
      LembretesCompanion.insert(
        itemId: id,
        quando: DateTime(2026, 11, 1, 8),
        frequencia: const Value(Frequencia.horas),
        intervalo: const Value(8),
      ),
    );

    var ativos = await db.watchLembretesAtivos().first;
    expect(ativos.single.item.titulo, 'Tomar remédio');
    expect(ativos.single.lembrete.intervalo, 8);

    await db.alternarConcluida((await db.itemPorId(id))!);
    expect(await db.watchLembretesAtivos().first, isEmpty);

    await db.excluir(id);
    expect(await db.lembreteDoItem(id), isNull);
  });

  test('definir o lembrete de novo substitui o anterior', () async {
    final id = await db.criar(tarefa('Ligar para o banco'));
    await db.definirLembrete(id, LembretesCompanion.insert(itemId: id, quando: DateTime(2026, 11, 1, 8)));
    await db.definirLembrete(id, LembretesCompanion.insert(itemId: id, quando: DateTime(2026, 11, 2, 9)));

    final porItem = await db.watchLembretesPorItem().first;
    expect(porItem[id]!.quando, DateTime(2026, 11, 2, 9));
    expect(porItem.length, 1);

    await db.definirLembrete(id, null);
    expect(await db.lembreteDoItem(id), isNull);
  });
}
