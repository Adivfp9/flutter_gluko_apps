import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_gluko_apps/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveProfile implements UseCase<Unit, UserProfile> {
  new(this._repository);

  final ProfileRepository _repository;

  /// Tahun lahir divalidasi longgar: menolak tahun di masa depan dan usia di
  /// atas 120 tahun, tanpa memaksa pengguna mengisinya.
  @override
  Future<Either<Failure, Unit>> call(UserProfile params) async {
    final year = params.birthYear;
    if (year != null) {
      final thisYear = DateTime.now().year;
      if (year > thisYear || year < thisYear - 120) {
        return const Left(
          ValidationFailure(
            'Tahun lahir tidak masuk akal.',
            field: 'birthYear',
          ),
        );
      }
    }

    if ((params.name?.length ?? 0) > 60) {
      return const Left(
        ValidationFailure('Nama maksimal 60 karakter.', field: 'name'),
      );
    }

    return await _repository.saveProfile(params);
  }
}
