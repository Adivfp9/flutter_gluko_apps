import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/glucose_dao.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/build_dashboard_summary.dart';
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

  @override
  Future<Either<Failure, List<GlucoseReading>>> getAllActive() async {
    try {
      return Right([
        for (final value in await _dao.allActive()) _toEntity(value),
      ]);
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal membaca seluruh catatan: $error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateClassifications(
    List<GlucoseReading> readings,
  ) async {
    try {
      await _dao.updateClassifications([
        for (final reading in readings)
          (
            id: reading.id!,
            status: reading.status.dbValue,
            isCritical: reading.isCritical,
            updatedAt: reading.updatedAt!.millisecondsSinceEpoch,
          ),
      ]);
      return const Right(unit);
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal menghitung ulang status: $error'));
    }
  }

  @override
  Stream<DashboardInput> watchDashboard({required DateTime now}) {
    // Jendela 14 hari: 7 hari berjalan plus 7 hari pembanding (PRD F-04 AC2).
    final from = DateTime(
      now.year,
      now.month,
      now.day - (BuildDashboardSummary.periodDays * 2 - 1),
    );

    return _dao
        .watchDashboard(
          fromLocalDate: LocalDate.ofLocal(from),
          toLocalDate: LocalDate.ofLocal(now),
        )
        .map(
          (raw) => DashboardInput(
            windowReadings: [
              for (final row in raw.window)
                _toEntity(ReadingWithSymptoms(row, const <String>[])),
            ],
            recentReadings: [for (final r in raw.recent) _toEntity(r)],
            lastRandom: raw.lastRandom == null
                ? null
                : _toEntity(
                    ReadingWithSymptoms(raw.lastRandom!, const <String>[]),
                  ),
          ),
        );
  }

  @override
  Stream<List<GlucoseReading>> watchHistory({
    ReadingType? type,
    GlucoseStatus? status,
    String? fromLocalDate,
    String? toLocalDate,
    int limit = 30,
    int offset = 0,
  }) {
    return _dao
        .watchHistory(
          type: type,
          status: status,
          fromLocalDate: fromLocalDate,
          toLocalDate: toLocalDate,
          limit: limit,
          offset: offset,
        )
        .map((rows) => [for (final row in rows) _toEntity(row)]);
  }

  @override
  Stream<List<GlucoseReading>> watchReadingsBetween({
    required String fromLocalDate,
    required String toLocalDate,
  }) => _dao
      .watchReadingsBetween(
        fromLocalDate: fromLocalDate,
        toLocalDate: toLocalDate,
      )
      .map(
        (rows) => [
          for (final row in rows)
            _toEntity(ReadingWithSymptoms(row, const <String>[])),
        ],
      );

  @override
  Stream<GlucoseReading?> watchById(int id) => _dao
      .watchById(id)
      .map((value) => value == null ? null : _toEntity(value));

  @override
  Future<Either<Failure, Map<String, GlucoseStatus>>> worstStatusPerDay({
    required String fromLocalDate,
    required String toLocalDate,
  }) async {
    try {
      final rows = await _dao.worstStatusPerDay(
        fromLocalDate: fromLocalDate,
        toLocalDate: toLocalDate,
      );
      return Right({for (final row in rows) row.localDate: row.status});
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal membaca status harian: $error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> softDelete(int id) async {
    try {
      await _dao.softDelete(id, DateTime.now());
      return const Right(unit);
    } on Object catch (error) {
      return Left(DatabaseFailure('Gagal menghapus catatan: $error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> restore(int id) async {
    try {
      await _dao.restore(id);
      return const Right(unit);
    } on Object catch (_) {
      // Penyebab paling mungkin: slot GDP hari itu sudah terisi pembacaan lain
      // sejak penghapusan, sehingga indeks unik menolak pemulihan.
      return const Left(
        DatabaseFailure(
          'Gagal memulihkan catatan. Mungkin sudah ada catatan puasa lain '
          'pada tanggal tersebut.',
        ),
      );
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
