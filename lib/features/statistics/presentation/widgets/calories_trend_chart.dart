import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_utils.dart';

/// Bar chart of total daily calories (from `meal_logs`) over the last
/// [days] days.
class CaloriesTrendChart extends StatelessWidget {
  const CaloriesTrendChart({super.key, required this.totalsByDay, this.days = 7});

  final Map<DateTime, double> totalsByDay;
  final int days;

  @override
  Widget build(BuildContext context) {
    final dates = AppDateUtils.lastNDays(days);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
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
                  toY: totalsByDay[dates[i]] ?? 0,
                  color: AppColors.calories,
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
