import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../shared/widgets.dart';
import '../../shared/form_fields.dart';

const productionFields = {
  'cant_batch': 'N° de batches de amasado',
  'batch_jarabe': 'N° de batches de jarabe',
  'cant_tinas': 'N° de tinas',
  'cant_extruido_tolva': 'Sacos extruido tolva',
  'pop_quinua_dosimetria': 'Sacos pop quinua · dosimetría',
  'cajas_pasas': 'Cajas de pasas utilizadas',
  'pop_kiwicha': 'Sacos pop kiwicha',
  'pop_quinua': 'Sacos pop quinua · mezclado',
  'merma_piso_crudo': 'Merma piso crudo (kg)',
  'merma_maquina': 'Merma máquina (kg)',
  'quemados': 'Quemados (kg)',
  'caja_blanco_rotos': 'Caja, blancos y rotos (kg)',
  'merma_piso_cocido': 'Piso cocido (kg)',
  'merma_piso': 'Merma piso (kg)',
  'merma_bobinas': 'Merma bobinas (kg)',
  'cinta_embalaje': 'Cinta de embalaje',
  'tampon': 'Tampón',
};
Future<void> openProductionEditor(
  BuildContext context,
  AppStore store, [
  Production? existing,
]) async {
  await Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => ProductionEditor(store: store, existing: existing),
    ),
  );
}

class ProductionEditor extends StatefulWidget {
  const ProductionEditor({super.key, required this.store, this.existing});
  final AppStore store;
  final Production? existing;
  @override
  State<ProductionEditor> createState() => _ProductionEditorState();
}

