import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/unit_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitConverter', () {
    test('mengonversi mg/dL ke mmol/L dengan satu desimal', () {
      expect(UnitConverter.mgDlToMmolLRounded(112), 6.2);
      expect(UnitConverter.formatValue(112, GlucoseUnit.mmolL), '6,2');
    });

    test('round-trip mmol/L kembali ke mg/dL bulat', () {
      for (final value in [20, 54, 70, 99, 126, 300, 600]) {
        final mmolL = UnitConverter.mgDlToMmolL(value);
        expect(UnitConverter.mmolLToMgDl(mmolL), value);
      }
    });

    test('menerima koma dan titik sebagai pemisah desimal', () {
      expect(UnitConverter.parseToMgDl('6,2', GlucoseUnit.mmolL), 112);
      expect(UnitConverter.parseToMgDl('6.2', GlucoseUnit.mmolL), 112);
    });

    test('menolak teks kosong dan bukan angka', () {
      expect(UnitConverter.parseToMgDl('', GlucoseUnit.mgDl), isNull);
      expect(UnitConverter.parseToMgDl('abc', GlucoseUnit.mmolL), isNull);
    });

    test('menolak nilai non-finite tanpa melempar exception', () {
      expect(UnitConverter.parseToMgDl('NaN', GlucoseUnit.mmolL), isNull);
      expect(UnitConverter.parseToMgDl('Infinity', GlucoseUnit.mmolL), isNull);
    });

    test('batas tampilan mmol/L tidak keluar dari 20–600 mg/dL', () {
      expect(UnitConverter.minMmolL, 1.2);
      expect(UnitConverter.maxMmolL, 33.3);
      expect(
        UnitConverter.isInValidRange(
          UnitConverter.mmolLToMgDl(UnitConverter.minMmolL),
        ),
        isTrue,
      );
      expect(
        UnitConverter.isInValidRange(
          UnitConverter.mmolLToMgDl(UnitConverter.maxMmolL),
        ),
        isTrue,
      );
    });
  });
}
