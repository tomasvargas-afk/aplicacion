import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/ai_food_estimate.dart';
import '../../domain/entities/barcode_food_result.dart';
import '../../domain/entities/meal_log.dart';
import '../providers/nutrition_provider.dart';
import 'ai_food_scan_screen.dart';
import 'barcode_scanner_screen.dart';

class AddMealLogScreen extends ConsumerStatefulWidget {
  const AddMealLogScreen({
    super.key,
    this.initialName,
    this.initialMealType,
    this.initialCalories,
    this.initialProtein,
    this.initialCarbs,
    this.initialFat,
  });

  final String? initialName;
  final String? initialMealType;
  final double? initialCalories;
  final double? initialProtein;
  final double? initialCarbs;
  final double? initialFat;

  @override
  ConsumerState<AddMealLogScreen> createState() => _AddMealLogScreenState();
}

class _AddMealLogScreenState extends ConsumerState<AddMealLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.initialName ?? '');
  late final _caloriesController =
      TextEditingController(text: widget.initialCalories?.toStringAsFixed(0) ?? '');
  late final _proteinController =
      TextEditingController(text: widget.initialProtein?.toStringAsFixed(0) ?? '');
  late final _carbsController =
      TextEditingController(text: widget.initialCarbs?.toStringAsFixed(0) ?? '');
  late final _fatController =
      TextEditingController(text: widget.initialFat?.toStringAsFixed(0) ?? '');
  late String _mealType = widget.initialMealType ?? 'lunch';

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  Future<void> _scanBarcode() async {
    final result = await Navigator.of(context).push<BarcodeFoodResult>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _nameController.text = result.name;
      _caloriesController.text = result.calories.toStringAsFixed(0);
      _proteinController.text = result.proteinG.toStringAsFixed(0);
      _carbsController.text = result.carbsG.toStringAsFixed(0);
      _fatController.text = result.fatG.toStringAsFixed(0);
    });
  }

  Future<void> _scanPhoto() async {
    final result = await Navigator.of(context).push<AiFoodEstimate>(
      MaterialPageRoute(builder: (_) => const AiFoodScanScreen()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _nameController.text = result.name;
      _caloriesController.text = result.calories.toStringAsFixed(0);
      _proteinController.text = result.proteinG.toStringAsFixed(0);
      _carbsController.text = result.carbsG.toStringAsFixed(0);
      _fatController.text = result.fatG.toStringAsFixed(0);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final log = MealLog(
      userId: user.id,
      customName: _nameController.text.trim(),
      mealType: _mealType,
      calories: _num(_caloriesController),
      proteinG: _num(_proteinController),
      carbsG: _num(_carbsController),
      fatG: _num(_fatController),
      loggedAt: DateTime.now(),
    );

    final error = await ref.read(nutritionControllerProvider.notifier).logMeal(log);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(nutritionControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar comida'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'Foto de comida (IA)',
            onPressed: _scanPhoto,
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear código de barras',
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Nombre',
                validator: Validators.required,
                autofocus: widget.initialName == null,
              ),
              const SizedBox(height: AppSizes.md),
              Wrap(
                spacing: AppSizes.sm,
                children: mealTypeLabels.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: _mealType == entry.key,
                    onSelected: (_) => setState(() => _mealType = entry.key),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _caloriesController,
                      label: 'Calorías',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _proteinController,
                      label: 'Proteína (g)',
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
                      controller: _carbsController,
                      label: 'Carbos (g)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _fatController,
                      label: 'Grasas (g)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              PrimaryButton(
                label: 'Registrar',
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
