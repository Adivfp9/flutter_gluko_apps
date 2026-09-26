import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/add_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/classify_reading.dart';
import 'package:flutter_gluko_apps/features/target/data/repositories/target_repository_impl.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../helpers/test_database.dart';

void main() {
  final now = DateTime.utc(2026, 9, 27, 3);
  final measuredAt = DateTime.utc(2026, 9, 26, 23, 12);

  late AppDatabase db;
  late GlucoseRepositoryImpl repository;
  late TargetRepositoryImpl targets;
  late AddReading addReading;

  setUp(() {
    db = createTestDatabase();
    repository = GlucoseRepositoryImpl(db.glucoseDao);
    targets = TargetRepositoryImpl(db.targetDao);
    addReading = AddReading.withClock(
      repository,
      targets,
      const ClassifyReading(),
      () => now,
    );
  });

  tearDown(() => db.close());

  AddReadingParams validParams({
    ReadingType type = ReadingType.fasting,
    int valueMgDl = 98,
    DateTime? at,
    String? note,
    bool fastingConfirmed = true,
    DuplicateFastingAction duplicateAction = DuplicateFastingAction.reject,
  }) => AddReadingParams(
    type: type,
    valueMgDl: valueMgDl,
    measuredAt: at ?? measuredAt,
    tzOffsetMinutes: 420,
    note: note,
    symptoms: const [Symptom.dizzy, Symptom.weak],
    fastingConfirmed: fastingConfirmed,
    duplicateAction: duplicateAction,
  );

  GlucoseReading unwrap(Either<Failure, GlucoseReading> result) =>
      result.getOrElse((failure) => throw StateError('gagal: $failure'));

  test('menyimpan pembacaan dan gejala secara atomik', () async {
    final result = await addReading(validParams(note: '  Sebelum sarapan  '));

    expect(result.isRight(), isTrue);
    final saved = unwrap(result);
    expect(saved.id, isNotNull);
    expect(saved.status, GlucoseStatus.normal);
    expect(saved.isCritical, isFalse);
    expect(saved.localDate, '2026-09-27');
    expect(saved.note, 'Sebelum sarapan');
    expect(saved.symptoms, [Symptom.dizzy, Symptom.weak]);

    final row = await db.glucoseDao.findById(saved.id!);
    expect(row, isNotNull);
    expect(row!.symptoms, ['dizzy', 'weak']);
  });

  test('memakai target aktif untuk klasifikasi snapshot', () async {
    await targets.saveTargets(TargetSet.fromPreset(TargetPreset.diabetes));

    final result = await addReading(validParams(valueMgDl: 120));

    expect(unwrap(result).status, GlucoseStatus.normal);
  });

  test('menolak nilai di luar 20–600 tanpa efek samping', () async {
    for (final value in [19, 601]) {
      final result = await addReading(validParams(valueMgDl: value));
      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    }
    expect(await db.glucoseDao.countActive(), 0);
  });

  test('menolak waktu masa depan dan lebih dari satu tahun', () async {
    final future = await addReading(
      validParams(at: now.add(const Duration(minutes: 1))),
    );
    final tooOld = await addReading(
      validParams(at: now.subtract(const Duration(days: 366))),
    );

    expect(future.getLeft().toNullable(), isA<ValidationFailure>());
    expect(tooOld.getLeft().toNullable(), isA<ValidationFailure>());
    expect(await db.glucoseDao.countActive(), 0);
  });

  test('menolak catatan di atas 500 karakter', () async {
    final result = await addReading(validParams(note: 'x' * 501));

    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    expect(await db.glucoseDao.countActive(), 0);
  });

  test('menolak tipe puasa yang belum dikonfirmasi 8 jam', () async {
    final result = await addReading(validParams(fastingConfirmed: false));

    final failure = result.getLeft().toNullable();
    expect(failure, isA<ValidationFailure>());
    expect((failure! as ValidationFailure).field, 'fasting');
  });

  test('GDP kedua mengembalikan konteks pembacaan lama', () async {
    final first = unwrap(await addReading(validParams()));

    final duplicate = await addReading(validParams(valueMgDl: 110));

    final failure = duplicate.getLeft().toNullable();
    expect(failure, isA<DuplicateFastingFailure>());
    final typed = failure! as DuplicateFastingFailure;
    expect(typed.existingReadingId, first.id);
    expect(typed.existingValueMgDl, 98);
    expect(typed.localDate, '2026-09-27');
    expect(await db.glucoseDao.countActive(), 1);
  });

  test('resolusi replace memperbarui GDP lama tanpa menambah baris', () async {
    final first = unwrap(await addReading(validParams()));

    final replaced = unwrap(
      await addReading(
        validParams(
          valueMgDl: 130,
          duplicateAction: DuplicateFastingAction.replace,
        ),
      ),
    );

    expect(replaced.id, first.id);
    expect(replaced.valueMgDl, 130);
    expect(replaced.status, GlucoseStatus.high);
    expect(await db.glucoseDao.countActive(), 1);
  });

  test('resolusi saveAsRandom menyimpan pembacaan kedua sebagai GDS', () async {
    await addReading(validParams());

    final second = unwrap(
      await addReading(
        validParams(
          valueMgDl: 150,
          duplicateAction: DuplicateFastingAction.saveAsRandom,
        ),
      ),
    );

    expect(second.type, ReadingType.random);
    expect(second.status, GlucoseStatus.warning);
    expect(await db.glucoseDao.countActive(), 2);
  });
}
