import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/diet_plan_meal.dart';

const _mealTypeLabels = {
  'breakfast': 'Desayuno',
  'lunch': 'Almuerzo',
  'dinner': 'Cena',
  'snack': 'Snack',
};

const _mealTypeIcons = {
  'breakfast': Icons.wb_sunny_outlined,
  'lunch': Icons.lunch_dining_outlined,
  'dinner': Icons.dinner_dining_outlined,
  'snack': Icons.apple_outlined,
};

class SampleMenuList extends StatelessWidget {
  const SampleMenuList({super.key, required this.meals});

  final List<DietPlanMeal> meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: meals.map((meal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_mealTypeIcons[meal.mealType] ?? Icons.restaurant,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _mealTypeLabels[meal.mealType] ?? meal.mealType,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(meal.suggestedFood,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '${meal.calories.round()} kcal · P ${meal.proteinG.round()}g · C ${meal.carbsG.round()}g · G ${meal.fatG.round()}g',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
