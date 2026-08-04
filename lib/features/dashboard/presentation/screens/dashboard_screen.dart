import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../core/widgets/progress_ring.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../diet_generator/presentation/providers/diet_generator_provider.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../statistics/presentation/providers/progress_summary_provider.dart';
import '../../../water/presentation/providers/water_provider.dart';
import '../../../workouts/presentation/providers/workout_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).valueOrNull;
    final user = ref.watch(currentUserProvider);
    final summary = ref.watch(progressSummaryProvider).valueOrNull;

    final workouts = ref.watch(workoutsProvider).valueOrNull ?? const [];
    final workoutLogs = ref.watch(workoutLogsProvider).valueOrNull ?? const [];
    final trainedToday = workoutLogs.any(
      (l) =>
          l.completedAt != null &&
          AppDateUtils.isSameDay(l.completedAt!, DateTime.now()),
    );
    final suggestedWorkout = workouts.isEmpty ? null : workouts.first;

    final todayCalories = ref.watch(todayCaloriesProvider).valueOrNull ?? 0;
    final dietPlans =
        ref.watch(dietPlanHistoryProvider).valueOrNull ?? const [];
    final calorieTarget = dietPlans.isEmpty
        ? null
        : dietPlans.first.dailyCalories;

    final waterToday = ref.watch(todayWaterTotalProvider);
    final waterGoal = ref.watch(waterGoalProvider);
    final waterRemaining = (waterGoal - waterToday).clamp(0, waterGoal);

    final nextReminder = ref.watch(nextReminderProvider);

    final goals = ref.watch(goalsProvider).valueOrNull ?? const [];
    final activeGoals = goals
        .where((g) => g.status == 'active')
        .take(3)
        .toList();

    final displayName = (profile?.fullName?.isNotEmpty ?? false)
        ? profile!.fullName!.split(' ').first
        : (user?.email.split('@').first ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(workoutsProvider);
          ref.invalidate(workoutLogsProvider);
          ref.invalidate(todayCaloriesProvider);
          ref.invalidate(dietPlanHistoryProvider);
          ref.invalidate(goalsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            Text(
              '${greetingForNow()}, $displayName 👋',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (summary != null && summary.currentStreak > 0) ...[
              const SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.workout,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${summary.currentStreak} ${summary.currentStreak == 1 ? 'día seguido' : 'días seguidos'} 🔥',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSizes.lg),

            // Entrenamiento de hoy
            AppCard(
              onTap: () => context.go(RoutePaths.workouts),
              child: Row(
                children: [
                  IconBadge(
                    icon: trainedToday ? Icons.check_circle : Icons.fitness_center,
                    color: trainedToday ? AppColors.success : AppColors.workout,
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainedToday
                              ? '¡Ya entrenaste hoy!'
                              : 'Entrenamiento de hoy',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          trainedToday
                              ? 'Sigue así 💪'
                              : (suggestedWorkout?.name ??
                                    'Crea tu primera rutina'),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // Próxima comida
            AppCard(
              onTap: () => context.go(RoutePaths.nutrition),
              child: Row(
                children: [
                  const IconBadge(icon: Icons.restaurant, color: AppColors.protein),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Próxima comida',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(currentMealSlot()),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // Agua + Calorías restantes, lado a lado
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: AppCard(
                      onTap: () => context.push(RoutePaths.water),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconBadge(icon: Icons.water_drop, color: AppColors.water, size: 36),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            '${(waterRemaining / 1000).toStringAsFixed(1)} L',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const Text(
                            'agua restante',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppCard(
                      onTap: () => context.go(RoutePaths.nutrition),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconBadge(
                            icon: Icons.local_fire_department,
                            color: AppColors.calories,
                            size: 36,
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            calorieTarget != null
                                ? '${(calorieTarget - todayCalories).clamp(0, calorieTarget).round()}'
                                : '—',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            calorieTarget != null
                                ? 'kcal restantes'
                                : 'genera tu plan',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // Próximo recordatorio
            AppCard(
              onTap: () => context.push(RoutePaths.reminders),
              child: Row(
                children: [
                  const IconBadge(icon: Icons.notifications_outlined, color: AppColors.info),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Próximo recordatorio',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          nextReminder != null
                              ? '${nextReminder.label} · ${nextReminder.formatted}'
                              : 'No tienes recordatorios activos',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Objetivos del día
            SectionHeader(
              title: 'Tus objetivos',
              actionLabel: 'Ver todos',
              onAction: () => context.push(RoutePaths.goals),
            ),
            if (activeGoals.isEmpty)
              EmptyState(
                icon: Icons.flag_outlined,
                message: 'No tienes objetivos activos',
                actionLabel: 'Crear objetivo',
                onAction: () => context.push(RoutePaths.goals),
              )
            else
              ...activeGoals.map((goal) {
                final progress = ref.watch(goalProgressProvider(goal));
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: AppCard(
                    child: Row(
                      children: [
                        ProgressRing(
                          progress: progress,
                          size: 48,
                          strokeWidth: 5,
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Text(
                            goal.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}
