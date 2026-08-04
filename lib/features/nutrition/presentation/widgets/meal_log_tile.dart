import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/meal_log.dart';

class MealLogTile extends StatelessWidget {
  const MealLogTile({super.key, required this.log, this.onDelete});

  final MealLog log;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.customName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${mealTypeLabels[log.mealType] ?? log.mealType} · ${log.calories.round()} kcal · '
                  'P ${log.proteinG.round()}g · C ${log.carbsG.round()}g · G ${log.fatG.round()}g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
