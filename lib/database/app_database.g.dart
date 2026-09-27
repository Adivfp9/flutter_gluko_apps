// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfileTableTable extends UserProfileTable
    with TableInfo<$UserProfileTableTable, UserProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diabetesTypeMeta = const VerificationMeta(
    'diabetesType',
  );
  @override
  late final GeneratedColumn<String> diabetesType = GeneratedColumn<String>(
    'diabetes_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mg_dl'),
  );
  static const VerificationMeta _presetMeta = const VerificationMeta('preset');
  @override
  late final GeneratedColumn<String> preset = GeneratedColumn<String>(
    'preset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    birthYear,
    diabetesType,
    unit,
    preset,
    onboardingDone,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    }
    if (data.containsKey('diabetes_type')) {
      context.handle(
        _diabetesTypeMeta,
        diabetesType.isAcceptableOrUnknown(
          data['diabetes_type']!,
          _diabetesTypeMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('preset')) {
      context.handle(
        _presetMeta,
        preset.isAcceptableOrUnknown(data['preset']!, _presetMeta),
      );
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      ),
      diabetesType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diabetes_type'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      preset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preset'],
      )!,
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfileTableTable createAlias(String alias) {
    return $UserProfileTableTable(attachedDatabase, alias);
  }
}

class UserProfileRow extends DataClass implements Insertable<UserProfileRow> {
  final int id;
  final String? name;
  final int? birthYear;
  final String diabetesType;
  final String unit;
  final String preset;
  final bool onboardingDone;
  final int createdAt;
  final int updatedAt;
  const UserProfileRow({
    required this.id,
    this.name,
    this.birthYear,
    required this.diabetesType,
    required this.unit,
    required this.preset,
    required this.onboardingDone,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || birthYear != null) {
      map['birth_year'] = Variable<int>(birthYear);
    }
    map['diabetes_type'] = Variable<String>(diabetesType);
    map['unit'] = Variable<String>(unit);
    map['preset'] = Variable<String>(preset);
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  UserProfileTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfileTableCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      diabetesType: Value(diabetesType),
      unit: Value(unit),
      preset: Value(preset),
      onboardingDone: Value(onboardingDone),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      birthYear: serializer.fromJson<int?>(json['birthYear']),
      diabetesType: serializer.fromJson<String>(json['diabetesType']),
      unit: serializer.fromJson<String>(json['unit']),
      preset: serializer.fromJson<String>(json['preset']),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'birthYear': serializer.toJson<int?>(birthYear),
      'diabetesType': serializer.toJson<String>(diabetesType),
      'unit': serializer.toJson<String>(unit),
      'preset': serializer.toJson<String>(preset),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  UserProfileRow copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<int?> birthYear = const Value.absent(),
    String? diabetesType,
    String? unit,
    String? preset,
    bool? onboardingDone,
    int? createdAt,
    int? updatedAt,
  }) => UserProfileRow(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    diabetesType: diabetesType ?? this.diabetesType,
    unit: unit ?? this.unit,
    preset: preset ?? this.preset,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfileRow copyWithCompanion(UserProfileTableCompanion data) {
    return UserProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      diabetesType: data.diabetesType.present
          ? data.diabetesType.value
          : this.diabetesType,
      unit: data.unit.present ? data.unit.value : this.unit,
      preset: data.preset.present ? data.preset.value : this.preset,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthYear: $birthYear, ')
          ..write('diabetesType: $diabetesType, ')
          ..write('unit: $unit, ')
          ..write('preset: $preset, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    birthYear,
    diabetesType,
    unit,
    preset,
    onboardingDone,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthYear == this.birthYear &&
          other.diabetesType == this.diabetesType &&
          other.unit == this.unit &&
          other.preset == this.preset &&
          other.onboardingDone == this.onboardingDone &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfileTableCompanion extends UpdateCompanion<UserProfileRow> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int?> birthYear;
  final Value<String> diabetesType;
  final Value<String> unit;
  final Value<String> preset;
  final Value<bool> onboardingDone;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const UserProfileTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.diabetesType = const Value.absent(),
    this.unit = const Value.absent(),
    this.preset = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfileTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.diabetesType = const Value.absent(),
    this.unit = const Value.absent(),
    this.preset = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfileRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? birthYear,
    Expression<String>? diabetesType,
    Expression<String>? unit,
    Expression<String>? preset,
    Expression<bool>? onboardingDone,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthYear != null) 'birth_year': birthYear,
      if (diabetesType != null) 'diabetes_type': diabetesType,
      if (unit != null) 'unit': unit,
      if (preset != null) 'preset': preset,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfileTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<int?>? birthYear,
    Value<String>? diabetesType,
    Value<String>? unit,
    Value<String>? preset,
    Value<bool>? onboardingDone,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return UserProfileTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthYear: birthYear ?? this.birthYear,
      diabetesType: diabetesType ?? this.diabetesType,
      unit: unit ?? this.unit,
      preset: preset ?? this.preset,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (diabetesType.present) {
      map['diabetes_type'] = Variable<String>(diabetesType.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (preset.present) {
      map['preset'] = Variable<String>(preset.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthYear: $birthYear, ')
          ..write('diabetesType: $diabetesType, ')
          ..write('unit: $unit, ')
          ..write('preset: $preset, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TargetRangesTableTable extends TargetRangesTable
    with TableInfo<$TargetRangesTableTable, TargetRangeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetRangesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _readingTypeMeta = const VerificationMeta(
    'readingType',
  );
  @override
  late final GeneratedColumn<String> readingType = GeneratedColumn<String>(
    'reading_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _lowMaxMeta = const VerificationMeta('lowMax');
  @override
  late final GeneratedColumn<int> lowMax = GeneratedColumn<int>(
    'low_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalMaxMeta = const VerificationMeta(
    'normalMax',
  );
  @override
  late final GeneratedColumn<int> normalMax = GeneratedColumn<int>(
    'normal_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warningMaxMeta = const VerificationMeta(
    'warningMax',
  );
  @override
  late final GeneratedColumn<int> warningMax = GeneratedColumn<int>(
    'warning_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criticalLowMeta = const VerificationMeta(
    'criticalLow',
  );
  @override
  late final GeneratedColumn<int> criticalLow = GeneratedColumn<int>(
    'critical_low',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(54),
  );
  static const VerificationMeta _criticalHighMeta = const VerificationMeta(
    'criticalHigh',
  );
  @override
  late final GeneratedColumn<int> criticalHigh = GeneratedColumn<int>(
    'critical_high',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(300),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    readingType,
    lowMax,
    normalMax,
    warningMax,
    criticalLow,
    criticalHigh,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'target_ranges';
  @override
  VerificationContext validateIntegrity(
    Insertable<TargetRangeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reading_type')) {
      context.handle(
        _readingTypeMeta,
        readingType.isAcceptableOrUnknown(
          data['reading_type']!,
          _readingTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readingTypeMeta);
    }
    if (data.containsKey('low_max')) {
      context.handle(
        _lowMaxMeta,
        lowMax.isAcceptableOrUnknown(data['low_max']!, _lowMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_lowMaxMeta);
    }
    if (data.containsKey('normal_max')) {
      context.handle(
        _normalMaxMeta,
        normalMax.isAcceptableOrUnknown(data['normal_max']!, _normalMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_normalMaxMeta);
    }
    if (data.containsKey('warning_max')) {
      context.handle(
        _warningMaxMeta,
        warningMax.isAcceptableOrUnknown(data['warning_max']!, _warningMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_warningMaxMeta);
    }
    if (data.containsKey('critical_low')) {
      context.handle(
        _criticalLowMeta,
        criticalLow.isAcceptableOrUnknown(
          data['critical_low']!,
          _criticalLowMeta,
        ),
      );
    }
    if (data.containsKey('critical_high')) {
      context.handle(
        _criticalHighMeta,
        criticalHigh.isAcceptableOrUnknown(
          data['critical_high']!,
          _criticalHighMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TargetRangeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TargetRangeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      readingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_type'],
      )!,
      lowMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_max'],
      )!,
      normalMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}normal_max'],
      )!,
      warningMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warning_max'],
      )!,
      criticalLow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}critical_low'],
      )!,
      criticalHigh: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}critical_high'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TargetRangesTableTable createAlias(String alias) {
    return $TargetRangesTableTable(attachedDatabase, alias);
  }
}

class TargetRangeRow extends DataClass implements Insertable<TargetRangeRow> {
  final int id;
  final String readingType;
  final int lowMax;
  final int normalMax;
  final int warningMax;
  final int criticalLow;
  final int criticalHigh;
  final int updatedAt;
  const TargetRangeRow({
    required this.id,
    required this.readingType,
    required this.lowMax,
    required this.normalMax,
    required this.warningMax,
    required this.criticalLow,
    required this.criticalHigh,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reading_type'] = Variable<String>(readingType);
    map['low_max'] = Variable<int>(lowMax);
    map['normal_max'] = Variable<int>(normalMax);
    map['warning_max'] = Variable<int>(warningMax);
    map['critical_low'] = Variable<int>(criticalLow);
    map['critical_high'] = Variable<int>(criticalHigh);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TargetRangesTableCompanion toCompanion(bool nullToAbsent) {
    return TargetRangesTableCompanion(
      id: Value(id),
      readingType: Value(readingType),
      lowMax: Value(lowMax),
      normalMax: Value(normalMax),
      warningMax: Value(warningMax),
      criticalLow: Value(criticalLow),
      criticalHigh: Value(criticalHigh),
      updatedAt: Value(updatedAt),
    );
  }

  factory TargetRangeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TargetRangeRow(
      id: serializer.fromJson<int>(json['id']),
      readingType: serializer.fromJson<String>(json['readingType']),
      lowMax: serializer.fromJson<int>(json['lowMax']),
      normalMax: serializer.fromJson<int>(json['normalMax']),
      warningMax: serializer.fromJson<int>(json['warningMax']),
      criticalLow: serializer.fromJson<int>(json['criticalLow']),
      criticalHigh: serializer.fromJson<int>(json['criticalHigh']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'readingType': serializer.toJson<String>(readingType),
      'lowMax': serializer.toJson<int>(lowMax),
      'normalMax': serializer.toJson<int>(normalMax),
      'warningMax': serializer.toJson<int>(warningMax),
      'criticalLow': serializer.toJson<int>(criticalLow),
      'criticalHigh': serializer.toJson<int>(criticalHigh),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TargetRangeRow copyWith({
    int? id,
    String? readingType,
    int? lowMax,
    int? normalMax,
    int? warningMax,
    int? criticalLow,
    int? criticalHigh,
    int? updatedAt,
  }) => TargetRangeRow(
    id: id ?? this.id,
    readingType: readingType ?? this.readingType,
    lowMax: lowMax ?? this.lowMax,
    normalMax: normalMax ?? this.normalMax,
    warningMax: warningMax ?? this.warningMax,
    criticalLow: criticalLow ?? this.criticalLow,
    criticalHigh: criticalHigh ?? this.criticalHigh,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TargetRangeRow copyWithCompanion(TargetRangesTableCompanion data) {
    return TargetRangeRow(
      id: data.id.present ? data.id.value : this.id,
      readingType: data.readingType.present
          ? data.readingType.value
          : this.readingType,
      lowMax: data.lowMax.present ? data.lowMax.value : this.lowMax,
      normalMax: data.normalMax.present ? data.normalMax.value : this.normalMax,
      warningMax: data.warningMax.present
          ? data.warningMax.value
          : this.warningMax,
      criticalLow: data.criticalLow.present
          ? data.criticalLow.value
          : this.criticalLow,
      criticalHigh: data.criticalHigh.present
          ? data.criticalHigh.value
          : this.criticalHigh,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TargetRangeRow(')
          ..write('id: $id, ')
          ..write('readingType: $readingType, ')
          ..write('lowMax: $lowMax, ')
          ..write('normalMax: $normalMax, ')
          ..write('warningMax: $warningMax, ')
          ..write('criticalLow: $criticalLow, ')
          ..write('criticalHigh: $criticalHigh, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    readingType,
    lowMax,
    normalMax,
    warningMax,
    criticalLow,
    criticalHigh,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetRangeRow &&
          other.id == this.id &&
          other.readingType == this.readingType &&
          other.lowMax == this.lowMax &&
          other.normalMax == this.normalMax &&
          other.warningMax == this.warningMax &&
          other.criticalLow == this.criticalLow &&
          other.criticalHigh == this.criticalHigh &&
          other.updatedAt == this.updatedAt);
}

class TargetRangesTableCompanion extends UpdateCompanion<TargetRangeRow> {
  final Value<int> id;
  final Value<String> readingType;
  final Value<int> lowMax;
  final Value<int> normalMax;
  final Value<int> warningMax;
  final Value<int> criticalLow;
  final Value<int> criticalHigh;
  final Value<int> updatedAt;
  const TargetRangesTableCompanion({
    this.id = const Value.absent(),
    this.readingType = const Value.absent(),
    this.lowMax = const Value.absent(),
    this.normalMax = const Value.absent(),
    this.warningMax = const Value.absent(),
    this.criticalLow = const Value.absent(),
    this.criticalHigh = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TargetRangesTableCompanion.insert({
    this.id = const Value.absent(),
    required String readingType,
    required int lowMax,
    required int normalMax,
    required int warningMax,
    this.criticalLow = const Value.absent(),
    this.criticalHigh = const Value.absent(),
    required int updatedAt,
  }) : readingType = Value(readingType),
       lowMax = Value(lowMax),
       normalMax = Value(normalMax),
       warningMax = Value(warningMax),
       updatedAt = Value(updatedAt);
  static Insertable<TargetRangeRow> custom({
    Expression<int>? id,
    Expression<String>? readingType,
    Expression<int>? lowMax,
    Expression<int>? normalMax,
    Expression<int>? warningMax,
    Expression<int>? criticalLow,
    Expression<int>? criticalHigh,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (readingType != null) 'reading_type': readingType,
      if (lowMax != null) 'low_max': lowMax,
      if (normalMax != null) 'normal_max': normalMax,
      if (warningMax != null) 'warning_max': warningMax,
      if (criticalLow != null) 'critical_low': criticalLow,
      if (criticalHigh != null) 'critical_high': criticalHigh,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TargetRangesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? readingType,
    Value<int>? lowMax,
    Value<int>? normalMax,
    Value<int>? warningMax,
    Value<int>? criticalLow,
    Value<int>? criticalHigh,
    Value<int>? updatedAt,
  }) {
    return TargetRangesTableCompanion(
      id: id ?? this.id,
      readingType: readingType ?? this.readingType,
      lowMax: lowMax ?? this.lowMax,
      normalMax: normalMax ?? this.normalMax,
      warningMax: warningMax ?? this.warningMax,
      criticalLow: criticalLow ?? this.criticalLow,
      criticalHigh: criticalHigh ?? this.criticalHigh,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (readingType.present) {
      map['reading_type'] = Variable<String>(readingType.value);
    }
    if (lowMax.present) {
      map['low_max'] = Variable<int>(lowMax.value);
    }
    if (normalMax.present) {
      map['normal_max'] = Variable<int>(normalMax.value);
    }
    if (warningMax.present) {
      map['warning_max'] = Variable<int>(warningMax.value);
    }
    if (criticalLow.present) {
      map['critical_low'] = Variable<int>(criticalLow.value);
    }
    if (criticalHigh.present) {
      map['critical_high'] = Variable<int>(criticalHigh.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetRangesTableCompanion(')
          ..write('id: $id, ')
          ..write('readingType: $readingType, ')
          ..write('lowMax: $lowMax, ')
          ..write('normalMax: $normalMax, ')
          ..write('warningMax: $warningMax, ')
          ..write('criticalLow: $criticalLow, ')
          ..write('criticalHigh: $criticalHigh, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GlucoseReadingsTableTable extends GlucoseReadingsTable
    with TableInfo<$GlucoseReadingsTableTable, GlucoseReadingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GlucoseReadingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _readingTypeMeta = const VerificationMeta(
    'readingType',
  );
  @override
  late final GeneratedColumn<String> readingType = GeneratedColumn<String>(
    'reading_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMgDlMeta = const VerificationMeta(
    'valueMgDl',
  );
  @override
  late final GeneratedColumn<int> valueMgDl = GeneratedColumn<int>(
    'value_mg_dl',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<int> measuredAt = GeneratedColumn<int>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tzOffsetMinMeta = const VerificationMeta(
    'tzOffsetMin',
  );
  @override
  late final GeneratedColumn<int> tzOffsetMin = GeneratedColumn<int>(
    'tz_offset_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCriticalMeta = const VerificationMeta(
    'isCritical',
  );
  @override
  late final GeneratedColumn<bool> isCritical = GeneratedColumn<bool>(
    'is_critical',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_critical" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mealContextMeta = const VerificationMeta(
    'mealContext',
  );
  @override
  late final GeneratedColumn<String> mealContext = GeneratedColumn<String>(
    'meal_context',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hoursAfterMealMeta = const VerificationMeta(
    'hoursAfterMeal',
  );
  @override
  late final GeneratedColumn<double> hoursAfterMeal = GeneratedColumn<double>(
    'hours_after_meal',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    readingType,
    valueMgDl,
    measuredAt,
    tzOffsetMin,
    localDate,
    status,
    isCritical,
    mealContext,
    hoursAfterMeal,
    note,
    source,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'glucose_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<GlucoseReadingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reading_type')) {
      context.handle(
        _readingTypeMeta,
        readingType.isAcceptableOrUnknown(
          data['reading_type']!,
          _readingTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readingTypeMeta);
    }
    if (data.containsKey('value_mg_dl')) {
      context.handle(
        _valueMgDlMeta,
        valueMgDl.isAcceptableOrUnknown(data['value_mg_dl']!, _valueMgDlMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMgDlMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('tz_offset_min')) {
      context.handle(
        _tzOffsetMinMeta,
        tzOffsetMin.isAcceptableOrUnknown(
          data['tz_offset_min']!,
          _tzOffsetMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tzOffsetMinMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_critical')) {
      context.handle(
        _isCriticalMeta,
        isCritical.isAcceptableOrUnknown(data['is_critical']!, _isCriticalMeta),
      );
    }
    if (data.containsKey('meal_context')) {
      context.handle(
        _mealContextMeta,
        mealContext.isAcceptableOrUnknown(
          data['meal_context']!,
          _mealContextMeta,
        ),
      );
    }
    if (data.containsKey('hours_after_meal')) {
      context.handle(
        _hoursAfterMealMeta,
        hoursAfterMeal.isAcceptableOrUnknown(
          data['hours_after_meal']!,
          _hoursAfterMealMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GlucoseReadingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GlucoseReadingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      readingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_type'],
      )!,
      valueMgDl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_mg_dl'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measured_at'],
      )!,
      tzOffsetMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tz_offset_min'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isCritical: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_critical'],
      )!,
      mealContext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_context'],
      ),
      hoursAfterMeal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours_after_meal'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $GlucoseReadingsTableTable createAlias(String alias) {
    return $GlucoseReadingsTableTable(attachedDatabase, alias);
  }
}

class GlucoseReadingRow extends DataClass
    implements Insertable<GlucoseReadingRow> {
  final int id;
  final String readingType;
  final int valueMgDl;
  final int measuredAt;
  final int tzOffsetMin;
  final String localDate;
  final String status;
  final bool isCritical;
  final String? mealContext;
  final double? hoursAfterMeal;
  final String? note;
  final String source;
  final int createdAt;
  final int updatedAt;

  /// Soft delete (PRD 5.5): baris tetap ada 30 hari agar Undo dan restore aman.
  final int? deletedAt;
  const GlucoseReadingRow({
    required this.id,
    required this.readingType,
    required this.valueMgDl,
    required this.measuredAt,
    required this.tzOffsetMin,
    required this.localDate,
    required this.status,
    required this.isCritical,
    this.mealContext,
    this.hoursAfterMeal,
    this.note,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reading_type'] = Variable<String>(readingType);
    map['value_mg_dl'] = Variable<int>(valueMgDl);
    map['measured_at'] = Variable<int>(measuredAt);
    map['tz_offset_min'] = Variable<int>(tzOffsetMin);
    map['local_date'] = Variable<String>(localDate);
    map['status'] = Variable<String>(status);
    map['is_critical'] = Variable<bool>(isCritical);
    if (!nullToAbsent || mealContext != null) {
      map['meal_context'] = Variable<String>(mealContext);
    }
    if (!nullToAbsent || hoursAfterMeal != null) {
      map['hours_after_meal'] = Variable<double>(hoursAfterMeal);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  GlucoseReadingsTableCompanion toCompanion(bool nullToAbsent) {
    return GlucoseReadingsTableCompanion(
      id: Value(id),
      readingType: Value(readingType),
      valueMgDl: Value(valueMgDl),
      measuredAt: Value(measuredAt),
      tzOffsetMin: Value(tzOffsetMin),
      localDate: Value(localDate),
      status: Value(status),
      isCritical: Value(isCritical),
      mealContext: mealContext == null && nullToAbsent
          ? const Value.absent()
          : Value(mealContext),
      hoursAfterMeal: hoursAfterMeal == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursAfterMeal),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GlucoseReadingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlucoseReadingRow(
      id: serializer.fromJson<int>(json['id']),
      readingType: serializer.fromJson<String>(json['readingType']),
      valueMgDl: serializer.fromJson<int>(json['valueMgDl']),
      measuredAt: serializer.fromJson<int>(json['measuredAt']),
      tzOffsetMin: serializer.fromJson<int>(json['tzOffsetMin']),
      localDate: serializer.fromJson<String>(json['localDate']),
      status: serializer.fromJson<String>(json['status']),
      isCritical: serializer.fromJson<bool>(json['isCritical']),
      mealContext: serializer.fromJson<String?>(json['mealContext']),
      hoursAfterMeal: serializer.fromJson<double?>(json['hoursAfterMeal']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'readingType': serializer.toJson<String>(readingType),
      'valueMgDl': serializer.toJson<int>(valueMgDl),
      'measuredAt': serializer.toJson<int>(measuredAt),
      'tzOffsetMin': serializer.toJson<int>(tzOffsetMin),
      'localDate': serializer.toJson<String>(localDate),
      'status': serializer.toJson<String>(status),
      'isCritical': serializer.toJson<bool>(isCritical),
      'mealContext': serializer.toJson<String?>(mealContext),
      'hoursAfterMeal': serializer.toJson<double?>(hoursAfterMeal),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  GlucoseReadingRow copyWith({
    int? id,
    String? readingType,
    int? valueMgDl,
    int? measuredAt,
    int? tzOffsetMin,
    String? localDate,
    String? status,
    bool? isCritical,
    Value<String?> mealContext = const Value.absent(),
    Value<double?> hoursAfterMeal = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? source,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => GlucoseReadingRow(
    id: id ?? this.id,
    readingType: readingType ?? this.readingType,
    valueMgDl: valueMgDl ?? this.valueMgDl,
    measuredAt: measuredAt ?? this.measuredAt,
    tzOffsetMin: tzOffsetMin ?? this.tzOffsetMin,
    localDate: localDate ?? this.localDate,
    status: status ?? this.status,
    isCritical: isCritical ?? this.isCritical,
    mealContext: mealContext.present ? mealContext.value : this.mealContext,
    hoursAfterMeal: hoursAfterMeal.present
        ? hoursAfterMeal.value
        : this.hoursAfterMeal,
    note: note.present ? note.value : this.note,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  GlucoseReadingRow copyWithCompanion(GlucoseReadingsTableCompanion data) {
    return GlucoseReadingRow(
      id: data.id.present ? data.id.value : this.id,
      readingType: data.readingType.present
          ? data.readingType.value
          : this.readingType,
      valueMgDl: data.valueMgDl.present ? data.valueMgDl.value : this.valueMgDl,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      tzOffsetMin: data.tzOffsetMin.present
          ? data.tzOffsetMin.value
          : this.tzOffsetMin,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      status: data.status.present ? data.status.value : this.status,
      isCritical: data.isCritical.present
          ? data.isCritical.value
          : this.isCritical,
      mealContext: data.mealContext.present
          ? data.mealContext.value
          : this.mealContext,
      hoursAfterMeal: data.hoursAfterMeal.present
          ? data.hoursAfterMeal.value
          : this.hoursAfterMeal,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GlucoseReadingRow(')
          ..write('id: $id, ')
          ..write('readingType: $readingType, ')
          ..write('valueMgDl: $valueMgDl, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('tzOffsetMin: $tzOffsetMin, ')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('isCritical: $isCritical, ')
          ..write('mealContext: $mealContext, ')
          ..write('hoursAfterMeal: $hoursAfterMeal, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    readingType,
    valueMgDl,
    measuredAt,
    tzOffsetMin,
    localDate,
    status,
    isCritical,
    mealContext,
    hoursAfterMeal,
    note,
    source,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GlucoseReadingRow &&
          other.id == this.id &&
          other.readingType == this.readingType &&
          other.valueMgDl == this.valueMgDl &&
          other.measuredAt == this.measuredAt &&
          other.tzOffsetMin == this.tzOffsetMin &&
          other.localDate == this.localDate &&
          other.status == this.status &&
          other.isCritical == this.isCritical &&
          other.mealContext == this.mealContext &&
          other.hoursAfterMeal == this.hoursAfterMeal &&
          other.note == this.note &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class GlucoseReadingsTableCompanion extends UpdateCompanion<GlucoseReadingRow> {
  final Value<int> id;
  final Value<String> readingType;
  final Value<int> valueMgDl;
  final Value<int> measuredAt;
  final Value<int> tzOffsetMin;
  final Value<String> localDate;
  final Value<String> status;
  final Value<bool> isCritical;
  final Value<String?> mealContext;
  final Value<double?> hoursAfterMeal;
  final Value<String?> note;
  final Value<String> source;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  const GlucoseReadingsTableCompanion({
    this.id = const Value.absent(),
    this.readingType = const Value.absent(),
    this.valueMgDl = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.tzOffsetMin = const Value.absent(),
    this.localDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.mealContext = const Value.absent(),
    this.hoursAfterMeal = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  GlucoseReadingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String readingType,
    required int valueMgDl,
    required int measuredAt,
    required int tzOffsetMin,
    required String localDate,
    required String status,
    this.isCritical = const Value.absent(),
    this.mealContext = const Value.absent(),
    this.hoursAfterMeal = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
  }) : readingType = Value(readingType),
       valueMgDl = Value(valueMgDl),
       measuredAt = Value(measuredAt),
       tzOffsetMin = Value(tzOffsetMin),
       localDate = Value(localDate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GlucoseReadingRow> custom({
    Expression<int>? id,
    Expression<String>? readingType,
    Expression<int>? valueMgDl,
    Expression<int>? measuredAt,
    Expression<int>? tzOffsetMin,
    Expression<String>? localDate,
    Expression<String>? status,
    Expression<bool>? isCritical,
    Expression<String>? mealContext,
    Expression<double>? hoursAfterMeal,
    Expression<String>? note,
    Expression<String>? source,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (readingType != null) 'reading_type': readingType,
      if (valueMgDl != null) 'value_mg_dl': valueMgDl,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (tzOffsetMin != null) 'tz_offset_min': tzOffsetMin,
      if (localDate != null) 'local_date': localDate,
      if (status != null) 'status': status,
      if (isCritical != null) 'is_critical': isCritical,
      if (mealContext != null) 'meal_context': mealContext,
      if (hoursAfterMeal != null) 'hours_after_meal': hoursAfterMeal,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  GlucoseReadingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? readingType,
    Value<int>? valueMgDl,
    Value<int>? measuredAt,
    Value<int>? tzOffsetMin,
    Value<String>? localDate,
    Value<String>? status,
    Value<bool>? isCritical,
    Value<String?>? mealContext,
    Value<double?>? hoursAfterMeal,
    Value<String?>? note,
    Value<String>? source,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
  }) {
    return GlucoseReadingsTableCompanion(
      id: id ?? this.id,
      readingType: readingType ?? this.readingType,
      valueMgDl: valueMgDl ?? this.valueMgDl,
      measuredAt: measuredAt ?? this.measuredAt,
      tzOffsetMin: tzOffsetMin ?? this.tzOffsetMin,
      localDate: localDate ?? this.localDate,
      status: status ?? this.status,
      isCritical: isCritical ?? this.isCritical,
      mealContext: mealContext ?? this.mealContext,
      hoursAfterMeal: hoursAfterMeal ?? this.hoursAfterMeal,
      note: note ?? this.note,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (readingType.present) {
      map['reading_type'] = Variable<String>(readingType.value);
    }
    if (valueMgDl.present) {
      map['value_mg_dl'] = Variable<int>(valueMgDl.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<int>(measuredAt.value);
    }
    if (tzOffsetMin.present) {
      map['tz_offset_min'] = Variable<int>(tzOffsetMin.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isCritical.present) {
      map['is_critical'] = Variable<bool>(isCritical.value);
    }
    if (mealContext.present) {
      map['meal_context'] = Variable<String>(mealContext.value);
    }
    if (hoursAfterMeal.present) {
      map['hours_after_meal'] = Variable<double>(hoursAfterMeal.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GlucoseReadingsTableCompanion(')
          ..write('id: $id, ')
          ..write('readingType: $readingType, ')
          ..write('valueMgDl: $valueMgDl, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('tzOffsetMin: $tzOffsetMin, ')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('isCritical: $isCritical, ')
          ..write('mealContext: $mealContext, ')
          ..write('hoursAfterMeal: $hoursAfterMeal, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $ReadingSymptomsTableTable extends ReadingSymptomsTable
    with TableInfo<$ReadingSymptomsTableTable, ReadingSymptomRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSymptomsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _readingIdMeta = const VerificationMeta(
    'readingId',
  );
  @override
  late final GeneratedColumn<int> readingId = GeneratedColumn<int>(
    'reading_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES glucose_readings (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _symptomMeta = const VerificationMeta(
    'symptom',
  );
  @override
  late final GeneratedColumn<String> symptom = GeneratedColumn<String>(
    'symptom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [readingId, symptom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSymptomRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reading_id')) {
      context.handle(
        _readingIdMeta,
        readingId.isAcceptableOrUnknown(data['reading_id']!, _readingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_readingIdMeta);
    }
    if (data.containsKey('symptom')) {
      context.handle(
        _symptomMeta,
        symptom.isAcceptableOrUnknown(data['symptom']!, _symptomMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {readingId, symptom};
  @override
  ReadingSymptomRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSymptomRow(
      readingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reading_id'],
      )!,
      symptom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom'],
      )!,
    );
  }

  @override
  $ReadingSymptomsTableTable createAlias(String alias) {
    return $ReadingSymptomsTableTable(attachedDatabase, alias);
  }
}

class ReadingSymptomRow extends DataClass
    implements Insertable<ReadingSymptomRow> {
  final int readingId;
  final String symptom;
  const ReadingSymptomRow({required this.readingId, required this.symptom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reading_id'] = Variable<int>(readingId);
    map['symptom'] = Variable<String>(symptom);
    return map;
  }

  ReadingSymptomsTableCompanion toCompanion(bool nullToAbsent) {
    return ReadingSymptomsTableCompanion(
      readingId: Value(readingId),
      symptom: Value(symptom),
    );
  }

  factory ReadingSymptomRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSymptomRow(
      readingId: serializer.fromJson<int>(json['readingId']),
      symptom: serializer.fromJson<String>(json['symptom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'readingId': serializer.toJson<int>(readingId),
      'symptom': serializer.toJson<String>(symptom),
    };
  }

  ReadingSymptomRow copyWith({int? readingId, String? symptom}) =>
      ReadingSymptomRow(
        readingId: readingId ?? this.readingId,
        symptom: symptom ?? this.symptom,
      );
  ReadingSymptomRow copyWithCompanion(ReadingSymptomsTableCompanion data) {
    return ReadingSymptomRow(
      readingId: data.readingId.present ? data.readingId.value : this.readingId,
      symptom: data.symptom.present ? data.symptom.value : this.symptom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSymptomRow(')
          ..write('readingId: $readingId, ')
          ..write('symptom: $symptom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(readingId, symptom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSymptomRow &&
          other.readingId == this.readingId &&
          other.symptom == this.symptom);
}

class ReadingSymptomsTableCompanion extends UpdateCompanion<ReadingSymptomRow> {
  final Value<int> readingId;
  final Value<String> symptom;
  final Value<int> rowid;
  const ReadingSymptomsTableCompanion({
    this.readingId = const Value.absent(),
    this.symptom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingSymptomsTableCompanion.insert({
    required int readingId,
    required String symptom,
    this.rowid = const Value.absent(),
  }) : readingId = Value(readingId),
       symptom = Value(symptom);
  static Insertable<ReadingSymptomRow> custom({
    Expression<int>? readingId,
    Expression<String>? symptom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (readingId != null) 'reading_id': readingId,
      if (symptom != null) 'symptom': symptom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingSymptomsTableCompanion copyWith({
    Value<int>? readingId,
    Value<String>? symptom,
    Value<int>? rowid,
  }) {
    return ReadingSymptomsTableCompanion(
      readingId: readingId ?? this.readingId,
      symptom: symptom ?? this.symptom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (readingId.present) {
      map['reading_id'] = Variable<int>(readingId.value);
    }
    if (symptom.present) {
      map['symptom'] = Variable<String>(symptom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSymptomsTableCompanion(')
          ..write('readingId: $readingId, ')
          ..write('symptom: $symptom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingTypeMeta = const VerificationMeta(
    'readingType',
  );
  @override
  late final GeneratedColumn<String> readingType = GeneratedColumn<String>(
    'reading_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeOfMinutesMeta = const VerificationMeta(
    'timeOfMinutes',
  );
  @override
  late final GeneratedColumn<int> timeOfMinutes = GeneratedColumn<int>(
    'time_of_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysMaskMeta = const VerificationMeta(
    'daysMask',
  );
  @override
  late final GeneratedColumn<int> daysMask = GeneratedColumn<int>(
    'days_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    readingType,
    timeOfMinutes,
    daysMask,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('reading_type')) {
      context.handle(
        _readingTypeMeta,
        readingType.isAcceptableOrUnknown(
          data['reading_type']!,
          _readingTypeMeta,
        ),
      );
    }
    if (data.containsKey('time_of_minutes')) {
      context.handle(
        _timeOfMinutesMeta,
        timeOfMinutes.isAcceptableOrUnknown(
          data['time_of_minutes']!,
          _timeOfMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeOfMinutesMeta);
    }
    if (data.containsKey('days_mask')) {
      context.handle(
        _daysMaskMeta,
        daysMask.isAcceptableOrUnknown(data['days_mask']!, _daysMaskMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      readingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_type'],
      ),
      timeOfMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_of_minutes'],
      )!,
      daysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_mask'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final int id;
  final String label;
  final String? readingType;
  final int timeOfMinutes;
  final int daysMask;
  final bool isActive;
  final int createdAt;
  const ReminderRow({
    required this.id,
    required this.label,
    this.readingType,
    required this.timeOfMinutes,
    required this.daysMask,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || readingType != null) {
      map['reading_type'] = Variable<String>(readingType);
    }
    map['time_of_minutes'] = Variable<int>(timeOfMinutes);
    map['days_mask'] = Variable<int>(daysMask);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      label: Value(label),
      readingType: readingType == null && nullToAbsent
          ? const Value.absent()
          : Value(readingType),
      timeOfMinutes: Value(timeOfMinutes),
      daysMask: Value(daysMask),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      readingType: serializer.fromJson<String?>(json['readingType']),
      timeOfMinutes: serializer.fromJson<int>(json['timeOfMinutes']),
      daysMask: serializer.fromJson<int>(json['daysMask']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'readingType': serializer.toJson<String?>(readingType),
      'timeOfMinutes': serializer.toJson<int>(timeOfMinutes),
      'daysMask': serializer.toJson<int>(daysMask),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ReminderRow copyWith({
    int? id,
    String? label,
    Value<String?> readingType = const Value.absent(),
    int? timeOfMinutes,
    int? daysMask,
    bool? isActive,
    int? createdAt,
  }) => ReminderRow(
    id: id ?? this.id,
    label: label ?? this.label,
    readingType: readingType.present ? readingType.value : this.readingType,
    timeOfMinutes: timeOfMinutes ?? this.timeOfMinutes,
    daysMask: daysMask ?? this.daysMask,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  ReminderRow copyWithCompanion(RemindersTableCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      readingType: data.readingType.present
          ? data.readingType.value
          : this.readingType,
      timeOfMinutes: data.timeOfMinutes.present
          ? data.timeOfMinutes.value
          : this.timeOfMinutes,
      daysMask: data.daysMask.present ? data.daysMask.value : this.daysMask,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('readingType: $readingType, ')
          ..write('timeOfMinutes: $timeOfMinutes, ')
          ..write('daysMask: $daysMask, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    readingType,
    timeOfMinutes,
    daysMask,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.readingType == this.readingType &&
          other.timeOfMinutes == this.timeOfMinutes &&
          other.daysMask == this.daysMask &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class RemindersTableCompanion extends UpdateCompanion<ReminderRow> {
  final Value<int> id;
  final Value<String> label;
  final Value<String?> readingType;
  final Value<int> timeOfMinutes;
  final Value<int> daysMask;
  final Value<bool> isActive;
  final Value<int> createdAt;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.readingType = const Value.absent(),
    this.timeOfMinutes = const Value.absent(),
    this.daysMask = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.readingType = const Value.absent(),
    required int timeOfMinutes,
    this.daysMask = const Value.absent(),
    this.isActive = const Value.absent(),
    required int createdAt,
  }) : label = Value(label),
       timeOfMinutes = Value(timeOfMinutes),
       createdAt = Value(createdAt);
  static Insertable<ReminderRow> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? readingType,
    Expression<int>? timeOfMinutes,
    Expression<int>? daysMask,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (readingType != null) 'reading_type': readingType,
      if (timeOfMinutes != null) 'time_of_minutes': timeOfMinutes,
      if (daysMask != null) 'days_mask': daysMask,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RemindersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<String?>? readingType,
    Value<int>? timeOfMinutes,
    Value<int>? daysMask,
    Value<bool>? isActive,
    Value<int>? createdAt,
  }) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      readingType: readingType ?? this.readingType,
      timeOfMinutes: timeOfMinutes ?? this.timeOfMinutes,
      daysMask: daysMask ?? this.daysMask,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (readingType.present) {
      map['reading_type'] = Variable<String>(readingType.value);
    }
    if (timeOfMinutes.present) {
      map['time_of_minutes'] = Variable<int>(timeOfMinutes.value);
    }
    if (daysMask.present) {
      map['days_mask'] = Variable<int>(daysMask.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('readingType: $readingType, ')
          ..write('timeOfMinutes: $timeOfMinutes, ')
          ..write('daysMask: $daysMask, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String key;
  final String? value;
  const AppSettingRow({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSettingRow copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppSettingRow(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppSettingRow copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfileTableTable userProfileTable = $UserProfileTableTable(
    this,
  );
  late final $TargetRangesTableTable targetRangesTable =
      $TargetRangesTableTable(this);
  late final $GlucoseReadingsTableTable glucoseReadingsTable =
      $GlucoseReadingsTableTable(this);
  late final $ReadingSymptomsTableTable readingSymptomsTable =
      $ReadingSymptomsTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final TargetDao targetDao = TargetDao(this as AppDatabase);
  late final GlucoseDao glucoseDao = GlucoseDao(this as AppDatabase);
  late final ReminderDao reminderDao = ReminderDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfileTable,
    targetRangesTable,
    glucoseReadingsTable,
    readingSymptomsTable,
    remindersTable,
    appSettingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'glucose_readings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_symptoms', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserProfileTableTableCreateCompanionBuilder =
    UserProfileTableCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<int?> birthYear,
      Value<String> diabetesType,
      Value<String> unit,
      Value<String> preset,
      Value<bool> onboardingDone,
      required int createdAt,
      required int updatedAt,
    });
typedef $$UserProfileTableTableUpdateCompanionBuilder =
    UserProfileTableCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<int?> birthYear,
      Value<String> diabetesType,
      Value<String> unit,
      Value<String> preset,
      Value<bool> onboardingDone,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$UserProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diabetesType => $composableBuilder(
    column: $table.diabetesType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preset => $composableBuilder(
    column: $table.preset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diabetesType => $composableBuilder(
    column: $table.diabetesType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preset => $composableBuilder(
    column: $table.preset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<String> get diabetesType => $composableBuilder(
    column: $table.diabetesType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get preset =>
      $composableBuilder(column: $table.preset, builder: (column) => column);

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTableTable,
          UserProfileRow,
          $$UserProfileTableTableFilterComposer,
          $$UserProfileTableTableOrderingComposer,
          $$UserProfileTableTableAnnotationComposer,
          $$UserProfileTableTableCreateCompanionBuilder,
          $$UserProfileTableTableUpdateCompanionBuilder,
          (
            UserProfileRow,
            BaseReferences<
              _$AppDatabase,
              $UserProfileTableTable,
              UserProfileRow
            >,
          ),
          UserProfileRow,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableTableManager(
    _$AppDatabase db,
    $UserProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String> diabetesType = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> preset = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => UserProfileTableCompanion(
                id: id,
                name: name,
                birthYear: birthYear,
                diabetesType: diabetesType,
                unit: unit,
                preset: preset,
                onboardingDone: onboardingDone,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<String> diabetesType = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> preset = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => UserProfileTableCompanion.insert(
                id: id,
                name: name,
                birthYear: birthYear,
                diabetesType: diabetesType,
                unit: unit,
                preset: preset,
                onboardingDone: onboardingDone,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfileTableTable, UserProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfileTableTable,
                    UserProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTableTable,
      UserProfileRow,
      $$UserProfileTableTableFilterComposer,
      $$UserProfileTableTableOrderingComposer,
      $$UserProfileTableTableAnnotationComposer,
      $$UserProfileTableTableCreateCompanionBuilder,
      $$UserProfileTableTableUpdateCompanionBuilder,
      (
        UserProfileRow,
        BaseReferences<_$AppDatabase, $UserProfileTableTable, UserProfileRow>,
      ),
      UserProfileRow,
      PrefetchHooks Function()
    >;
typedef $$TargetRangesTableTableCreateCompanionBuilder =
    TargetRangesTableCompanion Function({
      Value<int> id,
      required String readingType,
      required int lowMax,
      required int normalMax,
      required int warningMax,
      Value<int> criticalLow,
      Value<int> criticalHigh,
      required int updatedAt,
    });
typedef $$TargetRangesTableTableUpdateCompanionBuilder =
    TargetRangesTableCompanion Function({
      Value<int> id,
      Value<String> readingType,
      Value<int> lowMax,
      Value<int> normalMax,
      Value<int> warningMax,
      Value<int> criticalLow,
      Value<int> criticalHigh,
      Value<int> updatedAt,
    });

class $$TargetRangesTableTableFilterComposer
    extends Composer<_$AppDatabase, $TargetRangesTableTable> {
  $$TargetRangesTableTableFilterComposer({
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

  ColumnFilters<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowMax => $composableBuilder(
    column: $table.lowMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get normalMax => $composableBuilder(
    column: $table.normalMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warningMax => $composableBuilder(
    column: $table.warningMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get criticalLow => $composableBuilder(
    column: $table.criticalLow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get criticalHigh => $composableBuilder(
    column: $table.criticalHigh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TargetRangesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetRangesTableTable> {
  $$TargetRangesTableTableOrderingComposer({
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

  ColumnOrderings<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowMax => $composableBuilder(
    column: $table.lowMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get normalMax => $composableBuilder(
    column: $table.normalMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warningMax => $composableBuilder(
    column: $table.warningMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get criticalLow => $composableBuilder(
    column: $table.criticalLow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get criticalHigh => $composableBuilder(
    column: $table.criticalHigh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TargetRangesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetRangesTableTable> {
  $$TargetRangesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lowMax =>
      $composableBuilder(column: $table.lowMax, builder: (column) => column);

  GeneratedColumn<int> get normalMax =>
      $composableBuilder(column: $table.normalMax, builder: (column) => column);

  GeneratedColumn<int> get warningMax => $composableBuilder(
    column: $table.warningMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get criticalLow => $composableBuilder(
    column: $table.criticalLow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get criticalHigh => $composableBuilder(
    column: $table.criticalHigh,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TargetRangesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetRangesTableTable,
          TargetRangeRow,
          $$TargetRangesTableTableFilterComposer,
          $$TargetRangesTableTableOrderingComposer,
          $$TargetRangesTableTableAnnotationComposer,
          $$TargetRangesTableTableCreateCompanionBuilder,
          $$TargetRangesTableTableUpdateCompanionBuilder,
          (
            TargetRangeRow,
            BaseReferences<
              _$AppDatabase,
              $TargetRangesTableTable,
              TargetRangeRow
            >,
          ),
          TargetRangeRow,
          PrefetchHooks Function()
        > {
  $$TargetRangesTableTableTableManager(
    _$AppDatabase db,
    $TargetRangesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetRangesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetRangesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetRangesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> readingType = const Value.absent(),
                Value<int> lowMax = const Value.absent(),
                Value<int> normalMax = const Value.absent(),
                Value<int> warningMax = const Value.absent(),
                Value<int> criticalLow = const Value.absent(),
                Value<int> criticalHigh = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => TargetRangesTableCompanion(
                id: id,
                readingType: readingType,
                lowMax: lowMax,
                normalMax: normalMax,
                warningMax: warningMax,
                criticalLow: criticalLow,
                criticalHigh: criticalHigh,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String readingType,
                required int lowMax,
                required int normalMax,
                required int warningMax,
                Value<int> criticalLow = const Value.absent(),
                Value<int> criticalHigh = const Value.absent(),
                required int updatedAt,
              }) => TargetRangesTableCompanion.insert(
                id: id,
                readingType: readingType,
                lowMax: lowMax,
                normalMax: normalMax,
                warningMax: warningMax,
                criticalLow: criticalLow,
                criticalHigh: criticalHigh,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TargetRangesTableTable, TargetRangeRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TargetRangesTableTable,
                    TargetRangeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TargetRangesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetRangesTableTable,
      TargetRangeRow,
      $$TargetRangesTableTableFilterComposer,
      $$TargetRangesTableTableOrderingComposer,
      $$TargetRangesTableTableAnnotationComposer,
      $$TargetRangesTableTableCreateCompanionBuilder,
      $$TargetRangesTableTableUpdateCompanionBuilder,
      (
        TargetRangeRow,
        BaseReferences<_$AppDatabase, $TargetRangesTableTable, TargetRangeRow>,
      ),
      TargetRangeRow,
      PrefetchHooks Function()
    >;
typedef $$GlucoseReadingsTableTableCreateCompanionBuilder =
    GlucoseReadingsTableCompanion Function({
      Value<int> id,
      required String readingType,
      required int valueMgDl,
      required int measuredAt,
      required int tzOffsetMin,
      required String localDate,
      required String status,
      Value<bool> isCritical,
      Value<String?> mealContext,
      Value<double?> hoursAfterMeal,
      Value<String?> note,
      Value<String> source,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
    });
typedef $$GlucoseReadingsTableTableUpdateCompanionBuilder =
    GlucoseReadingsTableCompanion Function({
      Value<int> id,
      Value<String> readingType,
      Value<int> valueMgDl,
      Value<int> measuredAt,
      Value<int> tzOffsetMin,
      Value<String> localDate,
      Value<String> status,
      Value<bool> isCritical,
      Value<String?> mealContext,
      Value<double?> hoursAfterMeal,
      Value<String?> note,
      Value<String> source,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
    });

final class $$GlucoseReadingsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GlucoseReadingsTableTable,
          GlucoseReadingRow
        > {
  $$GlucoseReadingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ReadingSymptomsTableTable,
    List<ReadingSymptomRow>
  >
  _readingSymptomsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.readingSymptomsTable,
        aliasName: 'glucose_readings__id__reading_symptoms__reading_id',
      );

  $$ReadingSymptomsTableTableProcessedTableManager
  get readingSymptomsTableRefs {
    final manager = $$ReadingSymptomsTableTableTableManager(
      $_db,
      $_db.readingSymptomsTable,
    ).filter((f) => f.readingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSymptomsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GlucoseReadingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GlucoseReadingsTableTable> {
  $$GlucoseReadingsTableTableFilterComposer({
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

  ColumnFilters<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valueMgDl => $composableBuilder(
    column: $table.valueMgDl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tzOffsetMin => $composableBuilder(
    column: $table.tzOffsetMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealContext => $composableBuilder(
    column: $table.mealContext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hoursAfterMeal => $composableBuilder(
    column: $table.hoursAfterMeal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> readingSymptomsTableRefs(
    Expression<bool> Function($$ReadingSymptomsTableTableFilterComposer f) f,
  ) {
    final $$ReadingSymptomsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSymptomsTable,
      getReferencedColumn: (t) => t.readingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSymptomsTableTableFilterComposer(
            $db: $db,
            $table: $db.readingSymptomsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GlucoseReadingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GlucoseReadingsTableTable> {
  $$GlucoseReadingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueMgDl => $composableBuilder(
    column: $table.valueMgDl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tzOffsetMin => $composableBuilder(
    column: $table.tzOffsetMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealContext => $composableBuilder(
    column: $table.mealContext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hoursAfterMeal => $composableBuilder(
    column: $table.hoursAfterMeal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GlucoseReadingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GlucoseReadingsTableTable> {
  $$GlucoseReadingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valueMgDl =>
      $composableBuilder(column: $table.valueMgDl, builder: (column) => column);

  GeneratedColumn<int> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tzOffsetMin => $composableBuilder(
    column: $table.tzOffsetMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealContext => $composableBuilder(
    column: $table.mealContext,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hoursAfterMeal => $composableBuilder(
    column: $table.hoursAfterMeal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> readingSymptomsTableRefs<T extends Object>(
    Expression<T> Function($$ReadingSymptomsTableTableAnnotationComposer a) f,
  ) {
    final $$ReadingSymptomsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingSymptomsTable,
          getReferencedColumn: (t) => t.readingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSymptomsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.readingSymptomsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GlucoseReadingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GlucoseReadingsTableTable,
          GlucoseReadingRow,
          $$GlucoseReadingsTableTableFilterComposer,
          $$GlucoseReadingsTableTableOrderingComposer,
          $$GlucoseReadingsTableTableAnnotationComposer,
          $$GlucoseReadingsTableTableCreateCompanionBuilder,
          $$GlucoseReadingsTableTableUpdateCompanionBuilder,
          (GlucoseReadingRow, $$GlucoseReadingsTableTableReferences),
          GlucoseReadingRow,
          PrefetchHooks Function({bool readingSymptomsTableRefs})
        > {
  $$GlucoseReadingsTableTableTableManager(
    _$AppDatabase db,
    $GlucoseReadingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GlucoseReadingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GlucoseReadingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GlucoseReadingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> readingType = const Value.absent(),
                Value<int> valueMgDl = const Value.absent(),
                Value<int> measuredAt = const Value.absent(),
                Value<int> tzOffsetMin = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isCritical = const Value.absent(),
                Value<String?> mealContext = const Value.absent(),
                Value<double?> hoursAfterMeal = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
              }) => GlucoseReadingsTableCompanion(
                id: id,
                readingType: readingType,
                valueMgDl: valueMgDl,
                measuredAt: measuredAt,
                tzOffsetMin: tzOffsetMin,
                localDate: localDate,
                status: status,
                isCritical: isCritical,
                mealContext: mealContext,
                hoursAfterMeal: hoursAfterMeal,
                note: note,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String readingType,
                required int valueMgDl,
                required int measuredAt,
                required int tzOffsetMin,
                required String localDate,
                required String status,
                Value<bool> isCritical = const Value.absent(),
                Value<String?> mealContext = const Value.absent(),
                Value<double?> hoursAfterMeal = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
              }) => GlucoseReadingsTableCompanion.insert(
                id: id,
                readingType: readingType,
                valueMgDl: valueMgDl,
                measuredAt: measuredAt,
                tzOffsetMin: tzOffsetMin,
                localDate: localDate,
                status: status,
                isCritical: isCritical,
                mealContext: mealContext,
                hoursAfterMeal: hoursAfterMeal,
                note: note,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GlucoseReadingsTableTable, GlucoseReadingRow>(
                    table,
                  ),
                  $$GlucoseReadingsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({readingSymptomsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (readingSymptomsTableRefs) db.readingSymptomsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (readingSymptomsTableRefs)
                    await $_getPrefetchedData<
                      GlucoseReadingRow,
                      $GlucoseReadingsTableTable,
                      ReadingSymptomRow
                    >(
                      currentTable: table,
                      referencedTable: $$GlucoseReadingsTableTableReferences
                          ._readingSymptomsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GlucoseReadingsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).readingSymptomsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.readingId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GlucoseReadingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GlucoseReadingsTableTable,
      GlucoseReadingRow,
      $$GlucoseReadingsTableTableFilterComposer,
      $$GlucoseReadingsTableTableOrderingComposer,
      $$GlucoseReadingsTableTableAnnotationComposer,
      $$GlucoseReadingsTableTableCreateCompanionBuilder,
      $$GlucoseReadingsTableTableUpdateCompanionBuilder,
      (GlucoseReadingRow, $$GlucoseReadingsTableTableReferences),
      GlucoseReadingRow,
      PrefetchHooks Function({bool readingSymptomsTableRefs})
    >;
typedef $$ReadingSymptomsTableTableCreateCompanionBuilder =
    ReadingSymptomsTableCompanion Function({
      required int readingId,
      required String symptom,
      Value<int> rowid,
    });
typedef $$ReadingSymptomsTableTableUpdateCompanionBuilder =
    ReadingSymptomsTableCompanion Function({
      Value<int> readingId,
      Value<String> symptom,
      Value<int> rowid,
    });

final class $$ReadingSymptomsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingSymptomsTableTable,
          ReadingSymptomRow
        > {
  $$ReadingSymptomsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GlucoseReadingsTableTable _readingIdTable(_$AppDatabase db) => db
      .glucoseReadingsTable
      .createAlias('reading_symptoms__reading_id__glucose_readings__id');

  $$GlucoseReadingsTableTableProcessedTableManager get readingId {
    final $_column = $_itemColumn<int>('reading_id')!;

    final manager = $$GlucoseReadingsTableTableTableManager(
      $_db,
      $_db.glucoseReadingsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_readingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingSymptomsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSymptomsTableTable> {
  $$ReadingSymptomsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symptom => $composableBuilder(
    column: $table.symptom,
    builder: (column) => ColumnFilters(column),
  );

  $$GlucoseReadingsTableTableFilterComposer get readingId {
    final $$GlucoseReadingsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.readingId,
      referencedTable: $db.glucoseReadingsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GlucoseReadingsTableTableFilterComposer(
            $db: $db,
            $table: $db.glucoseReadingsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSymptomsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSymptomsTableTable> {
  $$ReadingSymptomsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symptom => $composableBuilder(
    column: $table.symptom,
    builder: (column) => ColumnOrderings(column),
  );

  $$GlucoseReadingsTableTableOrderingComposer get readingId {
    final $$GlucoseReadingsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingId,
          referencedTable: $db.glucoseReadingsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GlucoseReadingsTableTableOrderingComposer(
                $db: $db,
                $table: $db.glucoseReadingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReadingSymptomsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSymptomsTableTable> {
  $$ReadingSymptomsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symptom =>
      $composableBuilder(column: $table.symptom, builder: (column) => column);

  $$GlucoseReadingsTableTableAnnotationComposer get readingId {
    final $$GlucoseReadingsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingId,
          referencedTable: $db.glucoseReadingsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GlucoseReadingsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.glucoseReadingsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReadingSymptomsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSymptomsTableTable,
          ReadingSymptomRow,
          $$ReadingSymptomsTableTableFilterComposer,
          $$ReadingSymptomsTableTableOrderingComposer,
          $$ReadingSymptomsTableTableAnnotationComposer,
          $$ReadingSymptomsTableTableCreateCompanionBuilder,
          $$ReadingSymptomsTableTableUpdateCompanionBuilder,
          (ReadingSymptomRow, $$ReadingSymptomsTableTableReferences),
          ReadingSymptomRow,
          PrefetchHooks Function({bool readingId})
        > {
  $$ReadingSymptomsTableTableTableManager(
    _$AppDatabase db,
    $ReadingSymptomsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSymptomsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSymptomsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReadingSymptomsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> readingId = const Value.absent(),
                Value<String> symptom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingSymptomsTableCompanion(
                readingId: readingId,
                symptom: symptom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int readingId,
                required String symptom,
                Value<int> rowid = const Value.absent(),
              }) => ReadingSymptomsTableCompanion.insert(
                readingId: readingId,
                symptom: symptom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingSymptomsTableTable, ReadingSymptomRow>(
                    table,
                  ),
                  $$ReadingSymptomsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({readingId = false}) {
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
                    if (readingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.readingId,
                        referencedTable: $$ReadingSymptomsTableTableReferences
                            ._readingIdTable(db),
                        referencedColumn: $$ReadingSymptomsTableTableReferences
                            ._readingIdTable(db)
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

typedef $$ReadingSymptomsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSymptomsTableTable,
      ReadingSymptomRow,
      $$ReadingSymptomsTableTableFilterComposer,
      $$ReadingSymptomsTableTableOrderingComposer,
      $$ReadingSymptomsTableTableAnnotationComposer,
      $$ReadingSymptomsTableTableCreateCompanionBuilder,
      $$ReadingSymptomsTableTableUpdateCompanionBuilder,
      (ReadingSymptomRow, $$ReadingSymptomsTableTableReferences),
      ReadingSymptomRow,
      PrefetchHooks Function({bool readingId})
    >;
typedef $$RemindersTableTableCreateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<int> id,
      required String label,
      Value<String?> readingType,
      required int timeOfMinutes,
      Value<int> daysMask,
      Value<bool> isActive,
      required int createdAt,
    });
typedef $$RemindersTableTableUpdateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<String?> readingType,
      Value<int> timeOfMinutes,
      Value<int> daysMask,
      Value<bool> isActive,
      Value<int> createdAt,
    });

class $$RemindersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeOfMinutes => $composableBuilder(
    column: $table.timeOfMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysMask => $composableBuilder(
    column: $table.daysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeOfMinutes => $composableBuilder(
    column: $table.timeOfMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysMask => $composableBuilder(
    column: $table.daysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get readingType => $composableBuilder(
    column: $table.readingType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeOfMinutes => $composableBuilder(
    column: $table.timeOfMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysMask =>
      $composableBuilder(column: $table.daysMask, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RemindersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTableTable,
          ReminderRow,
          $$RemindersTableTableFilterComposer,
          $$RemindersTableTableOrderingComposer,
          $$RemindersTableTableAnnotationComposer,
          $$RemindersTableTableCreateCompanionBuilder,
          $$RemindersTableTableUpdateCompanionBuilder,
          (
            ReminderRow,
            BaseReferences<_$AppDatabase, $RemindersTableTable, ReminderRow>,
          ),
          ReminderRow,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableTableManager(
    _$AppDatabase db,
    $RemindersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> readingType = const Value.absent(),
                Value<int> timeOfMinutes = const Value.absent(),
                Value<int> daysMask = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => RemindersTableCompanion(
                id: id,
                label: label,
                readingType: readingType,
                timeOfMinutes: timeOfMinutes,
                daysMask: daysMask,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                Value<String?> readingType = const Value.absent(),
                required int timeOfMinutes,
                Value<int> daysMask = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required int createdAt,
              }) => RemindersTableCompanion.insert(
                id: id,
                label: label,
                readingType: readingType,
                timeOfMinutes: timeOfMinutes,
                daysMask: daysMask,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTableTable, ReminderRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RemindersTableTable,
                    ReminderRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTableTable,
      ReminderRow,
      $$RemindersTableTableFilterComposer,
      $$RemindersTableTableOrderingComposer,
      $$RemindersTableTableAnnotationComposer,
      $$RemindersTableTableCreateCompanionBuilder,
      $$RemindersTableTableUpdateCompanionBuilder,
      (
        ReminderRow,
        BaseReferences<_$AppDatabase, $RemindersTableTable, ReminderRow>,
      ),
      ReminderRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingRow,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingRow
            >,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingRow,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfileTableTableTableManager get userProfileTable =>
      $$UserProfileTableTableTableManager(_db, _db.userProfileTable);
  $$TargetRangesTableTableTableManager get targetRangesTable =>
      $$TargetRangesTableTableTableManager(_db, _db.targetRangesTable);
  $$GlucoseReadingsTableTableTableManager get glucoseReadingsTable =>
      $$GlucoseReadingsTableTableTableManager(_db, _db.glucoseReadingsTable);
  $$ReadingSymptomsTableTableTableManager get readingSymptomsTable =>
      $$ReadingSymptomsTableTableTableManager(_db, _db.readingSymptomsTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
