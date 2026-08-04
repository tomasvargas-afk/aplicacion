import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/units/unit_converter.dart';
import '../../../../core/units/unit_preference_provider.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/date_picker_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/body_measurement.dart';
import '../providers/body_tracking_provider.dart';

class AddMeasurementScreen extends ConsumerStatefulWidget {
  const AddMeasurementScreen({super.key});

  @override
  ConsumerState<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends ConsumerState<AddMeasurementScreen> {
  DateTime _date = DateTime.now();
  bool _showMoreFields = false;
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();
  final _armController = TextEditingController();
  final _thighController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _weightController,
      _bodyFatController,
      _muscleMassController,
      _chestController,
      _waistController,
      _hipController,
      _armController,
      _thighController,
      _notesController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parse(String text) {
    if (text.trim().isEmpty) return null;
    return double.tryParse(text.trim().replaceAll(',', '.'));
  }

  double? _weightKg() {
    final raw = _parse(_weightController.text);
    if (raw == null) return null;
    final useLb = ref.read(unitPreferenceProvider) == WeightUnit.lb;
    return useLb ? UnitConverter.lbToKg(raw) : raw;
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final measurement = BodyMeasurement(
      userId: user.id,
      measuredAt: _date,
      weightKg: _weightKg(),
      bodyFatPercent: _parse(_bodyFatController.text),
      muscleMassPercent: _parse(_muscleMassController.text),
      chestCm: _parse(_chestController.text),
      waistCm: _parse(_waistController.text),
      hipCm: _parse(_hipController.text),
      armCm: _parse(_armController.text),
      thighCm: _parse(_thighController.text),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    final error =
        await ref.read(bodyTrackingControllerProvider.notifier).addMeasurement(measurement);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bodyTrackingControllerProvider).isLoading;
    final useLb = ref.watch(unitPreferenceProvider) == WeightUnit.lb;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva medición')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            DatePickerField(
              label: 'Fecha',
              value: _date,
              onChanged: (date) => setState(() => _date = date),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              controller: _weightController,
              label: useLb ? 'Peso (lb)' : 'Peso (kg)',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.monitor_weight_outlined,
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.sm),
            if (!_showMoreFields)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showMoreFields = true),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Añadir más medidas'),
                ),
              ),
            if (_showMoreFields) ...[
              const SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _bodyFatController,
                      label: '% Grasa',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.percent,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _muscleMassController,
                      label: '% Músculo',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.fitness_center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _chestController,
                      label: 'Pecho (cm)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _waistController,
                      label: 'Cintura (cm)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _hipController,
                      label: 'Cadera (cm)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _armController,
                      label: 'Brazo (cm)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _thighController,
                label: 'Pierna (cm)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _notesController,
                label: 'Notas (opcional)',
                maxLines: 3,
              ),
            ],
            const SizedBox(height: AppSizes.lg),
            PrimaryButton(
              label: 'Guardar medición',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
