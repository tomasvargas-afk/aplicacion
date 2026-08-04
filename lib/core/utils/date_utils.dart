import 'package:intl/intl.dart';

/// Date helpers shared across calendar, logs and chart features.
abstract class AppDateUtils {
  AppDateUtils._();

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime startOfWeek(DateTime date) {
    final d = dateOnly(date);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month);

  static List<DateTime> lastNDays(int n, {DateTime? end}) {
    final endDate = dateOnly(end ?? DateTime.now());
    return List.generate(
      n,
      (i) => endDate.subtract(Duration(days: n - 1 - i)),
    );
  }

  static String formatShort(DateTime date) =>
      DateFormat('d MMM', 'es').format(date);

  static String formatWeekday(DateTime date) =>
      DateFormat('EEE', 'es').format(date);

  static String formatFull(DateTime date) =>
      DateFormat('EEEE d MMMM', 'es').format(date);

  static String formatIso(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(dateOnly(date));
}
