import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_language.dart';
import 'locale_cubit.dart';

class AppStrings {
  AppStrings._();

  static const Map<String, Map<AppLanguage, String>> _dict = {
    // common
    'skip': {AppLanguage.bn: 'এড়িয়ে যান', AppLanguage.en: 'Skip'},
    'continue': {AppLanguage.bn: 'এগিয়ে যান', AppLanguage.en: 'Continue'},
    'back': {AppLanguage.bn: 'পেছনে', AppLanguage.en: 'Back'},
    'finish': {AppLanguage.bn: 'শেষ করুন', AppLanguage.en: 'Finish'},
    'get_started': {AppLanguage.bn: 'শুরু করুন', AppLanguage.en: 'Get Started'},

    // language step
    'select_language': {AppLanguage.bn: 'ভাষা নির্বাচন করুন', AppLanguage.en: 'Select Language'},
    'select_language_sub': {
      AppLanguage.bn: 'আপনার পছন্দের ভাষা বেছে নিন',
      AppLanguage.en: 'Choose your preferred language',
    },

    // welcome step
    'welcome_title': {AppLanguage.bn: 'আপনার প্ল্যান তৈরি করি', AppLanguage.en: "Let's build your plan"},
    'welcome_sub': {
      AppLanguage.bn: 'কয়েকটা ছোট প্রশ্নের উত্তর দিন — আপনার জন্য উপযুক্ত রেসিপি, ওয়ার্কআউট ও লক্ষ্য তৈরি করে দেব।',
      AppLanguage.en: "Answer a few quick questions — we'll tailor recipes, workouts and goals for you.",
    },

    // notification step
    'notify_title': {AppLanguage.bn: 'আপডেট পেতে চান?', AppLanguage.en: 'Stay in the loop?'},
    'notify_sub': {
      AppLanguage.bn: 'ওয়ার্কআউট রিমাইন্ডার ও প্রোগ্রেস আপডেট পাঠাতে অনুমতি দিন — যেকোনো সময় বন্ধ করতে পারবেন।',
      AppLanguage.en: "Allow reminders for workouts and progress updates — you can turn this off anytime.",
    },
    'allow': {AppLanguage.bn: 'অনুমতি দিন', AppLanguage.en: 'Allow'},
    'not_now': {AppLanguage.bn: 'এখন না', AppLanguage.en: 'Not now'},

    // goal step
    'goal_title': {AppLanguage.bn: 'আপনার মূল লক্ষ্য কী?', AppLanguage.en: 'What is your main goal?'},
    'goal_fat_loss': {AppLanguage.bn: 'ফ্যাট কমানো', AppLanguage.en: 'Lose Fat'},
    'goal_fat_loss_sub': {AppLanguage.bn: 'ক্যালরি বার্ন করে ওজন কমান', AppLanguage.en: 'Burn calories and lose weight'},
    'goal_muscle_gain': {AppLanguage.bn: 'মাসল বাড়ানো', AppLanguage.en: 'Gain Muscle'},
    'goal_muscle_gain_sub': {AppLanguage.bn: 'শক্তি ও লিন মাসল গড়ুন', AppLanguage.en: 'Build strength and lean muscle'},
    'goal_stay_fit': {AppLanguage.bn: 'ফিট থাকুন', AppLanguage.en: 'Stay Fit'},
    'goal_stay_fit_sub': {
      AppLanguage.bn: 'বর্তমান ওজন ও স্বাস্থ্য ধরে রাখুন',
      AppLanguage.en: 'Maintain your current weight and health',
    },

    // gender step
    'gender_title': {AppLanguage.bn: 'আপনার লিঙ্গ কী?', AppLanguage.en: 'What is your gender?'},
    'gender_sub': {
      AppLanguage.bn: 'মেটাবলিজম সঠিকভাবে হিসাব করতে এটা ব্যবহার করি।',
      AppLanguage.en: 'We use this to calculate your metabolism accurately.',
    },
    'male': {AppLanguage.bn: 'পুরুষ', AppLanguage.en: 'Male'},
    'female': {AppLanguage.bn: 'মহিলা', AppLanguage.en: 'Female'},

    // age/weight/target steps
    'age_title': {AppLanguage.bn: 'আপনার বয়স কত?', AppLanguage.en: 'How old are you?'},
    'years': {AppLanguage.bn: 'বছর', AppLanguage.en: 'years'},
    'height_title': {AppLanguage.bn: 'আপনার উচ্চতা কত?', AppLanguage.en: 'What is your height?'},
    'cm': {AppLanguage.bn: 'সেমি', AppLanguage.en: 'cm'},
    'ft_in': {AppLanguage.bn: 'ফুট / ইঞ্চি', AppLanguage.en: 'ft / in'},
    'feet': {AppLanguage.bn: 'ফুট', AppLanguage.en: 'feet'},
    'inches': {AppLanguage.bn: 'ইঞ্চি', AppLanguage.en: 'inches'},
    'weight_title': {AppLanguage.bn: 'আপনার বর্তমান ওজন কত?', AppLanguage.en: 'What is your current weight?'},
    'target_weight_title': {AppLanguage.bn: 'টার্গেট ওজন কত?', AppLanguage.en: 'What is your target weight?'},
    'target_weight_sub': {
      AppLanguage.bn: 'এই সংখ্যায় পৌঁছানোর জন্য প্ল্যান তৈরি করব।',
      AppLanguage.en: "We'll build a plan to help you reach this number.",
    },
    'kg': {AppLanguage.bn: 'কেজি', AppLanguage.en: 'kg'},

    // activity step
    'activity_title': {AppLanguage.bn: 'আপনি কতটা সক্রিয়?', AppLanguage.en: 'How active are you?'},
    'activity_sedentary': {AppLanguage.bn: 'নিষ্ক্রিয়', AppLanguage.en: 'Sedentary'},
    'activity_sedentary_sub': {AppLanguage.bn: 'কম বা কোনো ব্যায়াম নেই', AppLanguage.en: 'Little or no exercise'},
    'activity_light': {AppLanguage.bn: 'হালকা সক্রিয়', AppLanguage.en: 'Lightly Active'},
    'activity_light_sub': {AppLanguage.bn: 'সপ্তাহে ১-৩ দিন', AppLanguage.en: '1-3 days per week'},
    'activity_moderate': {AppLanguage.bn: 'মাঝারি সক্রিয়', AppLanguage.en: 'Moderately Active'},
    'activity_moderate_sub': {AppLanguage.bn: 'সপ্তাহে ৩-৫ দিন', AppLanguage.en: '3-5 days per week'},
    'activity_very': {AppLanguage.bn: 'অত্যন্ত সক্রিয়', AppLanguage.en: 'Very Active'},
    'activity_very_sub': {AppLanguage.bn: 'সপ্তাহে ৬-৭ দিন', AppLanguage.en: '6-7 days per week'},
    'activity_extreme': {AppLanguage.bn: 'চরম সক্রিয়', AppLanguage.en: 'Extremely Active'},
    'activity_extreme_sub': {
      AppLanguage.bn: 'দৈনিক কঠোর ব্যায়াম বা শারীরিক কাজ',
      AppLanguage.en: 'Daily intense exercise or physical job',
    },

    // dashboard / settings
    'welcome_back': {AppLanguage.bn: 'স্বাগতম 👋', AppLanguage.en: 'Welcome back 👋'},
    'your_dashboard': {AppLanguage.bn: 'আপনার হেলথ ড্যাশবোর্ড', AppLanguage.en: 'Your Health Dashboard'},
    'features': {AppLanguage.bn: 'ফিচারসমূহ', AppLanguage.en: 'Features'},
    'settings': {AppLanguage.bn: 'সেটিংস', AppLanguage.en: 'Settings'},
    'language': {AppLanguage.bn: 'ভাষা', AppLanguage.en: 'Language'},
    'theme': {AppLanguage.bn: 'থিম', AppLanguage.en: 'Theme'},
    'light_mode': {AppLanguage.bn: 'লাইট মোড', AppLanguage.en: 'Light Mode'},
    'dark_mode': {AppLanguage.bn: 'ডার্ক মোড', AppLanguage.en: 'Dark Mode'},

    // dashboard feature cards
    'feature_health_calculator': {AppLanguage.bn: 'স্বাস্থ্য ক্যালকুলেটর', AppLanguage.en: 'Health Calculator'},
    'feature_health_calculator_sub': {
      AppLanguage.bn: 'BMI, BMR ও আদর্শ ওজন হিসাব করুন',
      AppLanguage.en: 'Calculate BMI, BMR & ideal weight',
    },
    'feature_meal_planner': {AppLanguage.bn: 'খাবার পরিকল্পনাকারী', AppLanguage.en: 'Meal Planner'},
    'feature_meal_planner_sub': {
      AppLanguage.bn: 'রেসিপি খুঁজুন ও ডায়েট প্ল্যান দেখুন',
      AppLanguage.en: 'Find recipes and view diet plans',
    },
    'feature_exercise': {AppLanguage.bn: 'ব্যায়াম', AppLanguage.en: 'Exercise'},
    'feature_exercise_sub': {
      AppLanguage.bn: 'ওয়ার্কআউট প্রোগ্রাম ও লাইভ সেশন',
      AppLanguage.en: 'Workout programs & live sessions',
    },
    'feature_more': {AppLanguage.bn: 'আরও ফিচার', AppLanguage.en: 'More Features'},
    'feature_more_sub': {AppLanguage.bn: 'শীঘ্রই আসছে', AppLanguage.en: 'Coming soon'},
    'stat_calories': {AppLanguage.bn: 'আজকের ক্যালরি', AppLanguage.en: "Today's Calories"},
    'stat_water': {AppLanguage.bn: 'পানি (লিটার)', AppLanguage.en: 'Water (L)'},
    'stat_workout': {AppLanguage.bn: 'এই সপ্তাহে ওয়ার্কআউট', AppLanguage.en: 'Workouts this week'},
  };

  static String get(String key, AppLanguage language) {
    return _dict[key]?[language] ?? key;
  }
}

extension LocalizedContext on BuildContext {
  /// Ex: Text(context.tr('welcome_title'))
  String tr(String key) {
    final language = watch<LocaleCubit>().state;
    return AppStrings.get(key, language);
  }
}
