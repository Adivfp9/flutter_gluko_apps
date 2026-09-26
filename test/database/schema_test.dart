import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  test('membuat enam tabel sesuai PRD 8.2', () async {
    final rows = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' "
          "AND name NOT LIKE 'sqlite_%' ORDER BY name",
        )
        .get();
    final names = rows.map((r) => r.read<String>('name')).toList();

    expect(names, [
      'app_settings',
      'glucose_readings',
      'reading_symptoms',
      'reminders',
      'target_ranges',
      'user_profile',
    ]);
  });

  test('membuat tiga indeks PRD 8.2', () async {
    final rows = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='index' "
          "AND name NOT LIKE 'sqlite_%' ORDER BY name",
        )
        .get();
    final names = rows.map((r) => r.read<String>('name')).toList();

    expect(names, contains('idx_readings_measured'));
    expect(names, contains('idx_readings_type_date'));
    expect(names, contains('ux_fasting_per_day'));
  });

  test(
    'seed berisi 3 target preset Umum dan 1 pengingat puasa 06.00',
    () async {
      final targets = await db.targetDao.all();
      expect(targets.length, 3);

      final fasting = targets.firstWhere(
        (t) => t.readingType == ReadingType.fasting.dbValue,
      );
      expect(fasting.lowMax, 70);
      expect(fasting.normalMax, 99);
      expect(fasting.warningMax, 125);
      expect(fasting.criticalLow, 54);
      expect(fasting.criticalHigh, 300);

      final random = targets.firstWhere(
        (t) => t.readingType == ReadingType.random.dbValue,
      );
      expect(random.normalMax, 139);
      expect(random.warningMax, 199);

      final reminders = await db.reminderDao.all();
      expect(reminders.length, 1);
      expect(reminders.single.timeOfMinutes, 360);
      expect(reminders.single.readingType, ReadingType.fasting.dbValue);
      expect(reminders.single.daysMask, 127);
      expect(reminders.single.isActive, isTrue);
    },
  );
}
