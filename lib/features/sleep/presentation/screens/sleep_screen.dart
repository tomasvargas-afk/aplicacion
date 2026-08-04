import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/chart_card.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/sleep_provider.dart';
import '../widgets/sleep_bar_chart.dart';
import 'add_sleep_screen.dart';

class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(sleepHistoryProvider);
    final average = ref.watch(averageSleepHoursProvider);
    final reminder = ref.watch(sleepReminderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sueño')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddSleepScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(sleepHistoryProvider),
        ),
        data: (logs) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(sleepHistoryProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                if (average != null)
                  AppCard(
                    child: Row(
                      children: [
                        const Icon(Icons.bedtime, size: 28),
                        const SizedBox(width: AppSizes.md),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${average.toStringAsFixed(1)} h',
                              style: context.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const Text('Promedio (últimos 14 días)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSizes.md),
                AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.bedtime_outlined),
                    title: const Text('Recordatorio para dormir'),
                    subtitle: Text(
                      'Todos los días a las ${reminder.time.format(context)} · toca para cambiar',
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: reminder.time,
                      );
                      if (picked != null) {
                        await ref.read(sleepReminderProvider.notifier).setTime(picked);
                      }
                    },
                    trailing: Switch(
                      value: reminder.enabled,
                      onChanged: (value) =>
                          ref.read(sleepReminderProvider.notifier).toggle(value),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                ChartCard(
                  title: 'Últimos 7 días',
                  height: 180,
                  isEmpty: logs.isEmpty,
                  child: SleepBarChart(logs: logs),
                ),
                const SizedBox(height: AppSizes.lg),
                if (logs.isEmpty)
                  const EmptyState(
                    icon: Icons.bedtime_outlined,
                    message: 'Todavía no has registrado tu sueño',
                  )
                else ...[
                  Text('Historial', style: context.textTheme.titleMedium),
                  const SizedBox(height: AppSizes.sm),
                  ...logs.reversed.map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.sm),
                        child: AppCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${log.hours.toStringAsFixed(1)} horas',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    if (log.bedTime != null && log.wakeTime != null)
                                      Text(
                                        '${log.bedTime} → ${log.wakeTime}',
                                        style: context.textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                              if (log.quality != null)
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < log.quality! ? Icons.star : Icons.star_border,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () async {
                                  final confirmed = await ConfirmDialog.show(
                                    context,
                                    title: 'Eliminar registro',
                                    message: '¿Eliminar este registro de sueño?',
                                  );
                                  if (confirmed && log.id != null) {
                                    await ref
                                        .read(sleepControllerProvider.notifier)
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