class _ProductionEditorState extends State<ProductionEditor> {
  final form = GlobalKey<FormState>();
  bool saving = false;
  late final String id = widget.existing?.id ?? const Uuid().v4();
  late String line = widget.existing?.row['tipo'] ?? 'Galletas',
      turn = widget.existing?.row['turno'] ?? 'Dia';
  late DateTime date =
      DateTime.tryParse('${widget.existing?.row['fecha']}') ?? DateTime.now();
  late String? supervisor = widget.existing?.row['id_supervisor'];
  late final fields = {
    for (final k in productionFields.keys)
      k: TextEditingController(
        text:
            '${widget.existing?.row[k] ?? (k == 'caja_blanco_rotos' ? widget.existing?.row['caja'] : null) ?? ''}',
      ),
  };
  late final notes = TextEditingController(
    text: widget.existing?.row['observaciones'] ?? '',
  );
  late final start = TextEditingController(
    text: widget.existing?.row['hora_inicio_envasado'] ?? '',
  );
  late final List<RowData> lots = [
    for (final l in widget.existing?.lots ?? <RowData>[]) Map.of(l),
  ];
  late final List<RowData> reels = [
    for (final b in widget.existing?.reels ?? <RowData>[]) Map.of(b),
  ];
  List<String> get visibleFields => line == 'Galletas'
      ? [
          'cant_batch',
          'merma_piso_crudo',
          'merma_maquina',
          'quemados',
          'caja_blanco_rotos',
          'merma_piso_cocido',
          'merma_bobinas',
          'cinta_embalaje',
          'tampon',
        ]
      : [
          'batch_jarabe',
          'cant_tinas',
          'cant_extruido_tolva',
          'pop_quinua_dosimetria',
          'cajas_pasas',
          'pop_kiwicha',
          'pop_quinua',
          'merma_bobinas',
          'merma_piso',
          'merma_maquina',
          'cinta_embalaje',
          'tampon',
        ];
  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    notes.dispose();
    start.dispose();
    super.dispose();
  }

  Future<void> lot([int? index]) async {
    final result = await showDialog<RowData>(
      context: context,
      builder: (_) => LotEditor(
        store: widget.store,
        line: line,
        jornadaId: id,
        row: index == null ? null : lots[index],
      ),
    );
    if (result != null) {
      setState(() {
        if (index == null) {
          lots.add(result);
        } else {
          lots[index] = result;
        }
      });
    }
  }

  Future<void> reel([int? index]) async {
    final result = await showDialog<RowData>(
      context: context,
      builder: (_) => ReelEditor(
        jornadaId: id,
        number: index == null ? reels.length + 1 : index + 1,
        row: index == null ? null : reels[index],
      ),
    );
    if (result != null) {
      setState(() {
        if (index == null) {
          reels.add(result);
        } else {
          reels[index] = result;
        }
      });
    }
  }

  Future<void> save() async {
    if (saving || !form.currentState!.validate()) return;
    String? error;
    if (lots.isEmpty) error = 'Agrega al menos un lote.';
    if (lots
            .map(
              (l) =>
                  '${l['id_producto']}/${l['numero_lote']}/${l['presentacion']}',
            )
            .toSet()
            .length !=
        lots.length) {
      error = 'Hay lotes repetidos en la jornada.';
    }
    final batches = number(
      fields[line == 'Galletas' ? 'cant_batch' : 'batch_jarabe']!.text
          .replaceAll(',', '.'),
    );
    if (line == 'Galletas' &&
        lots.map((l) => l['id_producto']).toSet().length > 1 &&
        (lots.any((l) => number(l['cant_batch']) <= 0) ||
            (lots.fold<double>(0, (s, l) => s + number(l['cant_batch'])) -
                        batches)
                    .abs() >
                .01)) {
      error =
          'Para varios productos, reparte los batches entre los lotes. La suma debe coincidir con la jornada.';
    }
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => saving = true);
    await guarded(context, () async {
      final row = <String, dynamic>{
        ...?(widget.existing?.row),
        'id_jornada': id,
        'fecha': dateKey(date),
        'turno': turn,
        'tipo': line,
        'id_supervisor': supervisor,
        'hora_inicio_envasado': start.text.trim().isEmpty
            ? null
            : start.text.trim(),
        'observaciones': notes.text.trim(),
        for (final k in visibleFields)
          k: fields[k]!.text.isEmpty
              ? null
              : double.parse(fields[k]!.text.replaceAll(',', '.')),
      };
      if (line == 'Barras') row['cant_batch'] = row['batch_jarabe'];
      final removed = <(String, RowData)>[];
      for (final l in widget.existing?.lots ?? <RowData>[]) {
        if (!lots.any((x) => x['id_lote'] == l['id_lote'])) {
          removed.add((
            'lotes_produccion',
            {...l, 'deleted_at': DateTime.now().toUtc().toIso8601String()},
          ));
        }
      }
      for (final b in widget.existing?.reels ?? <RowData>[]) {
        if (!reels.any((x) => x['id_bobina'] == b['id_bobina'])) {
          removed.add((
            'bobinas_produccion',
            {...b, 'deleted_at': DateTime.now().toUtc().toIso8601String()},
          ));
        }
      }
      await widget.store.saveBatch([
        ('jornadas_produccion', row),
        for (final l in lots) ('lotes_produccion', l),
        for (var i = 0; i < reels.length; i++)
          ('bobinas_produccion', {...reels[i], 'numero_bobina': i + 1}),
        ...removed,
      ]);
      if (mounted) Navigator.pop(context);
    });
    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.existing == null ? 'Nueva jornada' : 'Editar jornada'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionCard(
                  title: 'Datos de la jornada',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateField('Fecha', date, (d) => setState(() => date = d)),
                      ChoiceField(
                        'Línea',
                        line,
                        {'Galletas': 'Galletas', 'Barras': 'Barras'},
                        (v) async {
                          if (v == line) return;
                          if (lots.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Retira los lotes antes de cambiar la línea.',
                                ),
                              ),
                            );
                            return;
                          }
                          setState(() => line = v!);
                        },
                      ),
                      ChoiceField('Turno', turn, {
                        'Dia': 'Día',
                        'Noche': 'Noche',
                      }, (v) => setState(() => turn = v!)),
                      ChoiceField(
                        'Ingeniero / supervisor',
                        supervisor,
                        {
                          for (final p
                              in widget.store
                                  .rows('personal')
                                  .where(
                                    (p) =>
                                        p['activo'] != false ||
                                        p['id_trabajador'] == supervisor,
                                  ))
                            p['id_trabajador'] as String: fullName(p),
                        },
                        (v) => setState(() => supervisor = v),
                      ),
                      TextFormField(
                        controller: start,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Hora de inicio de envasado',
                          suffixIcon: Icon(Icons.schedule),
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            start.text =
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Lotes producidos',
                  child: Column(
                    children: [
                      for (var i = 0; i < lots.length; i++)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Lote ${lots[i]['numero_lote']} · ${lots[i]['presentacion']}',
                          ),
                          subtitle: Text(
                            '${widget.store.find('productos_envasados', lots[i]['id_producto'])?['nombre_producto']} · ${lots[i]['cantidad']} cajas',
                          ),
                          onTap: () => lot(i),
                          trailing: IconButton(
                            tooltip: 'Retirar lote',
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => lots.removeAt(i)),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: lot,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar lote'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Bobinas de la jornada',
                  child: Column(
                    children: [
                      for (var i = 0; i < reels.length; i++)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Bobina ${i + 1}'),
                          subtitle: Text(
                            'Bruto ${reels[i]['peso_bruto']} kg · Neto ${reels[i]['peso_neto']} kg',
                          ),
                          onTap: () => reel(i),
                          trailing: IconButton(
                            tooltip: 'Retirar bobina',
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => reels.removeAt(i)),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: reel,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar bobina'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: line == 'Galletas'
                      ? 'Amasado y mermas'
                      : 'Jarabe, dosimetría y mezclado',
                  child: LayoutBuilder(
                    builder: (c, box) => Wrap(
                      spacing: 16,
                      children: [
                        for (final k in visibleFields)
                          SizedBox(
                            width: box.maxWidth >= 650
                                ? (box.maxWidth - 16) / 2
                                : box.maxWidth,
                            child: EntryField(
                              productionFields[k]!,
                              fields[k]!,
                              numeric: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Observaciones',
                  child: EntryField(
                    'Observaciones de la jornada',
                    notes,
                    lines: 3,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: saving ? null : save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(saving ? 'Guardando…' : 'Guardar jornada'),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class LotEditor extends StatefulWidget {
  const LotEditor({
    super.key,
    required this.store,
    required this.line,
    required this.jornadaId,
    this.row,
  });
  final AppStore store;
  final String line, jornadaId;
  final RowData? row;
  @override
  State<LotEditor> createState() => _LotEditorState();
}

class _LotEditorState extends State<LotEditor> {
  final form = GlobalKey<FormState>();
  late String? product = widget.row?['id_producto'];
  late String presentation = '${widget.row?['presentacion']}'.contains('48')
      ? '48 gr'
      : '30 gr';
  late final code = TextEditingController(
        text: '${widget.row?['numero_lote'] ?? ''}',
      ),
      qty = TextEditingController(text: '${widget.row?['cantidad'] ?? ''}'),
      batches = TextEditingController(
        text: '${widget.row?['cant_batch'] ?? ''}',
      );
  late DateTime? expiry = DateTime.tryParse('${widget.row?['f_vencimiento']}');
  @override
  void dispose() {
    code.dispose();
    qty.dispose();
    batches.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Lote producido'),
    content: SizedBox(
      width: 450,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChoiceField('Producto', product, {
                for (final p
                    in widget.store
                        .rows('productos_envasados')
                        .where((p) => p['tipo'] == widget.line))
                  p['id_producto'] as String: '${p['nombre_producto']}',
              }, (v) => setState(() => product = v)),
              EntryField('Número de lote', code, required: true),
              ChoiceField('Presentación', presentation, {
                '30 gr': '30 gr',
                '48 gr': '48 gr',
              }, (v) => setState(() => presentation = v!)),
              EntryField(
                'Cantidad de cajas',
                qty,
                numeric: true,
                integer: true,
                required: true,
              ),
              if (widget.line == 'Galletas')
                EntryField(
                  'Batches de este lote (si hay varios productos)',
                  batches,
                  numeric: true,
                ),
              OutlinedButton.icon(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: expiry ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setState(() => expiry = d);
                },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  expiry == null
                      ? 'Fecha de vencimiento'
                      : 'Vencimiento: ${dateKey(expiry!)}',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (!form.currentState!.validate()) return;
          Navigator.pop(context, <String, dynamic>{
            ...?(widget.row),
            'id_lote': widget.row?['id_lote'] ?? const Uuid().v4(),
            'id_jornada': widget.jornadaId,
            'id_producto': product,
            'numero_lote': code.text.trim(),
            'presentacion': presentation,
            'cantidad': int.parse(qty.text),
            'cant_batch': batches.text.isEmpty
                ? null
                : double.parse(batches.text.replaceAll(',', '.')),
            'f_vencimiento': expiry == null ? null : dateKey(expiry!),
          });
        },
        child: const Text('Guardar lote'),
      ),
    ],
  );
}

class ReelEditor extends StatefulWidget {
  const ReelEditor({
    super.key,
    required this.jornadaId,
    required this.number,
    this.row,
  });
  final String jornadaId;
  final int number;
  final RowData? row;
  @override
  State<ReelEditor> createState() => _ReelEditorState();
}

class _ReelEditorState extends State<ReelEditor> {
  final form = GlobalKey<FormState>();
  static const labels = {
    'peso_bruto': 'Peso bruto (kg)',
    'peso_neto': 'Peso neto (kg)',
    'tuco_envoltorio': 'Tuco + envoltorio (kg)',
    'sobra_bobina': 'Sobra bobina (kg)',
  };
  late final fields = {
    for (final k in labels.keys)
      k: TextEditingController(text: '${widget.row?[k] ?? ''}'),
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
    title: Text('Bobina ${widget.number}'),
    content: SizedBox(
      width: 400,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final k in labels.keys)
                EntryField(
                  labels[k]!,
                  fields[k]!,
                  numeric: true,
                  required: k == 'peso_bruto' || k == 'peso_neto',
                ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (!form.currentState!.validate()) return;
          final values = {
            for (final k in labels.keys)
              k: fields[k]!.text.isEmpty
                  ? null
                  : double.parse(fields[k]!.text.replaceAll(',', '.')),
          };
          if (values['peso_neto']! > values['peso_bruto']!) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('El peso neto no puede superar al bruto.'),
              ),
            );
            return;
          }
          Navigator.pop(context, <String, dynamic>{
            ...?(widget.row),
            'id_bobina': widget.row?['id_bobina'] ?? const Uuid().v4(),
            'id_jornada': widget.jornadaId,
            'numero_bobina': widget.number,
            ...values,
          });
        },
        child: const Text('Guardar bobina'),
      ),
    ],
  );
}
