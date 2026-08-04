import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_form_screen.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nueva receta'),
      ),
      body: recipesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: describeError(error),
          onRetry: () => ref.invalidate(recipesProvider),
        ),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const EmptyState(
              icon: Icons.restaurant_menu_outlined,
              message: 'Todavía no tienes recetas guardadas',
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(recipesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: recipes.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
