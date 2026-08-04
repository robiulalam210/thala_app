import 'package:equatable/equatable.dart';

import '../models/exercise_model.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseLoading extends ExerciseState {
  const ExerciseLoading();
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> allExercises;
  final MuscleGroup? selectedMuscleGroup; // null = All

  const ExerciseLoaded({
    required this.allExercises,
    this.selectedMuscleGroup,
  });

  List<Exercise> get filteredExercises {
    if (selectedMuscleGroup == null) return allExercises;
    return allExercises.where((e) => e.muscleGroup == selectedMuscleGroup).toList();
  }

  ExerciseLoaded copyWith({
    MuscleGroup? selectedMuscleGroup,
    bool clearFilter = false,
  }) {
    return ExerciseLoaded(
      allExercises: allExercises,
      selectedMuscleGroup: clearFilter ? null : (selectedMuscleGroup ?? this.selectedMuscleGroup),
    );
  }

  @override
  List<Object?> get props => [allExercises, selectedMuscleGroup];
}
