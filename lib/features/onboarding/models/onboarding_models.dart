enum Goal { fatLoss, muscleGain, stayFit }

enum Gender { male, female }

enum ActivityLevel { sedentary, light, moderate, veryActive, extreme }

extension ActivityLevelFactorX on ActivityLevel {
  double get factor {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extreme:
        return 1.9;
    }
  }
}

/// Onboarding-e collect kora shob data — finish korle ei object DB/local storage e save hoy,
/// ar dashboard/health-calculator ei profile theke pre-fill hote pare.
class OnboardingProfile {
  final Goal? goal;
  final Gender gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final ActivityLevel? activityLevel;

  const OnboardingProfile({
    this.goal,
    this.gender = Gender.male,
    this.age = 25,
    this.heightCm = 170,
    this.weightKg = 65,
    this.targetWeightKg = 61,
    this.activityLevel,
  });

  OnboardingProfile copyWith({
    Goal? goal,
    Gender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    ActivityLevel? activityLevel,
  }) {
    return OnboardingProfile(
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  Map<String, dynamic> toJson() => {
        'goal': goal?.name,
        'gender': gender.name,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'targetWeightKg': targetWeightKg,
        'activityLevel': activityLevel?.name,
      };

  factory OnboardingProfile.fromJson(Map<String, dynamic> json) {
    return OnboardingProfile(
      goal: Goal.values.where((g) => g.name == json['goal']).firstOrNull,
      gender: Gender.values.firstWhere((g) => g.name == json['gender'], orElse: () => Gender.male),
      age: (json['age'] as num?)?.toInt() ?? 25,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 170,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 65,
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 61,
      activityLevel: ActivityLevel.values.where((a) => a.name == json['activityLevel']).firstOrNull,
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
