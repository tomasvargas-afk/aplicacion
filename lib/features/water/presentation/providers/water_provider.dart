import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/water_remote_datasource.dart';
import '../../data/repositories/water_repository_impl.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/repositories/water_repository.dart';

final waterRemoteDatasourceProvider = Provider<WaterRemoteDatasource>((ref) {
  return WaterRemoteDatasource(ref.watch(supabaseClientProvider));
});

final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  return WaterRepositoryImpl(ref.watch(waterRemoteDatasourceProvider));
});

final waterRecentLogsProvider = FutureProvider.autoDispose<List<WaterLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(waterRepositoryProvider).getRecentLogs(user.id, days: 7);
  return result.match((failure) => throw failure, (list) => list);
});

/// Today's total intake in ml, derived from the recent-logs list.
final todayWaterTotalProvider = Provider.autoDispose<int>((ref) {
  final logsAsync = ref.watch(waterRecentLogsProvider);
  final logs = logsAsync.valueOrNull ?? const [];
  final today = DateTime.now();
  return logs
      .where((l) => AppDateUtils.isSameDay(l.loggedDate, today))
      .fold(0, (sum, l) => sum + l.amountMl);
});

const _goalPrefsKey = 'water_goal_ml';
const _remindersPrefsKey = 'water_reminders_enabled';
const _reminderHours = [10, 13, 16, 19];

/// Exposed so other features (e.g. the dashboard's "next reminder" card)
/// can compute upcoming reminder times without duplicating this schedule.
const waterReminderHours = _reminderHours;

class WaterGoalNotifier extends Notifier<int> {
  @override
  int build() {
    _restore();
    return 2000;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getInt(_goalPrefsKey);
    if (stored != null) state = stored;
  }

  Future<void> setGoal(int ml) async {
    state = ml;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goalPrefsKey, ml);
  }
}

final waterGoalProvider = NotifierProvider<WaterGoalNotifier, int>(WaterGoalNotifier.new);

class WaterRemindersNotifier extends Notifier<bool> {
  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_remindersPrefsKey) ?? false;
  }

  Future<void> toggle(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersPrefsKey, enabled);

    if (enabled) {
      final granted = await NotificationService.instance.requestPermission();
      if (!granted) {
        state = false;
        await prefs.setBool(_remindersPrefsKey, false);
        return;
      }
      for (var i = 0; i < _reminderHours.length; i++) {
        await NotificationService.instance.scheduleDaily(
          id: 9200 + i,
          title: 'Bebe un vaso de agua 💧',
          body: 'Mantente hidratado — registra tu consumo de hoy',
          hour: _reminderHours[i],
          minute: 0,
        );
      }
    } else {
      for (var i = 0; i < _reminderHours.length; i++) {
        await NotificationService.instance.cancelForFeature(9200 + i);
      }
    }
  }
}

final waterRemindersProvider =
    NotifierProvider<WaterRemindersNotifier, bool>(WaterRemindersNotifier.new);

class WaterController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> addQuickLog(int amountMl) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return 'No hay sesión activa';

    final log = WaterLog(
      userId: user.id,
      loggedDate: DateTime.now(),
      amountMl: amountMl,
      goalMl: ref.read(waterGoalProvider),
    );

    state = const AsyncLoading();
    final result = await ref.read(waterRepositoryProvider).addLog(log);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(waterRecentLogsProvider);
        return null;
      },
    );
  }

  Future<String?> deleteLog(String id) async {
    final result = await ref.read(waterRepositoryProvider).deleteLog(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(waterRecentLogsProvider);
        return null;
      },
    );
  }
}

final waterControllerProvider = AsyncNotifierProvider<WaterController, void>(
  WaterController.new,
);
