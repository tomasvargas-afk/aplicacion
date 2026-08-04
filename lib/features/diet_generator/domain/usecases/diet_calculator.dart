/// Pure, dependency-free diet math — kept separate from Supabase/Riverpod so
/// it can be unit tested directly (see `test/features/diet_generator`).
library;

enum ActivityLevel {
  sedentary('sedentary', 1.2, 'Sedentario (poco o nada de ejercicio)'),
  light('light', 1.375, 'Ligero (1-3 días/semana)'),
  moderate('moderate', 1.55, 'Moderado (3-5 días/semana)'),
  active('active', 1.725, 'Activo (6-7 días/semana)'),
  veryActive('very_active', 1.9, 'Muy activo (2 veces al día / trabajo físico)');

  const ActivityLevel(this.dbValue, this.multiplier, this.label);

  final String dbValue;
  final double multiplier;
  final String label;
}

enum DietGoal {
  loseFat('lose_fat', 'Bajar grasa'),
  maintain('maintain', 'Mantener peso'),
  gainMuscle('gain_muscle', 'Ganar músculo'),
  recomposition('recomposition', 'Recomposición corporal');

  const DietGoal(this.dbValue, this.label);

  final String dbValue;
  final String label;
}

class MacroResult {
  const MacroResult({
    required this.bmr,
    required this.tdee,
    required this.dailyCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final double bmr;
  final double tdee;
  final double dailyCalories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

enum Sex { male, female }

abstract class DietCalculator {
  DietCalculator._();

  /// Mifflin-St Jeor equation.
  static double calculateBmr({
    required Sex sex,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return sex == Sex.male ? base + 5 : base - 161;
  }

  static double calculateTdee({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    return bmr * activityLevel.multiplier;
  }

  static MacroResult calculateMacros({
    required double weightKg,
    required double heightCm,
    required int age,
    required Sex sex,
    required ActivityLevel activityLevel,
    required DietGoal goal,
  }) {
    final bmr = calculateBmr(sex: sex, weightKg: weightKg, heightCm: heightCm, age: age);
    final tdee = calculateTdee(bmr: bmr, activityLevel: activityLevel);

    final dailyCalories = switch (goal) {
      DietGoal.loseFat => tdee - 500,
      DietGoal.maintain => tdee,
      DietGoal.gainMuscle => tdee + 300,
      DietGoal.recomposition => tdee,
    };
    final safeCalories = dailyCalories < 1200 ? 1200.0 : dailyCalories;

    final proteinPerKg = switch (goal) {
      DietGoal.loseFat => 2.2,
      DietGoal.maintain => 1.8,
      DietGoal.gainMuscle => 2.0,
      DietGoal.recomposition => 2.2,
    };
    final proteinG = weightKg * proteinPerKg;
    final proteinCalories = proteinG * 4;

    const fatFraction = 0.25;
    final fatCalories = safeCalories * fatFraction;
    final fatG = fatCalories / 9;

    final remainingCalories = (safeCalories - proteinCalories - fatCalories)
        .clamp(0, double.infinity);
    final carbsG = remainingCalories / 4;

    return MacroResult(
      bmr: bmr,
      tdee: tdee,
      dailyCalories: safeCalories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
  }
}
