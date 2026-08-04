import 'package:flutter/material.dart';

enum FoodCategory { sugar, protein, fat, general }

extension FoodCategoryX on FoodCategory {
  String get titleBn {
    switch (this) {
      case FoodCategory.sugar:
        return 'শর্করা জাতীয় খাদ্যের তালিকা';
      case FoodCategory.protein:
        return 'প্রোটিন জাতীয় খাদ্যের তালিকা';
      case FoodCategory.fat:
        return 'চর্বি জাতীয় খাদ্যের তালিকা';
      case FoodCategory.general:
        return 'সাধারণ খাদ্যের ক্যালরি তালিকা';
    }
  }

  String get subtitleBn {
    switch (this) {
      case FoodCategory.sugar:
        return 'ভাত, রুটি, মিষ্টি ও অন্যান্য';
      case FoodCategory.protein:
        return 'মাংস, মাছ, ডিম ও ডেইরি পণ্য';
      case FoodCategory.fat:
        return 'তেল, ঘি, বাদাম ও ফাস্ট ফুড';
      case FoodCategory.general:
        return 'সাধারণ খাদ্য সামগ্রীর ক্যালরি তথ্য';
    }
  }

  IconData get icon {
    switch (this) {
      case FoodCategory.sugar:
        return Icons.bakery_dining;
      case FoodCategory.protein:
        return Icons.water_drop;
      case FoodCategory.fat:
        return Icons.set_meal;
      case FoodCategory.general:
        return Icons.restaurant;
    }
  }

  Color get color {
    switch (this) {
      case FoodCategory.sugar:
        return const Color(0xFFE0982A);
      case FoodCategory.protein:
        return const Color(0xFFC0392B);
      case FoodCategory.fat:
        return const Color(0xFFAE9421);
      case FoodCategory.general:
        return const Color(0xFF1FA98F);
    }
  }
}

class FoodItem {
  final String name;
  final String amountLabel;
  final String caloriesLabel; // string keeps range values like "243-290" possible

  const FoodItem({required this.name, required this.amountLabel, required this.caloriesLabel});
}
