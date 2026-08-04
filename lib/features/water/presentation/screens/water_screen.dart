import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/chart_card.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/water_provider.dart';
import '../widgets/water_progress_bar.dart';
import '../widgets/water_quick_add_buttons.dart';
import '../widgets/water_trend_chart.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  Future<void> _editGoal(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: (ref.read(waterGoalProvider) / 1000).toStringAsFixed(1),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meta diaria de agua'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: 'L'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.'));
              Navigator.of(context).pop(value);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      await ref.read(waterGoalProvider.notifier).setGoal((result * 1000).round());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(waterRecentLogsProvider);
    final todayTotal = ref.watch(todayWaterTotalProvider);
    final goal = ref.watch(waterGoalProvider);
    final remindersEnabled = ref.watch(waterRemindersProvider);
    final isAdding = ref.watch(waterControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agua'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Editar meta',
            onPressed: () => _editGoal(context, ref),
          ),
        ],
      ),
      body: logsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(waterRecentLogsProvider),
        ),
        data: (logs) {
          final today = DateTime.now();
          final todayLogs = logs.where((l) => AppDateUtils.isSameDay(l.loggedDate, today))
              .toList()
              .reversed
              .toList();

          final totalsAllZero = AppDateUtils.lastNDays(7).every(
            (day) => logs
                .where((l) => AppDateUtils.isSameDay(l.loggedDate, day))
                .fold<int>(0, (sum, l) => sum + l.amountMl) == 0,
          );

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(waterRecentLogsProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WaterProgressBar(currentMl: todayTotal, goalMl: goal),
                      const SizedBox(height: AppSizes.md),
                      WaterQuickAddButtons(
                        isLoading: isAdding,
                        onAdd: (ml) async {
                          final error = await ref
                              .read(waterControllerProvider.notifier)
                              .addQuickLog(ml);
                          if (context.mounted && error != null) {
                            context.showSnackBar(error, isError: true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                AppCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Recordatorios de agua'),
                    subtitle: const Text('4 veces al día (10, 13, 16 y 19 h)'),
                    value: remindersEnabled,
                    onChanged: (value) =>
                        ref.read(waterRemindersProvider.notifier).toggle(value),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                ChartCard(
                  title: 'Últimos 7 días',
                  height: 160,
                  isEmpty: totalsAllZero,
                  child: WaterTrendChart(logs: logs),
                ),
                if (todayLogs.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.lg),
                  Text('Hoy', style: context.textTheme.titleMedium),
                  const SizedBox(height: AppSizes.sm),
                  ...todayLogs.map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.xs),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                            vertical: AppSizes.sm,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.water_drop, size: 18, color: AppColors.water),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(child: Text('${log.amountMl} ml')),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () async {
                                  final confirmed = await ConfirmDialog.show(
                                    context,
                                    title: 'Eliminar registro',
                                    message: '¿Eliminar este registro de agua?',
                                  );
                                  if (confirmed && log.id != null) {
                                    await ref
                                        .read(waterControllerProvider.notifier)
                                        .deleteLog(log.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}
