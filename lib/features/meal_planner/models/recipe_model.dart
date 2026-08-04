import 'package:flutter/material.dart';

enum MealType { breakfast, lunch, dinner }

extension MealTypeX on MealType {
  String get labelBn {
    switch (this) {
      case MealType.breakfast:
        return 'সকালের নাস্তা';
      case MealType.lunch:
        return 'দুপুরের খাবার';
      case MealType.dinner:
        return 'রাতের খাবার';
    }
  }
}

enum DifficultyLevel { easy, medium, hard }

extension DifficultyLevelX on DifficultyLevel {
  String get labelBn {
    switch (this) {
      case DifficultyLevel.easy:
        return 'সহজ';
      case DifficultyLevel.medium:
        return 'মাঝারি';
      case DifficultyLevel.hard:
        return 'কঠিন';
    }
  }

  Color get color {
    switch (this) {
      case DifficultyLevel.easy:
        return const Color(0xFF6FCF97);
      case DifficultyLevel.medium:
        return const Color(0xFFF2994A);
      case DifficultyLevel.hard:
        return const Color(0xFFEB5757);
    }
  }
}

class NutritionInfo {
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const NutritionInfo({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

class Recipe {
  final String id;
  final String title;
  final String shortDescription;
  final String aboutDescription;
  final String howToCook;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final NutritionInfo nutrition;
  final DifficultyLevel difficulty;
  final MealType mealType;
  final List<String> tags;
  final List<String> ingredients;
  final List<String> instructions;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.aboutDescription,
    required this.howToCook,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.nutrition,
    required this.difficulty,
    required this.mealType,
    required this.tags,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  Recipe copyWith({bool? isFavorite}) {
    return Recipe(
      id: id,
      title: title,
      shortDescription: shortDescription,
      aboutDescription: aboutDescription,
      howToCook: howToCook,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      servings: servings,
      nutrition: nutrition,
      difficulty: difficulty,
      mealType: mealType,
      tags: tags,
      ingredients: ingredients,
      instructions: instructions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
