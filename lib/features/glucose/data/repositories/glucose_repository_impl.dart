import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/glucose_dao.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GlucoseRepository)
class GlucoseRepositoryImpl implements GlucoseRepository {
  const new(this._dao);

  final GlucoseDao _dao;

  @override
  Future<Either<Failure, GlucoseReading?>> findById(int id) async {
    try {
      final result = await _dao.findById(id);
      return Right(result == null ? null : _toEntity(result));
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal membaca catatan: $error'));
    }
  }

  @override
  Future<Either<Failure, GlucoseReading?>> findFastingOn(
    String localDate,
  ) async {
    try {
      final row = await _dao.fastingOn(localDate);
      return Right(
        row == null
            ? null
            : _toEntity(ReadingWithSymptoms(row, const <String>[])),
      );
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal memeriksa catatan puasa: $error'));
    }
  }

  @override
  Future<Either<Failure, GlucoseReading>> add(GlucoseReading reading) async {
    try {
      final id = await _dao.insertReading(_toCompanion(reading), [
        for (final symptom in reading.symptoms) symptom.dbValue,
      ]);
      final saved = await _dao.findById(id);
      if (saved == null) return const Left(DatabaseFailure());
      return Right(_toEntity(saved));
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal menyimpan catatan: $error'));
    }
  }

  @override
  Future<Either<Failure, GlucoseReading>> update(GlucoseReading reading) async {
    final id = reading.id;
    if (id == null) {
      return const Left(
        ValidationFailure('Catatan yang diperbarui harus memiliki ID.'),
      );
    }

    try {
      await _dao.updateReading(id, _toCompanion(reading), [
        for (final symptom in reading.symptoms) symptom.dbValue,
      ]);
      final saved = await _dao.findById(id);
      if (saved == null) return const Left(NotFoundFailure());
      return Right(_toEntity(saved));
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal memperbarui catatan: $error'));
    }
  }

  GlucoseReadingsTableCompanion _toCompanion(GlucoseReading reading) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return GlucoseReadingsTableCompanion.insert(
      readingType: reading.type.dbValue,
      valueMgDl: reading.valueMgDl,
      measuredAt: reading.measuredAt.toUtc().millisecondsSinceEpoch,
      tzOffsetMin: reading.tzOffsetMinutes,
      localDate: reading.localDate,
      status: reading.status.dbValue,
      isCritical: Value(reading.isCritical),
      mealContext: Value(reading.mealContext?.dbValue),
      hoursAfterMeal: Value(reading.hoursAfterMeal),
      note: Value(reading.note),
      source: Value(reading.source),
      createdAt: reading.createdAt?.millisecondsSinceEpoch ?? now,
      updatedAt: reading.updatedAt?.millisecondsSinceEpoch ?? now,
      deletedAt: Value(reading.deletedAt?.millisecondsSinceEpoch),
    );
  }

  GlucoseReading _toEntity(ReadingWithSymptoms value) {
    final row = value.row;
    return GlucoseReading(
      id: row.id,
      type: ReadingType.fromDb(row.readingType),
      valueMgDl: row.valueMgDl,
      measuredAt: DateTime.fromMillisecondsSinceEpoch(
        row.measuredAt,
        isUtc: true,
      ),
      tzOffsetMinutes: row.tzOffsetMin,
      status: GlucoseStatus.fromDb(row.status),
      isCritical: row.isCritical,
      mealContext: MealContext.fromDb(row.mealContext),
      hoursAfterMeal: row.hoursAfterMeal,
      symptoms: [for (final raw in value.symptoms) ?Symptom.fromDb(raw)],
      note: row.note,
      source: row.source,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      deletedAt: row.deletedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.deletedAt!),
    );
  }
}
