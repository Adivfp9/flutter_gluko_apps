import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/reclassify_readings.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/save_profile.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/reset_targets.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/save_targets.dart';
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_cubit.dart';
import 'package:flutter_gluko_apps/features/target/presentation/cubit/target_settings_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TargetRepositoryImpl targets;
  late ProfileRepositoryImpl profiles;

  setUp(() {
    db = createTestDatabase();
    targets = TargetRepositoryImpl(db.targetDao);
    profiles = ProfileRepositoryImpl(db.profileDao);
  });
  tearDown(() => db.close());

  TargetSettingsCubit createCubit() {
    final saveTargets = SaveTargets(targets, profiles);
    return TargetSettingsCubit(
      GetTargets(targets),
      saveTargets,
      ResetTargets(saveTargets),
      GetProfile(profiles),
      SaveProfile(profiles),
      ReclassifyReadings(
        GlucoseRepositoryImpl(db.glucoseDao),
        const ClassifyReading(),
      ),
    );
  }

  blocTest<TargetSettingsCubit, TargetSettingsState>(
    'memuat preset Umum dan satuan profil',
    build: createCubit,
    act: (cubit) => cubit.initialize(),
    verify: (cubit) {
      expect(cubit.state.isReady, isTrue);
      expect(cubit.state.selectedPreset, TargetPreset.general);
      expect(cubit.state.unit, GlucoseUnit.mgDl);
    },
  );

  blocTest<TargetSettingsCubit, TargetSettingsState>(
    'memilih dan menyimpan preset Diabetes',
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize();
      cubit.selectPreset(TargetPreset.diabetes);
      await cubit.save();
    },
    verify: (cubit) async {
      expect(cubit.state.targets!.forType(ReadingType.fasting).normalMax, 130);
      expect(cubit.state.saved, isTrue);
      expect(
        (await profiles.getProfile()).getRight().toNullable()!.preset,
        TargetPreset.diabetes,
      );
    },
  );

  blocTest<TargetSettingsCubit, TargetSettingsState>(
    'perubahan ambang menjadi Kustom dan urutan invalid tidak tersimpan',
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize();
      cubit.updateThreshold(ReadingType.fasting, TargetBoundary.lowMax, 120);
      await cubit.save();
    },
    verify: (cubit) async {
      expect(cubit.state.selectedPreset, TargetPreset.custom);
      expect(cubit.state.saved, isFalse);
      expect(cubit.state.errorMessage, contains('berurutan'));
      expect(
        (await targets.getTargets())
            .getRight()
            .toNullable()!
            .forType(ReadingType.fasting)
            .lowMax,
        70,
      );
    },
  );

  blocTest<TargetSettingsCubit, TargetSettingsState>(
    'menyimpan perubahan satuan global',
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize();
      cubit.setUnit(GlucoseUnit.mmolL);
      await cubit.save();
    },
    verify: (cubit) async {
      expect(
        (await profiles.getProfile()).getRight().toNullable()!.unit,
        GlucoseUnit.mmolL,
      );
    },
  );
}
