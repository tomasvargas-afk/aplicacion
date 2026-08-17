import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../statistics/presentation/providers/progress_summary_provider.dart';
import '../../data/datasources/workout_remote_datasource.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_log.dart';
import '../../domain/entities/workout_schedule.dart';
import '../../domain/repositories/workout_repository.dart';

final workoutRemoteDatasourceProvider =
    Provider<WorkoutRemoteDatasource>((ref) {
  return WorkoutRemoteDatasource(ref.watch(supabaseClientProvider));
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepositoryImpl(ref.watch(workoutRemoteDatasourceProvider));
});

final exerciseLibraryProvider =
    FutureProvider.autoDispose<List<Exercise>>((ref) async {
  final result =
      await ref.watch(workoutRepositoryProvider).getExerciseLibrary();
  return result.match((failure) => throw failure, (list) => list);
});

final workoutsProvider = FutureProvider.autoDispose<List<Workout>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result =
      await ref.watch(workoutRepositoryProvider).getWorkouts(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

final workoutLogsProvider =
    FutureProvider.autoDispose<List<WorkoutLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(workoutRepositoryProvider).getLogs(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

/// Schedule window: a month back (so recently-passed entries stay visible
/// on the calendar) through 6 months ahead (covers the weekly-repeat option).
final workoutScheduleProvider =
    FutureProvider.autoDispose<List<WorkoutSchedule>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final now = DateTime.now();
  final result = await ref.watch(workoutRepositoryProvider).getSchedule(
        user.id,
        from: now.subtract(const Duration(days: 31)),
        to: now.add(const Duration(days: 183)),
      );
  return result.match((failure) => throw failure, (list) => list);
});

class WorkoutController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Creates a user-authored exercise (`is_custom = true`) so it shows up
  /// alongside the shared library. Returns the created exercise, or null +
  /// an error message on failure.
  Future<(Exercise?, String?)> createCustomExercise(String name) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return (null, 'No hay sesión activa');

    final result = await ref
        .read(workoutRepositoryProvider)
        .createCustomExercise(Exercise(name: name, isCustom: true), user.id);
    return result.match(
      (failure) => (null, failure.displayMessage),
      (exercise) {
        ref.invalidate(exerciseLibraryProvider);
        return (exercise, null);
      },
    );
  }

  Future<String?> saveWorkout(Workout workout) async {
    state = const AsyncLoading();
    final result =
        await ref.read(workoutRepositoryProvider).saveWorkout(workout);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(workoutsProvider);
        return null;
      },
    );
  }

  Future<String?> deleteWorkout(String id) async {
    final result = await ref.read(workoutRepositoryProvider).deleteWorkout(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(workoutsProvider);
        // Deleting a workout cascades to its schedule entries in the DB.
        ref.invalidate(workoutScheduleProvider);
        return null;
      },
    );
  }

  Future<String?> logCompletion(WorkoutLog log) async {
    state = const AsyncLoading();
    final result = await ref.read(workoutRepositoryProvider).logCompletion(log);
    state = const AsyncData(null);

    final failure = result.match((f) => f, (_) => null);
    if (failure != null) return failure.displayMessage;

    ref.invalidate(workoutLogsProvider);
    await _maybeCelebrateStreak(log.userId);
    return null;
  }

  /// Fires a one-off "🔥 racha" notification every 5th consecutive day
  /// trained (matches the "Llevas 5 días seguidos entrenando" example from
  /// the original brief) — checked right after logging a completion.
  Future<void> _maybeCelebrateStreak(String userId) async {
    final logsResult =
        await ref.read(workoutRepositoryProvider).getLogs(userId);
    final logs = logsResult.match((_) => const <WorkoutLog>[], (list) => list);
    final streak = calculateStreak(logs);
    if (streak > 0 && streak % 5 == 0) {
      await NotificationService.instance.showNow(
        id: 9600,
        title: '¡Racha de $streak días! 🔥',
        body: 'Llevas $streak días seguidos entrenando. ¡Sigue así!',
      );
    }
  }

  Future<String?> scheduleWorkout(List<WorkoutSchedule> entries) async {
    state = const AsyncLoading();
    final result =
        await ref.read(workoutRepositoryProvider).scheduleWorkout(entries);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(workoutScheduleProvider);
        return null;
      },
    );
  }

  Future<String?> deleteScheduleEntry(String id) async {
    final result =
        await ref.read(workoutRepositoryProvider).deleteScheduleEntry(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(workoutScheduleProvider);
        return null;
      },
    );
  }

  Future<String?> updateScheduleStatus(String id, String status) async {
    final result = await ref
        .read(workoutRepositoryProvider)
        .updateScheduleStatus(id, status);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(workoutScheduleProvider);
        return null;
      },
    );
  }
}

final workoutControllerProvider =
    AsyncNotifierProvider<WorkoutController, void>(
  WorkoutController.new,
);
