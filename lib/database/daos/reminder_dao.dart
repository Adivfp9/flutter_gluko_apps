import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/tables/reminders_table.dart';

part 'reminder_dao.g.dart';

@DriftAccessor(tables: [RemindersTable])
class ReminderDao extends DatabaseAccessor<AppDatabase>
    with _$ReminderDaoMixin {
  new(super.attachedDatabase);

  Future<List<ReminderRow>> all() => (select(
    remindersTable,
  )..orderBy([(t) => OrderingTerm(expression: t.timeOfMinutes)])).get();

  Stream<List<ReminderRow>> watchAll() => (select(
    remindersTable,
  )..orderBy([(t) => OrderingTerm(expression: t.timeOfMinutes)])).watch();

  Future<List<ReminderRow>> active() =>
      (select(remindersTable)..where((t) => t.isActive.equals(true))).get();

  Future<ReminderRow?> findById(int id) =>
      (select(remindersTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertReminder(RemindersTableCompanion row) =>
      into(remindersTable).insert(row);

  Future<void> updateReminder(int id, RemindersTableCompanion row) =>
      (update(remindersTable)..where((t) => t.id.equals(id))).write(row);

  Future<void> setActive(int id, {required bool isActive}) =>
      (update(remindersTable)..where((t) => t.id.equals(id))).write(
        RemindersTableCompanion(isActive: Value(isActive)),
      );

  Future<void> deleteReminder(int id) =>
      (delete(remindersTable)..where((t) => t.id.equals(id))).go();
}
