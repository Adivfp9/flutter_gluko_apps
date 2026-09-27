import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_gluko_apps/features/reminder/domain/entities/reminder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ReminderRepositoryImpl repository;

  setUp(() {
    db = createTestDatabase();
    repository = ReminderRepositoryImpl(db.reminderDao);
  });

  tearDown(() => db.close());

  Future<List<Reminder>> all() async => (await repository.getReminders())
      .getOrElse((f) => throw StateError(f.message));

  group('ReminderRepository (PRD F-07 AC1)', () {
    test('seed berisi satu pengingat puasa 06.00 aktif', () async {
      final reminders = await all();

      expect(reminders, hasLength(1));
      expect(reminders.single.readingType, ReadingType.fasting);
      expect(reminders.single.formattedTime, '06.00');
      expect(reminders.single.isActive, isTrue);
      expect(reminders.single.isDaily, isTrue);
    });

    test('upsert tanpa id menambah, dengan id memperbarui', () async {
      final added = (await repository.upsert(
        const Reminder(
          label: 'Cek malam',
          timeOfMinutes: 21 * 60 + 30,
          daysMask: 0x1F,
        ),
      )).getOrElse((f) => throw StateError(f.message));
      expect(added.id, isNotNull);

      await repository.upsert(
        added.copyWith(label: 'Cek sebelum tidur', timeOfMinutes: 22 * 60),
      );

      final stored = (await all()).singleWhere((r) => r.id == added.id);
      expect(stored.label, 'Cek sebelum tidur');
      expect(stored.formattedTime, '22.00');
      expect(stored.daysMask, 0x1F);
      expect(stored.readingType, isNull);
    });

    test('jam di luar 00.00–23.59 ditolak', () async {
      for (final minutes in [-1, 1440]) {
        final result = await repository.upsert(
          Reminder(label: 'x', timeOfMinutes: minutes),
        );
        expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      }
    });

    test('tanpa hari aktif ditolak', () async {
      final result = await repository.upsert(
        const Reminder(label: 'x', timeOfMinutes: 600, daysMask: 0),
      );

      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    });

    test('nonaktifkan lalu hapus', () async {
      final id = (await all()).single.id!;

      await repository.setActive(id, isActive: false);
      expect((await all()).single.isActive, isFalse);

      await repository.delete(id);
      expect(await all(), isEmpty);
    });

    test('pengingat puasa dari onboarding memperbarui baris seed', () async {
      await repository.setFastingReminder(
        timeOfMinutes: 5 * 60 + 30,
        isActive: true,
      );

      final reminders = await all();
      expect(reminders, hasLength(1), reason: 'tidak membuat duplikat');
      expect(reminders.single.formattedTime, '05.30');
    });

    test('pengingat puasa dibuat ulang bila seed sudah dihapus', () async {
      await repository.delete((await all()).single.id!);

      await repository.setFastingReminder(
        timeOfMinutes: 6 * 60,
        isActive: false,
      );

      final reminder = (await all()).single;
      expect(reminder.readingType, ReadingType.fasting);
      expect(reminder.isActive, isFalse);
    });

    test('jam pengingat puasa tidak valid ditolak', () async {
      final result = await repository.setFastingReminder(
        timeOfMinutes: 2000,
        isActive: true,
      );

      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    });

    test('stream mengikuti perubahan', () async {
      final stream = repository.watchReminders();
      expect(await stream.first, hasLength(1));

      final next = stream.firstWhere((list) => list.length == 2);
      await repository.upsert(
        const Reminder(label: 'Siang', timeOfMinutes: 720),
      );

      expect(await next.timeout(const Duration(seconds: 3)), hasLength(2));
    });
  });

  group('Reminder', () {
    test('days_mask: bit 0 = Senin … bit 6 = Minggu', () {
      const weekend = Reminder(label: 'x', timeOfMinutes: 0, daysMask: 0x60);

      expect(weekend.activeWeekdays, [DateTime.saturday, DateTime.sunday]);
      expect(weekend.runsOnWeekday(DateTime.monday), isFalse);
      expect(weekend.isDaily, isFalse);
    });

    test('jam dan menit diturunkan dari menit sejak tengah malam', () {
      const r = Reminder(label: 'x', timeOfMinutes: 7 * 60 + 5);

      expect(r.hour, 7);
      expect(r.minute, 5);
      expect(r.formattedTime, '07.05');
    });

    test('kesetaraan berdasarkan seluruh isi', () {
      const a = Reminder(id: 1, label: 'x', timeOfMinutes: 60);

      expect(a, const Reminder(id: 1, label: 'x', timeOfMinutes: 60));
      expect(a, isNot(a.copyWith(isActive: false)));
      expect(a.hashCode, a.copyWith().hashCode);
    });
  });
}
