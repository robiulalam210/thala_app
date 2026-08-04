enum Gender { male, female }

enum ActivityLevel {
  sedentary, // কম পরিশ্রম
  light, // হালকা পরিশ্রম
  moderate, // মাঝারি পরিশ্রম
  active, // বেশি পরিশ্রম
  veryActive, // অত্যধিক পরিশ্রম
}

extension ActivityLevelX on ActivityLevel {
  double get factor {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.active:
        return 1.725;
      case ActivityLevel.veryActive:
        return 1.9;
    }
  }

  String get labelBn {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'কম পরিশ্রম';
      case ActivityLevel.light:
        return 'হালকা পরিশ্রম';
      case ActivityLevel.moderate:
        return 'মাঝারি পরিশ্রম';
      case ActivityLevel.active:
        return 'বেশি পরিশ্রম';
      case ActivityLevel.veryActive:
        return 'অত্যধিক পরিশ্রম';
    }
  }
}

class HealthCalculatorInput {
  final int age;
  final int heightFeet;
  final double heightInches;
  final double weightKg;
  final Gender gender;

  const HealthCalculatorInput({
    required this.age,
    required this.heightFeet,
    required this.heightInches,
    required this.weightKg,
    required this.gender,
  });

  /// ফুট + ইঞ্চি কে সেন্টিমিটারে কনভার্ট করে
  double get heightCm => (heightFeet * 12 + heightInches) * 2.54;

  double get heightM => heightCm / 100;

  String? validate() {
    if (age <= 0 || age > 120) return 'বয়স সঠিকভাবে দিন';
    if (heightFeet <= 0 || heightFeet > 8) return 'উচ্চতা (ফুট) সঠিকভাবে দিন';
    if (heightInches < 0 || heightInches >= 12) {
      return 'ইঞ্চি ০-১১.৯ এর মধ্যে হতে হবে';
    }
    if (weightKg <= 0 || weightKg > 400) return 'ওজন সঠিকভাবে দিন';
    return null;
  }
}
