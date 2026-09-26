import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/app.dart';
import 'package:flutter_gluko_apps/core/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test rangka navigasi.
///
/// Router dimulai langsung di `/beranda` supaya splash — yang menjalankan
/// pemeriksaan database lewat dependency injection — tidak ikut terpanggil.
/// Alur splash diuji terpisah pada test integrasi.
Widget shellApp() =>
    GlukoTrackApp(router: createRouter(initialLocation: '/beranda'));

void main() {
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
      expect(find.textContaining('Kartu GDP/GDS'), findsOneWidget);
    });

    testWidgets('berpindah tab mengganti isi layar', (tester) async {
      await tester.pumpWidget(shellApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tren'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Grafik 7/14/30/90 hari'),
        findsOneWidget,
        reason: 'Tab Tren harus menampilkan isi layar Tren',
      );
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
    });
  });
}
