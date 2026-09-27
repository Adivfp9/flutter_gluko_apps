import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/flow/app_flow.dart';
import '../test/helpers/app_harness.dart';

/// Sprint 5.3 di perangkat Android: alur yang sama dengan
/// `test/flow/app_flow_test.dart`, tetapi dirender oleh engine asli.
///
/// Jalankan dengan HP terhubung:
///   flutter test integration_test/app_flow_test.dart
///
/// Database memakai in-memory dan layanan platform (Keystore, notifikasi,
/// share sheet) memakai fake, supaya test bisa diulang tanpa menyentuh data
/// dan izin di perangkat.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppHarness harness;

  setUp(() => harness = AppHarness.setUp());
  tearDown(() => harness.tearDown());

  testWidgets('alur penuh pengguna baru', (tester) async {
    await withClock(Clock.fixed(DateTime(2026, 9, 27, 7)), () async {
      await harness.initLock();
      await runFullAppFlow(tester, harness);
    });
  });
}
