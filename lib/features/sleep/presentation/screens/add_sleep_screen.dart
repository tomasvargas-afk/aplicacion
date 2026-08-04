import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/date_picker_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/sleep_log.dart';
import '../providers/sleep_provider.dart';

class AddSleepScreen extends ConsumerStatefulWidget {
  const AddSleepScreen({super.key});

  @override
  ConsumerState<AddSleepScreen> createState() => _AddSleepScreenState();
}

class _AddSleepScreenState extends ConsumerState<AddSleepScreen> {
  DateTime _date = DateTime.now();
  TimeOfDay _bedTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  int _quality = 3;

  double get _computedHours {
    final bedMinutes = _bedTime.hour * 60 + _bedTime.minute;
    final wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    var diff = wakeMinutes - bedMinutes;
    if (diff <= 0) diff += 24 * 60;
    return diff / 60.0;
  }

  Future<void> _pickTime(bool isBedTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isBedTime ? _bedTime : _wakeTime,
    );
    if (picked == null) return;
    setState(() {
      if (isBedTime) {
        _bedTime = picked;
      } else {
        _wakeTime = picked;
      }
    });
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final log = SleepLog(
      userId: user.id,
      sleepDate: _date,
      hours: double.parse(_computedHours.toStringAsFixed(2)),
      quality: _quality,
      bedTime: _formatTimeOfDay(_bedTime),
      wakeTime: _formatTimeOfDay(_wakeTime),
    );

    final error = await ref.read(sleepControllerProvider.notifier).addLog(log);
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      Navigator.of(context).pop();
    }
  }

  String _formatTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(sleepControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar sueño')),
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
            Row(
              children: [
                Expanded(
                  child: _TimeField(
                    label: 'Hora de dormir',
                    time: _bedTime,
                    onTap: () => _pickTime(true),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: _TimeField(
                    label: 'Hora de despertar',
                    time: _wakeTime,
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              '${_computedHours.toStringAsFixed(1)} horas dormidas',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.lg),
            Text('Calidad del sueño', style: context.textTheme.titleSmall),
            Slider(
              value: _quality.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$_quality',
              onChanged: (value) => setState(() => _quality = value.round()),
            ),
            const SizedBox(height: AppSizes.lg),
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

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.time, required this.onTap});

  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.access_time, size: 20),
        ),
        child: Text(time.format(context)),
      ),
    );
  }
}
