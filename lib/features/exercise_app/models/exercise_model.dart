import 'package:flutter/material.dart';

enum MuscleGroup { chest, back, shoulders, biceps, triceps, legs, core }

extension MuscleGroupX on MuscleGroup {
  String get label {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.core:
        return 'Core';
    }
  }
}

enum ExerciseDifficulty { beginner, intermediate, advanced }

extension ExerciseDifficultyX on ExerciseDifficulty {
  String get label {
    switch (this) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';
      case ExerciseDifficulty.intermediate:
        return 'Intermediate';
      case ExerciseDifficulty.advanced:
        return 'Advanced';
    }
  }

  Color get color {
    switch (this) {
      case ExerciseDifficulty.beginner:
        return const Color(0xFF6FCF97);
      case ExerciseDifficulty.intermediate:
        return const Color(0xFFDDA92C);
      case ExerciseDifficulty.advanced:
        return const Color(0xFFEB5757);
    }
  }
}

enum ExerciseCategory { compound, isolation }

extension ExerciseCategoryX on ExerciseCategory {
  String get label => this == ExerciseCategory.compound ? 'Compound' : 'Isolation';
}

class Exercise {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;
  final ExerciseDifficulty difficulty;
  final ExerciseCategory category;
  final String description;
  final List<String> instructions;
  final String? imageAsset;
  final int estimatedMinutes;
  final int estimatedKcal;
  final int defaultSets;
  final int defaultRestSeconds;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.difficulty,
    required this.category,
    required this.description,
    required this.instructions,
    this.imageAsset,
    required this.estimatedMinutes,
    required this.estimatedKcal,
    this.defaultSets = 4,
    this.defaultRestSeconds = 90,
  });
}
