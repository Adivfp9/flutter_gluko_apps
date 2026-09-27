import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const classify = ClassifyReading();
  const generalFasting = TargetThresholds(
    lowMax: 70,
    normalMax: 99,
    warningMax: 125,
  );

  group('ClassifyReading', () {
    const cases = <(int, GlucoseStatus)>[
      (69, GlucoseStatus.low),
      (70, GlucoseStatus.normal),
      (99, GlucoseStatus.normal),
      (100, GlucoseStatus.warning),
      (125, GlucoseStatus.warning),
      (126, GlucoseStatus.high),
    ];

    for (final (value, expected) in cases) {
      test('$value mg/dL diklasifikasikan sebagai ${expected.label}', () {
        expect(classify(value, generalFasting).status, expected);
      });
    }

    test('batas kritis bersifat eksklusif', () {
      expect(classify(53, generalFasting).isCritical, isTrue);
      expect(classify(54, generalFasting).isCritical, isFalse);
      expect(classify(300, generalFasting).isCritical, isFalse);
      expect(classify(301, generalFasting).isCritical, isTrue);
    });
  });
}
