import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/di/injection.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/features/security/domain/repositories/security_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart';
import '../helpers/fonts.dart';

/// Sprint 5.1 — audit aksesibilitas (WCAG AA): text scale 200% tanpa
/// overflow, target sentuh ≥ 48 dp, tombol berlabel, dan kontras teks cukup
/// di setiap layar utama, tema terang maupun gelap.
void main() {
  late AppHarness harness;

  setUpAll(loadAppFonts);

  setUp(() async {
    harness = AppHarness.setUp();
    await harness.completeOnboarding();
    await harness.initLock();
    final today = DateTime.now();
    for (var i = 0; i < 6; i++) {
      final at = DateTime(today.year, today.month, today.day - i, 6);
      await harness.db.glucoseDao.insertReading(
        readingCompanion(
          localDate: LocalDate.ofLocal(at),
          measuredAt: at.toUtc(),
          valueMgDl: 90 + i * 15,
          status: i < 2 ? GlucoseStatus.normal : GlucoseStatus.warning,
        ),
        [],
      );
    }
  });

  tearDown(() => harness.tearDown());

  const screens = {
    'Beranda': '/beranda',
    'Riwayat': '/riwayat',
    'Tren': '/tren',
    'Pengaturan': '/pengaturan',
    'Target': '/pengaturan/target',
    'Pengingat': '/pengaturan/pengingat',
    'Keamanan': '/pengaturan/keamanan',
    'Backup': '/pengaturan/backup',
    'Tentang': '/pengaturan/tentang',
    'Form catat': '/catat?type=fasting',
    'Onboarding': '/onboarding',
  };

  Future<void> pumpScreen(
    WidgetTester tester,
    String location, {
    double textScale = 1,
    Brightness brightness = Brightness.light,
  }) async {
    // Ukuran HP acuan: 360 × 800 dp.
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    tester.platformDispatcher
      ..textScaleFactorTestValue = textScale
      ..platformBrightnessTestValue = brightness;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    await tester.pumpWidget(
      harness.app(initialLocation: location, withLock: true),
    );
    await tester.pumpAndSettle();
  }

  group('Layar kunci', () {
    Future<void> pumpLocked(WidgetTester tester, {double textScale = 1}) async {
      await tester.runAsync(() async {
        await getIt<SecurityRepository>().enableLock('123456');
        await harness.initLock();
      });
      await pumpScreen(tester, '/beranda', textScale: textScale);
      expect(find.text('Masukkan PIN'), findsOneWidget);
    }

    testWidgets('text scale 200% tanpa overflow', (tester) async {
      await pumpLocked(tester, textScale: 2);
      await unmountApp(tester);
    });

    testWidgets('target sentuh, label, dan kontras', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLocked(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      handle.dispose();
      await unmountApp(tester);
    });
  });

  for (final MapEntry(key: name, value: location) in screens.entries) {
    group(name, () {
      testWidgets('text scale 200% tanpa overflow', (tester) async {
        // Overflow dilaporkan framework sebagai FlutterError lengkap dengan
        // widget penyebabnya, dan otomatis menggagalkan test.
        await pumpScreen(tester, location, textScale: 2);
        await unmountApp(tester);
      });

      testWidgets('target sentuh ≥ 48 dp dan berlabel', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreen(tester, location);

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        handle.dispose();
        await unmountApp(tester);
      });

      for (final brightness in Brightness.values) {
        testWidgets('kontras teks WCAG AA (${brightness.name})', (
          tester,
        ) async {
          final handle = tester.ensureSemantics();
          await pumpScreen(tester, location, brightness: brightness);

          await expectLater(tester, meetsGuideline(textContrastGuideline));

          handle.dispose();
          await unmountApp(tester);
        });
      }
    });
  }
}
