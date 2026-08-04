import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/meal_plan_cubit.dart';
import '../cubit/meal_plan_state.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card_widget.dart';
import 'recipe_detail_screen.dart';

class MealPlanListScreen extends StatefulWidget {
  const MealPlanListScreen({super.key});

  @override
  State<MealPlanListScreen> createState() => _MealPlanListScreenState();
}

class _MealPlanListScreenState extends State<MealPlanListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MealPlanCubit>().loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E11),
        elevation: 0,
        title: const Text('খাবার পরিকল্পনাকারী'),
        actions: const [
          Icon(Icons.favorite_border),
          SizedBox(width: 16),
          Icon(Icons.calendar_today_outlined),
          SizedBox(width: 12),
        ],
      ),
      body: BlocBuilder<MealPlanCubit, MealPlanState>(
        builder: (context, state) {
          if (state is MealPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MealPlanError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.white70)),
            );
          }

          final loaded = state as MealPlanLoaded;
          final recipes = loaded.filteredRecipes;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPersonalPlanBanner(),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 16),
              _buildMealTypeFilters(loaded.selectedMealType),
              const SizedBox(height: 16),
              if (recipes.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text('কোনো রেসিপি পাওয়া যায়নি', style: TextStyle(color: Colors.white54)),
                  ),
                )
              else
                ...recipes.map(
                  (recipe) => RecipeCardWidget(
                    recipe: recipe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
                    ),
                    onFavoriteTap: () => context.read<MealPlanCubit>().toggleFavorite(recipe.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPersonalPlanBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6E9EEB), Color(0xFF4A7ED1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.restaurant_menu, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আপনার ব্যক্তিগত প্ল্যান প্রস্তুত',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'আপনার ৭ দিনের ডায়েট প্ল্যান দেখতে ট্যাপ করুন',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => context.read<MealPlanCubit>().search(value),
      decoration: InputDecoration(
        hintText: 'রেসিপি খুঁজুন...',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        filled: true,
        fillColor: const Color(0xFF1B1B1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
      ),
    );
  }

  Widget _buildMealTypeFilters(MealType? selected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(label: 'সব', icon: Icons.restaurant, isSelected: selected == null, onTap: () {
            context.read<MealPlanCubit>().selectMealType(null);
          }),
          const SizedBox(width: 8),
          ...MealType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _filterChip(
                label: type.labelBn,
                icon: null,
                isSelected: selected == type,
                onTap: () => context.read<MealPlanCubit>().selectMealType(type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF1B1B1F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.white : Colors.grey.shade800),
        ),
        child: Row(
          children: [
            if (isSelected && icon == null) ...[
              const Icon(Icons.check, size: 14, color: Colors.black),
              const SizedBox(width: 4),
            ],
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? Colors.black : Colors.white70),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
