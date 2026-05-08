import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final DateTime? initialDate;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final IconData prefixIcon;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.controller,
    required this.onDateSelected,
    this.initialDate,
    this.prefixIcon = Icons.calendar_today,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(picked);
          onDateSelected(picked);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: colorScheme.primary),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}