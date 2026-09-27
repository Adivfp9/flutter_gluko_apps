import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/app_harness.dart';
import '../test/helpers/fixtures.dart';

/// Screenshot untuk README, dirender engine Android asli (font sistem ikut
/// dipakai sebagai cadangan, jadi simbol status tampil benar).
///
/// Data contoh sintetis di database in-memory, dibuat relatif terhadap
/// Minggu 27 September 2026. Jam yang tampil di layar (salam, waktu di form)
/// tetap mengikuti jam perangkat.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 9, 27, 7, 30);

  late AppHarness harness;

  Future<void> seed() async {
    final db = harness.db;
    await db.profileDao.save(
      const UserProfileTableCompanion(
        name: Value('Budi'),
        diabetesType: Value('type_2'),
        onboardingDone: Value(true),
        createdAt: Value(0),
        updatedAt: Value(0),
      ),
    );

    // Tiga minggu pemakaian: GDP tiap pagi, GDS berselang, 2 Jam PP
    // sesekali, dengan beberapa nilai di atas target.
    for (var day = 0; day < 21; day++) {
      final date = DateTime(now.year, now.month, now.day - day);
      Future<void> add(ReadingType type, int hour, int value) async {
        final at = DateTime(date.year, date.month, date.day, hour, 10);
        if (at.isAfter(now)) return;
        final status = switch (type) {
          ReadingType.fasting =>
            value < 70
                ? GlucoseStatus.low
                : value < 100
                ? GlucoseStatus.normal
                : value < 126
                ? GlucoseStatus.warning
                : GlucoseStatus.high,
          _ =>
            value < 70
                ? GlucoseStatus.low
                : value < 140
                ? GlucoseStatus.normal
                : value < 200
                ? GlucoseStatus.warning
                : GlucoseStatus.high,
        };
        await db.glucoseDao.insertReading(
          readingCompanion(
            localDate: LocalDate.ofLocal(at),
            measuredAt: at.toUtc(),
            type: type,
            valueMgDl: value,
            status: status,
          ),
          [],
        );
      }

      await add(ReadingType.fasting, 6, 86 + (day * 7) % 34);
      if (day.isEven) await add(ReadingType.random, 13, 112 + (day * 11) % 70);
      if (day % 3 == 0) {
        await add(ReadingType.postprandial2h, 20, 128 + (day * 13) % 50);
      }
    }

    await db.reminderDao.insertReminder(
      RemindersTableCompanion.insert(
        label: 'Cek setelah makan malam',
        readingType: Value(ReadingType.postprandial2h.dbValue),
        timeOfMinutes: 20 * 60 + 30,
        daysMask: const Value(0x1F),
        createdAt: 0,
      ),
    );
  }

  setUp(() async {
    harness = AppHarness.setUp();
    await withClock(Clock.fixed(now), seed);
  });

  tearDown(() => harness.tearDown());

  Future<void> shoot(
    WidgetTester tester,
    String name,
    String location, {
    Brightness brightness = Brightness.light,
    Future<void> Function()? before,
    Future<void> Function()? interact,
  }) async {
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await withClock(Clock.fixed(now), () async {
      if (before != null) await before();
      await harness.initLock();
      await tester.pumpWidget(
        harness.app(initialLocation: location, withLock: true),
      );
      await tester.pumpAndSettle();
      if (interact != null) await interact();

      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      await binding.takeScreenshot(name);
      await unmountApp(tester);
    });
  }

  testWidgets('01 beranda', (t) => shoot(t, '01-beranda', '/beranda'));

  testWidgets(
    '02 catat',
    (t) => shoot(
      t,
      '02-catat',
      '/catat?type=fasting',
      interact: () async {
        for (final d in ['1', '0', '8']) {
          await t.tap(find.byKey(Key('keypad-$d')));
          await t.pump();
        }
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets('03 riwayat', (t) => shoot(t, '03-riwayat', '/riwayat'));

  testWidgets(
    '04 kalender',
    (t) => shoot(
      t,
      '04-kalender',
      '/riwayat',
      interact: () async {
        await t.tap(find.text('Kalender'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets('05 tren', (t) => shoot(t, '05-tren', '/tren'));

  testWidgets('06 target', (t) => shoot(t, '06-target', '/pengaturan/target'));

  testWidgets(
    '07 pengingat',
    (t) => shoot(t, '07-pengingat', '/pengaturan/pengingat'),
  );

  testWidgets(
    '08 kunci',
    (t) => shoot(
      t,
      '08-kunci',
      '/beranda',
      before: () => getIt<SecurityRepository>().enableLock('123456'),
    ),
  );

  testWidgets(
    '09 beranda gelap',
    (t) =>
        shoot(t, '09-beranda-gelap', '/beranda', brightness: Brightness.dark),
  );

  testWidgets(
    '10 tren gelap',
    (t) => shoot(t, '10-tren-gelap', '/tren', brightness: Brightness.dark),
  );
}
