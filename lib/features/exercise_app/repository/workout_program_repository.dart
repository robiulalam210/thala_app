import 'package:dartz/dartz.dart';

import '../models/exercise_model.dart';
import '../models/workout_program_model.dart';

abstract class WorkoutProgramRepository {
  Future<Either<String, List<WorkoutProgram>>> getPrograms();
}

class WorkoutProgramRepositoryImpl implements WorkoutProgramRepository {
  @override
  Future<Either<String, List<WorkoutProgram>>> getPrograms() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return Right(_mockPrograms);
    } catch (e) {
      return const Left('প্রোগ্রাম লোড করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।');
    }
  }

  static const List<WorkoutProgram> _mockPrograms = [
    WorkoutProgram(
      id: 'p1',
      title: 'Beginner Muscle Gain - 3 Day Split',
      description: 'Perfect for beginners looking to build muscle with a simple 3-day full body routine.',
      difficulty: ExerciseDifficulty.beginner,
      weeks: 12,
      daysPerWeek: 3,
      goalTag: 'MuscleGain',
    ),
    WorkoutProgram(
      id: 'p2',
      title: 'Intermediate Push/Pull/Legs',
      description: 'Classic 6-day split for intermediate lifters focused on muscle hypertrophy.',
      difficulty: ExerciseDifficulty.intermediate,
      weeks: 12,
      daysPerWeek: 6,
      goalTag: 'MuscleGain',
    ),
    WorkoutProgram(
      id: 'p3',
      title: 'Advanced Upper/Lower Split',
      description: 'High-volume 4-day split for advanced lifters seeking maximum hypertrophy.',
      difficulty: ExerciseDifficulty.advanced,
      weeks: 16,
      daysPerWeek: 4,
      goalTag: 'MuscleGain',
    ),
  ];
}
