import 'package:dartz/dartz.dart';

import '../models/exercise_model.dart';

abstract class ExerciseRepository {
  Future<Either<String, List<Exercise>>> getExercises();
}

class ExerciseRepositoryImpl implements ExerciseRepository {
  // TODO: mock data — পরে ApiClient দিয়ে server থেকে fetch করবেন
  @override
  Future<Either<String, List<Exercise>>> getExercises() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return Right(_mockExercises);
    } catch (e) {
      return const Left('এক্সারসাইজ লোড করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।');
    }
  }

  static final List<Exercise> _mockExercises = [
    Exercise(
      id: 'e1',
      name: 'Barbell Bench Press',
      muscleGroup: MuscleGroup.chest,
      difficulty: ExerciseDifficulty.intermediate,
      category: ExerciseCategory.compound,
      description: 'The king of chest exercises for building mass and strength.',
      instructions: const [
        'Lie flat on bench with feet firmly on ground',
        'Grip barbell slightly wider than shoulder width',
        'Lower bar to mid-chest with controlled motion',
        'Press up powerfully, driving through chest',
        'Keep core tight and maintain natural arch',
      ],
      estimatedMinutes: 4,
      estimatedKcal: 45,
      defaultSets: 4,
      defaultRestSeconds: 90,
    ),
    Exercise(
      id: 'e2',
      name: 'Incline Dumbbell Press',
      muscleGroup: MuscleGroup.chest,
      difficulty: ExerciseDifficulty.intermediate,
      category: ExerciseCategory.compound,
      description: 'Targets upper chest for complete pectoral development.',
      instructions: const [
        'Set bench to 30-45 degree incline',
        'Hold dumbbells at shoulder level',
        'Press dumbbells up until arms extended',
        'Lower with control back to start position',
      ],
      estimatedMinutes: 4,
      estimatedKcal: 36,
      defaultSets: 4,
      defaultRestSeconds: 75,
    ),
    Exercise(
      id: 'e3',
      name: 'Dips (Chest Variation)',
      muscleGroup: MuscleGroup.chest,
      difficulty: ExerciseDifficulty.advanced,
      category: ExerciseCategory.compound,
      description: 'Bodyweight exercise for lower chest development.',
      instructions: const [
        'Grip parallel bars and lift body up',
        'Lean torso forward slightly',
        'Lower body until shoulders below elbows',
        'Push back up to starting position',
      ],
      estimatedMinutes: 4,
      estimatedKcal: 30,
      defaultSets: 3,
      defaultRestSeconds: 60,
    ),
    Exercise(
      id: 'e4',
      name: 'Pull-Ups',
      muscleGroup: MuscleGroup.back,
      difficulty: ExerciseDifficulty.intermediate,
      category: ExerciseCategory.compound,
      description: 'Classic bodyweight exercise for a wider, stronger back.',
      instructions: const [
        'Grip bar slightly wider than shoulders',
        'Hang with arms fully extended',
        'Pull body up until chin clears bar',
        'Lower with control back to start',
      ],
      estimatedMinutes: 4,
      estimatedKcal: 40,
      defaultSets: 4,
      defaultRestSeconds: 90,
    ),
    Exercise(
      id: 'e5',
      name: 'Overhead Shoulder Press',
      muscleGroup: MuscleGroup.shoulders,
      difficulty: ExerciseDifficulty.beginner,
      category: ExerciseCategory.compound,
      description: 'Builds strong, well-rounded shoulders.',
      instructions: const [
        'Hold dumbbells at shoulder height',
        'Press weights straight overhead',
        'Lower with control back to shoulders',
      ],
      estimatedMinutes: 3,
      estimatedKcal: 28,
      defaultSets: 3,
      defaultRestSeconds: 60,
    ),
    Exercise(
      id: 'e6',
      name: 'Barbell Bicep Curl',
      muscleGroup: MuscleGroup.biceps,
      difficulty: ExerciseDifficulty.beginner,
      category: ExerciseCategory.isolation,
      description: 'Isolation movement to build bigger, stronger biceps.',
      instructions: const [
        'Hold barbell with underhand grip',
        'Curl bar up while keeping elbows still',
        'Squeeze at the top, lower with control',
      ],
      estimatedMinutes: 3,
      estimatedKcal: 22,
      defaultSets: 3,
      defaultRestSeconds: 60,
    ),
  ];
}
