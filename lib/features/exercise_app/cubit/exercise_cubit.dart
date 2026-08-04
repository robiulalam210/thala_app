import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/exercise_model.dart';
import '../repository/exercise_repository.dart';
import 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository _repository;

  ExerciseCubit(this._repository) : super(const ExerciseLoading());

  Future<void> loadExercises() async {
    emit(const ExerciseLoading());
    final result = await _repository.getExercises();

    result.fold(
      (error) => emit(ExerciseError(error)),
      (exercises) => emit(ExerciseLoaded(allExercises: exercises)),
    );
  }

  void filterByMuscleGroup(MuscleGroup? group) {
    final current = state;
    if (current is! ExerciseLoaded) return;

    if (group == null) {
      emit(current.copyWith(clearFilter: true));
    } else {
      emit(current.copyWith(selectedMuscleGroup: group));
    }
  }
}
