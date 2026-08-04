import 'package:equatable/equatable.dart';

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

  Map<String, dynamic> toJson() => {
        'exerciseName': exerciseName,
        'completedAt': completedAt.toIso8601String(),
        'totalSets': totalSets,
        'durationSeconds': durationSeconds,
      };

  factory WorkoutHistoryEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryEntry(
      exerciseName: json['exerciseName'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      totalSets: json['totalSets'] as int,
      durationSeconds: json['durationSeconds'] as int,
    );
  }

  @override
  List<Object?> get props => [exerciseName, completedAt, totalSets, durationSeconds];
}
