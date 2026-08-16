import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/fade_slide_in.dart';
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
    final calorieTarget =
        dietPlans.isEmpty ? null : dietPlans.first.dailyCalories;

    final waterToday = ref.watch(todayWaterTotalProvider);
    final waterGoal = ref.watch(waterGoalProvider);
    final waterRemaining = (waterGoal - waterToday).clamp(0, waterGoal);

    final nextReminder = ref.watch(nextReminderProvider);

    final stepsPermission =
        ref.watch(stepsPermissionProvider).valueOrNull ?? false;
    final stepsToday = ref.watch(stepsTodayProvider).valueOrNull ?? 0;
    final stepsGoal = ref.watch(stepsGoalProvider);

    final goals = ref.watch(goalsProvider).valueOrNull ?? const [];
    final activeGoals =
        goals.where((g) => g.status == 'active').take(3).toList();

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
            _DashboardHero(
              greeting: '${greetingForNow()}, $displayName 👋',
              streak: (summary != null && summary.currentStreak > 0)
                  ? summary.currentStreak
                  : null,
            ),
            const SizedBox(height: AppSizes.lg),

            // Entrenamiento de hoy
            FadeSlideIn(
              index: 0,
              child: AppCard(
                onTap: () => context.go(RoutePaths.workouts),
                child: Row(
                  children: [
                    IconBadge(
                      icon: trainedToday
                          ? Icons.check_circle
                          : Icons.fitness_center,
                      color:
                          trainedToday ? AppColors.success : AppColors.workout,
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
            ),
            const SizedBox(height: AppSizes.sm),

            // Próxima comida
            FadeSlideIn(
              index: 1,
              child: AppCard(
                onTap: () => context.go(RoutePaths.nutrition),
                child: Row(
                  children: [
                    const IconBadge(
                        icon: Icons.restaurant, color: AppColors.protein),
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
            ),
            const SizedBox(height: AppSizes.sm),

            // Agua + Calorías restantes, lado a lado
            FadeSlideIn(
              index: 2,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: AppCard(
                        onTap: () => context.push(RoutePaths.water),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const IconBadge(
                                icon: Icons.water_drop,
                                color: AppColors.water,
                                size: 36),
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
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: AppCard(
                        onTap: stepsPermission
                            ? null
                            : () => ref
                                .read(
                                    stepsPermissionControllerProvider.notifier)
                                .request(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const IconBadge(
                              icon: Icons.directions_walk,
                              color: AppColors.steps,
                              size: 36,
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              stepsPermission ? '$stepsToday' : '—',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              stepsPermission
                                  ? 'de $stepsGoal pasos'
                                  : 'activar pasos',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),

            // Próximo recordatorio
            FadeSlideIn(
              index: 3,
              child: AppCard(
                onTap: () => context.push(RoutePaths.reminders),
                child: Row(
                  children: [
                    const IconBadge(
                        icon: Icons.notifications_outlined,
                        color: AppColors.info),
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
              ...activeGoals.asMap().entries.map((entry) {
                final goal = entry.value;
                final progress = ref.watch(goalProgressProvider(goal));
                return FadeSlideIn(
                  index: 4 + entry.key,
                  child: Padding(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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

/// Gradient greeting card at the top of the dashboard — the "hero" moment
/// that replaces the old plain-text greeting with something that feels
/// like a real landing spot instead of a settings page.
class _DashboardHero extends StatelessWidget {
  const _DashboardHero({required this.greeting, this.streak});

  final String greeting;
  final int? streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.seed, AppColors.seedDeep],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.seed.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -24,
              top: -36,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -40,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                ),
                if (streak != null) ...[
                  const SizedBox(height: AppSizes.sm),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSm + 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$streak ${streak == 1 ? 'día seguido' : 'días seguidos'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
