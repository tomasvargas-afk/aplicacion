import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/units/unit_converter.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/chart_card.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/body_measurement.dart';
import '../providers/body_tracking_provider.dart';
import '../widgets/measurement_line_chart.dart';
import 'add_measurement_screen.dart';

class _Metric {
  const _Metric(this.label, this.unit, this.color, this.selector,
      {this.isWeight = false});
  final String label;
  final String unit;
  final Color color;
  final double? Function(BodyMeasurement) selector;
  final bool isWeight;
}

final _metrics = <_Metric>[
  _Metric('Peso', 'kg', AppColors.calories, (m) => m.weightKg, isWeight: true),
  _Metric('% Grasa', '%', AppColors.warning, (m) => m.bodyFatPercent),
  _Metric('% Músculo', '%', AppColors.success, (m) => m.muscleMassPercent),
  _Metric('Cintura', 'cm', AppColors.info, (m) => m.waistCm),
  _Metric('Pecho', 'cm', AppColors.workout, (m) => m.chestCm),
  _Metric('Brazo', 'cm', AppColors.protein, (m) => m.armCm),
  _Metric('Pierna', 'cm', AppColors.sleep, (m) => m.thighCm),
];

class BodyTrackingScreen extends ConsumerStatefulWidget {
  const BodyTrackingScreen({super.key});

  @override
  ConsumerState<BodyTrackingScreen> createState() => _BodyTrackingScreenState();
}

class _BodyTrackingScreenState extends ConsumerState<BodyTrackingScreen> {
  int _selectedMetric = 0;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(bodyMeasurementHistoryProvider);
    final useLb = ref.watch(unitPreferenceProvider) == WeightUnit.lb;

    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento corporal')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddMeasurementScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(bodyMeasurementHistoryProvider),
        ),
        data: (history) {
          if (history.isEmpty) {
            return const EmptyState(
              icon: Icons.monitor_weight_outlined,
              message:
                  'Aún no has registrado mediciones.\nToca "Registrar" para empezar',
            );
          }

          final metric = _metrics[_selectedMetric];
          final convert = metric.isWeight && useLb;
          final displayUnit = convert ? 'lb' : metric.unit;
          final displaySelector = convert
              ? (BodyMeasurement m) {
                  final kg = metric.selector(m);
                  return kg == null ? null : UnitConverter.kgToLb(kg);
                }
              : metric.selector;
          final latest = history.last;
          final latestValue = displaySelector(latest);

          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(bodyMeasurementHistoryProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                Wrap(
                  spacing: AppSizes.sm,
                  children: List.generate(_metrics.length, (i) {
                    return ChoiceChip(
                      label: Text(_metrics[i].label),
                      selected: _selectedMetric == i,
                      onSelected: (_) => setState(() => _selectedMetric = i),
                    );
                  }),
                ),
                const SizedBox(height: AppSizes.md),
                ChartCard(
                  title:
                      '${metric.label} • ${latestValue != null ? '${latestValue.toStringAsFixed(1)} $displayUnit' : 'sin datos'}',
                  height: 220,
                  child: MeasurementLineChart(
                    measurements: history,
                    valueSelector: displaySelector,
                    color: metric.color,
                    unit: displayUnit,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Text('Historial', style: context.textTheme.titleMedium),
                const SizedBox(height: AppSizes.sm),
                ...history.reversed
                    .map((m) => _HistoryTile(measurement: m, useLb: useLb)),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.measurement, required this.useLb});

  final BodyMeasurement measurement;
  final bool useLb;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = <String>[
      if (measurement.weightKg != null)
        UnitConverter.formatWeight(measurement.weightKg!, useLb: useLb),
      if (measurement.bodyFatPercent != null)
        '${measurement.bodyFatPercent!.toStringAsFixed(1)}% grasa',
      if (measurement.muscleMassPercent != null)
        '${measurement.muscleMassPercent!.toStringAsFixed(1)}% músculo',
      if (measurement.waistCm != null)
        'Cintura ${measurement.waistCm!.toStringAsFixed(0)}cm',
    ];

    final photoUrlAsync =
        ref.watch(progressPhotoUrlProvider(measurement.photoPath));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: AppCard(
        child: Row(
          children: [
            if (measurement.photoPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: photoUrlAsync.when(
                  data: (url) => url == null
                      ? const SizedBox(width: 48, height: 48)
                      : Image.network(
                          url,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                  loading: () => const SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  error: (error, stackTrace) =>
                      const SizedBox(width: 48, height: 48),
                ),
              ),
              const SizedBox(width: AppSizes.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(measurement.measuredAt),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    parts.isEmpty ? 'Sin datos' : parts.join(' · '),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () async {
                final confirmed = await ConfirmDialog.show(
                  context,
                  title: 'Eliminar medición',
                  message: '¿Seguro que quieres eliminar este registro?',
                );
                if (confirmed && measurement.id != null) {
                  await ref
                      .read(bodyTrackingControllerProvider.notifier)
                      .deleteMeasurement(measurement.id!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
