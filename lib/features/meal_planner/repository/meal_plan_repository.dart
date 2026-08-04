import 'package:dartz/dartz.dart';

import '../models/recipe_model.dart';

abstract class MealPlanRepository {
  Future<Either<String, List<Recipe>>> getRecipes();
}

class MealPlanRepositoryImpl implements MealPlanRepository {
  // TODO: এখন mock data — পরে ApiClient দিয়ে server.greatclinic.org (বা থালার নিজস্ব API) থেকে fetch করবেন
  @override
  Future<Either<String, List<Recipe>>> getRecipes() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return Right(_mockRecipes);
    } catch (e) {
      return const Left('রেসিপি লোড করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।');
    }
  }

  static final List<Recipe> _mockRecipes = [
    Recipe(
      id: 'r1',
      title: 'অ্যাসপারাগাস সহ গ্রিল করা স্টেক',
      shortDescription: 'গ্রিল করা শাকসবজি সহ উচ্চ প্রোটিন রাতের খাবার',
      aboutDescription: 'গ্রিল করা শাকসবজি সহ উচ্চ প্রোটিন রাতের খাবার',
      howToCook:
          'এই রেস্তোরাঁ-মানের কেটো খাবার নরম অ্যাসপারাগাস সহ নিখুঁতভাবে গ্রিল করা স্টেক বৈশিষ্ট্য করে। '
          'রান্নার ৩০ মিনিট আগে আপনার স্টেক রেফ্রিজারেটর থেকে সরিয়ে কক্ষ তাপমাত্রায় আনতে শুরু করুন — এটি সমান রান্না নিশ্চিত করে। '
          'কাগজের তোয়ালে দিয়ে স্টেক সম্পূর্ণভাবে শুকিয়ে নিন এবং উভয় দিকে মোটা লবণ ও তাজা গ্রাউন্ড কালো মরিচ দিয়ে উদারভাবে মশলা দিন। '
          'গ্রিল বা গ্রিল প্যান উচ্চ তাপে (প্রায় ৪৫০-৫০০°F) গরম করুন। প্রথম দিকে ৪-৫ মিনিট গ্রিল করুন, ফ্লিপ করুন এবং মিডিয়াম-রেয়ার '
          '(১৩০-১৩৫°F অভ্যন্তরীণ তাপমাত্রা) এর জন্য আরও ৩-৪ মিনিট রান্না করুন। রান্নার শেষ ৫ মিনিটে অ্যাসপারাগাস গ্রিলে রাখুন।',
      prepTimeMinutes: 25,
      cookTimeMinutes: 15,
      servings: 2,
      nutrition: const NutritionInfo(calories: 520, proteinG: 48, carbsG: 6, fatG: 34),
      difficulty: DifficultyLevel.medium,
      mealType: MealType.dinner,
      tags: const ['ketogenic', 'low-carb', 'high-protein', 'gourmet'],
      ingredients: const [
        '২টি স্টেক (মোট ৪০০ গ্রাম)',
        '১ গুচ্ছ অ্যাসপারাগাস (৩০০ গ্রাম)',
        '২ টেবিল চামচ অলিভ তেল (২৮ মিলি)',
        '২ কোয়া রসুন (৬ গ্রাম)',
        'তাজা রোজমেরি (৫ গ্রাম)',
        'স্বাদমতো লবণ এবং গোলমরিচ',
        'ঐচ্ছিক: ২ টেবিল চামচ কম্পাউন্ড মাখন (২৮ গ্রাম)',
      ],
      instructions: const [
        'স্টেক ঘর তাপমাত্রায় আনুন',
        'লবণ, গোলমরিচ, রসুন এবং রোজমেরি দিয়ে উদারভাবে মশলা দিন',
        'অলিভ তেল দিয়ে অ্যাসপারাগাস প্রস্তুত করুন',
        'গ্রিল উচ্চ তাপে গরম করুন',
        'স্টেক প্রতি পাশে ৪-৫ মিনিট গ্রিল করুন',
        'অ্যাসপারাগাস ৪-৫ মিনিট গ্রিল করুন',
        'স্টেক ৫-১০ মিনিট বিশ্রাম দিন',
        'কেটে পরিবেশন করুন',
      ],
    ),
    Recipe(
      id: 'r2',
      title: 'ওটস ও ফলের বাটি',
      shortDescription: 'দ্রুত ও পুষ্টিকর সকালের নাস্তা',
      aboutDescription: 'ফাইবার ও পুষ্টিতে ভরপুর একটি সহজ সকালের নাস্তা',
      howToCook: 'ওটস দুধ বা পানিতে সিদ্ধ করে ওপরে তাজা ফল ও বাদাম দিয়ে পরিবেশন করুন।',
      prepTimeMinutes: 5,
      cookTimeMinutes: 10,
      servings: 1,
      nutrition: const NutritionInfo(calories: 320, proteinG: 12, carbsG: 45, fatG: 8),
      difficulty: DifficultyLevel.easy,
      mealType: MealType.breakfast,
      tags: const ['vegetarian', 'high-fiber', 'quick'],
      ingredients: const [
        '১ কাপ ওটস',
        '১ কাপ দুধ',
        '১টি কলা',
        'মধু (স্বাদমতো)',
        'বাদাম কুচি',
      ],
      instructions: const [
        'ওটস দুধে ভিজিয়ে রাখুন',
        'মাঝারি আঁচে ৫-৭ মিনিট সিদ্ধ করুন',
        'কলা কেটে ওপরে দিন',
        'মধু ও বাদাম কুচি ছিটিয়ে পরিবেশন করুন',
      ],
    ),
    Recipe(
      id: 'r3',
      title: 'গ্রিলড চিকেন সালাদ',
      shortDescription: 'হালকা অথচ প্রোটিন সমৃদ্ধ দুপুরের খাবার',
      aboutDescription: 'কম ক্যালরি, উচ্চ প্রোটিন সালাদ — ওজন কমাতে আদর্শ',
      howToCook: 'চিকেন ম্যারিনেট করে গ্রিল করুন, এরপর তাজা সবজির সাথে মিশিয়ে ড্রেসিং দিয়ে পরিবেশন করুন।',
      prepTimeMinutes: 15,
      cookTimeMinutes: 12,
      servings: 2,
      nutrition: const NutritionInfo(calories: 410, proteinG: 38, carbsG: 18, fatG: 20),
      difficulty: DifficultyLevel.medium,
      mealType: MealType.lunch,
      tags: const ['high-protein', 'low-carb'],
      ingredients: const [
        '২টি চিকেন ব্রেস্ট (৩০০ গ্রাম)',
        'লেটুস পাতা',
        'শসা ও টমেটো',
        'অলিভ অয়েল ড্রেসিং',
      ],
      instructions: const [
        'চিকেন লবণ-মরিচ দিয়ে ম্যারিনেট করুন',
        'গ্রিলে ৬ মিনিট প্রতি পাশে রান্না করুন',
        'সবজি কেটে বাটিতে রাখুন',
        'চিকেন কেটে ওপরে দিন ও ড্রেসিং ছিটিয়ে দিন',
      ],
    ),
  ];
}
