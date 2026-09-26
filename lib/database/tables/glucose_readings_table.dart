import 'package:drift/drift.dart';

/// PRD 8.2: tabel inti.
///
/// `measured_at` disimpan sebagai epoch milidetik UTC, `tz_offset_min` menyimpan
/// offset zona waktu saat pengukuran, dan `local_date` adalah turunan keduanya.
/// Ketiganya disimpan bersama supaya "hari" sebuah pembacaan tidak berubah saat
/// pengguna berpindah zona waktu (PRD 5.5).
@DataClassName('GlucoseReadingRow')
class GlucoseReadingsTable extends Table {
  @override
  String get tableName => 'glucose_readings';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get readingType => text().named('reading_type')();

  IntColumn get valueMgDl => integer().named('value_mg_dl')();

  IntColumn get measuredAt => integer().named('measured_at')();

  IntColumn get tzOffsetMin => integer().named('tz_offset_min')();

  TextColumn get localDate => text().named('local_date')();

  TextColumn get status => text()();

  BoolColumn get isCritical =>
      boolean().named('is_critical').withDefault(const Constant(false))();

  TextColumn get mealContext => text().named('meal_context').nullable()();

  RealColumn get hoursAfterMeal =>
      real().named('hours_after_meal').nullable()();

  TextColumn get note => text().nullable()();

  TextColumn get source => text().withDefault(const Constant('manual'))();

  IntColumn get createdAt => integer().named('created_at')();

  IntColumn get updatedAt => integer().named('updated_at')();

  /// Soft delete (PRD 5.5): baris tetap ada 30 hari agar Undo dan restore aman.
  IntColumn get deletedAt => integer().named('deleted_at').nullable()();

  @override
  List<String> get customConstraints => [
    "CHECK (reading_type IN ('fasting','random','postprandial_2h'))",
    'CHECK (value_mg_dl BETWEEN 20 AND 600)',
    "CHECK (status IN ('low','normal','warning','high'))",
    'CHECK (note IS NULL OR length(note) <= 500)',
  ];
}
