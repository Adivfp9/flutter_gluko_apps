import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gluko_apps/core/domain/glucose_enums.dart';
import 'package:flutter_gluko_apps/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:flutter_gluko_apps/features/profile/domain/usecases/complete_onboarding.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  new(this._completeOnboarding) : super(const OnboardingState());

  final CompleteOnboarding _completeOnboarding;

  void next() {
    if (!state.canContinue || state.isLastStep) return;
    emit(state.copyWith(step: OnboardingStep.values[state.stepIndex + 1]));
  }

  void back() {
    if (state.isFirstStep) return;
    emit(state.copyWith(step: OnboardingStep.values[state.stepIndex - 1]));
  }

  void setDisclaimerAccepted({required bool accepted}) =>
      emit(state.copyWith(disclaimerAccepted: accepted));

  void setUnit(GlucoseUnit unit) => emit(state.copyWith(unit: unit));

  void setDiabetesType(DiabetesType type) =>
      emit(state.copyWith(diabetesType: type));

  void setName(String name) => emit(state.copyWith(name: name));

  void setBirthYear(int? year) => emit(state.copyWith(birthYear: year));

  void setReminderMinutes(int minutes) =>
      emit(state.copyWith(fastingReminderMinutes: minutes));

  void setReminderEnabled({required bool enabled}) =>
      emit(state.copyWith(fastingReminderEnabled: enabled));

  Future<void> submit() async {
    if (state.isSubmitting) return;
    // Disclaimer wajib disetujui, walau pengguna sudah berada di langkah akhir.
    if (!state.disclaimerAccepted) {
      emit(
        state.copyWith(
          step: OnboardingStep.disclaimer,
          errorMessage: 'Persetujuan disclaimer diperlukan untuk melanjutkan.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await _completeOnboarding(
      CompleteOnboardingParams(
        diabetesType: state.diabetesType,
        unit: state.unit,
        fastingReminderMinutes: state.fastingReminderMinutes,
        name: state.name.trim().isEmpty ? null : state.name.trim(),
        birthYear: state.birthYear,
        enableFastingReminder: state.fastingReminderEnabled,
      ),
    );

    switch (result) {
      case Left(value: final failure):
        emit(
          state.copyWith(isSubmitting: false, errorMessage: failure.message),
        );
      case Right():
        emit(state.copyWith(isSubmitting: false, isDone: true));
    }
  }
}
