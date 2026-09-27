import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/app.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_harness.dart' show unmountApp;
import 'helpers/test_di.dart';

/// Test rangka navigasi.
///
/// Router dimulai langsung di `/beranda` supaya splash — yang menjalankan
/// pemeriksaan database lewat dependency injection — tidak ikut terpanggil.
Widget shellApp() =>
    GlukoTrackApp(router: createRouter(initialLocation: '/beranda'));

void main() {
  late AppDatabase db;

  setUp(() => db = configureTestDependencies());
  tearDown(() async {
    await resetTestDependencies();
    await db.close();
  });

  group('Rangka aplikasi', () {
    testWidgets('membuka Beranda dan menampilkan 4 tab', (tester) async {
      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      for (final label in ['Beranda', 'Riwayat', 'Tren', 'Setelan']) {
        expect(
          find.descendant(
            of: find.byType(NavigationBar),
            matching: find.text(label),
          ),
          findsOneWidget,
          reason: 'Tab $label harus ada di navigasi bawah',
        );
      }
      await unmountApp(tester);
    });

    testWidgets('beranda kosong menampilkan ajakan mencatat', (tester) async {
      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();

      expect(find.text('Belum ada catatan'), findsOneWidget);
      expect(
        find.textContaining('cek gula darah puasa besok pagi'),
        findsOneWidget,
      );
      await unmountApp(tester);
    });

    testWidgets('berpindah tab mengganti isi layar', (tester) async {
      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Tren'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Belum ada data pada periode ini'),
        findsOneWidget,
        reason: 'Tab Tren harus menampilkan isi layar Tren',
      );
      expect(find.text('14 hari'), findsOneWidget);

      await unmountApp(tester);
    });

    testWidgets('tema gelap memakai latar gelap', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();

      final theme = Theme.of(tester.element(find.byType(NavigationBar)));
      expect(theme.brightness, Brightness.dark);
      // PRD 6.2: background mode gelap #0B0D0F.
      expect(theme.scaffoldBackgroundColor, const Color(0xFF0B0D0F));
      await unmountApp(tester);
    });
  });
}
