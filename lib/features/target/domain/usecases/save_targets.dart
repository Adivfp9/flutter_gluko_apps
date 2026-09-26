import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_gluko_apps/features/target/domain/entities/target_set.dart';
import 'package:flutter_gluko_apps/features/target/domain/repositories/target_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

/// Menyimpan ambang target sekaligus menyelaraskan preset di profil.
///
/// Tanpa penyelarasan ini, layar Target akan menyorot segmen "Umum" padahal
/// angkanya sudah diubah pengguna.
@injectable
class SaveTargets implements UseCase<Unit, TargetSet> {
  new(this._targets, this._profiles);

  final TargetRepository _targets;
  final ProfileRepository _profiles;

  @override
  Future<Either<Failure, Unit>> call(TargetSet params) async {
    if (!params.isValid) {
      return const Left(
        ValidationFailure(
          'Ambang harus naik berurutan: rendah < normal < waspada.',
        ),
      );
    }

    final saved = await _targets.saveTargets(params);
    if (saved case Left(value: final failure)) {
      return Left(failure);
    }

    final profile = await _profiles.getProfile();
    if (profile case Left(value: final failure)) {
      return Left(failure);
    }

    // Preset diturunkan dari angkanya sendiri, jadi mengubah satu ambang
    // otomatis memindahkan profil ke preset "Kustom".
    final current = profile.getOrElse((_) => throw StateError('unreachable'));
    return await _profiles.saveProfile(current.copyWith(preset: params.preset));
  }
}
