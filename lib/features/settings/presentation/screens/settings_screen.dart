import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final unit = ref.watch(unitPreferenceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Personalización')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            const SectionHeader(title: 'Tema'),
            AppCard(
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Claro'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Oscuro'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('Sistema'),
                    icon: Icon(Icons.brightness_auto_outlined),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) => ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(selection.first),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            const SectionHeader(title: 'Unidades'),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peso',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  SegmentedButton<WeightUnit>(
                    segments: const [
                      ButtonSegment(value: WeightUnit.kg, label: Text('Kilogramos (kg)')),
                      ButtonSegment(value: WeightUnit.lb, label: Text('Libras (lb)')),
                    ],
                    selected: {unit},
                    onSelectionChanged: (selection) =>
                        ref.read(unitPreferenceProvider.notifier).setUnit(selection.first),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
