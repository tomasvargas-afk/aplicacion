import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/supabase_tables.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/storage_service.dart';
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
  ConsumerState<AddMeasurementScreen> createState() =>
      _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends ConsumerState<AddMeasurementScreen> {
  DateTime _date = DateTime.now();
  bool _showMoreFields = false;
  File? _photo;
  bool _isUploadingPhoto = false;
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

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  void _showPhotoSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.of(context).pop();
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () {
                Navigator.of(context).pop();
                _pickPhoto(ImageSource.gallery);
              },
            ),
            if (_photo != null)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Quitar foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() => _photo = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    String? photoPath;
    final photo = _photo;
    if (photo != null) {
      setState(() => _isUploadingPhoto = true);
      try {
        photoPath = await ref.read(storageServiceProvider).uploadPrivateImage(
              bucket: SupabaseTables.progressPhotos,
              userId: user.id,
              file: photo,
              fileName: 'progress_${DateTime.now().millisecondsSinceEpoch}.jpg',
            );
      } catch (_) {
        if (mounted) {
          context.showSnackBar('No se pudo subir la foto', isError: true);
        }
      }
      if (mounted) setState(() => _isUploadingPhoto = false);
    }

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
      photoPath: photoPath,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final error = await ref
        .read(bodyTrackingControllerProvider.notifier)
        .addMeasurement(measurement);
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
            GestureDetector(
              onTap: _showPhotoSourceSheet,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  image: _photo != null
                      ? DecorationImage(
                          image: FileImage(_photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _photo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'Foto de progreso (opcional)',
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            AppTextField(
              controller: _weightController,
              label: useLb ? 'Peso (lb)' : 'Peso (kg)',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.percent,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _muscleMassController,
                      label: '% Músculo',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _waistController,
                      label: 'Cintura (cm)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _armController,
                      label: 'Brazo (cm)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _thighController,
                label: 'Pierna (cm)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
              isLoading: isLoading || _isUploadingPhoto,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
