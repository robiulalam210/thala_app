import '../models/food_item_model.dart';

class FoodCalorieRepository {
  Future<List<FoodItem>> getItems(FoodCategory category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _data[category] ?? const [];
  }

  static const Map<FoodCategory, List<FoodItem>> _data = {
    FoodCategory.fat: [
      FoodItem(name: 'কাঠ বাদাম', amountLabel: '১ মুঠো', caloriesLabel: '১৬৮'),
      FoodItem(name: 'পেস্তা বাদাম', amountLabel: '১ মুঠো', caloriesLabel: '১৮৮'),
      FoodItem(name: 'কাজু বাদাম', amountLabel: '১ মুঠো', caloriesLabel: '১৭৮'),
      FoodItem(name: 'চিনা বাদাম', amountLabel: '১ মুঠো', caloriesLabel: '১৭০'),
      FoodItem(name: 'পরোটা (তেলে ভাজা)', amountLabel: '১টি', caloriesLabel: '২৪৩-২৯০'),
      FoodItem(name: 'আলু পরোটা', amountLabel: '১টি', caloriesLabel: '৩০০'),
      FoodItem(name: 'লুচি', amountLabel: '১টি', caloriesLabel: '১৪০'),
      FoodItem(name: 'নান রুটি (মাখন সহ)', amountLabel: '১টি', caloriesLabel: '৪২৪'),
      FoodItem(name: 'সয়াবিন তেল', amountLabel: '১ টেবিল চামচ', caloriesLabel: '১২০'),
      FoodItem(name: 'ঘি', amountLabel: '১ টেবিল চামচ', caloriesLabel: '১৩৫'),
    ],
    FoodCategory.sugar: [
      FoodItem(name: 'সাদা ভাত', amountLabel: '১ কাপ', caloriesLabel: '২০৫'),
      FoodItem(name: 'গমের রুটি', amountLabel: '১টি', caloriesLabel: '৭১'),
      FoodItem(name: 'সাদা রুটি (পাউরুটি)', amountLabel: '১ স্লাইস', caloriesLabel: '৭৯'),
      FoodItem(name: 'মিষ্টি (রসগোল্লা)', amountLabel: '১টি', caloriesLabel: '১৮৬'),
      FoodItem(name: 'চিনি', amountLabel: '১ চা চামচ', caloriesLabel: '১৬'),
      FoodItem(name: 'মধু', amountLabel: '১ টেবিল চামচ', caloriesLabel: '৬৪'),
      FoodItem(name: 'কলা', amountLabel: '১টি মাঝারি', caloriesLabel: '১০৫'),
      FoodItem(name: 'আম', amountLabel: '১ কাপ কুচি', caloriesLabel: '৯৯'),
    ],
    FoodCategory.protein: [
      FoodItem(name: 'মুরগির মাংস (রান্না)', amountLabel: '১০০ গ্রাম', caloriesLabel: '২৩৯'),
      FoodItem(name: 'গরুর মাংস (রান্না)', amountLabel: '১০০ গ্রাম', caloriesLabel: '২৫০'),
      FoodItem(name: 'ইলিশ মাছ', amountLabel: '১০০ গ্রাম', caloriesLabel: '৩১০'),
      FoodItem(name: 'রুই মাছ', amountLabel: '১০০ গ্রাম', caloriesLabel: '৯৭'),
      FoodItem(name: 'ডিম (সিদ্ধ)', amountLabel: '১টি', caloriesLabel: '৭৮'),
      FoodItem(name: 'দুধ', amountLabel: '১ কাপ', caloriesLabel: '১৪৯'),
      FoodItem(name: 'দই', amountLabel: '১ কাপ', caloriesLabel: '১৫০'),
      FoodItem(name: 'পনির', amountLabel: '১০০ গ্রাম', caloriesLabel: '২৬৫'),
    ],
    FoodCategory.general: [
      FoodItem(name: 'ভাত', amountLabel: '১০০ গ্রাম', caloriesLabel: '৩৪৬'),
      FoodItem(name: 'গমের রুটি', amountLabel: '১০০ গ্রাম', caloriesLabel: '৩৪১'),
      FoodItem(name: 'ছোলা', amountLabel: '১০০ গ্রাম', caloriesLabel: '৩৬০'),
      FoodItem(name: 'মসুর ডাল', amountLabel: '১০০ গ্রাম', caloriesLabel: '৩৪৩'),
      FoodItem(name: 'গাঁজর', amountLabel: '১০০ গ্রাম', caloriesLabel: '৪৮'),
      FoodItem(name: 'গোল আলু', amountLabel: '১০০ গ্রাম', caloriesLabel: '৯৭'),
      FoodItem(name: 'কলমিশাক', amountLabel: '১০০ গ্রাম', caloriesLabel: '২৮'),
      FoodItem(name: 'পুঁইশাক', amountLabel: '১০০ গ্রাম', caloriesLabel: '২৬'),
    ],
  };
}
