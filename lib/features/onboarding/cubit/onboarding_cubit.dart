import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/onboarding_models.dart';
import '../repository/onboarding_repository.dart';

class OnboardingState extends Equatable {
  final int stepIndex;
  final int totalSteps;
  final OnboardingProfile profile;
  final bool isComplete;

  const OnboardingState({
    required this.stepIndex,
    required this.totalSteps,
    required this.profile,
    this.isComplete = false,
  });

  factory OnboardingState.initial(int totalSteps) {
    return OnboardingState(stepIndex: 0, totalSteps: totalSteps, profile: const OnboardingProfile());
  }

  OnboardingState copyWith({int? stepIndex, OnboardingProfile? profile, bool? isComplete}) {
    return OnboardingState(
      stepIndex: stepIndex ?? this.stepIndex,
      totalSteps: totalSteps,
      profile: profile ?? this.profile,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [stepIndex, totalSteps, profile.toJson(), isComplete];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingCubit(this._repository, {required int totalSteps}) : super(OnboardingState.initial(totalSteps));

  void nextStep() {
    if (state.stepIndex < state.totalSteps - 1) {
      emit(state.copyWith(stepIndex: state.stepIndex + 1));
    }
  }

  void previousStep() {
    if (state.stepIndex > 0) {
      emit(state.copyWith(stepIndex: state.stepIndex - 1));
    }
  }

  void updateProfile(OnboardingProfile Function(OnboardingProfile current) update) {
    emit(state.copyWith(profile: update(state.profile)));
  }

  Future<void> finish() async {
    await _repository.saveProfile(state.profile);
    emit(state.copyWith(isComplete: true));
  }

  Future<void> skipAll() async {
    await _repository.saveProfile(state.profile);
    emit(state.copyWith(isComplete: true));
  }
}
