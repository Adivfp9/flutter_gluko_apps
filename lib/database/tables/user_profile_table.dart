import 'package:drift/drift.dart';

/// PRD 8.2: satu baris profil, dipaksa `id = 1`.
@DataClassName('UserProfileRow')
class UserProfileTable extends Table {
  @override
  String get tableName => 'user_profile';

  IntColumn get id => integer().withDefault(const Constant(1))();

  TextColumn get name => text().nullable()();

  IntColumn get birthYear => integer().named('birth_year').nullable()();

  TextColumn get diabetesType =>
      text().named('diabetes_type').withDefault(const Constant('unknown'))();

  TextColumn get unit => text().withDefault(const Constant('mg_dl'))();

  TextColumn get preset => text().withDefault(const Constant('general'))();

  BoolColumn get onboardingDone =>
      boolean().named('onboarding_done').withDefault(const Constant(false))();

  IntColumn get createdAt => integer().named('created_at')();

  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    "CHECK (unit IN ('mg_dl','mmol_l'))",
  ];
}
