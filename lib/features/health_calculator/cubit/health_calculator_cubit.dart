import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/health_calculator_input.dart';
import '../repository/health_calculator_repository.dart';
import 'health_calculator_state.dart';

class HealthCalculatorCubit extends Cubit<HealthCalculatorState> {
  final HealthCalculatorRepository _repository;

  HealthCalculatorCubit(this._repository) : super(const HealthCalculatorInitial());

  void calculate(HealthCalculatorInput input) {
    emit(const HealthCalculatorLoading());

    final result = _repository.calculate(input);

    result.fold(
      (error) => emit(HealthCalculatorError(error)),
      (data) => emit(HealthCalculatorLoaded(result: data)),
    );
  }

  void reset() => emit(const HealthCalculatorInitial());
}
