import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';
import '../helpers/fonts.dart';
import 'app_flow.dart';

void main() {
  late AppHarness harness;

  setUpAll(loadAppFonts);
  setUp(() => harness = AppHarness.setUp());
  tearDown(() => harness.tearDown());

  testWidgets('alur penuh pengguna baru (Sprint 5.3)', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Pukul 07.00: form catat menyarankan tipe Puasa, dan pengingat puasa
    // 06.00 hari ini sudah lewat.
    await withClock(Clock.fixed(DateTime(2026, 9, 27, 7)), () async {
      await harness.initLock();
      await runFullAppFlow(tester, harness);
    });
  });
}
