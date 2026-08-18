import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/diet_generator/domain/usecases/diet_calculator.dart';

/// Answers collected during the questionnaire-style onboarding, held only
/// in memory for the duration of the onboarding → register flow. Once the
/// account is created, [RegisterScreen] uses these to pre-fill the
/// profile and save the first body-weight entry — nothing is persisted
/// before there's an account to attach it to.
class OnboardingAnswers {
  const OnboardingAnswers({
    this.goal,
    this.sex,
    this.age,
    this.weightKg,
    this.heightCm,
    this.activityLevel,
  });

  final DietGoal? goal;
  final Sex? sex;
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final ActivityLevel? activityLevel;

  bool get isComplete =>
      goal != null &&
      sex != null &&
      age != null &&
      weightKg != null &&
      heightCm != null &&
      activityLevel != null;

  MacroResult? get macros {
    if (!isComplete) return null;
    return DietCalculator.calculateMacros(
      weightKg: weightKg!,
      heightCm: heightCm!,
      age: age!,
      sex: sex!,
      activityLevel: activityLevel!,
      goal: goal!,
    );
  }

  OnboardingAnswers copyWith({
    DietGoal? goal,
    Sex? sex,
    int? age,
    double? weightKg,
    double? heightCm,
    ActivityLevel? activityLevel,
  }) {
    return OnboardingAnswers(
      goal: goal ?? this.goal,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}

class OnboardingAnswersNotifier extends Notifier<OnboardingAnswers> {
  @override
  OnboardingAnswers build() => const OnboardingAnswers();

  void update(
    OnboardingAnswers Function(OnboardingAnswers current) updater,
  ) {
    state = updater(state);
  }

  void clear() => state = const OnboardingAnswers();
}

final onboardingAnswersProvider =
    NotifierProvider<OnboardingAnswersNotifier, OnboardingAnswers>(
  OnboardingAnswersNotifier.new,
);
