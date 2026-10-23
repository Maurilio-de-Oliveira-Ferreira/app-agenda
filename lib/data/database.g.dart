// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ItensTable extends Itens with TableInfo<$ItensTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoItem, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoItem>($ItensTable.$convertertipo);
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  @override
  late final GeneratedColumn<DateTime> inicio = GeneratedColumn<DateTime>(
    'inicio',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fimMeta = const VerificationMeta('fim');
  @override
  late final GeneratedColumn<DateTime> fim = GeneratedColumn<DateTime>(
    'fim',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diaInteiroMeta = const VerificationMeta(
    'diaInteiro',
  );
  @override
  late final GeneratedColumn<bool> diaInteiro = GeneratedColumn<bool>(
    'dia_inteiro',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dia_inteiro" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _concluidaMeta = const VerificationMeta(
    'concluida',
  );
  @override
  late final GeneratedColumn<bool> concluida = GeneratedColumn<bool>(
    'concluida',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("concluida" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    titulo,
    descricao,
    inicio,
    fim,
    diaInteiro,
    concluida,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itens';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    if (data.containsKey('inicio')) {
      context.handle(
        _inicioMeta,
        inicio.isAcceptableOrUnknown(data['inicio']!, _inicioMeta),
      );
    }
    if (data.containsKey('fim')) {
      context.handle(
        _fimMeta,
        fim.isAcceptableOrUnknown(data['fim']!, _fimMeta),
      );
    }
    if (data.containsKey('dia_inteiro')) {
      context.handle(
        _diaInteiroMeta,
        diaInteiro.isAcceptableOrUnknown(data['dia_inteiro']!, _diaInteiroMeta),
      );
    }
    if (data.containsKey('concluida')) {
      context.handle(
        _concluidaMeta,
        concluida.isAcceptableOrUnknown(data['concluida']!, _concluidaMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: $ItensTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
      inicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inicio'],
      ),
      fim: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fim'],
      ),
      diaInteiro: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dia_inteiro'],
      )!,
      concluida: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}concluida'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $ItensTable createAlias(String alias) {
    return $ItensTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoItem, int, int> $convertertipo =
      const EnumIndexConverter<TipoItem>(TipoItem.values);
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final TipoItem tipo;
  final String titulo;
  final String? descricao;
  final DateTime? inicio;
  final DateTime? fim;
  final bool diaInteiro;
  final bool concluida;
  final DateTime criadoEm;
  const Item({
    required this.id,
    required this.tipo,
    required this.titulo,
    this.descricao,
    this.inicio,
    this.fim,
    required this.diaInteiro,
    required this.concluida,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tipo'] = Variable<int>($ItensTable.$convertertipo.toSql(tipo));
    }
    map['titulo'] = Variable<String>(titulo);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    if (!nullToAbsent || inicio != null) {
      map['inicio'] = Variable<DateTime>(inicio);
    }
    if (!nullToAbsent || fim != null) {
      map['fim'] = Variable<DateTime>(fim);
    }
    map['dia_inteiro'] = Variable<bool>(diaInteiro);
    map['concluida'] = Variable<bool>(concluida);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  ItensCompanion toCompanion(bool nullToAbsent) {
    return ItensCompanion(
      id: Value(id),
      tipo: Value(tipo),
      titulo: Value(titulo),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      inicio: inicio == null && nullToAbsent
          ? const Value.absent()
          : Value(inicio),
      fim: fim == null && nullToAbsent ? const Value.absent() : Value(fim),
      diaInteiro: Value(diaInteiro),
      concluida: Value(concluida),
      criadoEm: Value(criadoEm),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      tipo: $ItensTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      titulo: serializer.fromJson<String>(json['titulo']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      inicio: serializer.fromJson<DateTime?>(json['inicio']),
      fim: serializer.fromJson<DateTime?>(json['fim']),
      diaInteiro: serializer.fromJson<bool>(json['diaInteiro']),
      concluida: serializer.fromJson<bool>(json['concluida']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<int>($ItensTable.$convertertipo.toJson(tipo)),
      'titulo': serializer.toJson<String>(titulo),
      'descricao': serializer.toJson<String?>(descricao),
      'inicio': serializer.toJson<DateTime?>(inicio),
      'fim': serializer.toJson<DateTime?>(fim),
      'diaInteiro': serializer.toJson<bool>(diaInteiro),
      'concluida': serializer.toJson<bool>(concluida),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Item copyWith({
    int? id,
    TipoItem? tipo,
    String? titulo,
    Value<String?> descricao = const Value.absent(),
    Value<DateTime?> inicio = const Value.absent(),
    Value<DateTime?> fim = const Value.absent(),
    bool? diaInteiro,
    bool? concluida,
    DateTime? criadoEm,
  }) => Item(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    titulo: titulo ?? this.titulo,
    descricao: descricao.present ? descricao.value : this.descricao,
    inicio: inicio.present ? inicio.value : this.inicio,
    fim: fim.present ? fim.value : this.fim,
    diaInteiro: diaInteiro ?? this.diaInteiro,
    concluida: concluida ?? this.concluida,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  Item copyWithCompanion(ItensCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      inicio: data.inicio.present ? data.inicio.value : this.inicio,
      fim: data.fim.present ? data.fim.value : this.fim,
      diaInteiro: data.diaInteiro.present
          ? data.diaInteiro.value
          : this.diaInteiro,
      concluida: data.concluida.present ? data.concluida.value : this.concluida,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('inicio: $inicio, ')
          ..write('fim: $fim, ')
          ..write('diaInteiro: $diaInteiro, ')
          ..write('concluida: $concluida, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    titulo,
    descricao,
    inicio,
    fim,
    diaInteiro,
    concluida,
    criadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.titulo == this.titulo &&
          other.descricao == this.descricao &&
          other.inicio == this.inicio &&
          other.fim == this.fim &&
          other.diaInteiro == this.diaInteiro &&
          other.concluida == this.concluida &&
          other.criadoEm == this.criadoEm);
}

class ItensCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<TipoItem> tipo;
  final Value<String> titulo;
  final Value<String?> descricao;
  final Value<DateTime?> inicio;
  final Value<DateTime?> fim;
  final Value<bool> diaInteiro;
  final Value<bool> concluida;
  final Value<DateTime> criadoEm;
  const ItensCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descricao = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fim = const Value.absent(),
    this.diaInteiro = const Value.absent(),
    this.concluida = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  ItensCompanion.insert({
    this.id = const Value.absent(),
    required TipoItem tipo,
    required String titulo,
    this.descricao = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fim = const Value.absent(),
    this.diaInteiro = const Value.absent(),
    this.concluida = const Value.absent(),
    this.criadoEm = const Value.absent(),
  }) : tipo = Value(tipo),
       titulo = Value(titulo);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<int>? tipo,
    Expression<String>? titulo,
    Expression<String>? descricao,
    Expression<DateTime>? inicio,
    Expression<DateTime>? fim,
    Expression<bool>? diaInteiro,
    Expression<bool>? concluida,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (titulo != null) 'titulo': titulo,
      if (descricao != null) 'descricao': descricao,
      if (inicio != null) 'inicio': inicio,
      if (fim != null) 'fim': fim,
      if (diaInteiro != null) 'dia_inteiro': diaInteiro,
      if (concluida != null) 'concluida': concluida,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  ItensCompanion copyWith({
    Value<int>? id,
    Value<TipoItem>? tipo,
    Value<String>? titulo,
    Value<String?>? descricao,
    Value<DateTime?>? inicio,
    Value<DateTime?>? fim,
    Value<bool>? diaInteiro,
    Value<bool>? concluida,
    Value<DateTime>? criadoEm,
  }) {
    return ItensCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      inicio: inicio ?? this.inicio,
      fim: fim ?? this.fim,
      diaInteiro: diaInteiro ?? this.diaInteiro,
      concluida: concluida ?? this.concluida,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>($ItensTable.$convertertipo.toSql(tipo.value));
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (inicio.present) {
      map['inicio'] = Variable<DateTime>(inicio.value);
    }
    if (fim.present) {
      map['fim'] = Variable<DateTime>(fim.value);
    }
    if (diaInteiro.present) {
      map['dia_inteiro'] = Variable<bool>(diaInteiro.value);
    }
    if (concluida.present) {
      map['concluida'] = Variable<bool>(concluida.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItensCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('descricao: $descricao, ')
          ..write('inicio: $inicio, ')
          ..write('fim: $fim, ')
          ..write('diaInteiro: $diaInteiro, ')
          ..write('concluida: $concluida, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $LembretesTable extends Lembretes
    with TableInfo<$LembretesTable, Lembrete> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LembretesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES itens (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _quandoMeta = const VerificationMeta('quando');
  @override
  late final GeneratedColumn<DateTime> quando = GeneratedColumn<DateTime>(
    'quando',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Frequencia, int> frequencia =
      GeneratedColumn<int>(
        'frequencia',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Frequencia>($LembretesTable.$converterfrequencia);
  static const VerificationMeta _intervaloMeta = const VerificationMeta(
    'intervalo',
  );
  @override
  late final GeneratedColumn<int> intervalo = GeneratedColumn<int>(
    'intervalo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sonecaMinutosMeta = const VerificationMeta(
    'sonecaMinutos',
  );
  @override
  late final GeneratedColumn<int> sonecaMinutos = GeneratedColumn<int>(
    'soneca_minutos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    quando,
    frequencia,
    intervalo,
    sonecaMinutos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lembretes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lembrete> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quando')) {
      context.handle(
        _quandoMeta,
        quando.isAcceptableOrUnknown(data['quando']!, _quandoMeta),
      );
    } else if (isInserting) {
      context.missing(_quandoMeta);
    }
    if (data.containsKey('intervalo')) {
      context.handle(
        _intervaloMeta,
        intervalo.isAcceptableOrUnknown(data['intervalo']!, _intervaloMeta),
      );
    }
    if (data.containsKey('soneca_minutos')) {
      context.handle(
        _sonecaMinutosMeta,
        sonecaMinutos.isAcceptableOrUnknown(
          data['soneca_minutos']!,
          _sonecaMinutosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lembrete map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lembrete(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      quando: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}quando'],
      )!,
      frequencia: $LembretesTable.$converterfrequencia.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}frequencia'],
        )!,
      ),
      intervalo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intervalo'],
      )!,
      sonecaMinutos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}soneca_minutos'],
      )!,
    );
  }

  @override
  $LembretesTable createAlias(String alias) {
    return $LembretesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Frequencia, int, int> $converterfrequencia =
      const EnumIndexConverter<Frequencia>(Frequencia.values);
}

class Lembrete extends DataClass implements Insertable<Lembrete> {
  final int id;
  final int itemId;
  final DateTime quando;
  final Frequencia frequencia;
  final int intervalo;

  /// Quantos minutos o botão "Adiar" da notificação espera.
  final int sonecaMinutos;
  const Lembrete({
    required this.id,
    required this.itemId,
    required this.quando,
    required this.frequencia,
    required this.intervalo,
    required this.sonecaMinutos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['quando'] = Variable<DateTime>(quando);
    {
      map['frequencia'] = Variable<int>(
        $LembretesTable.$converterfrequencia.toSql(frequencia),
      );
    }
    map['intervalo'] = Variable<int>(intervalo);
    map['soneca_minutos'] = Variable<int>(sonecaMinutos);
    return map;
  }

  LembretesCompanion toCompanion(bool nullToAbsent) {
    return LembretesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      quando: Value(quando),
      frequencia: Value(frequencia),
      intervalo: Value(intervalo),
      sonecaMinutos: Value(sonecaMinutos),
    );
  }

  factory Lembrete.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lembrete(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      quando: serializer.fromJson<DateTime>(json['quando']),
      frequencia: $LembretesTable.$converterfrequencia.fromJson(
        serializer.fromJson<int>(json['frequencia']),
      ),
      intervalo: serializer.fromJson<int>(json['intervalo']),
      sonecaMinutos: serializer.fromJson<int>(json['sonecaMinutos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'quando': serializer.toJson<DateTime>(quando),
      'frequencia': serializer.toJson<int>(
        $LembretesTable.$converterfrequencia.toJson(frequencia),
      ),
      'intervalo': serializer.toJson<int>(intervalo),
      'sonecaMinutos': serializer.toJson<int>(sonecaMinutos),
    };
  }

  Lembrete copyWith({
    int? id,
    int? itemId,
    DateTime? quando,
    Frequencia? frequencia,
    int? intervalo,
    int? sonecaMinutos,
  }) => Lembrete(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    quando: quando ?? this.quando,
    frequencia: frequencia ?? this.frequencia,
    intervalo: intervalo ?? this.intervalo,
    sonecaMinutos: sonecaMinutos ?? this.sonecaMinutos,
  );
  Lembrete copyWithCompanion(LembretesCompanion data) {
    return Lembrete(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quando: data.quando.present ? data.quando.value : this.quando,
      frequencia: data.frequencia.present
          ? data.frequencia.value
          : this.frequencia,
      intervalo: data.intervalo.present ? data.intervalo.value : this.intervalo,
      sonecaMinutos: data.sonecaMinutos.present
          ? data.sonecaMinutos.value
          : this.sonecaMinutos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lembrete(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('quando: $quando, ')
          ..write('frequencia: $frequencia, ')
          ..write('intervalo: $intervalo, ')
          ..write('sonecaMinutos: $sonecaMinutos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, quando, frequencia, intervalo, sonecaMinutos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lembrete &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.quando == this.quando &&
          other.frequencia == this.frequencia &&
          other.intervalo == this.intervalo &&
          other.sonecaMinutos == this.sonecaMinutos);
}

class LembretesCompanion extends UpdateCompanion<Lembrete> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<DateTime> quando;
  final Value<Frequencia> frequencia;
  final Value<int> intervalo;
  final Value<int> sonecaMinutos;
  const LembretesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quando = const Value.absent(),
    this.frequencia = const Value.absent(),
    this.intervalo = const Value.absent(),
    this.sonecaMinutos = const Value.absent(),
  });
  LembretesCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required DateTime quando,
    this.frequencia = const Value.absent(),
    this.intervalo = const Value.absent(),
    this.sonecaMinutos = const Value.absent(),
  }) : itemId = Value(itemId),
       quando = Value(quando);
  static Insertable<Lembrete> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<DateTime>? quando,
    Expression<int>? frequencia,
    Expression<int>? intervalo,
    Expression<int>? sonecaMinutos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (quando != null) 'quando': quando,
      if (frequencia != null) 'frequencia': frequencia,
      if (intervalo != null) 'intervalo': intervalo,
      if (sonecaMinutos != null) 'soneca_minutos': sonecaMinutos,
    });
  }

  LembretesCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<DateTime>? quando,
    Value<Frequencia>? frequencia,
    Value<int>? intervalo,
    Value<int>? sonecaMinutos,
  }) {
    return LembretesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      quando: quando ?? this.quando,
      frequencia: frequencia ?? this.frequencia,
      intervalo: intervalo ?? this.intervalo,
      sonecaMinutos: sonecaMinutos ?? this.sonecaMinutos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (quando.present) {
      map['quando'] = Variable<DateTime>(quando.value);
    }
    if (frequencia.present) {
      map['frequencia'] = Variable<int>(
        $LembretesTable.$converterfrequencia.toSql(frequencia.value),
      );
    }
    if (intervalo.present) {
      map['intervalo'] = Variable<int>(intervalo.value);
    }
    if (sonecaMinutos.present) {
      map['soneca_minutos'] = Variable<int>(sonecaMinutos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LembretesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('quando: $quando, ')
          ..write('frequencia: $frequencia, ')
          ..write('intervalo: $intervalo, ')
          ..write('sonecaMinutos: $sonecaMinutos')
          ..write(')'))
        .toString();
  }
}

class $ListasTable extends Listas with TableInfo<$ListasTable, ListaCompras> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'listas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListaCompras> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListaCompras map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListaCompras(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $ListasTable createAlias(String alias) {
    return $ListasTable(attachedDatabase, alias);
  }
}

class ListaCompras extends DataClass implements Insertable<ListaCompras> {
  final int id;
  final String nome;
  final DateTime criadoEm;
  const ListaCompras({
    required this.id,
    required this.nome,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  ListasCompanion toCompanion(bool nullToAbsent) {
    return ListasCompanion(
      id: Value(id),
      nome: Value(nome),
      criadoEm: Value(criadoEm),
    );
  }

  factory ListaCompras.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListaCompras(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  ListaCompras copyWith({int? id, String? nome, DateTime? criadoEm}) =>
      ListaCompras(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  ListaCompras copyWithCompanion(ListasCompanion data) {
    return ListaCompras(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListaCompras(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListaCompras &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.criadoEm == this.criadoEm);
}

class ListasCompanion extends UpdateCompanion<ListaCompras> {
  final Value<int> id;
  final Value<String> nome;
  final Value<DateTime> criadoEm;
  const ListasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  ListasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.criadoEm = const Value.absent(),
  }) : nome = Value(nome);
  static Insertable<ListaCompras> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  ListasCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<DateTime>? criadoEm,
  }) {
    return ListasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $ProdutosTable extends Produtos with TableInfo<$ProdutosTable, Produto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdutosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listaIdMeta = const VerificationMeta(
    'listaId',
  );
  @override
  late final GeneratedColumn<int> listaId = GeneratedColumn<int>(
    'lista_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES listas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantidadeMeta = const VerificationMeta(
    'quantidade',
  );
  @override
  late final GeneratedColumn<String> quantidade = GeneratedColumn<String>(
    'quantidade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _compradoMeta = const VerificationMeta(
    'comprado',
  );
  @override
  late final GeneratedColumn<bool> comprado = GeneratedColumn<bool>(
    'comprado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("comprado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listaId,
    nome,
    quantidade,
    comprado,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produtos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Produto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lista_id')) {
      context.handle(
        _listaIdMeta,
        listaId.isAcceptableOrUnknown(data['lista_id']!, _listaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listaIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('quantidade')) {
      context.handle(
        _quantidadeMeta,
        quantidade.isAcceptableOrUnknown(data['quantidade']!, _quantidadeMeta),
      );
    }
    if (data.containsKey('comprado')) {
      context.handle(
        _compradoMeta,
        comprado.isAcceptableOrUnknown(data['comprado']!, _compradoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Produto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Produto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lista_id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      quantidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantidade'],
      ),
      comprado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}comprado'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $ProdutosTable createAlias(String alias) {
    return $ProdutosTable(attachedDatabase, alias);
  }
}

class Produto extends DataClass implements Insertable<Produto> {
  final int id;
  final int listaId;
  final String nome;

  /// Texto livre, como "2 kg" ou "1 caixa".
  final String? quantidade;
  final bool comprado;
  final DateTime criadoEm;
  const Produto({
    required this.id,
    required this.listaId,
    required this.nome,
    this.quantidade,
    required this.comprado,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lista_id'] = Variable<int>(listaId);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || quantidade != null) {
      map['quantidade'] = Variable<String>(quantidade);
    }
    map['comprado'] = Variable<bool>(comprado);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  ProdutosCompanion toCompanion(bool nullToAbsent) {
    return ProdutosCompanion(
      id: Value(id),
      listaId: Value(listaId),
      nome: Value(nome),
      quantidade: quantidade == null && nullToAbsent
          ? const Value.absent()
          : Value(quantidade),
      comprado: Value(comprado),
      criadoEm: Value(criadoEm),
    );
  }

  factory Produto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Produto(
      id: serializer.fromJson<int>(json['id']),
      listaId: serializer.fromJson<int>(json['listaId']),
      nome: serializer.fromJson<String>(json['nome']),
      quantidade: serializer.fromJson<String?>(json['quantidade']),
      comprado: serializer.fromJson<bool>(json['comprado']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listaId': serializer.toJson<int>(listaId),
      'nome': serializer.toJson<String>(nome),
      'quantidade': serializer.toJson<String?>(quantidade),
      'comprado': serializer.toJson<bool>(comprado),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Produto copyWith({
    int? id,
    int? listaId,
    String? nome,
    Value<String?> quantidade = const Value.absent(),
    bool? comprado,
    DateTime? criadoEm,
  }) => Produto(
    id: id ?? this.id,
    listaId: listaId ?? this.listaId,
    nome: nome ?? this.nome,
    quantidade: quantidade.present ? quantidade.value : this.quantidade,
    comprado: comprado ?? this.comprado,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  Produto copyWithCompanion(ProdutosCompanion data) {
    return Produto(
      id: data.id.present ? data.id.value : this.id,
      listaId: data.listaId.present ? data.listaId.value : this.listaId,
      nome: data.nome.present ? data.nome.value : this.nome,
      quantidade: data.quantidade.present
          ? data.quantidade.value
          : this.quantidade,
      comprado: data.comprado.present ? data.comprado.value : this.comprado,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Produto(')
          ..write('id: $id, ')
          ..write('listaId: $listaId, ')
          ..write('nome: $nome, ')
          ..write('quantidade: $quantidade, ')
          ..write('comprado: $comprado, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, listaId, nome, quantidade, comprado, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produto &&
          other.id == this.id &&
          other.listaId == this.listaId &&
          other.nome == this.nome &&
          other.quantidade == this.quantidade &&
          other.comprado == this.comprado &&
          other.criadoEm == this.criadoEm);
}

class ProdutosCompanion extends UpdateCompanion<Produto> {
  final Value<int> id;
  final Value<int> listaId;
  final Value<String> nome;
  final Value<String?> quantidade;
  final Value<bool> comprado;
  final Value<DateTime> criadoEm;
  const ProdutosCompanion({
    this.id = const Value.absent(),
    this.listaId = const Value.absent(),
    this.nome = const Value.absent(),
    this.quantidade = const Value.absent(),
    this.comprado = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  ProdutosCompanion.insert({
    this.id = const Value.absent(),
    required int listaId,
    required String nome,
    this.quantidade = const Value.absent(),
    this.comprado = const Value.absent(),
    this.criadoEm = const Value.absent(),
  }) : listaId = Value(listaId),
       nome = Value(nome);
  static Insertable<Produto> custom({
    Expression<int>? id,
    Expression<int>? listaId,
    Expression<String>? nome,
    Expression<String>? quantidade,
    Expression<bool>? comprado,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listaId != null) 'lista_id': listaId,
      if (nome != null) 'nome': nome,
      if (quantidade != null) 'quantidade': quantidade,
      if (comprado != null) 'comprado': comprado,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  ProdutosCompanion copyWith({
    Value<int>? id,
    Value<int>? listaId,
    Value<String>? nome,
    Value<String?>? quantidade,
    Value<bool>? comprado,
    Value<DateTime>? criadoEm,
  }) {
    return ProdutosCompanion(
      id: id ?? this.id,
      listaId: listaId ?? this.listaId,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listaId.present) {
      map['lista_id'] = Variable<int>(listaId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (quantidade.present) {
      map['quantidade'] = Variable<String>(quantidade.value);
    }
    if (comprado.present) {
      map['comprado'] = Variable<bool>(comprado.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdutosCompanion(')
          ..write('id: $id, ')
          ..write('listaId: $listaId, ')
          ..write('nome: $nome, ')
          ..write('quantidade: $quantidade, ')
          ..write('comprado: $comprado, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

class $AnexosTable extends Anexos with TableInfo<$AnexosTable, Anexo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnexosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES itens (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoAnexo, int> tipo =
      GeneratedColumn<int>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<TipoAnexo>($AnexosTable.$convertertipo);
  static const VerificationMeta _arquivoMeta = const VerificationMeta(
    'arquivo',
  );
  @override
  late final GeneratedColumn<String> arquivo = GeneratedColumn<String>(
    'arquivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _duracaoMsMeta = const VerificationMeta(
    'duracaoMs',
  );
  @override
  late final GeneratedColumn<int> duracaoMs = GeneratedColumn<int>(
    'duracao_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    tipo,
    arquivo,
    duracaoMs,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anexos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Anexo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('arquivo')) {
      context.handle(
        _arquivoMeta,
        arquivo.isAcceptableOrUnknown(data['arquivo']!, _arquivoMeta),
      );
    } else if (isInserting) {
      context.missing(_arquivoMeta);
    }
    if (data.containsKey('duracao_ms')) {
      context.handle(
        _duracaoMsMeta,
        duracaoMs.isAcceptableOrUnknown(data['duracao_ms']!, _duracaoMsMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Anexo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Anexo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      tipo: $AnexosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      arquivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arquivo'],
      )!,
      duracaoMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duracao_ms'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $AnexosTable createAlias(String alias) {
    return $AnexosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoAnexo, int, int> $convertertipo =
      const EnumIndexConverter<TipoAnexo>(TipoAnexo.values);
}

class Anexo extends DataClass implements Insertable<Anexo> {
  final int id;
  final int itemId;
  final TipoAnexo tipo;
  final String arquivo;

  /// Duração das gravações, para mostrar sem abrir o arquivo.
  final int? duracaoMs;
  final DateTime criadoEm;
  const Anexo({
    required this.id,
    required this.itemId,
    required this.tipo,
    required this.arquivo,
    this.duracaoMs,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    {
      map['tipo'] = Variable<int>($AnexosTable.$convertertipo.toSql(tipo));
    }
    map['arquivo'] = Variable<String>(arquivo);
    if (!nullToAbsent || duracaoMs != null) {
      map['duracao_ms'] = Variable<int>(duracaoMs);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  AnexosCompanion toCompanion(bool nullToAbsent) {
    return AnexosCompanion(
      id: Value(id),
      itemId: Value(itemId),
      tipo: Value(tipo),
      arquivo: Value(arquivo),
      duracaoMs: duracaoMs == null && nullToAbsent
          ? const Value.absent()
          : Value(duracaoMs),
      criadoEm: Value(criadoEm),
    );
  }

  factory Anexo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Anexo(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      tipo: $AnexosTable.$convertertipo.fromJson(
        serializer.fromJson<int>(json['tipo']),
      ),
      arquivo: serializer.fromJson<String>(json['arquivo']),
      duracaoMs: serializer.fromJson<int?>(json['duracaoMs']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'tipo': serializer.toJson<int>($AnexosTable.$convertertipo.toJson(tipo)),
      'arquivo': serializer.toJson<String>(arquivo),
      'duracaoMs': serializer.toJson<int?>(duracaoMs),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Anexo copyWith({
    int? id,
    int? itemId,
    TipoAnexo? tipo,
    String? arquivo,
    Value<int?> duracaoMs = const Value.absent(),
    DateTime? criadoEm,
  }) => Anexo(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    tipo: tipo ?? this.tipo,
    arquivo: arquivo ?? this.arquivo,
    duracaoMs: duracaoMs.present ? duracaoMs.value : this.duracaoMs,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  Anexo copyWithCompanion(AnexosCompanion data) {
    return Anexo(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      arquivo: data.arquivo.present ? data.arquivo.value : this.arquivo,
      duracaoMs: data.duracaoMs.present ? data.duracaoMs.value : this.duracaoMs,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Anexo(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('tipo: $tipo, ')
          ..write('arquivo: $arquivo, ')
          ..write('duracaoMs: $duracaoMs, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, tipo, arquivo, duracaoMs, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Anexo &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.tipo == this.tipo &&
          other.arquivo == this.arquivo &&
          other.duracaoMs == this.duracaoMs &&
          other.criadoEm == this.criadoEm);
}

class AnexosCompanion extends UpdateCompanion<Anexo> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<TipoAnexo> tipo;
  final Value<String> arquivo;
  final Value<int?> duracaoMs;
  final Value<DateTime> criadoEm;
  const AnexosCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.arquivo = const Value.absent(),
    this.duracaoMs = const Value.absent(),
    this.criadoEm = const Value.absent(),
  });
  AnexosCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required TipoAnexo tipo,
    required String arquivo,
    this.duracaoMs = const Value.absent(),
    this.criadoEm = const Value.absent(),
  }) : itemId = Value(itemId),
       tipo = Value(tipo),
       arquivo = Value(arquivo);
  static Insertable<Anexo> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? tipo,
    Expression<String>? arquivo,
    Expression<int>? duracaoMs,
    Expression<DateTime>? criadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (tipo != null) 'tipo': tipo,
      if (arquivo != null) 'arquivo': arquivo,
      if (duracaoMs != null) 'duracao_ms': duracaoMs,
      if (criadoEm != null) 'criado_em': criadoEm,
    });
  }

  AnexosCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<TipoAnexo>? tipo,
    Value<String>? arquivo,
    Value<int?>? duracaoMs,
    Value<DateTime>? criadoEm,
  }) {
    return AnexosCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      tipo: tipo ?? this.tipo,
      arquivo: arquivo ?? this.arquivo,
      duracaoMs: duracaoMs ?? this.duracaoMs,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<int>(
        $AnexosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (arquivo.present) {
      map['arquivo'] = Variable<String>(arquivo.value);
    }
    if (duracaoMs.present) {
      map['duracao_ms'] = Variable<int>(duracaoMs.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnexosCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('tipo: $tipo, ')
          ..write('arquivo: $arquivo, ')
          ..write('duracaoMs: $duracaoMs, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItensTable itens = $ItensTable(this);
  late final $LembretesTable lembretes = $LembretesTable(this);
  late final $ListasTable listas = $ListasTable(this);
  late final $ProdutosTable produtos = $ProdutosTable(this);
  late final $AnexosTable anexos = $AnexosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    itens,
    lembretes,
    listas,
    produtos,
    anexos,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'itens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lembretes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'listas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('produtos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'itens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('anexos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ItensTableCreateCompanionBuilder = ItensCompanion Function({
  Value<int> id,
  required TipoItem tipo,
  required String titulo,
  Value<String?> descricao,
  Value<DateTime?> inicio,
  Value<DateTime?> fim,
  Value<bool> diaInteiro,
  Value<bool> concluida,
  Value<DateTime> criadoEm,
});
typedef $$ItensTableUpdateCompanionBuilder = ItensCompanion Function({
  Value<int> id,
  Value<TipoItem> tipo,
  Value<String> titulo,
  Value<String?> descricao,
  Value<DateTime?> inicio,
  Value<DateTime?> fim,
  Value<bool> diaInteiro,
  Value<bool> concluida,
  Value<DateTime> criadoEm,
});

final class $$ItensTableReferences
    extends BaseReferences<_$AppDatabase, $ItensTable, Item> {
  $$ItensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LembretesTable, List<Lembrete>>
  _lembretesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.lembretes,
    aliasName: 'itens__id__lembretes__item_id',
  );

  $$LembretesTableProcessedTableManager get lembretesRefs {
    final manager = $$LembretesTableTableManager(
      $_db,
      $_db.lembretes,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lembretesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnexosTable, List<Anexo>> _anexosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.anexos,
    aliasName: 'itens__id__anexos__item_id',
  );

  $$AnexosTableProcessedTableManager get anexosRefs {
    final manager = $$AnexosTableTableManager(
      $_db,
      $_db.anexos,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_anexosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItensTableFilterComposer extends Composer<_$AppDatabase, $ItensTable> {
  $$ItensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoItem, TipoItem, int> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inicio => $composableBuilder(
    column: $table.inicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fim => $composableBuilder(
    column: $table.fim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get diaInteiro => $composableBuilder(
    column: $table.diaInteiro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get concluida => $composableBuilder(
    column: $table.concluida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lembretesRefs(
    Expression<bool> Function($$LembretesTableFilterComposer f) f,
  ) {
    final $$LembretesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lembretes,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LembretesTableFilterComposer(
            $db: $db,
            $table: $db.lembretes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> anexosRefs(
    Expression<bool> Function($$AnexosTableFilterComposer f) f,
  ) {
    final $$AnexosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anexos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnexosTableFilterComposer(
            $db: $db,
            $table: $db.anexos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItensTableOrderingComposer
    extends Composer<_$AppDatabase, $ItensTable> {
  $$ItensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inicio => $composableBuilder(
    column: $table.inicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fim => $composableBuilder(
    column: $table.fim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get diaInteiro => $composableBuilder(
    column: $table.diaInteiro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get concluida => $composableBuilder(
    column: $table.concluida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItensTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItensTable> {
  $$ItensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoItem, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<DateTime> get inicio =>
      $composableBuilder(column: $table.inicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fim =>
      $composableBuilder(column: $table.fim, builder: (column) => column);

  GeneratedColumn<bool> get diaInteiro => $composableBuilder(
    column: $table.diaInteiro,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get concluida =>
      $composableBuilder(column: $table.concluida, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> lembretesRefs<T extends Object>(
    Expression<T> Function($$LembretesTableAnnotationComposer a) f,
  ) {
    final $$LembretesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lembretes,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LembretesTableAnnotationComposer(
            $db: $db,
            $table: $db.lembretes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> anexosRefs<T extends Object>(
    Expression<T> Function($$AnexosTableAnnotationComposer a) f,
  ) {
    final $$AnexosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anexos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnexosTableAnnotationComposer(
            $db: $db,
            $table: $db.anexos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItensTable,
          Item,
          $$ItensTableFilterComposer,
          $$ItensTableOrderingComposer,
          $$ItensTableAnnotationComposer,
          $$ItensTableCreateCompanionBuilder,
          $$ItensTableUpdateCompanionBuilder,
          (Item, $$ItensTableReferences),
          Item,
          PrefetchHooks Function({bool lembretesRefs, bool anexosRefs})
        > {
  $$ItensTableTableManager(_$AppDatabase db, $ItensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TipoItem> tipo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<DateTime?> inicio = const Value.absent(),
                Value<DateTime?> fim = const Value.absent(),
                Value<bool> diaInteiro = const Value.absent(),
                Value<bool> concluida = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => ItensCompanion(
                id: id,
                tipo: tipo,
                titulo: titulo,
                descricao: descricao,
                inicio: inicio,
                fim: fim,
                diaInteiro: diaInteiro,
                concluida: concluida,
                criadoEm: criadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TipoItem tipo,
                required String titulo,
                Value<String?> descricao = const Value.absent(),
                Value<DateTime?> inicio = const Value.absent(),
                Value<DateTime?> fim = const Value.absent(),
                Value<bool> diaInteiro = const Value.absent(),
                Value<bool> concluida = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => ItensCompanion.insert(
                id: id,
                tipo: tipo,
                titulo: titulo,
                descricao: descricao,
                inicio: inicio,
                fim: fim,
                diaInteiro: diaInteiro,
                concluida: concluida,
                criadoEm: criadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItensTable, Item>(table),
                  $$ItensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lembretesRefs = false, anexosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lembretesRefs) db.lembretes,
                if (anexosRefs) db.anexos,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lembretesRefs)
                    await $_getPrefetchedData<Item, $ItensTable, Lembrete>(
                      currentTable: table,
                      referencedTable: $$ItensTableReferences
                          ._lembretesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ItensTableReferences(db, table, p0).lembretesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.itemId == item.id),
                      typedResults: items,
                    ),
                  if (anexosRefs)
                    await $_getPrefetchedData<Item, $ItensTable, Anexo>(
                      currentTable: table,
                      referencedTable: $$ItensTableReferences._anexosRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$ItensTableReferences(db, table, p0).anexosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.itemId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ItensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItensTable,
      Item,
      $$ItensTableFilterComposer,
      $$ItensTableOrderingComposer,
      $$ItensTableAnnotationComposer,
      $$ItensTableCreateCompanionBuilder,
      $$ItensTableUpdateCompanionBuilder,
      (Item, $$ItensTableReferences),
      Item,
      PrefetchHooks Function({bool lembretesRefs, bool anexosRefs})
    >;
typedef $$LembretesTableCreateCompanionBuilder = LembretesCompanion Function({
  Value<int> id,
  required int itemId,
  required DateTime quando,
  Value<Frequencia> frequencia,
  Value<int> intervalo,
  Value<int> sonecaMinutos,
});
typedef $$LembretesTableUpdateCompanionBuilder = LembretesCompanion Function({
  Value<int> id,
  Value<int> itemId,
  Value<DateTime> quando,
  Value<Frequencia> frequencia,
  Value<int> intervalo,
  Value<int> sonecaMinutos,
});

final class $$LembretesTableReferences
    extends BaseReferences<_$AppDatabase, $LembretesTable, Lembrete> {
  $$LembretesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItensTable _itemIdTable(_$AppDatabase db) =>
      db.itens.createAlias('lembretes__item_id__itens__id');

  $$ItensTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItensTableTableManager(
      $_db,
      $_db.itens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LembretesTableFilterComposer
    extends Composer<_$AppDatabase, $LembretesTable> {
  $$LembretesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get quando => $composableBuilder(
    column: $table.quando,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Frequencia, Frequencia, int> get frequencia =>
      $composableBuilder(
        column: $table.frequencia,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get intervalo => $composableBuilder(
    column: $table.intervalo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sonecaMinutos => $composableBuilder(
    column: $table.sonecaMinutos,
    builder: (column) => ColumnFilters(column),
  );

  $$ItensTableFilterComposer get itemId {
    final $$ItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.itens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensTableFilterComposer(
            $db: $db,
            $table: $db.itens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LembretesTableOrderingComposer
    extends Composer<_$AppDatabase, $LembretesTable> {
  $$LembretesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get quando => $composableBuilder(
    column: $table.quando,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencia => $composableBuilder(
    column: $table.frequencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalo => $composableBuilder(
    column: $table.intervalo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sonecaMinutos => $composableBuilder(
    column: $table.sonecaMinutos,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItensTableOrderingComposer get itemId {
    final $$ItensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.itens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensTableOrderingComposer(
            $db: $db,
            $table: $db.itens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LembretesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LembretesTable> {
  $$LembretesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get quando =>
      $composableBuilder(column: $table.quando, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Frequencia, int> get frequencia =>
      $composableBuilder(
        column: $table.frequencia,
        builder: (column) => column,
      );

  GeneratedColumn<int> get intervalo =>
      $composableBuilder(column: $table.intervalo, builder: (column) => column);

  GeneratedColumn<int> get sonecaMinutos => $composableBuilder(
    column: $table.sonecaMinutos,
    builder: (column) => column,
  );

  $$ItensTableAnnotationComposer get itemId {
    final $$ItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.itens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensTableAnnotationComposer(
            $db: $db,
            $table: $db.itens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LembretesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LembretesTable,
          Lembrete,
          $$LembretesTableFilterComposer,
          $$LembretesTableOrderingComposer,
          $$LembretesTableAnnotationComposer,
          $$LembretesTableCreateCompanionBuilder,
          $$LembretesTableUpdateCompanionBuilder,
          (Lembrete, $$LembretesTableReferences),
          Lembrete,
          PrefetchHooks Function({bool itemId})
        > {
  $$LembretesTableTableManager(_$AppDatabase db, $LembretesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LembretesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LembretesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LembretesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<DateTime> quando = const Value.absent(),
                Value<Frequencia> frequencia = const Value.absent(),
                Value<int> intervalo = const Value.absent(),
                Value<int> sonecaMinutos = const Value.absent(),
              }) => LembretesCompanion(
                id: id,
                itemId: itemId,
                quando: quando,
                frequencia: frequencia,
                intervalo: intervalo,
                sonecaMinutos: sonecaMinutos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required DateTime quando,
                Value<Frequencia> frequencia = const Value.absent(),
                Value<int> intervalo = const Value.absent(),
                Value<int> sonecaMinutos = const Value.absent(),
              }) => LembretesCompanion.insert(
                id: id,
                itemId: itemId,
                quando: quando,
                frequencia: frequencia,
                intervalo: intervalo,
                sonecaMinutos: sonecaMinutos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LembretesTable, Lembrete>(table),
                  $$LembretesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$LembretesTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$LembretesTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LembretesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LembretesTable,
      Lembrete,
      $$LembretesTableFilterComposer,
      $$LembretesTableOrderingComposer,
      $$LembretesTableAnnotationComposer,
      $$LembretesTableCreateCompanionBuilder,
      $$LembretesTableUpdateCompanionBuilder,
      (Lembrete, $$LembretesTableReferences),
      Lembrete,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$ListasTableCreateCompanionBuilder = ListasCompanion Function({
  Value<int> id,
  required String nome,
  Value<DateTime> criadoEm,
});
typedef $$ListasTableUpdateCompanionBuilder = ListasCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<DateTime> criadoEm,
});

final class $$ListasTableReferences
    extends BaseReferences<_$AppDatabase, $ListasTable, ListaCompras> {
  $$ListasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProdutosTable, List<Produto>> _produtosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.produtos,
    aliasName: 'listas__id__produtos__lista_id',
  );

  $$ProdutosTableProcessedTableManager get produtosRefs {
    final manager = $$ProdutosTableTableManager(
      $_db,
      $_db.produtos,
    ).filter((f) => f.listaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_produtosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ListasTableFilterComposer
    extends Composer<_$AppDatabase, $ListasTable> {
  $$ListasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> produtosRefs(
    Expression<bool> Function($$ProdutosTableFilterComposer f) f,
  ) {
    final $$ProdutosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableFilterComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListasTableOrderingComposer
    extends Composer<_$AppDatabase, $ListasTable> {
  $$ListasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListasTable> {
  $$ListasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> produtosRefs<T extends Object>(
    Expression<T> Function($$ProdutosTableAnnotationComposer a) f,
  ) {
    final $$ProdutosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.listaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableAnnotationComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ListasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListasTable,
          ListaCompras,
          $$ListasTableFilterComposer,
          $$ListasTableOrderingComposer,
          $$ListasTableAnnotationComposer,
          $$ListasTableCreateCompanionBuilder,
          $$ListasTableUpdateCompanionBuilder,
          (ListaCompras, $$ListasTableReferences),
          ListaCompras,
          PrefetchHooks Function({bool produtosRefs})
        > {
  $$ListasTableTableManager(_$AppDatabase db, $ListasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
          }) => ListasCompanion(id: id, nome: nome, criadoEm: criadoEm),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            Value<DateTime> criadoEm = const Value.absent(),
          }) => ListasCompanion.insert(id: id, nome: nome, criadoEm: criadoEm),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ListasTable, ListaCompras>(table),
                  $$ListasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produtosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (produtosRefs) db.produtos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (produtosRefs)
                    await $_getPrefetchedData<
                      ListaCompras,
                      $ListasTable,
                      Produto
                    >(
                      currentTable: table,
                      referencedTable: $$ListasTableReferences
                          ._produtosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ListasTableReferences(db, table, p0).produtosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ListasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListasTable,
      ListaCompras,
      $$ListasTableFilterComposer,
      $$ListasTableOrderingComposer,
      $$ListasTableAnnotationComposer,
      $$ListasTableCreateCompanionBuilder,
      $$ListasTableUpdateCompanionBuilder,
      (ListaCompras, $$ListasTableReferences),
      ListaCompras,
      PrefetchHooks Function({bool produtosRefs})
    >;
typedef $$ProdutosTableCreateCompanionBuilder = ProdutosCompanion Function({
  Value<int> id,
  required int listaId,
  required String nome,
  Value<String?> quantidade,
  Value<bool> comprado,
  Value<DateTime> criadoEm,
});
typedef $$ProdutosTableUpdateCompanionBuilder = ProdutosCompanion Function({
  Value<int> id,
  Value<int> listaId,
  Value<String> nome,
  Value<String?> quantidade,
  Value<bool> comprado,
  Value<DateTime> criadoEm,
});

final class $$ProdutosTableReferences
    extends BaseReferences<_$AppDatabase, $ProdutosTable, Produto> {
  $$ProdutosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ListasTable _listaIdTable(_$AppDatabase db) =>
      db.listas.createAlias('produtos__lista_id__listas__id');

  $$ListasTableProcessedTableManager get listaId {
    final $_column = $_itemColumn<int>('lista_id')!;

    final manager = $$ListasTableTableManager(
      $_db,
      $_db.listas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProdutosTableFilterComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get comprado => $composableBuilder(
    column: $table.comprado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ListasTableFilterComposer get listaId {
    final $$ListasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasTableFilterComposer(
            $db: $db,
            $table: $db.listas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdutosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get comprado => $composableBuilder(
    column: $table.comprado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ListasTableOrderingComposer get listaId {
    final $$ListasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasTableOrderingComposer(
            $db: $db,
            $table: $db.listas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdutosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get quantidade => $composableBuilder(
    column: $table.quantidade,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get comprado =>
      $composableBuilder(column: $table.comprado, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$ListasTableAnnotationComposer get listaId {
    final $$ListasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listaId,
      referencedTable: $db.listas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListasTableAnnotationComposer(
            $db: $db,
            $table: $db.listas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdutosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdutosTable,
          Produto,
          $$ProdutosTableFilterComposer,
          $$ProdutosTableOrderingComposer,
          $$ProdutosTableAnnotationComposer,
          $$ProdutosTableCreateCompanionBuilder,
          $$ProdutosTableUpdateCompanionBuilder,
          (Produto, $$ProdutosTableReferences),
          Produto,
          PrefetchHooks Function({bool listaId})
        > {
  $$ProdutosTableTableManager(_$AppDatabase db, $ProdutosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdutosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdutosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdutosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listaId = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> quantidade = const Value.absent(),
                Value<bool> comprado = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => ProdutosCompanion(
                id: id,
                listaId: listaId,
                nome: nome,
                quantidade: quantidade,
                comprado: comprado,
                criadoEm: criadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listaId,
                required String nome,
                Value<String?> quantidade = const Value.absent(),
                Value<bool> comprado = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => ProdutosCompanion.insert(
                id: id,
                listaId: listaId,
                nome: nome,
                quantidade: quantidade,
                comprado: comprado,
                criadoEm: criadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProdutosTable, Produto>(table),
                  $$ProdutosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.listaId,
                        referencedTable: $$ProdutosTableReferences
                            ._listaIdTable(db),
                        referencedColumn: $$ProdutosTableReferences
                            ._listaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProdutosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdutosTable,
      Produto,
      $$ProdutosTableFilterComposer,
      $$ProdutosTableOrderingComposer,
      $$ProdutosTableAnnotationComposer,
      $$ProdutosTableCreateCompanionBuilder,
      $$ProdutosTableUpdateCompanionBuilder,
      (Produto, $$ProdutosTableReferences),
      Produto,
      PrefetchHooks Function({bool listaId})
    >;
typedef $$AnexosTableCreateCompanionBuilder = AnexosCompanion Function({
  Value<int> id,
  required int itemId,
  required TipoAnexo tipo,
  required String arquivo,
  Value<int?> duracaoMs,
  Value<DateTime> criadoEm,
});
typedef $$AnexosTableUpdateCompanionBuilder = AnexosCompanion Function({
  Value<int> id,
  Value<int> itemId,
  Value<TipoAnexo> tipo,
  Value<String> arquivo,
  Value<int?> duracaoMs,
  Value<DateTime> criadoEm,
});

final class $$AnexosTableReferences
    extends BaseReferences<_$AppDatabase, $AnexosTable, Anexo> {
  $$AnexosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItensTable _itemIdTable(_$AppDatabase db) =>
      db.itens.createAlias('anexos__item_id__itens__id');

  $$ItensTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItensTableTableManager(
      $_db,
      $_db.itens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnexosTableFilterComposer
    extends Composer<_$AppDatabase, $AnexosTable> {
  $$AnexosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoAnexo, TipoAnexo, int> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get arquivo => $composableBuilder(
    column: $table.arquivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duracaoMs => $composableBuilder(
    column: $table.duracaoMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ItensTableFilterComposer get itemId {
    final $$ItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.itens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensTableFilterComposer(
            $db: $db,
            $table: $db.itens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnexosTableOrderingComposer
    extends Composer<_$AppDatabase, $AnexosTable> {
  $$AnexosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arquivo => $composableBuilder(
    column: $table.arquivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duracaoMs => $composableBuilder(
    column: $table.duracaoMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItensTableOrderingComposer get itemId {
    final $$ItensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.itens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensTableOrderingComposer(
            $db: $db,
            $table: $db.itens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnexosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnexosTable> {
  $$AnexosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoAnexo, int> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get arquivo =>
      $composableBuilder(column: $table.arquivo, builder: (column) => column);

  GeneratedColumn<int> get duracaoMs =>
      $composableBuilder(column: $table.duracaoMs, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$ItensTableAnnotationComposer get itemId {
    final $$ItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.itens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItensTableAnnotationComposer(
            $db: $db,
            $table: $db.itens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnexosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnexosTable,
          Anexo,
          $$AnexosTableFilterComposer,
          $$AnexosTableOrderingComposer,
          $$AnexosTableAnnotationComposer,
          $$AnexosTableCreateCompanionBuilder,
          $$AnexosTableUpdateCompanionBuilder,
          (Anexo, $$AnexosTableReferences),
          Anexo,
          PrefetchHooks Function({bool itemId})
        > {
  $$AnexosTableTableManager(_$AppDatabase db, $AnexosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnexosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnexosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnexosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<TipoAnexo> tipo = const Value.absent(),
                Value<String> arquivo = const Value.absent(),
                Value<int?> duracaoMs = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => AnexosCompanion(
                id: id,
                itemId: itemId,
                tipo: tipo,
                arquivo: arquivo,
                duracaoMs: duracaoMs,
                criadoEm: criadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required TipoAnexo tipo,
                required String arquivo,
                Value<int?> duracaoMs = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
              }) => AnexosCompanion.insert(
                id: id,
                itemId: itemId,
                tipo: tipo,
                arquivo: arquivo,
                duracaoMs: duracaoMs,
                criadoEm: criadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnexosTable, Anexo>(table),
                  $$AnexosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$AnexosTableReferences._itemIdTable(
                          db,
                        ),
                        referencedColumn: $$AnexosTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnexosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnexosTable,
      Anexo,
      $$AnexosTableFilterComposer,
      $$AnexosTableOrderingComposer,
      $$AnexosTableAnnotationComposer,
      $$AnexosTableCreateCompanionBuilder,
      $$AnexosTableUpdateCompanionBuilder,
      (Anexo, $$AnexosTableReferences),
      Anexo,
      PrefetchHooks Function({bool itemId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItensTableTableManager get itens =>
      $$ItensTableTableManager(_db, _db.itens);
  $$LembretesTableTableManager get lembretes =>
      $$LembretesTableTableManager(_db, _db.lembretes);
  $$ListasTableTableManager get listas =>
      $$ListasTableTableManager(_db, _db.listas);
  $$ProdutosTableTableManager get produtos =>
      $$ProdutosTableTableManager(_db, _db.produtos);
  $$AnexosTableTableManager get anexos =>
      $$AnexosTableTableManager(_db, _db.anexos);
}
