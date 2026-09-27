import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// Profil pengguna (PRD F-10 AC2).
///
/// Seluruh field selain [unit] dan [preset] bersifat opsional: PRD menyebut
/// profil sebagai langkah opsional, jadi aplikasi harus tetap berfungsi penuh
/// untuk pengguna yang melewatinya.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory({
    String? name,
    int? birthYear,
    @Default(DiabetesType.unknown) DiabetesType diabetesType,
    @Default(GlucoseUnit.mgDl) GlucoseUnit unit,
    @Default(TargetPreset.general) TargetPreset preset,
    @Default(false) bool onboardingDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  const new _();

  /// Usia perkiraan dari tahun lahir; `null` bila tahun lahir tidak diisi.
  int? ageAt(DateTime now) => birthYear == null ? null : now.year - birthYear!;

  /// Sapaan untuk beranda. Kembali ke sapaan netral bila nama kosong.
  String greetingName() {
    final trimmed = name?.trim() ?? '';
    return trimmed.isEmpty ? 'Anda' : trimmed;
  }
}
