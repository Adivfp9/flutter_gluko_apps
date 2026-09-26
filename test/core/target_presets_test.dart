import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Preset ambang PRD 5.1', () {
    test('preset Umum sama persis dengan tabel PRD', () {
      const expected = {
        ReadingType.fasting: [70, 99, 125],
        ReadingType.random: [70, 139, 199],
        ReadingType.postprandial2h: [70, 139, 199],
      };

      for (final entry in expected.entries) {
        final t = TargetPresets.forType(TargetPreset.general, entry.key);
        expect(
          [t.lowMax, t.normalMax, t.warningMax],
          entry.value,
          reason: 'preset Umum untuk ${entry.key.label}',
        );
      }
    });

    test('preset Diabetes sama persis dengan tabel PRD', () {
      const expected = {
        ReadingType.fasting: [70, 130, 180],
        ReadingType.random: [70, 180, 250],
        ReadingType.postprandial2h: [70, 180, 250],
      };

      for (final entry in expected.entries) {
        final t = TargetPresets.forType(TargetPreset.diabetes, entry.key);
        expect(
          [t.lowMax, t.normalMax, t.warningMax],
          entry.value,
          reason: 'preset Diabetes untuk ${entry.key.label}',
        );
      }
    });

    test('ambang kritis bawaan 54 dan 300 (PRD 5.2)', () {
      for (final preset in [TargetPreset.general, TargetPreset.diabetes]) {
        for (final type in ReadingType.values) {
          final t = TargetPresets.forType(preset, type);
          expect(t.criticalLow, 54);
          expect(t.criticalHigh, 300);
        }
      }
    });

    test('semua preset punya ambang yang naik berurutan', () {
      for (final preset in TargetPreset.values) {
        for (final type in ReadingType.values) {
          expect(
            TargetPresets.forType(preset, type).isOrdered,
            isTrue,
            reason: '$preset / ${type.label}',
          );
        }
      }
    });
  });

  group('Pemilihan preset dari jenis diabetes (PRD 5.1)', () {
    test('tipe 1, tipe 2, dan gestasional memakai preset Diabetes', () {
      for (final type in [
        DiabetesType.type1,
        DiabetesType.type2,
        DiabetesType.gestational,
      ]) {
        expect(type.defaultPreset, TargetPreset.diabetes, reason: type.label);
      }
    });

    test('tidak ada, prediabetes, dan tidak tahu memakai preset Umum', () {
      for (final type in [
        DiabetesType.none,
        DiabetesType.prediabetes,
        DiabetesType.unknown,
      ]) {
        expect(type.defaultPreset, TargetPreset.general, reason: type.label);
      }
    });
  });

  group('Deteksi preset dari angka', () {
    test('mengenali preset Umum', () {
      expect(TargetPresets.detect(TargetPresets.general), TargetPreset.general);
    });

    test('mengenali preset Diabetes', () {
      expect(
        TargetPresets.detect(TargetPresets.diabetes),
        TargetPreset.diabetes,
      );
    });

    test('satu angka diubah sudah dianggap Kustom', () {
      final modified = {
        ...TargetPresets.general,
        ReadingType.fasting: const TargetThresholds(
          lowMax: 70,
          normalMax: 100,
          warningMax: 125,
        ),
      };
      expect(TargetPresets.detect(modified), TargetPreset.custom);
    });
  });
}
