import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/usecases/save_targets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

/// PRD F-03 AC3: tombol "Kembalikan ke default".
///
/// Preset yang dipulihkan mengikuti pilihan pengguna di layar Target, bukan
/// selalu "Umum" — pasien diabetes yang menekan tombol ini mengharapkan target
/// terapinya kembali, bukan kriteria diagnostik orang sehat.
@injectable
class ResetTargets implements UseCase<TargetSet, TargetPreset> {
  new(this._saveTargets);

  final SaveTargets _saveTargets;

  @override
  Future<Either<Failure, TargetSet>> call(TargetPreset params) async {
    final defaults = TargetSet.fromPreset(params);
    final result = await _saveTargets(defaults);
    return result.map((_) => defaults);
  }
}
