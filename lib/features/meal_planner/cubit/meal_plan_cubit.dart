import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/recipe_model.dart';
import '../repository/meal_plan_repository.dart';
import 'meal_plan_state.dart';

class MealPlanCubit extends Cubit<MealPlanState> {
  final MealPlanRepository _repository;

  MealPlanCubit(this._repository) : super(const MealPlanLoading());

  Future<void> loadRecipes() async {
    emit(const MealPlanLoading());
    final result = await _repository.getRecipes();

    result.fold(
      (error) => emit(MealPlanError(error)),
      (recipes) => emit(MealPlanLoaded(allRecipes: recipes)),
    );
  }

  void selectMealType(MealType? type) {
    final current = state;
    if (current is! MealPlanLoaded) return;

    if (type == null) {
      emit(current.copyWith(clearMealType: true));
    } else {
      emit(current.copyWith(selectedMealType: type));
    }
  }

  void search(String query) {
    final current = state;
    if (current is! MealPlanLoaded) return;
    emit(current.copyWith(searchQuery: query));
  }

  void toggleFavorite(String recipeId) {
    final current = state;
    if (current is! MealPlanLoaded) return;

    final updated = current.allRecipes.map((recipe) {
      if (recipe.id == recipeId) {
        return recipe.copyWith(isFavorite: !recipe.isFavorite);
      }
      return recipe;
    }).toList();

    emit(current.copyWith(allRecipes: updated));
  }
}
