import 'package:flutter/material.dart';

import '../models/recipe_model.dart';

class RecipeCardWidget extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const RecipeCardWidget({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1F),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.restaurant, size: 36, color: Colors.black38),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: recipe.difficulty.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      recipe.difficulty.labelBn,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: recipe.isFavorite ? Colors.redAccent : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.shortDescription,
                    style: TextStyle(fontSize: 12.5, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _metaItem(Icons.access_time, '${recipe.totalTimeMinutes} মিনিট'),
                      const SizedBox(width: 14),
                      _metaItem(Icons.local_fire_department, '${recipe.nutrition.calories} ক্যাল'),
                      const SizedBox(width: 14),
                      _metaItem(Icons.restaurant_menu, '${recipe.servings} পরিবেশন'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _macroChip('প্রো: ${recipe.nutrition.proteinG.toStringAsFixed(0)}গ্রাম', const Color(0xFF56CCF2)),
                      _macroChip('কার্বস: ${recipe.nutrition.carbsG.toStringAsFixed(0)}গ্রাম', const Color(0xFFF2C94C)),
                      _macroChip('ফ্যাট: ${recipe.nutrition.fatG.toStringAsFixed(0)}গ্রাম', const Color(0xFF6FCF97)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade400)),
      ],
    );
  }

  Widget _macroChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
