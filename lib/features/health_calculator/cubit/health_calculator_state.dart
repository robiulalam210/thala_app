import 'package:equatable/equatable.dart';

import '../models/health_calculator_result.dart';

abstract class HealthCalculatorState extends Equatable {
  const HealthCalculatorState();

  @override
  List<Object?> get props => [];
}

class HealthCalculatorInitial extends HealthCalculatorState {
  const HealthCalculatorInitial();
}

class HealthCalculatorLoading extends HealthCalculatorState {
  const HealthCalculatorLoading();
}

class HealthCalculatorError extends HealthCalculatorState {
  final String message;

  const HealthCalculatorError(this.message);

  @override
  List<Object?> get props => [message];
}

class HealthCalculatorLoaded extends HealthCalculatorState {
  final HealthCalculatorResult result;
  final bool isPersonalizedTipsUnlocked;
  final bool isHealthScoreUnlocked;

  const HealthCalculatorLoaded({
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
