import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/tables/app_settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  new(super.attachedDatabase);

  Future<String?> read(String key) async {
    final row = await (select(
      appSettingsTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Stream<String?> watch(String key) => (select(
    appSettingsTable,
  )..where((t) => t.key.equals(key))).watchSingleOrNull().map((r) => r?.value);

  Future<void> write(String key, String? value) => into(appSettingsTable)
      .insertOnConflictUpdate(
        AppSettingsTableCompanion.insert(key: key, value: Value(value)),
      );

  Future<void> remove(String key) =>
      (delete(appSettingsTable)..where((t) => t.key.equals(key))).go();

  Future<bool> readBool(String key, {bool fallback = false}) async =>
      switch (await read(key)) {
        'true' => true,
        'false' => false,
        _ => fallback,
      };

  Future<void> writeBool(String key, {required bool value}) =>
      write(key, value ? 'true' : 'false');

  Future<DateTime?> readDateTime(String key) async {
    final raw = await read(key);
    final ms = raw == null ? null : int.tryParse(raw);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> writeDateTime(String key, DateTime value) =>
      write(key, value.millisecondsSinceEpoch.toString());
}
