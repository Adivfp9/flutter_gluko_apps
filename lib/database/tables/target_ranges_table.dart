import 'package:drift/drift.dart';

/// PRD 8.2: ambang per tipe pengukuran, selalu dalam mg/dL.
///
/// CHECK berurutan (`low < normal < warning`) ada di level tabel supaya
/// target yang tidak konsisten tidak bisa masuk database, bahkan lewat jalur
/// selain use case (mis. restore backup yang cacat).
@DataClassName('TargetRangeRow')
class TargetRangesTable extends Table {
  @override
  String get tableName => 'target_ranges';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get readingType => text().named('reading_type').unique()();

  IntColumn get lowMax => integer().named('low_max')();

  IntColumn get normalMax => integer().named('normal_max')();

  IntColumn get warningMax => integer().named('warning_max')();

  IntColumn get criticalLow =>
      integer().named('critical_low').withDefault(const Constant(54))();

  IntColumn get criticalHigh =>
      integer().named('critical_high').withDefault(const Constant(300))();

  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  List<String> get customConstraints => [
    "CHECK (reading_type IN ('fasting','random','postprandial_2h'))",
    'CHECK (low_max < normal_max AND normal_max < warning_max)',
  ];
}
