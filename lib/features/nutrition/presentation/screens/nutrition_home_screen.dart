import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/macro_bar.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../diet_generator/domain/entities/diet_plan_meal.dart';
import '../../../diet_generator/presentation/providers/diet_generator_provider.dart';
import '../../../diet_generator/presentation/screens/diet_generator_form_screen.dart';
import '../../domain/entities/meal_log.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/meal_log_tile.dart';
import 'add_meal_log_screen.dart';
import 'recipes_screen.dart';

class NutritionHomeScreen extends ConsumerWidget {
  const NutritionHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(todayMealLogsProvider);
    final dietPlans = ref.watch(dietPlanHistoryProvider).valueOrNull ?? const [];
    final latestPlan = dietPlans.isEmpty ? null : dietPlans.first;
    final mealSlot = currentMealSlot();
    final mealType = mealSlotToType(mealSlot);
    DietPlanMeal? suggestion;
    if (latestPlan != null) {
      for (final m in latestPlan.meals) {
        if (m.mealType == mealType) {
          suggestion = m;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Alimentación')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddMealLogScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: logsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(todayMealLogsProvider),
        ),
        data: (logs) {
          final totalCalories = logs.fold<double>(0, (sum, l) => sum + l.calories);
          final totalProtein = logs.fold<double>(0, (sum, l) => sum + l.proteinG);
          final totalCarbs = logs.fold<double>(0, (sum, l) => sum + l.carbsG);
          final totalFat = logs.fold<double>(0, (sum, l) => sum + l.fatG);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(todayMealLogsProvider);
              ref.invalidate(dietPlanHistoryProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${totalCalories.round()}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6, bottom: 6),
                            child: Text(
                              latestPlan != null
                                  ? '/ ${latestPlan.dailyCalories.round()} kcal hoy'
                                  : 'kcal hoy',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      MacroBar(
                        proteinG: totalProtein,
                        carbsG: totalCarbs,
                        fatG: totalFat,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DietGeneratorFormScreen()),
                  ),
                  child: const Row(
                    children: [
                      IconBadge(icon: Icons.calculate_outlined, color: AppColors.protein),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Generador de dieta',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text('Calcula tus calorías y macros según tu objetivo'),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RecipesScreen()),
                  ),
                  child: const Row(
                    children: [
                      IconBadge(icon: Icons.favorite, color: AppColors.protein),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recetas favoritas', style: TextStyle(fontWeight: FontWeight.w700)),
                            Text('Tus comidas guardadas para registrar rápido'),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                if (suggestion case final s?) ...[
                  const SizedBox(height: AppSizes.lg),
                  SectionHeader(title: 'Ahora toca: $mealSlot'),
                  AppCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddMealLogScreen(
                          initialName: s.suggestedFood,
                          initialMealType: mealType,
                          initialCalories: s.calories,
                          initialProtein: s.proteinG,
                          initialCarbs: s.carbsG,
                          initialFat: s.fatG,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const IconBadge(icon: Icons.restaurant, color: AppColors.calories),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.suggestedFood,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text('${s.calories.round()} kcal · según tu plan'),
                            ],
                          ),
                        ),
                        const Icon(Icons.add_circle_outline),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.lg),
                Text('Hoy', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSizes.sm),
                if (logs.isEmpty)
                  const EmptyState(
                    icon: Icons.restaurant_outlined,
                    message: 'Todavía no has registrado comidas hoy',
                  )
                else
                  ...logs.reversed.map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.sm),
                        child: MealLogTile(
                          log: log,
                          onDelete: () async {
                            final confirmed = await ConfirmDialog.show(
                              context,
                              title: 'Eliminar registro',
                              message: '¿Eliminar este registro de comida?',
                            );
                            if (confirmed && log.id != null) {
                              await ref
                                  .read(nutritionControllerProvider.notifier)
                                  .deleteMealLog(log.id!);
                            }
                          },
                        ),
                      )),
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}
