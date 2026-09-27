// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_dao.dart';

// ignore_for_file: type=lint
mixin _$GlucoseDaoMixin on DatabaseAccessor<AppDatabase> {
  $GlucoseReadingsTableTable get glucoseReadingsTable =>
      attachedDatabase.glucoseReadingsTable;
  $ReadingSymptomsTableTable get readingSymptomsTable =>
      attachedDatabase.readingSymptomsTable;
  GlucoseDaoManager get managers => GlucoseDaoManager(this);
}

class GlucoseDaoManager {
  final _$GlucoseDaoMixin _db;
  GlucoseDaoManager(this._db);
  $$GlucoseReadingsTableTableTableManager get glucoseReadingsTable =>
      $$GlucoseReadingsTableTableTableManager(
        _db.attachedDatabase,
        _db.glucoseReadingsTable,
      );
  $$ReadingSymptomsTableTableTableManager get readingSymptomsTable =>
      $$ReadingSymptomsTableTableTableManager(
        _db.attachedDatabase,
        _db.readingSymptomsTable,
      );
}
