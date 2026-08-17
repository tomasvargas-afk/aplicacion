import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/ai_diet_datasource.dart';
import '../../data/datasources/diet_plan_remote_datasource.dart';
import '../../data/repositories/diet_plan_repository_impl.dart';
import '../../domain/entities/diet_plan.dart';
import '../../domain/entities/diet_plan_meal.dart';
import '../../domain/repositories/diet_plan_repository.dart';
import '../../domain/usecases/diet_calculator.dart';
import '../../domain/usecases/generate_sample_menu.dart';

final aiDietDatasourceProvider = Provider<AiDietDatasource>((ref) {
  return AiDietDatasource(ref.watch(supabaseClientProvider));
});

final dietPlanRemoteDatasourceProvider =
    Provider<DietPlanRemoteDatasource>((ref) {
  return DietPlanRemoteDatasource(ref.watch(supabaseClientProvider));
});

final dietPlanRepositoryProvider = Provider<DietPlanRepository>((ref) {
  return DietPlanRepositoryImpl(ref.watch(dietPlanRemoteDatasourceProvider));
});

final dietPlanHistoryProvider =
    FutureProvider.autoDispose<List<DietPlan>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result =
      await ref.watch(dietPlanRepositoryProvider).getHistory(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

/// Holds the most recently generated (not-yet-necessarily-saved) plan so
/// the result screen can display it and, on confirm, persist it.
class DietGeneratorController extends AsyncNotifier<DietPlan?> {
  @override
  DietPlan? build() => null;

  Future<void> generate({
    required double weightKg,
    required double heightCm,
    required int age,
    required Sex sex,
    required ActivityLevel activityLevel,
    required DietGoal goal,
  }) async {
    state = const AsyncLoading();

    final macros = DietCalculator.calculateMacros(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
      activityLevel: activityLevel,
      goal: goal,
    );

    List<DietPlanMeal> meals;
    try {
      meals = await ref
          .read(aiDietDatasourceProvider)
          .generateMenu(macros: macros, goal: goal);
    } catch (_) {
      // AI generation failed (rate limit, network, etc.) — fall back to the
      // static rule-based menu so the user still gets a usable plan.
      meals = GenerateSampleMenu.generate(macros: macros, goal: goal);
    }

    final user = ref.read(currentUserProvider);

    state = AsyncData(DietPlan(
      userId: user?.id ?? '',
      formulaUsed: 'mifflin_st_jeor',
      bmr: macros.bmr,
      tdee: macros.tdee,
      dailyCalories: macros.dailyCalories,
      proteinG: macros.proteinG,
      carbsG: macros.carbsG,
      fatG: macros.fatG,
      activityLevel: activityLevel.dbValue,
      goal: goal.dbValue,
      meals: meals,
    ));
  }

  Future<String?> savePlan() async {
    final plan = state.valueOrNull;
    if (plan == null) return 'No hay un plan generado';
    state = const AsyncLoading();
    final result = await ref.read(dietPlanRepositoryProvider).savePlan(plan);
    return result.match(
      (failure) {
        state = AsyncData(plan);
        return failure.displayMessage;
      },
      (saved) {
        state = AsyncData(saved);
        ref.invalidate(dietPlanHistoryProvider);
        return null;
      },
    );
  }

  void clear() => state = const AsyncData(null);
}

final dietGeneratorControllerProvider =
    AsyncNotifierProvider<DietGeneratorController, DietPlan?>(
  DietGeneratorController.new,
);
