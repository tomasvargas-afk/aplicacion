import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/nutrition_remote_datasource.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../domain/entities/meal_log.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/nutrition_repository.dart';

final nutritionRemoteDatasourceProvider = Provider<NutritionRemoteDatasource>((ref) {
  return NutritionRemoteDatasource(ref.watch(supabaseClientProvider));
});

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return NutritionRepositoryImpl(ref.watch(nutritionRemoteDatasourceProvider));
});

final recipesProvider = FutureProvider.autoDispose<List<Recipe>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(nutritionRepositoryProvider).getRecipes(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

final todayMealLogsProvider = FutureProvider.autoDispose<List<MealLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(nutritionRepositoryProvider).getMealLogs(user.id, days: 1);
  final logs = result.match((failure) => throw failure, (list) => list);
  final today = DateTime.now();
  return logs.where((l) => l.loggedAt != null && AppDateUtils.isSameDay(l.loggedAt!, today))
      .toList();
});

class NutritionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> saveRecipe(Recipe recipe) async {
    state = const AsyncLoading();
    final result = await ref.read(nutritionRepositoryProvider).saveRecipe(recipe);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(recipesProvider);
        return null;
      },
    );
  }

  Future<String?> deleteRecipe(String id) async {
    final result = await ref.read(nutritionRepositoryProvider).deleteRecipe(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(recipesProvider);
        return null;
      },
    );
  }

  Future<String?> logMeal(MealLog log) async {
    state = const AsyncLoading();
    final result = await ref.read(nutritionRepositoryProvider).logMeal(log);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(todayMealLogsProvider);
        return null;
      },
    );
  }

  Future<String?> deleteMealLog(String id) async {
    final result = await ref.read(nutritionRepositoryProvider).deleteMealLog(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(todayMealLogsProvider);
        return null;
      },
    );
  }
}

final nutritionControllerProvider = AsyncNotifierProvider<NutritionController, void>(
  NutritionController.new,
);
