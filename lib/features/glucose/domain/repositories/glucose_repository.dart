import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/error/failures.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_gluko_apps/features/glucose/domain/usecases/build_dashboard_summary.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GlucoseRepository {
  Future<Either<Failure, GlucoseReading?>> findById(int id);

  Future<Either<Failure, GlucoseReading?>> findFastingOn(String localDate);

  Future<Either<Failure, GlucoseReading>> add(GlucoseReading reading);

  Future<Either<Failure, GlucoseReading>> update(GlucoseReading reading);

  Future<Either<Failure, List<GlucoseReading>>> getAllActive();

  Future<Either<Failure, Unit>> updateClassifications(
    List<GlucoseReading> readings,
  );

  /// Bahan beranda dalam satu langganan; memancar ulang setiap kali tabel
  /// pembacaan berubah (PRD F-04).
  Stream<DashboardInput> watchDashboard({required DateTime now});

  /// Riwayat berpaginasi dengan filter (PRD F-05 AC1 & AC2).
  Stream<List<GlucoseReading>> watchHistory({
    ReadingType? type,
    GlucoseStatus? status,
    String? fromLocalDate,
    String? toLocalDate,
    int limit,
    int offset,
  });

  Stream<GlucoseReading?> watchById(int id);

  /// Status terburuk per tanggal untuk tampilan kalender (PRD F-05 AC4).
  Future<Either<Failure, Map<String, GlucoseStatus>>> worstStatusPerDay({
    required String fromLocalDate,
    required String toLocalDate,
  });

  /// PRD 5.5: penghapusan bersifat soft delete agar Undo aman.
  Future<Either<Failure, Unit>> softDelete(int id);

  /// Membatalkan soft delete (Undo 5 detik, PRD F-05 AC3).
  Future<Either<Failure, Unit>> restore(int id);
}
