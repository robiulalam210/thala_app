
import 'package:dartz/dartz.dart';

import '../model/health_calculator_input.dart';
import '../model/health_calculator_result.dart';


abstract class HealthCalculatorRepository {
  Either<String, HealthCalculatorResult> calculate(HealthCalculatorInput input);
}

class HealthCalculatorRepositoryImpl implements HealthCalculatorRepository {
  @override
  Either<String, HealthCalculatorResult> calculate(HealthCalculatorInput input) {
    final validationError = input.validate();
    if (validationError != null) {
      return Left(validationError);
    }

    try {
      final heightM = input.heightM;
      final heightCm = input.heightCm;

      // BMI = weight(kg) / height(m)^2
      final bmi = input.weightKg / (heightM * heightM);
      final bmiCategory = _categorizeBmi(bmi);

      // BMR — Mifflin-St Jeor equation
      final bmr = _calculateBmr(
        weightKg: input.weightKg,
        heightCm: heightCm,
        age: input.age,
        gender: input.gender,
      );

      // সব কয়টা অ্যাক্টিভিটি লেভেলের জন্য TDEE
      final tdeeByActivity = <ActivityLevel, double>{
        for (final level in ActivityLevel.values) level: bmr * level.factor,
      };

      // আদর্শ ওজন — BMI 20-25 রেঞ্জের ওপর ভিত্তি করে
      final idealWeightMin = 20 * heightM * heightM;
      final idealWeightMax = 25 * heightM * heightM;
      final idealWeight = (idealWeightMin + idealWeightMax) / 2;

      return Right(
        HealthCalculatorResult(
          bmi: _round2(bmi),
          bmiCategory: bmiCategory,
          bmr: _round2(bmr),
          tdeeByActivity: tdeeByActivity.map(
                (key, value) => MapEntry(key, _round2(value)),
          ),
          idealWeightKg: _round2(idealWeight),
          idealWeightMinKg: _round2(idealWeightMin),
          idealWeightMaxKg: _round2(idealWeightMax),
        ),
      );
    } catch (e) {
      return const Left('গণনা করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।');
    }
  }

  double _calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return gender == Gender.male ? base + 5 : base - 161;
  }

  BmiCategory _categorizeBmi(double bmi) {
    if (bmi < 20) return BmiCategory.underweight;
    if (bmi < 25) return BmiCategory.normal;
    if (bmi < 30) return BmiCategory.overweight;
    if (bmi < 40) return BmiCategory.obese;
    return BmiCategory.severelyObese;
  }

  double _round2(double value) => (value * 100).roundToDouble() / 100;
}