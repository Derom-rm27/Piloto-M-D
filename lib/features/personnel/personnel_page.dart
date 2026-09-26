import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../shared/widgets.dart';
import '../../shared/form_fields.dart';

class PersonnelPage extends StatefulWidget {
  const PersonnelPage({super.key, required this.store});
  final AppStore store;
  @override
  State<PersonnelPage> createState() => _PersonnelPageState();
}

class _PersonnelPageState extends State<PersonnelPage> {
  String filter = 'Activos', search = '';
  Future<void> details(RowData p) async {
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(fullName(p)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DNI: ${p['dni'] ?? '—'}'),
              Text('Teléfono: ${p['telefono'] ?? '—'}'),
              Text('Cargo: ${p['cargo'] ?? '—'}'),
              Text('Precio por hora: ${p['precio_h'] ?? '—'}'),
              Text(p['activo'] == false ? 'Inactivo' : 'Activo'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(c);
              await guarded(
                context,
                () => widget.store.save('personal', {
                  ...p,
                  'activo': p['activo'] == false,
                }),
              );
            },
            child: Text(p['activo'] == false ? 'Reactivar' : 'Desactivar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(c);
              edit(p);
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(c);
              final id = p['id_trabajador'];
              final used =
                  widget.store
                      .rows('registro_asistencia')
                      .any(
                        (r) =>
                            r['id_trabajador'] == id ||
                            r['id_supervisor'] == id,
                      ) ||
                  widget.store
                      .rows('jornadas_produccion')
                      .any((r) => r['id_supervisor'] == id);
              if (used) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Tiene registros históricos. Puedes desactivarlo.',
                      ),
                    ),
                  );
                }
                return;
              }
              if (await confirm(
                context,
                'Eliminar personal',
                'Se ocultará a ${fullName(p)}.',
              )) {
                if (mounted) {
                  await guarded(
                    context,
                    () => widget.store.remove('personal', p),
                  );
                }
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> edit([RowData? person]) async {
    await showDialog(
      context: context,
      builder: (c) => PersonnelEditor(store: widget.store, person: person),
    );
  }

  @override
  Widget build(BuildContext context) {
    final people =
        widget.store
            .rows('personal')
            .where(
              (p) =>
                  (filter == 'Todos' ||
                      (p['activo'] != false) == (filter == 'Activos')) &&
                  fullName(p).toLowerCase().contains(search.toLowerCase()),
            )
            .toList()
          ..sort((a, b) => fullName(a).compareTo(fullName(b)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          'Personal',
          'Tu equipo de trabajo',
          actions: [
            FilledButton.icon(
              onPressed: edit,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo personal'),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final f in ['Todos', 'Activos', 'Inactivos'])
              ChoiceChip(
                label: Text(f),
                selected: filter == f,
                onSelected: (_) => setState(() => filter = f),
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar por nombre completo',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (s) => setState(() => search = s),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: people.isEmpty
                ? const EmptyState('No hay personal para este filtro.')
                : ListView.separated(
                    itemCount: people.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (c, i) => ListTile(
                      title: Text(fullName(people[i])),
                      onTap: () => details(people[i]),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class PersonnelEditor extends StatefulWidget {
  const PersonnelEditor({super.key, required this.store, this.person});
  final AppStore store;
  final RowData? person;
  @override
  State<PersonnelEditor> createState() => _PersonnelEditorState();
}

class _PersonnelEditorState extends State<PersonnelEditor> {
  final form = GlobalKey<FormState>();
  bool saving = false;
  static const labels = {
    'nombre': 'Nombres',
    'apellido_paterno': 'Apellido paterno',
    'apellido_materno': 'Apellido materno',
    'dni': 'DNI',
    'telefono': 'Teléfono',
    'cargo': 'Cargo',
    'precio_h': 'Precio por hora',
  };
  late final fields = {
    for (final k in labels.keys)
      k: TextEditingController(text: '${widget.person?[k] ?? ''}'),
  };
  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.person == null ? 'Nuevo personal' : 'Editar personal'),
    content: SizedBox(
      width: 440,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final e in fields.entries)
                EntryField(
                  labels[e.key]!,
                  e.value,
                  required: e.key == 'nombre',
                  numeric: e.key == 'precio_h',
                ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: saving
            ? null
            : () async {
                if (!form.currentState!.validate()) return;
                setState(() => saving = true);
                await guarded(context, () async {
                  await widget.store.save('personal', {
                    ...?(widget.person),
                    'id_trabajador':
                        widget.person?['id_trabajador'] ?? const Uuid().v4(),
                    'activo': widget.person?['activo'] ?? true,
                    for (final e in fields.entries)
                      e.key: e.key == 'precio_h'
                          ? (e.value.text.isEmpty
                                ? null
                                : double.parse(
                                    e.value.text.replaceAll(',', '.'),
                                  ))
                          : e.value.text.trim(),
                  });
                  if (context.mounted) Navigator.pop(context);
                });
                if (mounted) setState(() => saving = false);
              },
        child: const Text('Guardar'),
      ),
    ],
  );
}
