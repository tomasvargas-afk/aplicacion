import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/diet_generator_provider.dart';

class DietPlanHistoryScreen extends ConsumerWidget {
  const DietPlanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(dietPlanHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de dietas')),
      body: historyAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(dietPlanHistoryProvider),
        ),
        data: (plans) {
          if (plans.isEmpty) {
            return const EmptyState(
              icon: Icons.restaurant_menu_outlined,
              message: 'Todavía no has generado ningún plan de alimentación',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: plans.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) {
              final plan = plans[index];
              return AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${plan.dailyCalories.round()} kcal/día',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'P ${plan.proteinG.round()}g · C ${plan.carbsG.round()}g · G ${plan.fatG.round()}g',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (plan.generatedAt != null)
                            Text(
                              AppDateUtils.formatFull(plan.generatedAt!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
