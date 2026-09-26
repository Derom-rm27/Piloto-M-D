import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/data/app_store.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets.dart';
import '../../shared/form_fields.dart';
import '../reports/export_actions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.store,
    required this.appearance,
  });
  final AppStore store;
  final Appearance appearance;
  Widget palette(
    BuildContext context,
    String title,
    Color? current,
    ValueChanged<Color?> set,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        children: [
          for (final color in AppColors.palette)
            Semantics(
              label: 'Elegir color ${AppColors.palette.indexOf(color) + 1}',
              selected: current == color,
              button: true,
              child: InkWell(
                onTap: () => set(color),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: current == color
                        ? Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 3,
                          )
                        : null,
                  ),
                  child: current == color
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ),
            ),
          IconButton(
            tooltip: 'Restablecer color',
            onPressed: () => set(null),
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
    ],
  );
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeading(
              'Configuración',
              'Haz tuyo el espacio de trabajo',
            ),
            SectionCard(
              title: 'Apariencia',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Claro'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Oscuro'),
                      ),
                    ],
                    selected: {appearance.mode},
                    onSelectionChanged: (s) {
                      appearance.mode = s.first;
                      appearance.save();
                    },
                  ),
                  const SizedBox(height: 20),
                  ChoiceField(
                    'Tipografía',
                    appearance.font,
                    {
                      'Inter': 'Inter',
                      'Lato': 'Lato',
                      'Merriweather': 'Merriweather',
                    },
                    (s) {
                      appearance.font = s!;
                      appearance.save();
                    },
                  ),
                  palette(context, 'Color principal', appearance.primary, (c) {
                    appearance.primary = c;
                    appearance.save();
                  }),
                  const SizedBox(height: 16),
                  palette(context, 'Botones', appearance.button, (c) {
                    appearance.button = c;
                    appearance.save();
                  }),
                  const Divider(height: 32),
                  Text(
                    'Vista previa',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Producción de hoy',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text('Cada registro, en su lugar.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Guardar jornada'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Datos en este dispositivo',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.status),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: store.syncing ? null : store.sync,
                        icon: const Icon(Icons.sync),
                        label: const Text('Sincronizar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => guarded(context, () async {
                          await saveBytes(
                            Uint8List.fromList(
                              utf8.encode(await store.backup()),
                            ),
                            'Respaldo_MD.json',
                            'application/json',
                          );
                        }),
                        icon: const Icon(Icons.download),
                        label: const Text('Guardar respaldo'),
                      ),
                    ],
                  ),
                  if (store.syncError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: OutlinedButton(
                        onPressed: () => reviewConflict(context),
                        child: const Text('Revisar envío pendiente'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> reviewConflict(BuildContext context) async {
    await guarded(context, () async {
      final queue = await store.db.query('outbox', orderBy: 'seq', limit: 1);
      if (queue.isEmpty) return;
      final changes = List<Map<String, dynamic>>.from(
        (jsonDecode(queue.first['body'] as String) as List).map(
          (x) => Map<String, dynamic>.from(x),
        ),
      );
      final remote = <Map<String, dynamic>>[];
      for (final op in changes) {
        final table = op['table'] as String, pk = primaryKeys[op['table']]!;
        final row = await store.client!
            .from(table)
            .select()
            .eq(pk, op['after'][pk])
            .maybeSingle();
        remote.add({...op, 'before': row});
      }
      if (!context.mounted) return;
      final apply = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Revisar cambios pendientes'),
          content: SizedBox(
            width: 650,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compara los registros antes de conservar tus valores locales. Se volverá a verificar el servidor al enviarlos.',
                  ),
                  for (final op in remote) ...[
                    const Divider(),
                    Text(
                      '${op['table']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      'Servidor:\n${const JsonEncoder.withIndent('  ').convert(op['before'])}\n\nLocal:\n${const JsonEncoder.withIndent('  ').convert(op['after'])}',
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cerrar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Conservar cambios locales'),
            ),
          ],
        ),
      );
      if (apply != true) return;
      await store.db.update(
        'outbox',
        {'body': jsonEncode(remote)},
        where: 'seq=?',
        whereArgs: [queue.first['seq']],
      );
      await store.sync();
    });
  }
}
