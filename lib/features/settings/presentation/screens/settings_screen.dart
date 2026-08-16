import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/security/app_lock_provider.dart';
import '../../../../core/services/app_lock_service.dart';
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
    final appLockEnabled = ref.watch(appLockEnabledProvider);

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
                      ButtonSegment(
                          value: WeightUnit.kg, label: Text('Kilogramos (kg)')),
                      ButtonSegment(
                          value: WeightUnit.lb, label: Text('Libras (lb)')),
                    ],
                    selected: {unit},
                    onSelectionChanged: (selection) => ref
                        .read(unitPreferenceProvider.notifier)
                        .setUnit(selection.first),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            const SectionHeader(title: 'Seguridad'),
            AppCard(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Bloqueo con Face ID / huella'),
                subtitle:
                    const Text('Pide autenticación cada vez que abres la app'),
                value: appLockEnabled,
                onChanged: (value) async {
                  if (value) {
                    final ok = await AppLockService.instance.authenticate();
                    if (!ok) return;
                    ref.read(appLockUnlockedProvider.notifier).state = true;
                  }
                  await ref
                      .read(appLockEnabledProvider.notifier)
                      .setEnabled(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
