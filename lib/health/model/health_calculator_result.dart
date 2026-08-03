
import 'health_calculator_input.dart';

enum BmiCategory {
  underweight, // কম ওজন <20
  normal, // স্বাভাবিক 20-25
  overweight, // অতিরিক্ত ওজন 25-30
  obese, // স্থূলতা 30-40
  severelyObese, // মারাত্মক স্থূলতা >40
}

extension BmiCategoryX on BmiCategory {
  String get labelBn {
    switch (this) {
      case BmiCategory.underweight:
        return 'কম ওজন';
      case BmiCategory.normal:
        return 'স্বাভাবিক';
      case BmiCategory.overweight:
        return 'অতিরিক্ত ওজন';
      case BmiCategory.obese:
        return 'স্থূলতা';
      case BmiCategory.severelyObese:
        return 'মারাত্মক স্থূলতা';
    }
  }

  String get adviceBn {
    switch (this) {
      case BmiCategory.underweight:
        return 'আপনার ওজন স্বাভাবিকের চেয়ে কম। পুষ্টিকর খাবার বেশি করে খান।';
      case BmiCategory.normal:
        return 'আপনার ওজন স্বাস্থ্যকর পরিসরে আছে। এভাবেই বজায় রাখুন।';
      case BmiCategory.overweight:
        return 'আপনার আরও বেশি শারীরিক পরিশ্রম করা উচিত এবং ক্যালরি গ্রহণ কমানো উচিত।';
      case BmiCategory.obese:
        return 'আপনার ওজন কমানোর জন্য একজন পুষ্টিবিদের পরামর্শ নেওয়া উচিত।';
      case BmiCategory.severelyObese:
        return 'অবিলম্বে একজন চিকিৎসকের পরামর্শ নেওয়া জরুরি।';
    }
  }
}

class HealthCalculatorResult {
  final double bmi;
  final BmiCategory bmiCategory;
  final double bmr;
  final Map<ActivityLevel, double> tdeeByActivity;
  final double idealWeightKg;
  final double idealWeightMinKg;
  final double idealWeightMaxKg;

  const HealthCalculatorResult({
    required this.bmi,
    required this.bmiCategory,
    required this.bmr,
    required this.tdeeByActivity,
    required this.idealWeightKg,
    required this.idealWeightMinKg,
    required this.idealWeightMaxKg,
  });
}