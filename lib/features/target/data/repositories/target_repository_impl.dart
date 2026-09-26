import 'package:drift/drift.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/domain/target_presets.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/database/app_database.dart';
import 'package:flutter_gluko_apps/database/daos/target_dao.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TargetRepository)
class TargetRepositoryImpl implements TargetRepository {
  new(this._dao);

  final TargetDao _dao;

  @override
  Future<Either<Failure, TargetSet>> getTargets() async {
    try {
      return Right(_toEntity(await _dao.all()));
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal membaca target: $e'));
    }
  }

  @override
  Stream<TargetSet> watchTargets() => _dao.watchAll().map(_toEntity);

  @override
  Future<Either<Failure, Unit>> saveTargets(TargetSet targets) async {
    if (!targets.isValid) {
      return const Left(
        ValidationFailure(
          'Ambang harus naik berurutan: rendah < normal < waspada.',
        ),
      );
    }

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await _dao.upsertAll([
        for (final type in ReadingType.values)
          TargetRangesTableCompanion.insert(
            readingType: type.dbValue,
            lowMax: targets.forType(type).lowMax,
            normalMax: targets.forType(type).normalMax,
            warningMax: targets.forType(type).warningMax,
            criticalLow: Value(targets.forType(type).criticalLow),
            criticalHigh: Value(targets.forType(type).criticalHigh),
            updatedAt: now,
          ),
      ]);
      return const Right(unit);
    } on Object catch (e) {
      return Left(DatabaseFailure('Gagal menyimpan target: $e'));
    }
  }

  /// Baris yang hilang diisi preset Umum, sehingga klasifikasi tidak pernah
  /// kehilangan ambang walau database rusak sebagian.
  TargetSet _toEntity(List<TargetRangeRow> rows) {
    final map = <ReadingType, TargetThresholds>{};
    for (final row in rows) {
      map[ReadingType.fromDb(row.readingType)] = TargetThresholds(
        lowMax: row.lowMax,
        normalMax: row.normalMax,
        warningMax: row.warningMax,
        criticalLow: row.criticalLow,
        criticalHigh: row.criticalHigh,
      );
    }
    for (final type in ReadingType.values) {
      map.putIfAbsent(
        type,
        () => TargetPresets.forType(TargetPreset.general, type),
      );
    }
    return TargetSet(map);
  }
}
