import 'package:flutter_test/flutter_test.dart';

import 'package:aplicacion/features/diet_generator/domain/usecases/diet_calculator.dart';

void main() {
  group('DietCalculator.calculateBmr (Mifflin-St Jeor)', () {
    test('male: 30yo, 80kg, 180cm', () {
      final bmr = DietCalculator.calculateBmr(
        sex: Sex.male,
        weightKg: 80,
        heightCm: 180,
        age: 30,
      );
      expect(bmr, closeTo(1780, 0.01));
    });

    test('female: 30yo, 60kg, 165cm', () {
      final bmr = DietCalculator.calculateBmr(
        sex: Sex.female,
        weightKg: 60,
        heightCm: 165,
        age: 30,
      );
      expect(bmr, closeTo(1320.25, 0.01));
    });
  });

  group('DietCalculator.calculateTdee', () {
    test('applies the activity multiplier to the BMR', () {
      final tdee = DietCalculator.calculateTdee(
        bmr: 1780,
        activityLevel: ActivityLevel.moderate,
      );
      expect(tdee, closeTo(1780 * 1.55, 0.01));
    });
  });

  group('DietCalculator.calculateMacros', () {
    test('lose_fat targets fewer calories than maintain for the same inputs', () {
      final maintain = DietCalculator.calculateMacros(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        sex: Sex.male,
        activityLevel: ActivityLevel.moderate,
        goal: DietGoal.maintain,
      );
      final loseFat = DietCalculator.calculateMacros(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        sex: Sex.male,
        activityLevel: ActivityLevel.moderate,
        goal: DietGoal.loseFat,
      );

      expect(loseFat.dailyCalories, lessThan(maintain.dailyCalories));
    });

    test('gain_muscle targets more calories than maintain for the same inputs', () {
      final maintain = DietCalculator.calculateMacros(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        sex: Sex.male,
        activityLevel: ActivityLevel.moderate,
        goal: DietGoal.maintain,
      );
      final gainMuscle = DietCalculator.calculateMacros(
        weightKg: 80,
        heightCm: 180,
        age: 30,
        sex: Sex.male,
        activityLevel: ActivityLevel.moderate,
        goal: DietGoal.gainMuscle,
      );

      expect(gainMuscle.dailyCalories, greaterThan(maintain.dailyCalories));
    });

    test('macro calories add up to (approximately) the daily calorie target', () {
      final result = DietCalculator.calculateMacros(
        weightKg: 70,
        heightCm: 170,
        age: 25,
        sex: Sex.female,
        activityLevel: ActivityLevel.active,
        goal: DietGoal.recomposition,
      );

      final macroCalories =
          result.proteinG * 4 + result.carbsG * 4 + result.fatG * 9;

      expect(macroCalories, closeTo(result.dailyCalories, 1));
    });

    test('never drops the calorie target below the 1200 kcal safety floor', () {
      final result = DietCalculator.calculateMacros(
        weightKg: 45,
        heightCm: 150,
        age: 60,
        sex: Sex.female,
        activityLevel: ActivityLevel.sedentary,
        goal: DietGoal.loseFat,
      );

      expect(result.dailyCalories, greaterThanOrEqualTo(1200));
    });
  });
}
