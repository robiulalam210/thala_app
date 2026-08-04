import 'package:flutter/material.dart';

import '../models/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E11),
        elevation: 0,
        title: Text(recipe.title, style: const TextStyle(fontSize: 17)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTimeRow(),
          const SizedBox(height: 24),
          _sectionTitle('পুষ্টি তথ্য'),
          const SizedBox(height: 10),
          _buildNutritionCard(),
          const SizedBox(height: 24),
          _sectionTitle('ট্যাগ'),
          const SizedBox(height: 10),
          _buildTags(),
          const SizedBox(height: 24),
          _sectionTitle('উপকরণ'),
          const SizedBox(height: 10),
          _buildIngredients(),
          const SizedBox(height: 24),
          _sectionTitle('নির্দেশনা'),
          const SizedBox(height: 10),
          _buildInstructions(),
          const SizedBox(height: 24),
          _sectionTitle('এই রেসিপি সম্পর্কে'),
          const SizedBox(height: 10),
          _infoCard(recipe.aboutDescription),
          const SizedBox(height: 24),
          _sectionTitle('কীভাবে রান্না করবেন'),
          const SizedBox(height: 10),
          _infoCard(recipe.howToCook, lineHeight: 1.7),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
      );

  Widget _buildTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _timeStat('প্রস্তুতির সময়', '${recipe.prepTimeMinutes} মিনিট'),
        _timeStat('রান্নার সময়', '${recipe.cookTimeMinutes} মিনিট'),
        _timeStat('পরিবেশন', '${recipe.servings}'),
      ],
    );
  }

  Widget _timeStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildNutritionCard() {
    final rows = [
      (Colors.orange, 'ক্যাল', '${recipe.nutrition.calories} কিক্যাল'),
      (Colors.blue, 'প্রোটিন', '${recipe.nutrition.proteinG.toStringAsFixed(0)}গ্রাম'),
      (Colors.orange, 'কার্বস', '${recipe.nutrition.carbsG.toStringAsFixed(0)}গ্রাম'),
      (Colors.green, 'ফ্যাট', '${recipe.nutrition.fatG.toStringAsFixed(0)}গ্রাম'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: rows[i].$1, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Text(rows[i].$2, style: const TextStyle(fontSize: 14, color: Colors.white)),
                    ],
                  ),
                  Text(
                    rows[i].$3,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            if (i != rows.length - 1) Divider(color: Colors.grey.shade800, height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: recipe.tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tag, style: const TextStyle(fontSize: 12.5, color: Color(0xFF2D5C8C))),
            ),
          )
          .toList(),
    );
  }

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipe.ingredients
          .map(
            (ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: List.generate(recipe.instructions.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF2D5C8C),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    recipe.instructions[index],
                    style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoCard(String text, {double lineHeight = 1.5}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.5, color: Colors.grey.shade300, height: lineHeight),
      ),
    );
  }
}
