import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.title});
  final Widget child;
  final String? title;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(
    this.title,
    this.subtitle, {
    super.key,
    this.actions = const [],
  });
  final String title, subtitle;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 16,
      spacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Wrap(spacing: 8, runSpacing: 8, children: actions),
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Center(child: Text(text, textAlign: TextAlign.center)),
  );
}

Future<void> guarded(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se completó la operación: $e')),
      );
    }
  }
}

Future<bool> confirm(BuildContext context, String title, String text) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ) ??
    false;

class MonthPicker extends StatelessWidget {
  const MonthPicker({super.key, required this.value, required this.onChanged});
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        tooltip: 'Mes anterior',
        onPressed: () => onChanged(DateTime(value.year, value.month - 1)),
        icon: const Icon(Icons.chevron_left),
      ),
      TextButton(
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            helpText: 'Selecciona una fecha del mes',
          );
          if (date != null) onChanged(DateTime(date.year, date.month));
        },
        child: Text(DateFormat.yMMMM('es_PE').format(value)),
      ),
      IconButton(
        tooltip: 'Mes siguiente',
        onPressed: () => onChanged(DateTime(value.year, value.month + 1)),
        icon: const Icon(Icons.chevron_right),
      ),
    ],
  );
}

class Metric extends StatelessWidget {
  const Metric(this.label, this.value, this.icon, {super.key});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 215,
    child: SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(label),
        ],
      ),
    ),
  );
}
