import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_schedule.dart';
import '../providers/workout_provider.dart';
import 'workout_detail_screen.dart';

class WorkoutCalendarScreen extends ConsumerStatefulWidget {
  const WorkoutCalendarScreen({super.key});

  @override
  ConsumerState<WorkoutCalendarScreen> createState() => _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState extends ConsumerState<WorkoutCalendarScreen> {
  DateTime _focusedDay = AppDateUtils.dateOnly(DateTime.now());
  DateTime _selectedDay = AppDateUtils.dateOnly(DateTime.now());
  CalendarFormat _format = CalendarFormat.month;

  Map<DateTime, List<WorkoutSchedule>> _groupByDay(List<WorkoutSchedule> entries) {
    final map = <DateTime, List<WorkoutSchedule>>{};
    for (final entry in entries) {
      final day = AppDateUtils.dateOnly(entry.scheduledDate);
      map.putIfAbsent(day, () => []).add(entry);
    }
    return map;
  }

  Future<void> _openScheduleSheet() async {
    final workouts = ref.read(workoutsProvider).valueOrNull ?? const [];
    if (workouts.isEmpty) {
      context.showSnackBar('Crea primero una rutina para poder programarla', isError: true);
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    Workout selected = workouts.first;
    bool repeatWeekly = false;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: AppSizes.lg,
            right: AppSizes.lg,
            top: AppSizes.lg,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppSizes.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Programar para ${AppDateUtils.formatFull(_selectedDay)}',
                style: sheetContext.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<Workout>(
                initialValue: selected,
                items: workouts
                    .map((w) => DropdownMenuItem(value: w, child: Text(w.name)))
                    .toList(),
                onChanged: (w) => setSheetState(() => selected = w ?? selected),
                decoration: const InputDecoration(labelText: 'Rutina'),
              ),
              const SizedBox(height: AppSizes.xs),
              CheckboxListTile(
                value: repeatWeekly,
                onChanged: (v) => setSheetState(() => repeatWeekly = v ?? false),
                title: const Text('Repetir cada semana (8 semanas)'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSizes.md),
              FilledButton(
                onPressed: () => Navigator.of(sheetContext).pop(true),
                child: const Text('Programar'),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    final entries = <WorkoutSchedule>[
      WorkoutSchedule(
        userId: user.id,
        workoutId: selected.id!,
        scheduledDate: _selectedDay,
      ),
      if (repeatWeekly)
        for (var i = 1; i <= 8; i++)
          WorkoutSchedule(
            userId: user.id,
            workoutId: selected.id!,
            scheduledDate: _selectedDay.add(Duration(days: 7 * i)),
          ),
    ];

    final error = await ref.read(workoutControllerProvider.notifier).scheduleWorkout(entries);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      context.showSnackBar('Rutina programada');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(workoutScheduleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de entrenamiento')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openScheduleSheet,
        icon: const Icon(Icons.add),
        label: const Text('Programar'),
      ),
      body: scheduleAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(workoutScheduleProvider),
        ),
        data: (entries) {
          final byDay = _groupByDay(entries);
          final selectedEntries = byDay[_selectedDay] ?? const <WorkoutSchedule>[];

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(workoutScheduleProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                AppCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  child: TableCalendar<WorkoutSchedule>(
                    locale: 'es',
                    firstDay: DateTime.now().subtract(const Duration(days: 31)),
                    lastDay: DateTime.now().add(const Duration(days: 183)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => AppDateUtils.isSameDay(day, _selectedDay),
                    calendarFormat: _format,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    eventLoader: (day) => byDay[AppDateUtils.dateOnly(day)] ?? const [],
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = AppDateUtils.dateOnly(selectedDay);
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) => setState(() => _format = format),
                    onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                    calendarStyle: CalendarStyle(
                      markerDecoration: const BoxDecoration(
                        color: AppColors.workout,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Text(
                  AppDateUtils.formatFull(_selectedDay),
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSizes.sm),
                if (selectedEntries.isEmpty)
                  const EmptyState(
                    icon: Icons.event_available_outlined,
                    message: 'No hay rutinas programadas este día',
                  )
                else
                  ...selectedEntries.map((entry) => _ScheduleTile(entry: entry)),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleTile extends ConsumerWidget {
  const _ScheduleTile({required this.entry});

  final WorkoutSchedule entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workout = entry.workout;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: AppCard(
        onTap: workout == null
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => WorkoutDetailScreen(workout: workout)),
                ),
        child: Row(
          children: [
            const IconBadge(icon: Icons.fitness_center, color: AppColors.workout),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout?.name ?? 'Rutina',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(entry.status.scheduleStatusLabel, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirmed = await ConfirmDialog.show(
                    context,
                    title: 'Quitar del calendario',
                    message: '¿Quitar esta rutina programada de este día?',
                  );
                  if (confirmed && entry.id != null) {
                    await ref
                        .read(workoutControllerProvider.notifier)
                        .deleteScheduleEntry(entry.id!);
                  }
                } else if (entry.id != null) {
                  await ref
                      .read(workoutControllerProvider.notifier)
                      .updateScheduleStatus(entry.id!, value);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'completed', child: Text('Marcar completado')),
                PopupMenuItem(value: 'skipped', child: Text('Marcar omitido')),
                PopupMenuItem(value: 'delete', child: Text('Quitar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
