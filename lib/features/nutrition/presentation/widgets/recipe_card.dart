import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../domain/entities/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconBadge(
            icon: recipe.isFavorite ? Icons.favorite : Icons.restaurant_menu,
            color: recipe.isFavorite ? AppColors.protein : AppColors.seed,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${recipe.calories.round()} kcal · P ${recipe.proteinG.round()}g · C ${recipe.carbsG.round()}g · G ${recipe.fatG.round()}g',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
