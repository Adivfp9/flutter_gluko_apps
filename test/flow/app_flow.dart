import 'package:flutter/material.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

/// Sprint 5.3 — alur penuh pengguna baru, dijalankan lewat UI:
/// onboarding → catat GDP → beranda → edit → hapus/undo → backup/restore.
///
/// Dipakai dua runner: `test/flow/app_flow_test.dart` (host, CI) dan
/// `integration_test/app_flow_test.dart` (perangkat Android).
Future<void> runFullAppFlow(WidgetTester tester, AppHarness harness) async {
  Future<void> tapFinder(Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tapText(String text) => tapFinder(find.text(text).last);

  Future<void> tapTab(String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> typeValue(String digits) async {
    for (final d in digits.split('')) {
      final key = find.byKey(Key('keypad-$d'));
      await tester.ensureVisible(key);
      await tester.pump();
      await tester.tap(key);
      await tester.pump();
    }
  }

  Future<List<int>> storedValues() async {
    final rows = await harness.db.select(harness.db.glucoseReadingsTable).get();
    return [
      for (final r in rows)
        if (r.deletedAt == null) r.valueMgDl,
    ];
  }

  // ── 1. Splash → onboarding 4 langkah (PRD F-10) ─────────────────────────
  await tester.pumpWidget(harness.app(initialLocation: '/', withLock: true));
  await tester.pumpAndSettle();
  expect(find.text('Lanjut'), findsOneWidget, reason: 'splash → onboarding');

  await tapText('Lanjut'); // sambutan
  // Disclaimer wajib; seluruh kartu persetujuan adalah area sentuhnya.
  await tapFinder(find.textContaining('Saya mengerti'));
  await tapText('Lanjut');
  await tapText('Lanjut'); // satuan (mg/dL bawaan)
  await tapText('Mulai pakai GlukoTrack'); // pengingat puasa 06.00

  expect(find.text('Belum ada catatan'), findsOneWidget);
  expect(
    harness.scheduler.last,
    isNotEmpty,
    reason: 'pengingat puasa bawaan terjadwal setelah onboarding (F-07)',
  );

  // ── 2. Catat GDP dari beranda (PRD F-01, F-02) ──────────────────────────
  await tapText('Catat');
  await tapText(ReadingType.fasting.label);
  await typeValue('105');
  await tapText('Simpan');
  expect(find.text('Selesai'), findsOneWidget, reason: 'layar S-05 hasil');
  await tapText('Selesai');

  // ── 3. Beranda menampilkan catatan baru tanpa refresh (PRD F-04) ────────
  expect(find.text('105'), findsWidgets);
  expect(await storedValues(), [105]);

  // ── 4. Edit dari riwayat → detail (PRD F-05 AC3) ────────────────────────
  await tapTab('Riwayat');
  await tapText('105');
  expect(find.text('Detail catatan'), findsOneWidget);
  await tapText('Edit catatan');
  await typeValue('⌫⌫⌫');
  await typeValue('98');
  await tapText('Simpan');
  await tapText('Selesai');
  expect(await storedValues(), [98]);

  // ── 5. Hapus + Urungkan dalam 5 detik (PRD F-05) ────────────────────────
  await tapTab('Riwayat');
  await tapText('98');
  await tapText('Hapus catatan');
  await tapText('Hapus'); // konfirmasi dialog
  expect(find.text('Catatan dihapus'), findsOneWidget);
  expect(await storedValues(), isEmpty);
  await tester.tap(find.text('Urungkan'));
  await tester.pumpAndSettle();
  expect(await storedValues(), [98], reason: 'undo mengembalikan catatan');

  // ── 6. Backup → hapus → restore (PRD F-09, gate Sprint 4) ───────────────
  await tapTab('Setelan');
  await tapText('Backup & restore');
  await tapText('Buat backup & bagikan');
  const passphrase = 'rahasia-pagi-2026';
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), passphrase);
  await tester.enterText(fields.at(1), passphrase);
  await tester.pumpAndSettle();
  await tapText('Buat backup');
  expect(harness.files.lastShared, isNotNull, reason: 'file .gtbak dibagikan');
  expect(harness.files.lastFileName, endsWith('.gtbak'));

  // Data hilang (mis. HP rusak) lalu dipulihkan dari file tadi.
  await harness.db.delete(harness.db.glucoseReadingsTable).go();
  expect(await storedValues(), isEmpty);

  harness.files.nextPick = harness.files.lastShared;
  await tapText('Pulihkan dari file');
  await tester.enterText(find.byType(TextField), passphrase);
  await tester.pumpAndSettle();
  await tapText('Buka');
  expect(find.text('Timpa data sekarang?'), findsOneWidget);
  await tapText('Pulihkan');
  expect(find.text('Data berhasil dipulihkan.'), findsOneWidget);
  expect(await storedValues(), [98]);

  await unmountApp(tester);
}
