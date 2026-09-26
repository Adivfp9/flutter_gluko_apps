import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Kontrak dasar use case sekali jalan.
///
/// PRD 7.5: satu use case = satu tanggung jawab, dan setiap use case punya
/// unit test. Hasilnya selalu `Either` supaya jalur gagal ikut diketik dan
/// tidak bisa diabaikan diam-diam oleh pemanggil.
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Kontrak use case reaktif.
///
/// Dipakai oleh query yang bersumber dari `Stream` drift (PRD 7.4 langkah 5),
/// mis. `WatchDashboardSummary` dan daftar riwayat: satu kali simpan langsung
/// memancar ke semua layar tanpa refresh manual.
///
/// Sengaja tidak membungkus `Failure` — stream drift yang gagal berarti
/// database bermasalah, dan itu ditangani sebagai error stream di BLoC,
/// bukan sebagai state kosong yang menyesatkan.
abstract interface class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

/// Penanda untuk use case tanpa argumen.
final class NoParams {
  const new();
}
