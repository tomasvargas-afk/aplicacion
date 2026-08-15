import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/barcode_food_result.dart';
import '../../domain/entities/recipe.dart';
import '../providers/nutrition_provider.dart';
import 'barcode_scanner_screen.dart';

class RecipeFormScreen extends ConsumerStatefulWidget {
  const RecipeFormScreen({super.key, this.recipe});

  final Recipe? recipe;

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.recipe?.name ?? '');
  late final _ingredientsController =
      TextEditingController(text: widget.recipe?.ingredients.join('\n') ?? '');
  late final _instructionsController =
      TextEditingController(text: widget.recipe?.instructions ?? '');
  late final _caloriesController =
      TextEditingController(text: widget.recipe?.calories.toStringAsFixed(0) ?? '');
  late final _proteinController =
      TextEditingController(text: widget.recipe?.proteinG.toStringAsFixed(0) ?? '');
  late final _carbsController =
      TextEditingController(text: widget.recipe?.carbsG.toStringAsFixed(0) ?? '');
  late final _fatController =
      TextEditingController(text: widget.recipe?.fatG.toStringAsFixed(0) ?? '');
  late bool _isFavorite = widget.recipe?.isFavorite ?? false;
  String? _barcode;

  @override
  void initState() {
    super.initState();
    _barcode = widget.recipe?.barcode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
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
      _barcode = result.barcode;
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

    final recipe = Recipe(
      id: widget.recipe?.id,
      userId: user.id,
      name: _nameController.text.trim(),
      ingredients: _ingredientsController.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      instructions:
          _instructionsController.text.trim().isEmpty ? null : _instructionsController.text.trim(),
      calories: _num(_caloriesController),
      proteinG: _num(_proteinController),
      carbsG: _num(_carbsController),
      fatG: _num(_fatController),
      isFavorite: _isFavorite,
      barcode: _barcode,
    );

    final error = await ref.read(nutritionControllerProvider.notifier).saveRecipe(recipe);
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
        title: Text(widget.recipe == null ? 'Nueva receta' : 'Editar receta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear código de barras',
            onPressed: _scanBarcode,
          ),
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
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
                label: 'Nombre de la receta',
                validator: Validators.required,
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
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _ingredientsController,
                label: 'Ingredientes (uno por línea)',
                maxLines: 4,
              ),
              const SizedBox(height: AppSizes.md),
              AppTextField(
                controller: _instructionsController,
                label: 'Instrucciones (opcional)',
                maxLines: 4,
              ),
              const SizedBox(height: AppSizes.xl),
              PrimaryButton(
                label: 'Guardar receta',
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
