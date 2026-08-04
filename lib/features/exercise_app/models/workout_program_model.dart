import 'exercise_model.dart';

class WorkoutProgram {
  final String id;
  final String title;
  final String description;
  final ExerciseDifficulty difficulty;
  final int weeks;
  final int daysPerWeek;
  final String goalTag;

  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.weeks,
    required this.daysPerWeek,
    required this.goalTag,
  });
}
