import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/units/unit_converter.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
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

class _DietGeneratorFormScreenState extends ConsumerState<DietGeneratorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Sex _sex = Sex.male;
  ActivityLevel _activityLevel = ActivityLevel.moderate;
  DietGoal _goal = DietGoal.maintain;

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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.positiveNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _heightController,
                label: 'Estatura (cm)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.positiveNumber,
              ),
              const SizedBox(height: AppSizes.lg),
              Text('Nivel de actividad', style: context.textTheme.titleSmall),
              const SizedBox(height: AppSizes.xs),
              DropdownButtonFormField<ActivityLevel>(
                initialValue: _activityLevel,
                items: ActivityLevel.values
                    .map((a) => DropdownMenuItem(value: a, child: Text(a.label)))
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
