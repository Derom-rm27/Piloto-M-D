import 'package:flutter/material.dart';
import '../core/domain/production.dart';

class EntryField extends StatelessWidget {
  const EntryField(
    this.label,
    this.controller, {
    super.key,
    this.required = false,
    this.numeric = false,
    this.integer = false,
    this.lines = 1,
  });
  final String label;
  final TextEditingController controller;
  final bool required, numeric, integer;
  final int lines;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      maxLines: lines,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      validator: (s) {
        if (required && (s ?? '').trim().isEmpty) return 'Completa este campo';
        if (numeric && (s ?? '').isNotEmpty) {
          final n = double.tryParse(s!.replaceAll(',', '.'));
          if (n == null ||
              !n.isFinite ||
              n < 0 ||
              (integer && n != n.roundToDouble())) {
            return integer
                ? 'Ingresa un entero positivo o cero'
                : 'Ingresa un número positivo o cero';
          }
        }
        return null;
      },
    ),
  );
}

class ChoiceField extends StatelessWidget {
  const ChoiceField(
    this.label,
    this.value,
    this.options,
    this.onChanged, {
    super.key,
  });
  final String label;
  final String? value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<String>(
      key: ValueKey('$label/$value/${options.length}'),
      initialValue: options.containsKey(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: options.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (s) => s == null ? 'Selecciona una opción' : null,
    ),
  );
}

class DateField extends StatelessWidget {
  const DateField(this.label, this.value, this.onChanged, {super.key});
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: OutlinedButton.icon(
      onPressed: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (d != null) onChanged(d);
      },
      icon: const Icon(Icons.calendar_today_outlined, size: 18),
      label: Text('$label: ${dateKey(value)}'),
    ),
  );
}
