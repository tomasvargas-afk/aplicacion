import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/macro_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/recipe.dart';
import '../providers/nutrition_provider.dart';
import 'add_meal_log_screen.dart';
import 'recipe_form_screen.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => RecipeFormScreen(recipe: recipe)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Eliminar receta',
                message: '¿Eliminar "${recipe.name}"?',
              );
              if (confirmed && recipe.id != null) {
                await ref.read(nutritionControllerProvider.notifier).deleteRecipe(recipe.id!);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            Text(
              '${recipe.calories.round()} kcal',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSizes.sm),
            MacroBar(proteinG: recipe.proteinG, carbsG: recipe.carbsG, fatG: recipe.fatG),
            if (recipe.ingredients.isNotEmpty) ...[
              const SizedBox(height: AppSizes.lg),
              Text('Ingredientes', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.sm),
              ...recipe.ingredients.map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('•  $i'),
                  )),
            ],
            if (recipe.instructions != null && recipe.instructions!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.lg),
              Text('Instrucciones', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.sm),
              Text(recipe.instructions!),
            ],
            const SizedBox(height: AppSizes.xl),
            PrimaryButton(
              label: 'Registrar esta comida',
              icon: Icons.add,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddMealLogScreen(
                    initialName: recipe.name,
                    initialCalories: recipe.calories,
                    initialProtein: recipe.proteinG,
                    initialCarbs: recipe.carbsG,
                    initialFat: recipe.fatG,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
