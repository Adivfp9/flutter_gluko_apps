import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/database/tables/glucose_readings_table.dart';

/// PRD 8.2: tabel junction gejala dengan primary key gabungan.
@DataClassName('ReadingSymptomRow')
class ReadingSymptomsTable extends Table {
  @override
  String get tableName => 'reading_symptoms';

  IntColumn get readingId => integer()
      .named('reading_id')
      .references(GlucoseReadingsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get symptom => text()();

  @override
  Set<Column<Object>> get primaryKey => {readingId, symptom};
}
