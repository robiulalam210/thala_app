part of 'health_calculator_cubit.dart';

@immutable
sealed class HealthCalculatorState {}

final class HealthCalculatorInitial extends HealthCalculatorState {}
class HealthCalculatorLoading extends HealthCalculatorState {
   HealthCalculatorLoading();
}

class HealthCalculatorError extends HealthCalculatorState {
  final String message;

   HealthCalculatorError(this.message);

  @override
  List<Object?> get props => [message];
}

class HealthCalculatorLoaded extends HealthCalculatorState {
  final HealthCalculatorResult result;
  final bool isPersonalizedTipsUnlocked;
  final bool isHealthScoreUnlocked;

   HealthCalculatorLoaded({
    required this.result,
    this.isPersonalizedTipsUnlocked = false,
    this.isHealthScoreUnlocked = false,
  });

  HealthCalculatorLoaded copyWith({
    HealthCalculatorResult? result,
    bool? isPersonalizedTipsUnlocked,
    bool? isHealthScoreUnlocked,
  }) {
    return HealthCalculatorLoaded(
      result: result ?? this.result,
      isPersonalizedTipsUnlocked:
      isPersonalizedTipsUnlocked ?? this.isPersonalizedTipsUnlocked,
      isHealthScoreUnlocked: isHealthScoreUnlocked ?? this.isHealthScoreUnlocked,
    );
  }

  @override
  List<Object?> get props => [
    result.bmi,
    result.bmr,
    isPersonalizedTipsUnlocked,
    isHealthScoreUnlocked,
  ];
}