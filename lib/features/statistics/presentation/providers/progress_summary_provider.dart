import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../../water/presentation/providers/water_provider.dart';
import '../../../workouts/domain/entities/workout_log.dart';
import '../../../workouts/presentation/providers/workout_provider.dart';

class ProgressSummary {
  const ProgressSummary({
    required this.daysTrained,
    required this.currentStreak,
    required this.completedWorkouts,
    required this.totalMinutesTrained,
    required this.weightChangeKg,
    required this.waterTodayMl,
    required this.caloriesTodayKcal,
  });

  final int daysTrained;
  final int currentStreak;
  final int completedWorkouts;
  final int totalMinutesTrained;
  final double? weightChangeKg;
  final int waterTodayMl;
  final double caloriesTodayKcal;
}

/// Today's total calories from `meal_logs`. Reads the table directly since
/// the full nutrition/meal-logging feature isn't built yet — this starts
/// reporting real numbers automatically once it is.
final todayCaloriesProvider = FutureProvider.autoDispose<double>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return 0;
  final client = ref.watch(supabaseClientProvider);
  final startOfDay = AppDateUtils.dateOnly(DateTime.now());
  try {
    final rows = await client
        .from(SupabaseTables.mealLogs)
        .select('calories')
        .eq('user_id', user.id)
        .gte('logged_at', startOfDay.toIso8601String());
    return rows.fold<double>(0, (sum, row) => sum + (row['calories'] as num? ?? 0));
  } catch (_) {
    return 0;
  }
});

/// Daily calorie totals for the last [days] days from `meal_logs`, keyed
/// by day (date-only). Powers the calories trend chart on the stats
/// screen — same "reads the table directly" caveat as [todayCaloriesProvider].
final recentCaloriesProvider =
    FutureProvider.autoDispose.family<Map<DateTime, double>, int>((ref, days) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return {};
  final client = ref.watch(supabaseClientProvider);
  final since = AppDateUtils.dateOnly(DateTime.now().subtract(Duration(days: days - 1)));
  try {
    final rows = await client
        .from(SupabaseTables.mealLogs)
        .select('calories, logged_at')
        .eq('user_id', user.id)
        .gte('logged_at', since.toIso8601String());

    final totals = <DateTime, double>{};
    for (final row in rows) {
      final loggedAt = DateTime.parse(row['logged_at'] as String);
      final day = AppDateUtils.dateOnly(loggedAt);
      totals[day] = (totals[day] ?? 0) + (row['calories'] as num? ?? 0);
    }
    return totals;
  } catch (_) {
    return {};
  }
});

/// Consecutive-day training streak, shared by the stats screen and by the
/// "streak milestone" celebration notification fired after logging a
/// workout (see `WorkoutController.logCompletion`).
int calculateStreak(List<WorkoutLog> logs) {
  final trainedDays = logs
      .where((l) => l.completedAt != null)
      .map((l) => AppDateUtils.dateOnly(l.completedAt!))
      .toSet();

  var streak = 0;
  final today = AppDateUtils.dateOnly(DateTime.now());
  var cursor = trainedDays.contains(today)
      ? today
      : today.subtract(const Duration(days: 1));
  while (trainedDays.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

final progressSummaryProvider = Provider.autoDispose<AsyncValue<ProgressSummary>>((ref) {
  final logsAsync = ref.watch(workoutLogsProvider);
  final measurementsAsync = ref.watch(bodyMeasurementHistoryProvider);
  final caloriesAsync = ref.watch(todayCaloriesProvider);
  final waterToday = ref.watch(todayWaterTotalProvider);

  if (logsAsync.isLoading || measurementsAsync.isLoading || caloriesAsync.isLoading) {
    return const AsyncLoading();
  }
  final error = logsAsync.error ?? measurementsAsync.error ?? caloriesAsync.error;
  if (error != null) return AsyncError(error, StackTrace.current);

  final logs = logsAsync.valueOrNull ?? const [];
  final measurements = measurementsAsync.valueOrNull ?? const [];
  final calories = caloriesAsync.valueOrNull ?? 0;

  final trainedDays = logs
      .where((l) => l.completedAt != null)
      .map((l) => AppDateUtils.dateOnly(l.completedAt!))
      .toSet();
  final streak = calculateStreak(logs);

  final totalMinutes = logs.fold<int>(0, (sum, l) => sum + (l.durationMinutes ?? 0));

  final weighIns = measurements.where((m) => m.weightKg != null).toList();
  final weightChange =
      weighIns.length >= 2 ? weighIns.last.weightKg! - weighIns.first.weightKg! : null;

  return AsyncData(ProgressSummary(
    daysTrained: trainedDays.length,
    currentStreak: streak,
    completedWorkouts: logs.length,
    totalMinutesTrained: totalMinutes,
    weightChangeKg: weightChange,
    waterTodayMl: waterToday,
    caloriesTodayKcal: calories,
  ));
});
