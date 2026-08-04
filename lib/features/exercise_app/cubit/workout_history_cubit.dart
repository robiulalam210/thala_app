import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutHistoryEntry extends Equatable {
  final String exerciseName;
  final DateTime completedAt;
  final int totalSets;
  final int durationSeconds;

  const WorkoutHistoryEntry({
    required this.exerciseName,
    required this.completedAt,
    required this.totalSets,
    required this.durationSeconds,
  });

  @override
  List<Object?> get props => [exerciseName, completedAt, totalSets, durationSeconds];
}

abstract class WorkoutHistoryState extends Equatable {
  const WorkoutHistoryState();

  @override
  List<Object?> get props => [];
}

class WorkoutHistoryLoading extends WorkoutHistoryState {
  const WorkoutHistoryLoading();
}

class WorkoutHistoryLoaded extends WorkoutHistoryState {
  final List<WorkoutHistoryEntry> entries;

  const WorkoutHistoryLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  WorkoutHistoryCubit() : super(const WorkoutHistoryLoading());

  // TODO: local DB / API theke workout history load korben
  Future<void> loadHistory() async {
    emit(const WorkoutHistoryLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const WorkoutHistoryLoaded([]));
  }

  void addEntry(WorkoutHistoryEntry entry) {
    final current = state;
    if (current is WorkoutHistoryLoaded) {
      emit(WorkoutHistoryLoaded([entry, ...current.entries]));
    }
  }
}
