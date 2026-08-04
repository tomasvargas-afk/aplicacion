import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/notification_service.dart';

class ReminderSettings {
  const ReminderSettings({required this.enabled, required this.time});

  final bool enabled;
  final TimeOfDay time;

  ReminderSettings copyWith({bool? enabled, TimeOfDay? time}) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
    );
  }
}

/// Shared implementation behind the workout/meal reminder toggles — same
/// enable+time persistence and scheduling pattern as the sleep reminder,
/// just parameterized per feature so it isn't copy-pasted three times.
abstract class _SimpleReminderNotifier extends Notifier<ReminderSettings> {
  String get _enabledKey;
  String get _hourKey;
  String get _minuteKey;
  int get _notificationId;
  String get _title;
  String get _body;
  TimeOfDay get _defaultTime;

  @override
  ReminderSettings build() {
    _restore();
    return ReminderSettings(enabled: false, time: _defaultTime);
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    state = ReminderSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      time: TimeOfDay(
        hour: prefs.getInt(_hourKey) ?? _defaultTime.hour,
        minute: prefs.getInt(_minuteKey) ?? _defaultTime.minute,
      ),
    );
  }

  Future<void> toggle(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);

    if (enabled) {
      await _scheduleAtCurrentTime();
    } else {
      await NotificationService.instance.cancelForFeature(_notificationId);
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    state = state.copyWith(time: time);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, time.hour);
    await prefs.setInt(_minuteKey, time.minute);
    if (state.enabled) {
      await _scheduleAtCurrentTime();
    }
  }

  Future<void> _scheduleAtCurrentTime() async {
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      state = state.copyWith(enabled: false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enabledKey, false);
      return;
    }
    await NotificationService.instance.scheduleDaily(
      id: _notificationId,
      title: _title,
      body: _body,
      hour: state.time.hour,
      minute: state.time.minute,
    );
  }
}

class WorkoutReminderNotifier extends _SimpleReminderNotifier {
  @override
  String get _enabledKey => 'workout_reminder_enabled';
  @override
  String get _hourKey => 'workout_reminder_hour';
  @override
  String get _minuteKey => 'workout_reminder_minute';
  @override
  int get _notificationId => 9400;
  @override
  String get _title => 'Es hora de entrenar 💪';
  @override
  String get _body => 'Tu cuerpo te lo va a agradecer';
  @override
  TimeOfDay get _defaultTime => const TimeOfDay(hour: 18, minute: 0);
}

final workoutReminderProvider =
    NotifierProvider<WorkoutReminderNotifier, ReminderSettings>(
  WorkoutReminderNotifier.new,
);

class MealReminderNotifier extends _SimpleReminderNotifier {
  @override
  String get _enabledKey => 'meal_reminder_enabled';
  @override
  String get _hourKey => 'meal_reminder_hour';
  @override
  String get _minuteKey => 'meal_reminder_minute';
  @override
  int get _notificationId => 9500;
  @override
  String get _title => 'No olvides almorzar 🍗';
  @override
  String get _body => 'Registra tu comida para seguir tu plan';
  @override
  TimeOfDay get _defaultTime => const TimeOfDay(hour: 13, minute: 0);
}

final mealReminderProvider =
    NotifierProvider<MealReminderNotifier, ReminderSettings>(
  MealReminderNotifier.new,
);
