import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../../sleep/presentation/providers/sleep_provider.dart';
import '../../../water/presentation/providers/water_provider.dart';
import '../../../workouts/presentation/providers/workout_provider.dart';
import '../../data/datasources/goals_remote_datasource.dart';
import '../../data/repositories/goals_repository_impl.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goals_repository.dart';

final goalsRemoteDatasourceProvider = Provider<GoalsRemoteDatasource>((ref) {
  return GoalsRemoteDatasource(ref.watch(supabaseClientProvider));
});

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepositoryImpl(ref.watch(goalsRemoteDatasourceProvider));
});

final goalsProvider = FutureProvider.autoDispose<List<Goal>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(goalsRepositoryProvider).getGoals(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

/// Live completion ratio (0.0-1.0) for a goal, computed from the actual
/// tracked data of the relevant feature instead of a manually-updated
/// counter — e.g. a "4x/week" workout goal reflects real workout_logs.
final goalProgressProvider = Provider.family.autoDispose<double, Goal>((ref, goal) {
  switch (GoalType.fromDbValue(goal.type)) {
    case GoalType.workoutFrequency:
      final logs = ref.watch(workoutLogsProvider).valueOrNull ?? const [];
      final weekStart = AppDateUtils.startOfWeek(DateTime.now());
      final countThisWeek = logs
          .where((l) =>
              l.completedAt != null && !l.completedAt!.isBefore(weekStart))
          .length;
      return goal.targetValue <= 0 ? 0 : (countThisWeek / goal.targetValue).clamp(0, 1);

    case GoalType.water:
      final todayMl = ref.watch(todayWaterTotalProvider);
      final targetMl = goal.targetValue * 1000;
      return targetMl <= 0 ? 0 : (todayMl / targetMl).clamp(0, 1);

    case GoalType.sleep:
      final average = ref.watch(averageSleepHoursProvider);
      if (average == null || goal.targetValue <= 0) return 0;
      return (average / goal.targetValue).clamp(0, 1);

    case GoalType.weight:
      final measurements = ref.watch(bodyMeasurementHistoryProvider).valueOrNull ?? const [];
      final withWeight = measurements.where((m) => m.weightKg != null).toList();
      if (withWeight.isEmpty) return 0;
      final current = withWeight.last.weightKg!;
      final baseline = goal.currentValue;
      final target = goal.targetValue;
      if (baseline == target) return current == target ? 1 : 0;
      return ((baseline - current) / (baseline - target)).clamp(0, 1);

    case GoalType.custom:
      return goal.targetValue <= 0 ? 0 : (goal.currentValue / goal.targetValue).clamp(0, 1);
  }
});

class GoalsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> saveGoal(Goal goal) async {
    state = const AsyncLoading();
    final result = await ref.read(goalsRepositoryProvider).saveGoal(goal);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(goalsProvider);
        return null;
      },
    );
  }

  Future<String?> deleteGoal(String id) async {
    final result = await ref.read(goalsRepositoryProvider).deleteGoal(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(goalsProvider);
        return null;
      },
    );
  }
}

final goalsControllerProvider = AsyncNotifierProvider<GoalsController, void>(
  GoalsController.new,
);
