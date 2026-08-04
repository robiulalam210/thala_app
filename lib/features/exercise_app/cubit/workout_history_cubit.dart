import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/workout_history_entry_model.dart';
import '../repository/workout_history_repository.dart';

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
  final WorkoutHistoryRepository _repository;

  WorkoutHistoryCubit(this._repository) : super(const WorkoutHistoryLoading());

  Future<void> loadHistory() async {
    emit(const WorkoutHistoryLoading());
    final entries = await _repository.getEntries();
    emit(WorkoutHistoryLoaded(entries));
  }

  Future<void> addEntry(WorkoutHistoryEntry entry) async {
    await _repository.addEntry(entry);
    await loadHistory();
  }
}
