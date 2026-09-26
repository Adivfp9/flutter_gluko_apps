import 'package:drift/drift.dart';

/// PRD 8.2: pengingat lokal.
///
/// `days_mask` adalah bitmask hari: bit 0 = Senin … bit 6 = Minggu,
/// default 127 (setiap hari).
@DataClassName('ReminderRow')
class RemindersTable extends Table {
  @override
  String get tableName => 'reminders';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text()();

  TextColumn get readingType => text().named('reading_type').nullable()();

  IntColumn get timeOfMinutes => integer().named('time_of_minutes')();

  IntColumn get daysMask =>
      integer().named('days_mask').withDefault(const Constant(127))();

  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(true))();

  IntColumn get createdAt => integer().named('created_at')();

  @override
  List<String> get customConstraints => [
    'CHECK (time_of_minutes BETWEEN 0 AND 1439)',
    'CHECK (days_mask BETWEEN 0 AND 127)',
  ];
}
