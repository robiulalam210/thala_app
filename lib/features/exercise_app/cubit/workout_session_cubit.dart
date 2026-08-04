import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/workout_session_model.dart';
import 'workout_session_state.dart';

class WorkoutSessionCubit extends Cubit<WorkoutSessionState> {
  Timer? _elapsedTimer;
  Timer? _restTimer;

  WorkoutSessionCubit({required int totalSets, required int restDurationSeconds})
      : super(WorkoutSessionState.initial(totalSets: totalSets, restDurationSeconds: restDurationSeconds)) {
    _startElapsedTimer();
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isCompleted) {
        emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
      }
    });
  }

  void addSet({required int reps, required double weight}) {
    if (state.phase != SessionPhase.addingSet) return;

    final newLog = SetLog(setNumber: state.currentSetNumber, reps: reps, weight: weight);
    final updatedLogs = [...state.completedSets, newLog];

    if (state.currentSetNumber >= state.totalSets) {
      _finishWorkout(updatedLogs);
      return;
    }

    emit(state.copyWith(
      completedSets: updatedLogs,
      phase: SessionPhase.resting,
      restRemainingSeconds: state.restDurationSeconds,
    ));
    _startRestTimer();
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.restRemainingSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        _moveToNextSet();
      } else {
        emit(state.copyWith(restRemainingSeconds: remaining));
      }
    });
  }

  void skipRest() {
    if (state.phase != SessionPhase.resting) return;
    _restTimer?.cancel();
    _moveToNextSet();
  }

  void _moveToNextSet() {
    emit(state.copyWith(
      currentSetNumber: state.currentSetNumber + 1,
      phase: SessionPhase.addingSet,
      restRemainingSeconds: state.restDurationSeconds,
    ));
  }

  /// "Complete Workout" বাটনে ম্যানুয়ালি এখনই শেষ করার জন্য
  void completeWorkoutNow() {
    _finishWorkout(state.completedSets);
  }

  void _finishWorkout(List<SetLog> logs) {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    emit(state.copyWith(completedSets: logs, isCompleted: true));
  }

  void cancelWorkout() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
  }

  @override
  Future<void> close() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    return super.close();
  }
}
