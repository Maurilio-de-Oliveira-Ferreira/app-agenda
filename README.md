# App Agenda

App de agenda e lembretes em português, feito em Flutter (Android primeiro).

## O que já funciona

- **Tarefas:** criar, editar, concluir, excluir (deslizando para o lado, com "Desfazer") e prazo opcional.
- **Eventos:** início e fim, ou dia inteiro, inclusive eventos de vários dias.
- **Calendário:** visão de mês, 2 semanas ou semana, com marcadores nos dias que têm eventos ou tarefas com prazo.
- **Lembretes:** cada tarefa ou evento pode ter um lembrete que mostra uma notificação no horário escolhido. Ele pode se repetir a cada N minutos, horas, dias, semanas ou meses. A notificação tem os botões **Adiar** (soneca de 5 min a 1 hora) e, nas tarefas, **Concluir**. Tocar na notificação abre o item.
- **Foto e voz:** cada tarefa ou evento pode ter fotos (da câmera ou da galeria) e recados de voz gravados no próprio app. A primeira foto aparece grande na notificação do lembrete. Se houver recado de voz, a notificação diz "Toque para ouvir o recado de voz" e, ao tocar nela, o app abre o item e já toca a gravação.
- **Listas de compras:** várias listas (Mercado, Farmácia...), cada uma com seus produtos. Tocar num produto marca como comprado (ele desce para "No carrinho"), o lápis edita nome e quantidade, e deslizar remove (com "Desfazer"). No menu da lista dá para renomear, desmarcar tudo para a próxima compra, remover os comprados ou excluir a lista.

### Como os lembretes funcionam

O Android não deixa um app agendar avisos infinitos, então o app agenda as próximas ocorrências de cada lembrete (até 30 por lembrete e 400 no total) e refaz essa conta sempre que algo muda ou o app é aberto. Os avisos continuam valendo depois que o celular reinicia.

### Onde ficam as fotos e gravações

Os arquivos ficam numa pasta interna do app (`anexos/`), e o banco guarda só o nome deles. Quando um item é excluído, os arquivos dele são apagados na próxima vez que o app abre (assim o "Desfazer" ainda consegue recuperar tudo).

## Tecnologia

- Flutter 3.47 / Dart 3.13
- [drift](https://drift.simonbinder.eu/) (SQLite local) para guardar os dados
- [Riverpod](https://riverpod.dev/) para o estado
- [table_calendar](https://pub.dev/packages/table_calendar) para o calendário
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) para as notificações
- [image_picker](https://pub.dev/packages/image_picker), [record](https://pub.dev/packages/record) e [audioplayers](https://pub.dev/packages/audioplayers) para fotos, gravação e reprodução de voz

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
  data/database.dart      tabelas de itens (tarefas e eventos), lembretes, anexos e listas de compras
  anexos/                 câmera, galeria, gravação de voz e a parte de anexos do formulário
  data/providers.dart     providers do Riverpod
  notificacoes/           cálculo da repetição e agendamento das notificações
  ui/                     telas: tarefas, calendário e formulário
  ui/compras/             telas das listas de compras
  util/datas.dart         formatação de datas em português
```
