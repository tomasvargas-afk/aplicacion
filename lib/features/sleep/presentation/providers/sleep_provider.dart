import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/sleep_remote_datasource.dart';
import '../../data/repositories/sleep_repository_impl.dart';
import '../../domain/entities/sleep_log.dart';
import '../../domain/repositories/sleep_repository.dart';

final sleepRemoteDatasourceProvider = Provider<SleepRemoteDatasource>((ref) {
  return SleepRemoteDatasource(ref.watch(supabaseClientProvider));
});

final sleepRepositoryProvider = Provider<SleepRepository>((ref) {
  return SleepRepositoryImpl(ref.watch(sleepRemoteDatasourceProvider));
});

final sleepHistoryProvider = FutureProvider.autoDispose<List<SleepLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final result = await ref.watch(sleepRepositoryProvider).getHistory(user.id);
  return result.match((failure) => throw failure, (list) => list);
});

final averageSleepHoursProvider = Provider.autoDispose<double?>((ref) {
  final logs = ref.watch(sleepHistoryProvider).valueOrNull ?? const [];
  if (logs.isEmpty) return null;
  return logs.fold<double>(0, (sum, l) => sum + l.hours) / logs.length;
});

const _bedtimeReminderEnabledKey = 'sleep_reminder_enabled';
const _bedtimeReminderHourKey = 'sleep_reminder_hour';
const _bedtimeReminderMinuteKey = 'sleep_reminder_minute';
const _bedtimeReminderId = 9300;

class SleepReminderSettings {
  const SleepReminderSettings({required this.enabled, required this.time});

  final bool enabled;
  final TimeOfDay time;

  SleepReminderSettings copyWith({bool? enabled, TimeOfDay? time}) {
    return SleepReminderSettings(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
    );
  }
}

class SleepReminderNotifier extends Notifier<SleepReminderSettings> {
  @override
  SleepReminderSettings build() {
    _restore();
    return const SleepReminderSettings(
      enabled: false,
      time: TimeOfDay(hour: 22, minute: 0),
    );
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = SleepReminderSettings(
      enabled: prefs.getBool(_bedtimeReminderEnabledKey) ?? false,
      time: TimeOfDay(
        hour: prefs.getInt(_bedtimeReminderHourKey) ?? 22,
        minute: prefs.getInt(_bedtimeReminderMinuteKey) ?? 0,
      ),
    );
  }

  Future<void> toggle(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bedtimeReminderEnabledKey, enabled);

    if (enabled) {
      await _scheduleAtCurrentTime();
    } else {
      await NotificationService.instance.cancelForFeature(_bedtimeReminderId);
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    state = state.copyWith(time: time);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bedtimeReminderHourKey, time.hour);
    await prefs.setInt(_bedtimeReminderMinuteKey, time.minute);
    if (state.enabled) {
      await _scheduleAtCurrentTime();
    }
  }

  Future<void> _scheduleAtCurrentTime() async {
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      state = state.copyWith(enabled: false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_bedtimeReminderEnabledKey, false);
      return;
    }
    await NotificationService.instance.scheduleDaily(
      id: _bedtimeReminderId,
      title: 'Hora de dormir 😴',
      body: 'Un buen descanso te ayuda a rendir mejor mañana',
      hour: state.time.hour,
      minute: state.time.minute,
    );
  }
}

final sleepReminderProvider =
    NotifierProvider<SleepReminderNotifier, SleepReminderSettings>(
  SleepReminderNotifier.new,
);

class SleepController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> addLog(SleepLog log) async {
    state = const AsyncLoading();
    final result = await ref.read(sleepRepositoryProvider).addLog(log);
    state = const AsyncData(null);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(sleepHistoryProvider);
        return null;
      },
    );
  }

  Future<String?> deleteLog(String id) async {
    final result = await ref.read(sleepRepositoryProvider).deleteLog(id);
    return result.match(
      (failure) => failure.displayMessage,
      (_) {
        ref.invalidate(sleepHistoryProvider);
        return null;
      },
    );
  }
}

final sleepControllerProvider = AsyncNotifierProvider<SleepController, void>(
  SleepController.new,
);
