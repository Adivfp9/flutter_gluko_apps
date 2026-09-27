import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Menyimpan screenshot dari `integration_test/screenshots_test.dart` ke
/// `docs/screenshots/` (dipakai README).
///
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/screenshots_test.dart -d emulator-5554
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final file = File('docs/screenshots/$name.png');
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
    return true;
  },
);
