import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/units/unit_converter.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../../profile/domain/entities/profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/usecases/diet_calculator.dart';
import '../providers/diet_generator_provider.dart';
import 'diet_generator_result_screen.dart';
import 'diet_plan_history_screen.dart';

class DietGeneratorFormScreen extends ConsumerStatefulWidget {
  const DietGeneratorFormScreen({super.key});

  @override
  ConsumerState<DietGeneratorFormScreen> createState() =>
      _DietGeneratorFormScreenState();
}

class _DietGeneratorFormScreenState
    extends ConsumerState<DietGeneratorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Sex _sex = Sex.male;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  DietGoal _goal = DietGoal.maintain;
  bool _prefilled = false;

  /// Pre-fills from the saved profile + latest body-tracking weight, once,
  /// so re-entering this screen doesn't silently reset to hardcoded
  /// defaults (Hombre/Moderado/Mantener) and produce a different result
  /// than last time without the user noticing.
  void _maybePrefill(Profile? profile, double? latestWeightKg, bool useLb) {
    if (_prefilled) return;
    if (profile == null && latestWeightKg == null) return;
    _prefilled = true;

    if (profile != null) {
      if (profile.sex == 'female') _sex = Sex.female;
      if (profile.heightCm != null) {
        _heightController.text = _trimZero(profile.heightCm!);
      }
      final age = profile.age;
      if (age != null) _ageController.text = age.toString();
      for (final a in ActivityLevel.values) {
        if (a.dbValue == profile.activityLevel) {
          _activityLevel = a;
          break;
        }
      }
      for (final g in DietGoal.values) {
        if (g.dbValue == profile.goal) {
          _goal = g;
          break;
        }
      }
    }

    if (latestWeightKg != null) {
      final display =
          useLb ? UnitConverter.kgToLb(latestWeightKg) : latestWeightKg;
      _weightController.text = _trimZero(display);
    }
  }

  String _trimZero(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final rawWeight = double.parse(_weightController.text.replaceAll(',', '.'));
    final useLb = ref.read(unitPreferenceProvider) == WeightUnit.lb;
    final weightKg = useLb ? UnitConverter.lbToKg(rawWeight) : rawWeight;

    ref.read(dietGeneratorControllerProvider.notifier).generate(
          weightKg: weightKg,
          heightCm: double.parse(_heightController.text.replaceAll(',', '.')),
          age: int.parse(_ageController.text),
          sex: _sex,
          activityLevel: _activityLevel,
          goal: _goal,
        );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DietGeneratorResultScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final useLb = ref.watch(unitPreferenceProvider) == WeightUnit.lb;
    final profile = ref.watch(profileProvider).valueOrNull;
    final measurements =
        ref.watch(bodyMeasurementHistoryProvider).valueOrNull ?? const [];
    double? latestWeightKg;
    for (final m in measurements.reversed) {
      if (m.weightKg != null) {
        latestWeightKg = m.weightKg;
        break;
      }
    }
    _maybePrefill(profile, latestWeightKg, useLb);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de dieta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DietPlanHistoryScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              Text(
                'Cuéntanos sobre ti y calculamos tus calorías y macros diarios',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSizes.lg),
              SegmentedButton<Sex>(
                segments: const [
                  ButtonSegment(value: Sex.male, label: Text('Hombre')),
                  ButtonSegment(value: Sex.female, label: Text('Mujer')),
                ],
                selected: {_sex},
                onSelectionChanged: (s) => setState(() => _sex = s.first),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _ageController,
                      label: 'Edad',
                      keyboardType: TextInputType.number,
                      validator: Validators.positiveNumber,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _weightController,
                      label: useLb ? 'Peso (lb)' : 'Peso (kg)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.positiveNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _heightController,
                label: 'Estatura (cm)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.positiveNumber,
              ),
              const SizedBox(height: AppSizes.lg),
              Text('Nivel de actividad', style: context.textTheme.titleSmall),
              const SizedBox(height: AppSizes.xs),
              DropdownButtonFormField<ActivityLevel>(
                initialValue: _activityLevel,
                items: ActivityLevel.values
                    .map(
                        (a) => DropdownMenuItem(value: a, child: Text(a.label)))
                    .toList(),
                onChanged: (value) => setState(() => _activityLevel = value!),
              ),
              const SizedBox(height: AppSizes.lg),
              Text('Objetivo', style: context.textTheme.titleSmall),
              const SizedBox(height: AppSizes.xs),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: DietGoal.values.map((g) {
                  return ChoiceChip(
                    label: Text(g.label),
                    selected: _goal == g,
                    onSelected: (_) => setState(() => _goal = g),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.xl),
              PrimaryButton(label: 'Calcular', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
