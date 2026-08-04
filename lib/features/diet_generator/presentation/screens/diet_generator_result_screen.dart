import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/diet_generator_provider.dart';
import '../widgets/macro_result_card.dart';
import '../widgets/sample_menu_list.dart';

class DietGeneratorResultScreen extends ConsumerWidget {
  const DietGeneratorResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = ref.watch(dietGeneratorControllerProvider);
    final plan = controllerState.valueOrNull;
    final isSaving = controllerState.isLoading;
    final isSaved = plan?.id != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Tu plan de alimentación')),
      body: plan == null
          ? const LoadingIndicator()
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.lg),
                children: [
                  MacroResultCard(plan: plan),
                  const SizedBox(height: AppSizes.lg),
                  Text('Ejemplo de menú diario', style: context.textTheme.titleMedium),
                  const SizedBox(height: AppSizes.sm),
                  SampleMenuList(meals: plan.meals),
                  const SizedBox(height: AppSizes.lg),
                  if (isSaved)
                    const Center(child: Text('✓ Guardado en tu historial'))
                  else
                    PrimaryButton(
                      label: 'Guardar en mi historial',
                      isLoading: isSaving,
                      onPressed: () async {
                        final error = await ref
                            .read(dietGeneratorControllerProvider.notifier)
                            .savePlan();
                        if (context.mounted && error != null) {
                          context.showSnackBar(error, isError: true);
                        } else if (context.mounted) {
                          context.showSnackBar('Plan guardado');
                        }
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
