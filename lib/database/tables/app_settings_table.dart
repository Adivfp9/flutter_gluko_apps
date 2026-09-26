import 'package:drift/drift.dart';

/// PRD 8.2: penyimpanan key-value untuk setelan kecil
/// (`last_backup_at`, `lock_enabled`, dan sebagainya).
@DataClassName('AppSettingRow')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();

  TextColumn get value => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
