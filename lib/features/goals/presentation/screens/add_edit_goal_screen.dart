import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/date_picker_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../body_tracking/presentation/providers/body_tracking_provider.dart';
import '../../domain/entities/goal.dart';
import '../providers/goals_provider.dart';

const _defaultTitles = {
  GoalType.weight: 'Alcanzar mi peso objetivo',
  GoalType.water: 'Beber más agua al día',
  GoalType.workoutFrequency: 'Entrenar más veces por semana',
  GoalType.sleep: 'Dormir mejor',
};

const _units = {
  GoalType.weight: 'kg',
  GoalType.water: 'L/día',
  GoalType.workoutFrequency: 'veces/semana',
  GoalType.sleep: 'horas',
};

class AddEditGoalScreen extends ConsumerStatefulWidget {
  const AddEditGoalScreen({super.key});

  @override
  ConsumerState<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends ConsumerState<AddEditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  GoalType _type = GoalType.workoutFrequency;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleController.text = _defaultTitles[_type] ?? '';
    _unitController.text = _units[_type] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _onTypeChanged(GoalType type) {
    setState(() {
      _type = type;
      if (_defaultTitles.containsKey(type)) _titleController.text = _defaultTitles[type]!;
      _unitController.text = _units[type] ?? '';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    double baselineForWeight = 0;
    if (_type == GoalType.weight) {
      final measurements = ref.read(bodyMeasurementHistoryProvider).valueOrNull ?? const [];
      final withWeight = measurements.where((m) => m.weightKg != null);
      baselineForWeight = withWeight.isEmpty ? 0 : withWeight.last.weightKg!;
    }

    final goal = Goal(
      userId: user.id,
      type: _type.dbValue,
      title: _titleController.text.trim(),
      targetValue: double.parse(_targetController.text.replaceAll(',', '.')),
      currentValue: baselineForWeight,
      unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      deadline: _deadline,
    );

    final error = await ref.read(goalsControllerProvider.notifier).saveGoal(goal);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(goalsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo objetivo')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              Text('Tipo de objetivo', style: context.textTheme.titleSmall),
              const SizedBox(height: AppSizes.xs),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: GoalType.values.map((type) {
                  return ChoiceChip(
                    avatar: Icon(type.icon, size: 16),
                    label: Text(type.label),
                    selected: _type == type,
                    onSelected: (_) => _onTypeChanged(type),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.lg),
              AppTextField(
                controller: _titleController,
                label: 'Título',
                validator: Validators.required,
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _targetController,
                      label: 'Meta',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: Validators.positiveNumber,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(controller: _unitController, label: 'Unidad'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              DatePickerField(
                label: 'Fecha límite (opcional)',
                value: _deadline,
                onChanged: (date) => setState(() => _deadline = date),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)),
              ),
              const SizedBox(height: AppSizes.xl),
              PrimaryButton(
                label: 'Guardar objetivo',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
