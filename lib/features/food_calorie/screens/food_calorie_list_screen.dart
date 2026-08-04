import 'package:flutter/material.dart';

import '../models/food_item_model.dart';
import '../repository/food_calorie_repository.dart';

class FoodCalorieListScreen extends StatefulWidget {
  final FoodCategory category;

  const FoodCalorieListScreen({super.key, required this.category});

  @override
  State<FoodCalorieListScreen> createState() => _FoodCalorieListScreenState();
}

class _FoodCalorieListScreenState extends State<FoodCalorieListScreen> {
  final _repository = FoodCalorieRepository();
  List<FoodItem>? _items;

  @override
  void initState() {
    super.initState();
    _repository.getItems(widget.category).then((items) {
      if (mounted) setState(() => _items = items);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = widget.category;

    return Scaffold(
      appBar: AppBar(title: Text(category.titleBn)),
      body: _items == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [category.color.withOpacity(0.25), category.color.withOpacity(0.06)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(category.icon, color: category.color, size: 28),
                      const SizedBox(height: 8),
                      Text(category.titleBn, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(category.subtitleBn,
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.55))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_items!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text('এই তালিকায় এখনো কোনো খাবার যোগ করা হয়নি', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                    ),
                  )
                else
                  ..._items!.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Icon(Icons.restaurant, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                Text(item.amountLabel, style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                              ],
                            ),
                          ),
                          Text(
                            '${item.caloriesLabel} kcal',
                            style: TextStyle(fontWeight: FontWeight.bold, color: category.color, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
