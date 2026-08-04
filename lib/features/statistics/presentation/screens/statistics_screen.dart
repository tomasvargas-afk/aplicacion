import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/units/unit_converter.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/chart_card.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../../body_tracking/presentation/widgets/measurement_line_chart.dart';
import '../../../sleep/presentation/providers/sleep_provider.dart';
import '../../../sleep/presentation/widgets/sleep_bar_chart.dart';
import '../../../water/presentation/providers/water_provider.dart';
import '../../../water/presentation/widgets/water_trend_chart.dart';
import '../../../workouts/presentation/providers/workout_provider.dart';
import '../providers/progress_summary_provider.dart';
import '../widgets/attendance_chart.dart';
import '../widgets/calories_trend_chart.dart';

// Gráficos históricos (calorías, asistencia) llegan cuando exista más
// historial; por ahora esta pantalla muestra el resumen de progreso y
// accesos directos a cada tracker.
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(progressSummaryProvider);

    final measurements = ref.watch(bodyMeasurementHistoryProvider).valueOrNull ?? const [];
    final waterLogs = ref.watch(waterRecentLogsProvider).valueOrNull ?? const [];
    final workoutLogs = ref.watch(workoutLogsProvider).valueOrNull ?? const [];
    final sleepLogs = ref.watch(sleepHistoryProvider).valueOrNull ?? const [];
    final calorieTotals = ref.watch(recentCaloriesProvider(7)).valueOrNull ?? const {};
    final useLb = ref.watch(unitPreferenceProvider) == WeightUnit.lb;

    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          summaryAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSizes.lg),
              child: LoadingIndicator(),
            ),
            error: (error, _) => ErrorView(message: describeError(error)),
            data: (summary) => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSizes.sm,
              crossAxisSpacing: AppSizes.sm,
              childAspectRatio: 1.5,
              children: [
                _StatTile(
                  icon: Icons.local_fire_department,
                  color: AppColors.workout,
                  value: '${summary.currentStreak}',
                  label: summary.currentStreak == 1 ? 'día seguido' : 'días seguidos',
                ),
                _StatTile(
                  icon: Icons.event_available,
                  color: AppColors.info,
                  value: '${summary.daysTrained}',
                  label: 'días entrenados',
                ),
                _StatTile(
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  value: '${summary.completedWorkouts}',
                  label: 'entrenamientos',
                ),
                _StatTile(
                  icon: Icons.timer_outlined,
                  color: AppColors.warning,
                  value: (summary.totalMinutesTrained / 60).toStringAsFixed(1),
                  label: 'horas entrenadas',
                ),
                _StatTile(
                  icon: Icons.monitor_weight_outlined,
                  color: AppColors.calories,
                  value: summary.weightChangeKg == null
                      ? '—'
                      : '${summary.weightChangeKg! > 0 ? '+' : ''}${summary.weightChangeKg!.toStringAsFixed(1)} kg',
                  label: 'cambio de peso',
                ),
                _StatTile(
                  icon: Icons.water_drop_outlined,
                  color: AppColors.water,
                  value: '${(summary.waterTodayMl / 1000).toStringAsFixed(1)} L',
                  label: 'agua hoy',
                ),
                _StatTile(
                  icon: Icons.restaurant_outlined,
                  color: AppColors.protein,
                  value: '${summary.caloriesTodayKcal.round()}',
                  label: 'kcal hoy',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          AppCard(
            onTap: () => context.push(RoutePaths.bodyTracking),
            child: const Row(
              children: [
                IconBadge(icon: Icons.monitor_weight_outlined, color: AppColors.calories),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seguimiento corporal',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('Peso, % grasa, medidas y su evolución'),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppCard(
            onTap: () => context.push(RoutePaths.water),
            child: const Row(
              children: [
                IconBadge(icon: Icons.water_drop_outlined, color: AppColors.water),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agua',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('Consumo diario, meta y recordatorios'),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppCard(
            onTap: () => context.push(RoutePaths.sleep),
            child: const Row(
              children: [
                IconBadge(icon: Icons.bedtime_outlined, color: AppColors.sleep),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sueño',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('Horas dormidas y estadísticas'),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const SectionHeader(title: 'Gráficos'),
          ChartCard(
            title: 'Peso',
            isEmpty: measurements.where((m) => m.weightKg != null).length < 2,
            child: MeasurementLineChart(
              measurements: measurements,
              valueSelector: (m) {
                final kg = m.weightKg;
                if (kg == null) return null;
                return useLb ? UnitConverter.kgToLb(kg) : kg;
              },
              color: AppColors.calories,
              unit: useLb ? 'lb' : 'kg',
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          ChartCard(
            title: 'Calorías (últimos 7 días)',
            isEmpty: calorieTotals.values.every((v) => v == 0),
            child: CaloriesTrendChart(totalsByDay: calorieTotals),
          ),
          const SizedBox(height: AppSizes.sm),
          ChartCard(
            title: 'Agua (últimos 7 días)',
            isEmpty: waterLogs.isEmpty,
            child: WaterTrendChart(logs: waterLogs),
          ),
          const SizedBox(height: AppSizes.sm),
          ChartCard(
            title: 'Asistencia (últimos 14 días)',
            isEmpty: workoutLogs.isEmpty,
            child: AttendanceChart(logs: workoutLogs),
          ),
          const SizedBox(height: AppSizes.sm),
          ChartCard(
            title: 'Sueño (últimos 7 días)',
            isEmpty: sleepLogs.isEmpty,
            child: SleepBarChart(logs: sleepLogs),
          ),
          const SizedBox(height: AppSizes.xxl),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBadge(icon: icon, color: color, size: 32),
          const SizedBox(height: AppSizes.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
