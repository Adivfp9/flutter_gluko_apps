import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/tables/target_ranges_table.dart';
import 'package:flutter_gluko_apps/database/tables/user_profile_table.dart';

part 'target_dao.g.dart';

@DriftAccessor(tables: [TargetRangesTable, UserProfileTable])
class TargetDao extends DatabaseAccessor<AppDatabase> with _$TargetDaoMixin {
  new(super.attachedDatabase);

  Future<List<TargetRangeRow>> all() => select(targetRangesTable).get();

  Stream<List<TargetRangeRow>> watchAll() => select(targetRangesTable).watch();

  Future<TargetRangeRow?> findByType(String readingType) => (select(
    targetRangesTable,
  )..where((t) => t.readingType.equals(readingType))).getSingleOrNull();

  /// Menyimpan ambang satu tipe. Memakai upsert pada kolom unik `reading_type`
  /// supaya restore backup yang barisnya belum ada tetap berhasil.
  Future<void> upsert(TargetRangesTableCompanion row) =>
      into(targetRangesTable).insert(
        row,
        onConflict: DoUpdate.withExcluded(
          (old, excluded) => TargetRangesTableCompanion.custom(
            lowMax: excluded.lowMax,
            normalMax: excluded.normalMax,
            warningMax: excluded.warningMax,
            criticalLow: excluded.criticalLow,
            criticalHigh: excluded.criticalHigh,
            updatedAt: excluded.updatedAt,
          ),
          target: [targetRangesTable.readingType],
        ),
      );

  Future<void> upsertAll(List<TargetRangesTableCompanion> rows) =>
      transaction(() async {
        for (final row in rows) {
          await upsert(row);
        }
      });

  Future<void> upsertAllWithProfile(
    List<TargetRangesTableCompanion> rows,
    UserProfileTableCompanion profile,
  ) => transaction(() async {
    for (final row in rows) {
      await upsert(row);
    }
    await into(userProfileTable)
        .insertOnConflictUpdate(profile.copyWith(id: const Value(1)));
  });
}
