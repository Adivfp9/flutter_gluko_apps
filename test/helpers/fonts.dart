import 'package:flutter/services.dart';

bool _loaded = false;

/// Memuat Plus Jakarta Sans asli ke mesin test.
///
/// Tanpa ini flutter_test memakai font "FlutterTest" berglyph kotak yang jauh
/// lebih lebar, sehingga audit overflow dan golden tidak mencerminkan
/// tampilan di HP. Dipanggil dari `setUpAll`.
Future<void> loadAppFonts() async {
  if (_loaded) return;
  final loader = FontLoader('PlusJakartaSans');
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
  }
  await loader.load();
  _loaded = true;
}
