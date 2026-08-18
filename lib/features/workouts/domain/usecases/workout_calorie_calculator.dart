/// Estimates calories burned during a workout using the standard MET
/// (Metabolic Equivalent of Task) formula:
///
///   calories = MET × weight(kg) × duration(hours)
///
/// Uses MET 6.0 — "resistance training (weight lifting), multiple
/// exercises, vigorous effort" from the Compendium of Physical Activities.
/// This app's exercise library is all strength/resistance training, so a
/// single MET constant is a reasonable estimate without needing per-set
/// duration data the app doesn't track.
abstract class WorkoutCalorieCalculator {
  WorkoutCalorieCalculator._();

  static const double metResistanceTraining = 6.0;

  static double estimate({
    required int durationMinutes,
    required double weightKg,
  }) {
    final hours = durationMinutes / 60;
    return metResistanceTraining * weightKg * hours;
  }
}
