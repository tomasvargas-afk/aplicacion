import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _baselineCountKey = 'steps_baseline_count';
const _baselineDateKey = 'steps_baseline_date';

/// Wraps the device's built-in step sensor (CMPedometer on iOS, the step
/// counter sensor on Android) via `pedometer` — no HealthKit/Health Connect
/// involved, so it works with a free Apple ID / sideloaded build.
///
/// The OS stream reports a running total since the last device reboot, so
/// "steps today" is derived by storing a baseline reading at the start of
/// each day (in [SharedPreferences]) and subtracting it from live updates.
class StepCounterService {
  StepCounterService._();

  static final StepCounterService instance = StepCounterService._();

  Future<bool> hasPermission() async =>
      Permission.activityRecognition.isGranted;

  Future<bool> requestPermission() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  /// Emits steps taken today. Resets automatically at midnight and if the
  /// device's raw counter goes backwards (reboot).
  Stream<int> get stepsToday async* {
    await for (final event in Pedometer.stepCountStream) {
      yield await _stepsSinceBaseline(event.steps);
    }
  }

  Future<int> _stepsSinceBaseline(int rawCount) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _dateKey(DateTime.now());
    final storedDate = prefs.getString(_baselineDateKey);

    if (storedDate != todayKey) {
      await prefs.setString(_baselineDateKey, todayKey);
      await prefs.setInt(_baselineCountKey, rawCount);
      return 0;
    }

    final baseline = prefs.getInt(_baselineCountKey) ?? rawCount;
    if (rawCount < baseline) {
      await prefs.setInt(_baselineCountKey, rawCount);
      return 0;
    }
    return rawCount - baseline;
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
