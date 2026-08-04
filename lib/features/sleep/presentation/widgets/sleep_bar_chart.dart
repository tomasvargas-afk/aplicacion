import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/sleep_log.dart';

class SleepBarChart extends StatelessWidget {
  const SleepBarChart({super.key, required this.logs, this.days = 7});

  final List<SleepLog> logs;
  final int days;

  @override
  Widget build(BuildContext context) {
    final dates = AppDateUtils.lastNDays(days);
    final hoursByDay = {
      for (final day in dates)
        day: logs.where((l) => AppDateUtils.isSameDay(l.sleepDate, day)).fold<double>(
              0,
              (sum, l) => sum + l.hours,
            ),
    };

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 12,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= dates.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    AppDateUtils.formatWeekday(dates[index]),
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
                  toY: hoursByDay[dates[i]] ?? 0,
                  color: AppColors.sleep,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
