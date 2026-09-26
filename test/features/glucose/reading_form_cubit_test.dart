import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/find_fasting_on.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_cubit.dart';
import 'package:flutter_gluko_apps/features/glucose/presentation/cubit/reading_form_state.dart';
import 'package:flutter_gluko_apps/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/get_targets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_database.dart';

void main() {
  final morning = DateTime(2026, 9, 27, 6, 15);
  late AppDatabase db;
  late GlucoseRepositoryImpl readings;
  late TargetRepositoryImpl targets;
  late ProfileRepositoryImpl profiles;

  setUp(() {
    db = createTestDatabase();
    readings = GlucoseRepositoryImpl(db.glucoseDao);
    targets = TargetRepositoryImpl(db.targetDao);
    profiles = ProfileRepositoryImpl(db.profileDao);
  });

  tearDown(() => db.close());

  ReadingFormCubit createCubit({DateTime? now}) {
    DateTime clock() => now ?? morning;
    return ReadingFormCubit.withClock(
      AddReading.withClock(readings, targets, const ClassifyReading(), clock),
      GetTargets(targets),
      GetProfile(profiles),
      FindFastingOn(readings),
      const ClassifyReading(),
      clock,
    );
  }

  Future<void> seedReading({
    required ReadingType type,
    required int valueMgDl,
    required DateTime measuredAt,
  }) async {
    final result =
        await AddReading.withClock(
          readings,
          targets,
          const ClassifyReading(),
          () => morning,
        )(
          AddReadingParams(
            type: type,
            valueMgDl: valueMgDl,
            measuredAt: measuredAt,
          ),
        );
    expect(result.isRight(), isTrue);
  }

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menyarankan Puasa pukul 04–09 bila GDP hari ini belum ada',
    build: createCubit,
    act: (cubit) => cubit.initialize(),
    verify: (cubit) {
      expect(cubit.state.isReady, isTrue);
      expect(cubit.state.type, ReadingType.fasting);
      expect(cubit.state.measuredAt, morning);
    },
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menyarankan Sewaktu bila GDP hari ini sudah ada',
    setUp: () => seedReading(
      type: ReadingType.fasting,
      valueMgDl: 98,
      measuredAt: morning,
    ),
    build: createCubit,
    act: (cubit) => cubit.initialize(),
    verify: (cubit) => expect(cubit.state.type, ReadingType.random),
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menyarankan Sewaktu di luar pukul 04–09',
    build: () => createCubit(now: DateTime(2026, 9, 27, 10)),
    act: (cubit) => cubit.initialize(),
    verify: (cubit) => expect(cubit.state.type, ReadingType.random),
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'mengklasifikasikan input live sesuai satuan dan tipe',
    setUp: () => profiles.saveProfile(
      const UserProfile(unit: GlucoseUnit.mmolL, onboardingDone: true),
    ),
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize(initialType: ReadingType.fasting);
      cubit
        ..setValue('6,2')
        ..setType(ReadingType.random);
    },
    verify: (cubit) {
      expect(cubit.state.unit, GlucoseUnit.mmolL);
      expect(cubit.state.valueMgDl, 112);
      expect(cubit.state.classification?.status, GlucoseStatus.normal);
      expect(cubit.state.canSubmit, isTrue);
    },
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menginisialisasi 2JPP dengan dua jam setelah makan',
    build: createCubit,
    act: (cubit) => cubit.initialize(initialType: ReadingType.postprandial2h),
    verify: (cubit) => expect(cubit.state.hoursAfterMeal, 2),
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'jam setelah makan hanya dipertahankan saat konteksnya relevan',
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize(initialType: ReadingType.random);
      cubit
        ..setMealContext(MealContext.afterMeal)
        ..setHoursAfterMeal(1.5)
        ..setMealContext(MealContext.bedtime);
    },
    verify: (cubit) {
      expect(cubit.state.mealContext, MealContext.bedtime);
      expect(cubit.state.hoursAfterMeal, isNull);
    },
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menampilkan alasan nilai tidak dapat disimpan saat masih invalid',
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize(initialType: ReadingType.fasting);
      cubit.setValue('10');
    },
    verify: (cubit) {
      expect(cubit.state.canSubmit, isFalse);
      expect(cubit.state.validationMessage, contains('20 dan 600'));
    },
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menyimpan nilai beserta gejala dan catatan',
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize(initialType: ReadingType.random);
      cubit
        ..setValue('150')
        ..setMealContext(MealContext.afterMeal)
        ..toggleSymptom(Symptom.thirsty)
        ..setNote('Sesudah makan siang');
      await cubit.submit();
    },
    verify: (cubit) {
      expect(cubit.state.savedReading?.valueMgDl, 150);
      expect(cubit.state.savedReading?.status, GlucoseStatus.warning);
      expect(cubit.state.savedReading?.hoursAfterMeal, 2);
      expect(cubit.state.savedReading?.symptoms, [Symptom.thirsty]);
      expect(cubit.state.errorMessage, isNull);
    },
  );

  blocTest<ReadingFormCubit, ReadingFormState>(
    'menawarkan resolusi GDP duplikat lalu menyimpan sebagai Sewaktu',
    setUp: () => seedReading(
      type: ReadingType.fasting,
      valueMgDl: 98,
      measuredAt: morning,
    ),
    build: createCubit,
    act: (cubit) async {
      await cubit.initialize(initialType: ReadingType.fasting);
      cubit.setValue('110');
      await cubit.submit();
      await cubit.resolveDuplicate(DuplicateFastingAction.saveAsRandom);
    },
    verify: (cubit) {
      expect(cubit.state.duplicateFasting, isNull);
      expect(cubit.state.savedReading?.type, ReadingType.random);
    },
  );
}
