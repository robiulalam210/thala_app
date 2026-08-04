import 'package:equatable/equatable.dart';

import '../models/recipe_model.dart';

abstract class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  List<Object?> get props => [];
}

class MealPlanLoading extends MealPlanState {
  const MealPlanLoading();
}

class MealPlanError extends MealPlanState {
  final String message;

  const MealPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class MealPlanLoaded extends MealPlanState {
  final List<Recipe> allRecipes;
  final MealType? selectedMealType; // null = সব
  final String searchQuery;

  const MealPlanLoaded({
    required this.allRecipes,
    this.selectedMealType,
    this.searchQuery = '',
  });

  List<Recipe> get filteredRecipes {
    return allRecipes.where((recipe) {
      final matchesMealType = selectedMealType == null || recipe.mealType == selectedMealType;
      final matchesQuery = searchQuery.trim().isEmpty ||
          recipe.title.toLowerCase().contains(searchQuery.trim().toLowerCase());
      return matchesMealType && matchesQuery;
    }).toList();
  }

  MealPlanLoaded copyWith({
    List<Recipe>? allRecipes,
    MealType? selectedMealType,
    bool clearMealType = false,
    String? searchQuery,
  }) {
    return MealPlanLoaded(
      allRecipes: allRecipes ?? this.allRecipes,
      selectedMealType: clearMealType ? null : (selectedMealType ?? this.selectedMealType),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allRecipes, selectedMealType, searchQuery];
}
