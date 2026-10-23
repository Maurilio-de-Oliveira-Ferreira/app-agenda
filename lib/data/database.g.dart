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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItensTable itens = $ItensTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [itens];
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
          (Item, BaseReferences<_$AppDatabase, $ItensTable, Item>),
          Item,
          PrefetchHooks Function()
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
                  BaseReferences<_$AppDatabase, $ItensTable, Item>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
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
      (Item, BaseReferences<_$AppDatabase, $ItensTable, Item>),
      Item,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItensTableTableManager get itens =>
      $$ItensTableTableManager(_db, _db.itens);
}
