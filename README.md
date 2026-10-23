# App Agenda

App de agenda e lembretes em português, feito em Flutter (Android primeiro).

## O que já funciona

- **Tarefas:** criar, editar, concluir, excluir (deslizando para o lado, com "Desfazer") e prazo opcional.
- **Eventos:** início e fim, ou dia inteiro, inclusive eventos de vários dias.
- **Calendário:** visão de mês, 2 semanas ou semana, com marcadores nos dias que têm eventos ou tarefas com prazo.

Notificações, alarmes e repetição vêm na próxima etapa.

## Tecnologia

- Flutter 3.47 / Dart 3.13
- [drift](https://drift.simonbinder.eu/) (SQLite local) para guardar os dados
- [Riverpod](https://riverpod.dev/) para o estado
- [table_calendar](https://pub.dev/packages/table_calendar) para o calendário

## Como rodar

```bash
flutter pub get
flutter run          # com um celular Android conectado ou um emulador
flutter test         # testes do banco e da tela de tarefas
```

Depois de mudar as tabelas em `lib/data/database.dart`, gere o código do banco de novo:

```bash
dart run build_runner build
```

## Estrutura

```
lib/
  main.dart               app, tema e idioma pt-BR
  data/database.dart      tabela de itens (tarefas e eventos) e consultas
  data/providers.dart     providers do Riverpod
  ui/                     telas: tarefas, calendário e formulário
  util/datas.dart         formatação de datas em português
```
