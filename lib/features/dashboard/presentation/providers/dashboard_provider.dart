import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notifications/presentation/providers/reminders_provider.dart';
import '../../../sleep/presentation/providers/sleep_provider.dart';
import '../../../water/presentation/providers/water_provider.dart';

String greetingForNow() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Buenos días';
  if (hour < 19) return 'Buenas tardes';
  return 'Buenas noches';
}

/// Simple time-of-day heuristic for "next meal" — there's no meal
/// scheduling feature yet, so this just names the meal slot for right now.
String currentMealSlot() {
  final hour = DateTime.now().hour;
  if (hour < 11) return 'Desayuno';
  if (hour < 15) return 'Almuerzo';
  if (hour < 19) return 'Snack';
  if (hour < 22) return 'Cena';
  return 'Snack nocturno';
}

class UpcomingReminder {
  const UpcomingReminder({required this.label, required this.hour, required this.minute, required this.isTomorrow});
  final String label;
  final int hour;
  final int minute;
  final bool isTomorrow;

  String get formatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return isTomorrow ? '$h:$m mañana' : '$h:$m';
  }
}

/// Picks the soonest still-upcoming reminder across every reminder type
/// that's currently enabled (water, sleep, workout, meal).
final nextReminderProvider = Provider.autoDispose<UpcomingReminder?>((ref) {
  final waterEnabled = ref.watch(waterRemindersProvider);
  final sleepReminder = ref.watch(sleepReminderProvider);
  final workoutReminder = ref.watch(workoutReminderProvider);
  final mealReminder = ref.watch(mealReminderProvider);

  final candidates = <UpcomingReminder>[
    if (waterEnabled)
      for (final hour in waterReminderHours)
        UpcomingReminder(label: 'Beber agua 💧', hour: hour, minute: 0, isTomorrow: false),
    if (sleepReminder.enabled)
      UpcomingReminder(
        label: 'Hora de dormir 😴',
        hour: sleepReminder.time.hour,
        minute: sleepReminder.time.minute,
        isTomorrow: false,
      ),
    if (workoutReminder.enabled)
      UpcomingReminder(
        label: 'Es hora de entrenar 💪',
        hour: workoutReminder.time.hour,
        minute: workoutReminder.time.minute,
        isTomorrow: false,
      ),
    if (mealReminder.enabled)
      UpcomingReminder(
        label: 'No olvides comer 🍗',
        hour: mealReminder.time.hour,
        minute: mealReminder.time.minute,
        isTomorrow: false,
      ),
  ];

  if (candidates.isEmpty) return null;

  final now = DateTime.now();
  final nowMinutes = now.hour * 60 + now.minute;

  candidates.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));

  for (final reminder in candidates) {
    if (reminder.hour * 60 + reminder.minute > nowMinutes) return reminder;
  }
  // Nothing left today — the earliest one will fire tomorrow.
  final first = candidates.first;
  return UpcomingReminder(
    label: first.label,
    hour: first.hour,
    minute: first.minute,
    isTomorrow: true,
  );
});
