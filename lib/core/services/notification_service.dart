import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper around `flutter_local_notifications` used by the
/// `notifications`/`reminders` feature and by other features that want to
/// schedule a recurring reminder (water, workout, sleep, meals).
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(tz.local.name));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    List<int>? daysOfWeek, // 1 = Monday .. 7 = Sunday, null = every day
  }) async {
    await initialize();
    final targets = daysOfWeek ?? const [1, 2, 3, 4, 5, 6, 7];
    for (final weekday in targets) {
      await _plugin.zonedSchedule(
        _compoundId(id, weekday),
        title,
        body,
        _nextInstanceOfWeekdayTime(weekday, hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders_channel',
            'Recordatorios',
            channelDescription: 'Recordatorios de salud, entrenamiento y nutrición',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> scheduleOneOff({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    await initialize();
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Recordatorios',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Fires immediately — used for one-off celebratory notifications (e.g.
  /// hitting a streak milestone) rather than a scheduled reminder.
  Future<void> showNow({required int id, required String title, required String body}) async {
    await initialize();
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements_channel',
          'Logros',
          channelDescription: 'Celebraciones de racha y logros',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  Future<void> cancelForFeature(int baseId) async {
    for (var weekday = 1; weekday <= 7; weekday++) {
      await _plugin.cancel(_compoundId(baseId, weekday));
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  int _compoundId(int baseId, int weekday) => baseId * 10 + weekday;

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute) {
    var scheduled = tz.TZDateTime.now(tz.local);
    scheduled = tz.TZDateTime(
      tz.local,
      scheduled.year,
      scheduled.month,
      scheduled.day,
      hour,
      minute,
    );
    while (scheduled.weekday != weekday || scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
