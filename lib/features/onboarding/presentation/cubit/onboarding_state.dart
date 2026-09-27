import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

/// Empat langkah onboarding (PRD F-10 AC1).
enum OnboardingStep { welcome, disclaimer, unit, reminder }

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory({
    @Default(OnboardingStep.welcome) OnboardingStep step,
    @Default(false) bool disclaimerAccepted,
    @Default(GlucoseUnit.mgDl) GlucoseUnit unit,
    @Default(DiabetesType.unknown) DiabetesType diabetesType,
    @Default('') String name,
    int? birthYear,

    /// Default 06.00 (PRD F-07 AC1).
    @Default(6 * 60) int fastingReminderMinutes,
    @Default(true) bool fastingReminderEnabled,
    @Default(false) bool isSubmitting,
    @Default(false) bool isDone,
    String? errorMessage,
  }) = _OnboardingState;

  const new _();

  int get stepIndex => OnboardingStep.values.indexOf(step);

  bool get isFirstStep => step == OnboardingStep.welcome;
  bool get isLastStep => step == OnboardingStep.reminder;

  /// Tombol Lanjut hanya aktif bila langkah saat ini sudah terpenuhi.
  ///
  /// Hanya langkah disclaimer yang memblokir (PRD F-10 AC1: wajib disetujui);
  /// sisanya selalu punya nilai default yang sah.
  bool get canContinue => switch (step) {
    OnboardingStep.disclaimer => disclaimerAccepted,
    _ => true,
  };

  /// Preset target yang akan diterapkan, ditampilkan sebagai pratinjau di
  /// langkah satuan supaya pengguna tahu konsekuensi pilihannya.
  TargetPreset get resultingPreset => diabetesType.defaultPreset;
}
