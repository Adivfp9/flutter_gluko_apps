import 'dart:convert';
import 'dart:io';

import 'package:flutter_gluko_apps/l10n/app_localizations_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_harness.dart';

void main() {
  final id = AppLocalizationsId();

  test('disclaimer sama persis dengan PRD 10.4 (rencana 5.7)', () {
    final prd = File('docs/PRD-GlukoTrack.md').readAsLinesSync();
    final start = prd.indexWhere((l) => l.startsWith('### 10.4'));
    expect(start, isNot(-1), reason: 'bagian 10.4 harus ada di PRD');

    final quote = prd
        .skip(start)
        .firstWhere((l) => l.startsWith('> '))
        .substring(2)
        .trim();

    expect(id.aboutDisclaimer, quote);
  });

  test('ARB id dan en punya kunci yang sama (rencana 5.6)', () {
    Set<String> keys(String path) =>
        (jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>).keys
            .where((k) => !k.startsWith('@'))
            .toSet();

    expect(keys('lib/l10n/app_en.arb'), keys('lib/l10n/app_id.arb'));
  });

  testWidgets('halaman Tentang bisa dibuka dari Pengaturan', (tester) async {
    final harness = AppHarness.setUp();
    addTearDown(harness.tearDown);
    await harness.completeOnboarding();

    await tester.pumpWidget(harness.app(initialLocation: '/pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(id.settingsAboutTitle));
    await tester.pumpAndSettle();

    expect(find.text(id.aboutDisclaimerTitle), findsOneWidget);
    expect(find.text(id.aboutDisclaimer), findsOneWidget);
    await unmountApp(tester);
  });
}
