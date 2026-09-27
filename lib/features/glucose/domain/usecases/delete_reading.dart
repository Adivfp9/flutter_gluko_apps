import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/core/usecase/usecase.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

/// PRD F-05 AC3: hapus dengan konfirmasi dan opsi Undo 5 detik.
///
/// Penghapusan bersifat soft delete, jadi Undo cukup mengembalikan
/// `deleted_at` ke null.
@injectable
class DeleteReading implements UseCase<Unit, int> {
  const new(this._repository);

  final GlucoseRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) =>
      _repository.softDelete(params);
}

/// Membatalkan penghapusan.
///
/// Bisa gagal bila slot GDP pada tanggal itu sudah terisi pembacaan lain sejak
/// penghapusan — kegagalan itu dikembalikan sebagai `Left`, bukan diabaikan.
@injectable
class RestoreReading implements UseCase<Unit, int> {
  const new(this._repository);

  final GlucoseRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(int params) => _repository.restore(params);
}
