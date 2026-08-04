import 'package:flutter/material.dart';

import '../models/food_item_model.dart';
import 'food_calorie_list_screen.dart';

class FoodCalorieHomeScreen extends StatelessWidget {
  const FoodCalorieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('খাদ্যের ক্যালরি তালিকা')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary.withOpacity(0.25), theme.colorScheme.primary.withOpacity(0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Icon(Icons.restaurant, size: 34, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                const Text('খাদ্যের ধরণ নির্বাচন করুন',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(
                  'বিভিন্ন খাদ্যের ক্যালরি সম্পর্কে জানুন',
                  style: TextStyle(fontSize: 12.5, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...FoodCategory.values.map((category) => _CategoryCard(category: category)),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final FoodCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => FoodCalorieListScreen(category: category)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: category.color.withOpacity(0.18), borderRadius: BorderRadius.circular(14)),
              child: Icon(category.icon, color: category.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.titleBn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
                  const SizedBox(height: 3),
                  Text(category.subtitleBn,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.55))),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: category.color),
          ],
        ),
      ),
    );
  }
}
