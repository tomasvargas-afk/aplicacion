import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../workouts/domain/entities/workout_log.dart';

/// Bar chart of workouts completed per day over the last [days] days —
/// the "asistencia" (attendance) visualization from the original brief.
class AttendanceChart extends StatelessWidget {
  const AttendanceChart({super.key, required this.logs, this.days = 14});

  final List<WorkoutLog> logs;
  final int days;

  @override
  Widget build(BuildContext context) {
    final dates = AppDateUtils.lastNDays(days);
    final countByDay = {
      for (final day in dates)
        day: logs
            .where((l) => l.completedAt != null && AppDateUtils.isSameDay(l.completedAt!, day))
            .length,
    };

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (countByDay.values.isEmpty ? 1 : countByDay.values.reduce((a, b) => a > b ? a : b))
                .clamp(1, 999)
                .toDouble() +
            1,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (days / 7).clamp(1, double.infinity).floorToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= dates.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    AppDateUtils.formatShort(dates[index]),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < dates.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (countByDay[dates[i]] ?? 0).toDouble(),
                  color: AppColors.workout,
                  width: 10,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
