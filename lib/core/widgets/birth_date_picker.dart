import 'package:flutter/material.dart';

const _months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];

/// Day/month/year dropdowns for entering a birth date. Deliberately avoids
/// the Material `showDatePicker` calendar grid — picking a decades-old
/// date by flipping months is slow, and the calendar grid has had
/// unreliable touch handling on mobile Safari in Flutter web.
class BirthDatePicker extends StatelessWidget {
  const BirthDatePicker({super.key, required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  void _update({int? day, int? month, int? year}) {
    final now = DateTime.now();
    final currentYear = value?.year ?? now.year - 25;
    final currentMonth = value?.month ?? 1;
    final currentDay = value?.day ?? 1;

    final newYear = year ?? currentYear;
    final newMonth = month ?? currentMonth;
    final maxDay = _daysInMonth(newYear, newMonth);
    final newDay = (day ?? currentDay).clamp(1, maxDay).toInt();

    onChanged(DateTime(newYear, newMonth, newDay));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final years = List.generate(100, (i) => now.year - 5 - i);
    final maxDay = value != null ? _daysInMonth(value!.year, value!.month) : 31;
    final days = List.generate(maxDay, (i) => i + 1);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            initialValue: value?.day,
            isExpanded: true,
            hint: const Text('Día'),
            decoration: const InputDecoration(labelText: 'Día'),
            items: days
                .map((d) => DropdownMenuItem(value: d, child: Text('$d')))
                .toList(),
            onChanged: (d) => _update(day: d),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: DropdownButtonFormField<int>(
            initialValue: value?.month,
            isExpanded: true,
            hint: const Text('Mes'),
            decoration: const InputDecoration(labelText: 'Mes'),
            items: List.generate(12, (i) => i + 1)
                .map((m) => DropdownMenuItem(value: m, child: Text(_months[m - 1])))
                .toList(),
            onChanged: (m) => _update(month: m),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: DropdownButtonFormField<int>(
            initialValue: value?.year,
            isExpanded: true,
            hint: const Text('Año'),
            decoration: const InputDecoration(labelText: 'Año'),
            items: years
                .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                .toList(),
            onChanged: (y) => _update(year: y),
          ),
        ),
      ],
    );
  }
}
