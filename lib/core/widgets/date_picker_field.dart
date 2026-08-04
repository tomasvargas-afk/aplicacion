import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final effectiveFirst = firstDate ?? DateTime(1950);
        final effectiveLast = lastDate ?? DateTime.now();
        var initial = value ?? effectiveLast;
        if (initial.isBefore(effectiveFirst)) initial = effectiveFirst;
        if (initial.isAfter(effectiveLast)) initial = effectiveLast;

        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: effectiveFirst,
          lastDate: effectiveLast,
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
        ),
        child: Text(
          value != null ? AppDateUtils.formatFull(value!) : 'Selecciona una fecha',
        ),
      ),
    );
  }
}
