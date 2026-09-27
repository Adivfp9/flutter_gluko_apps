@Tags(['golden'])
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart';
import '../helpers/fonts.dart';
import 'flutter_test_config.dart' show goldenNow;

/// Sprint 5.2 — golden 6 layar utama × tema terang dan gelap.
///
/// Waktu dipatok di `flutter_test_config.dart` (27 September 2026 09.00),
/// jadi gambar tidak berubah dari hari ke hari. Perbarui setelah perubahan
/// UI yang disengaja:
///   flutter test test/golden --update-goldens
void main() {
  late AppHarness harness;

  setUpAll(loadAppFonts);

  setUp(() async {
    harness = AppHarness.setUp();
    await harness.completeOnboarding();
    await harness.initLock();

    // Dua minggu pemakaian wajar: GDP setiap pagi, GDS dan 2JPP berselang.
    final now = clock.now();
    for (var day = 0; day < 14; day++) {
      final date = DateTime(now.year, now.month, now.day - day);
      Future<void> add(ReadingType type, int hour, int value) async {
        final at = DateTime(date.year, date.month, date.day, hour, 10);
        if (at.isAfter(now)) return;
        await harness.db.glucoseDao.insertReading(
          readingCompanion(
            localDate: LocalDate.ofLocal(at),
            measuredAt: at.toUtc(),
            type: type,
            valueMgDl: value,
            status: switch (type) {
              ReadingType.fasting =>
                value < 100 ? GlucoseStatus.normal : GlucoseStatus.warning,
              _ => value < 140 ? GlucoseStatus.normal : GlucoseStatus.warning,
            },
          ),
          [],
        );
      }

      await add(ReadingType.fasting, 6, 88 + (day * 7) % 30);
      if (day.isEven) await add(ReadingType.random, 13, 118 + (day * 11) % 50);
      if (day % 3 == 0) {
        await add(ReadingType.postprandial2h, 20, 130 + (day * 13) % 40);
      }
    }
  });

  tearDown(() => harness.tearDown());

  const screens = {
    'beranda': '/beranda',
    'riwayat': '/riwayat',
    'tren': '/tren',
    'catat': '/catat?type=fasting',
    'target': '/pengaturan/target',
    'pengaturan': '/pengaturan',
  };

  for (final MapEntry(key: name, value: location) in screens.entries) {
    for (final brightness in Brightness.values) {
      testWidgets('$name (${brightness.name})', (tester) async {
        tester.view
          ..physicalSize = const Size(720, 1600)
          ..devicePixelRatio = 2;
        tester.platformDispatcher.platformBrightnessTestValue = brightness;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearAllTestValues);

        // testWidgets memasang jam fake-async sendiri; dipatok ulang di sini
        // agar build (salam pagi/siang, jam di form) ikut waktu tetap.
        await withClock(Clock.fixed(goldenNow), () async {
          await tester.pumpWidget(
            harness.app(initialLocation: location, withLock: true),
          );
          await tester.pumpAndSettle();

          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
          );
          await unmountApp(tester);
        });
      });
    }
  }
}
