import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/avatar_picker.dart';
import '../../../../core/widgets/birth_date_picker.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../diet_generator/domain/usecases/diet_calculator.dart';
import '../../domain/entities/profile.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final Profile? profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final _nameController =
      TextEditingController(text: widget.profile?.fullName ?? '');
  late final _heightController = TextEditingController(
    text: widget.profile?.heightCm?.toStringAsFixed(0) ?? '',
  );
  DateTime? _birthDate;
  ActivityLevel? _activityLevel;
  DietGoal? _goal;

  @override
  void initState() {
    super.initState();
    _birthDate = widget.profile?.birthDate;
    for (final a in ActivityLevel.values) {
      if (a.dbValue == widget.profile?.activityLevel) _activityLevel = a;
    }
    for (final g in DietGoal.values) {
      if (g.dbValue == widget.profile?.goal) _goal = g;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(File image) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final error = await ref.read(profileControllerProvider.notifier).updateAvatar(
          user.id,
          image,
        );
    if (!mounted) return;
    if (error != null) context.showSnackBar(error, isError: true);
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final updated = Profile(
      id: user.id,
      fullName: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      avatarUrl: widget.profile?.avatarUrl,
      birthDate: _birthDate,
      heightCm: double.tryParse(_heightController.text.replaceAll(',', '.')),
      activityLevel: _activityLevel?.dbValue,
      goal: _goal?.dbValue,
      weightUnit: widget.profile?.weightUnit ?? 'kg',
      themePreference: widget.profile?.themePreference ?? 'system',
      locale: widget.profile?.locale ?? 'es',
    );

    final error = await ref.read(profileControllerProvider.notifier).updateProfile(updated);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: [
            Center(
              child: AvatarPicker(
                currentImageUrl: widget.profile?.avatarUrl,
                onImageSelected: _pickAvatar,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: AppSizes.md),
            Text('Fecha de nacimiento', style: context.textTheme.titleSmall),
            const SizedBox(height: AppSizes.xs),
            BirthDatePicker(
              value: _birthDate,
              onChanged: (date) => setState(() => _birthDate = date),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Estatura (cm)'),
            ),
            const SizedBox(height: AppSizes.lg),
            Text('Nivel de actividad', style: context.textTheme.titleSmall),
            const SizedBox(height: AppSizes.xs),
            DropdownButtonFormField<ActivityLevel>(
              initialValue: _activityLevel,
              hint: const Text('Selecciona tu nivel de actividad'),
              items: ActivityLevel.values
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.label)))
                  .toList(),
              onChanged: (value) => setState(() => _activityLevel = value),
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
            PrimaryButton(
              label: 'Guardar',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
