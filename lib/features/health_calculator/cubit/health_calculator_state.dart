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

  const HealthCalculatorLoaded({required this.result});

  @override
  List<Object?> get props => [result.bmi, result.bmr];
}
