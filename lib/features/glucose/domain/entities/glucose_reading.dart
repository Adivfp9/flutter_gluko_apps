import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/core/utils/local_date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'glucose_reading.freezed.dart';

/// Satu hasil pengukuran gula darah (PRD 7.3).
///
/// [measuredAt] selalu UTC dan [tzOffsetMinutes] menyimpan offset perangkat
/// saat pengukuran. Keduanya disimpan bersama supaya "hari" sebuah pembacaan
/// tidak bergeser ketika pengguna berpindah zona waktu (PRD 5.5) — itulah
/// yang menjaga indeks unik GDP-per-hari tetap benar.
@freezed
abstract class GlucoseReading with _$GlucoseReading {
  const factory({
    required ReadingType type,
    required int valueMgDl,
    required DateTime measuredAt,
    required int tzOffsetMinutes,
    required GlucoseStatus status,
    required bool isCritical,
    int? id,
    MealContext? mealContext,
    double? hoursAfterMeal,
    @Default(<Symptom>[]) List<Symptom> symptoms,
    String? note,
    @Default('manual') String source,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _GlucoseReading;

  const new _();

  /// Waktu pengukuran dalam jam dinding lokal saat pengukuran dilakukan.
  DateTime get measuredAtLocal =>
      LocalDate.toLocalWallClock(measuredAt, tzOffsetMinutes);

  /// `YYYY-MM-DD`, sama dengan kolom `local_date`.
  String get localDate => LocalDate.fromUtc(measuredAt, tzOffsetMinutes);

  /// `HH.mm`, format jam Indonesia seperti pada desain.
  String get formattedTime {
    final local = measuredAtLocal;
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h.$m';
  }

  bool get isDeleted => deletedAt != null;

  /// PRD F-01 AC5: konteks makan hanya berlaku untuk tipe non-puasa.
  bool get supportsMealContext => type != ReadingType.fasting;
}
