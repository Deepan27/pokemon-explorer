// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PokemonItemsTable extends PokemonItems
    with TableInfo<$PokemonItemsTable, PokemonItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokemonItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statsMeta = const VerificationMeta('stats');
  @override
  late final GeneratedColumn<String> stats = GeneratedColumn<String>(
      'stats', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typesMeta = const VerificationMeta('types');
  @override
  late final GeneratedColumn<String> types = GeneratedColumn<String>(
      'types', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _abilitiesMeta =
      const VerificationMeta('abilities');
  @override
  late final GeneratedColumn<String> abilities = GeneratedColumn<String>(
      'abilities', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        imageUrl,
        height,
        weight,
        stats,
        types,
        abilities,
        lastUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokemon_items';
  @override
  VerificationContext validateIntegrity(Insertable<PokemonItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('stats')) {
      context.handle(
          _statsMeta, stats.isAcceptableOrUnknown(data['stats']!, _statsMeta));
    }
    if (data.containsKey('types')) {
      context.handle(
          _typesMeta, types.isAcceptableOrUnknown(data['types']!, _typesMeta));
    }
    if (data.containsKey('abilities')) {
      context.handle(_abilitiesMeta,
          abilities.isAcceptableOrUnknown(data['abilities']!, _abilitiesMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PokemonItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PokemonItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height']),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight']),
      stats: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stats']),
      types: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}types']),
      abilities: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abilities']),
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $PokemonItemsTable createAlias(String alias) {
    return $PokemonItemsTable(attachedDatabase, alias);
  }
}

class PokemonItem extends DataClass implements Insertable<PokemonItem> {
  final int id;
  final String name;
  final String? imageUrl;
  final int? height;
  final int? weight;
  final String? stats;
  final String? types;
  final String? abilities;
  final DateTime lastUpdated;
  const PokemonItem(
      {required this.id,
      required this.name,
      this.imageUrl,
      this.height,
      this.weight,
      this.stats,
      this.types,
      this.abilities,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<int>(weight);
    }
    if (!nullToAbsent || stats != null) {
      map['stats'] = Variable<String>(stats);
    }
    if (!nullToAbsent || types != null) {
      map['types'] = Variable<String>(types);
    }
    if (!nullToAbsent || abilities != null) {
      map['abilities'] = Variable<String>(abilities);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  PokemonItemsCompanion toCompanion(bool nullToAbsent) {
    return PokemonItemsCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      stats:
          stats == null && nullToAbsent ? const Value.absent() : Value(stats),
      types:
          types == null && nullToAbsent ? const Value.absent() : Value(types),
      abilities: abilities == null && nullToAbsent
          ? const Value.absent()
          : Value(abilities),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory PokemonItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PokemonItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      height: serializer.fromJson<int?>(json['height']),
      weight: serializer.fromJson<int?>(json['weight']),
      stats: serializer.fromJson<String?>(json['stats']),
      types: serializer.fromJson<String?>(json['types']),
      abilities: serializer.fromJson<String?>(json['abilities']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'height': serializer.toJson<int?>(height),
      'weight': serializer.toJson<int?>(weight),
      'stats': serializer.toJson<String?>(stats),
      'types': serializer.toJson<String?>(types),
      'abilities': serializer.toJson<String?>(abilities),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  PokemonItem copyWith(
          {int? id,
          String? name,
          Value<String?> imageUrl = const Value.absent(),
          Value<int?> height = const Value.absent(),
          Value<int?> weight = const Value.absent(),
          Value<String?> stats = const Value.absent(),
          Value<String?> types = const Value.absent(),
          Value<String?> abilities = const Value.absent(),
          DateTime? lastUpdated}) =>
      PokemonItem(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        height: height.present ? height.value : this.height,
        weight: weight.present ? weight.value : this.weight,
        stats: stats.present ? stats.value : this.stats,
        types: types.present ? types.value : this.types,
        abilities: abilities.present ? abilities.value : this.abilities,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('PokemonItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('stats: $stats, ')
          ..write('types: $types, ')
          ..write('abilities: $abilities, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, imageUrl, height, weight, stats, types, abilities, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PokemonItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.stats == this.stats &&
          other.types == this.types &&
          other.abilities == this.abilities &&
          other.lastUpdated == this.lastUpdated);
}

class PokemonItemsCompanion extends UpdateCompanion<PokemonItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<int?> height;
  final Value<int?> weight;
  final Value<String?> stats;
  final Value<String?> types;
  final Value<String?> abilities;
  final Value<DateTime> lastUpdated;
  const PokemonItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.stats = const Value.absent(),
    this.types = const Value.absent(),
    this.abilities = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  PokemonItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.imageUrl = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.stats = const Value.absent(),
    this.types = const Value.absent(),
    this.abilities = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PokemonItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<int>? height,
    Expression<int>? weight,
    Expression<String>? stats,
    Expression<String>? types,
    Expression<String>? abilities,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (stats != null) 'stats': stats,
      if (types != null) 'types': types,
      if (abilities != null) 'abilities': abilities,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  PokemonItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? imageUrl,
      Value<int?>? height,
      Value<int?>? weight,
      Value<String?>? stats,
      Value<String?>? types,
      Value<String?>? abilities,
      Value<DateTime>? lastUpdated}) {
    return PokemonItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      stats: stats ?? this.stats,
      types: types ?? this.types,
      abilities: abilities ?? this.abilities,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (stats.present) {
      map['stats'] = Variable<String>(stats.value);
    }
    if (types.present) {
      map['types'] = Variable<String>(types.value);
    }
    if (abilities.present) {
      map['abilities'] = Variable<String>(abilities.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokemonItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('stats: $stats, ')
          ..write('types: $types, ')
          ..write('abilities: $abilities, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $PokemonItemsTable pokemonItems = $PokemonItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pokemonItems];
}
