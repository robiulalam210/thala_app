import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/health_calculator_input.dart';
import '../model/health_calculator_result.dart';
import '../repository/health_calculator_repository.dart';

part 'health_calculator_state.dart';


class HealthCalculatorCubit extends Cubit<HealthCalculatorState> {
  final HealthCalculatorRepository _repository;

  HealthCalculatorCubit(this._repository) : super( HealthCalculatorInitial());

  void calculate(HealthCalculatorInput input) {
    emit( HealthCalculatorLoading());

    final result = _repository.calculate(input);

    result.fold(
          (error) => emit(HealthCalculatorError(error)),
          (data) => emit(HealthCalculatorLoaded(result: data)),
    );
  }

  /// প্রিমিয়াম আনলক সফল হওয়ার পর UI থেকে কল করবেন
  /// (পেমেন্ট/সাবস্ক্রিপশন চেক করার লজিক এখানে বসাতে পারেন — এখন সরাসরি আনলক করছে)
  void unlockPersonalizedTips() {
    final current = state;
    if (current is HealthCalculatorLoaded) {
      emit(current.copyWith(isPersonalizedTipsUnlocked: true));
    }
  }

  void unlockHealthScore() {
    final current = state;
    if (current is HealthCalculatorLoaded) {
      emit(current.copyWith(isHealthScoreUnlocked: true));
    }
  }

  void reset() => emit( HealthCalculatorInitial());
}
