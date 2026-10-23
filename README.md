# App Agenda

App de agenda e lembretes em português, feito em Flutter (Android primeiro).

## O que já funciona

- **Tarefas:** criar, editar, concluir, excluir (deslizando para o lado, com "Desfazer") e prazo opcional.
- **Eventos:** início e fim, ou dia inteiro, inclusive eventos de vários dias.
- **Calendário:** visão de mês, 2 semanas ou semana, com marcadores nos dias que têm eventos ou tarefas com prazo.
- **Lembretes:** cada tarefa ou evento pode ter um lembrete que mostra uma notificação no horário escolhido. Ele pode se repetir a cada N minutos, horas, dias, semanas ou meses. A notificação tem os botões **Adiar** (soneca de 5 min a 1 hora) e, nas tarefas, **Concluir**. Tocar na notificação abre o item.

### Como os lembretes funcionam

O Android não deixa um app agendar avisos infinitos, então o app agenda as próximas ocorrências de cada lembrete (até 30 por lembrete e 400 no total) e refaz essa conta sempre que algo muda ou o app é aberto. Os avisos continuam valendo depois que o celular reinicia.

## Tecnologia

- Flutter 3.47 / Dart 3.13
- [drift](https://drift.simonbinder.eu/) (SQLite local) para guardar os dados
- [Riverpod](https://riverpod.dev/) para o estado
- [table_calendar](https://pub.dev/packages/table_calendar) para o calendário
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) para as notificações

## Como rodar

```bash
flutter pub get
flutter run          # com um celular Android conectado ou um emulador
flutter test         # testes do banco, da repetição e das telas
```

Depois de mudar as tabelas em `lib/data/database.dart`, gere o código do banco de novo:

```bash
dart run build_runner build
```

## Estrutura

```
lib/
  main.dart               app, tema e idioma pt-BR
  data/database.dart      tabelas de itens (tarefas e eventos) e lembretes
  data/providers.dart     providers do Riverpod
  notificacoes/           cálculo da repetição e agendamento das notificações
  ui/                     telas: tarefas, calendário e formulário
  util/datas.dart         formatação de datas em português
```
