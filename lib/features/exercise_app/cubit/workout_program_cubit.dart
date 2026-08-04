import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/workout_program_model.dart';
import '../repository/workout_program_repository.dart';

abstract class WorkoutProgramState extends Equatable {
  const WorkoutProgramState();

  @override
  List<Object?> get props => [];
}

class WorkoutProgramLoading extends WorkoutProgramState {
  const WorkoutProgramLoading();
}

class WorkoutProgramError extends WorkoutProgramState {
  final String message;

  const WorkoutProgramError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkoutProgramLoaded extends WorkoutProgramState {
  final List<WorkoutProgram> programs;

  const WorkoutProgramLoaded(this.programs);

  @override
  List<Object?> get props => [programs];
}

class WorkoutProgramCubit extends Cubit<WorkoutProgramState> {
  final WorkoutProgramRepository _repository;

  WorkoutProgramCubit(this._repository) : super(const WorkoutProgramLoading());

  Future<void> loadPrograms() async {
    emit(const WorkoutProgramLoading());
    final result = await _repository.getPrograms();

    result.fold(
      (error) => emit(WorkoutProgramError(error)),
      (programs) => emit(WorkoutProgramLoaded(programs)),
    );
  }
}
