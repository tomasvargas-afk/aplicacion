import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/body_measurement.dart';

/// Line chart of a single numeric metric (weight, body fat %, a
/// circumference, ...) across the user's measurement history.
class MeasurementLineChart extends StatelessWidget {
  const MeasurementLineChart({
    super.key,
    required this.measurements,
    required this.valueSelector,
    required this.color,
    this.unit = '',
  });

  final List<BodyMeasurement> measurements;
  final double? Function(BodyMeasurement) valueSelector;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final points = <FlSpot>[];
    final withValues = <BodyMeasurement>[];
    for (final m in measurements) {
      final value = valueSelector(m);
      if (value != null) {
        withValues.add(m);
        points.add(FlSpot(withValues.length - 1.0, value));
      }
    }

    if (points.length < 2) {
      return Center(
        child: Text(
          'Registra al menos 2 mediciones para ver la evolución',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    final minY = points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((p) => p.y).reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY).abs() * 0.15).clamp(0.5, double.infinity);

    return LineChart(
      LineChartData(
        minY: minY - padding,
        maxY: maxY + padding,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: (withValues.length / 4).clamp(1, double.infinity).floorToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= withValues.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    AppDateUtils.formatShort(withValues[index].measuredAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem('${s.y.toStringAsFixed(1)} $unit',
                    const TextStyle(fontWeight: FontWeight.w600)))
                .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            color: color,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.12)),
          ),
        ],
      ),
    );
  }
}
