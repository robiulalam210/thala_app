import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/progress_entry_model.dart';
import '../repository/progress_repository.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

class ProgressLoaded extends ProgressState {
  final List<ProgressEntry> entries; // oldest -> newest

  const ProgressLoaded(this.entries);

  @override
  List<Object?> get props => [entries.length, entries.isEmpty ? null : entries.last.date];
}

class ProgressCubit extends Cubit<ProgressState> {
  final ProgressRepository _repository;

  ProgressCubit(this._repository) : super(const ProgressLoading());

  Future<void> loadEntries() async {
    emit(const ProgressLoading());
    final entries = await _repository.getEntries();
    emit(ProgressLoaded(entries));
  }

  Future<void> addEntry(ProgressEntry entry) async {
    await _repository.addEntry(entry);
    await loadEntries();
  }
}
