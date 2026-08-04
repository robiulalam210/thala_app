import 'package:equatable/equatable.dart';

import '../models/workout_session_model.dart';

enum SessionPhase { addingSet, resting }

class WorkoutSessionState extends Equatable {
  final int elapsedSeconds;
  final int currentSetNumber; // 1-indexed
  final int totalSets;
  final List<SetLog> completedSets;
  final SessionPhase phase;
  final int restRemainingSeconds;
  final int restDurationSeconds;
  final bool isCompleted;

  const WorkoutSessionState({
    required this.elapsedSeconds,
    required this.currentSetNumber,
    required this.totalSets,
    required this.completedSets,
    required this.phase,
    required this.restRemainingSeconds,
    required this.restDurationSeconds,
    this.isCompleted = false,
  });

  factory WorkoutSessionState.initial({required int totalSets, required int restDurationSeconds}) {
    return WorkoutSessionState(
      elapsedSeconds: 0,
      currentSetNumber: 1,
      totalSets: totalSets,
      completedSets: const [],
      phase: SessionPhase.addingSet,
      restRemainingSeconds: restDurationSeconds,
      restDurationSeconds: restDurationSeconds,
    );
  }

  WorkoutSessionState copyWith({
    int? elapsedSeconds,
    int? currentSetNumber,
    List<SetLog>? completedSets,
    SessionPhase? phase,
    int? restRemainingSeconds,
    bool? isCompleted,
  }) {
    return WorkoutSessionState(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      currentSetNumber: currentSetNumber ?? this.currentSetNumber,
      totalSets: totalSets,
      completedSets: completedSets ?? this.completedSets,
      phase: phase ?? this.phase,
      restRemainingSeconds: restRemainingSeconds ?? this.restRemainingSeconds,
      restDurationSeconds: restDurationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        elapsedSeconds,
        currentSetNumber,
        totalSets,
        completedSets,
        phase,
        restRemainingSeconds,
        isCompleted,
      ];
}
