import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/attendance.dart';
import '../../core/domain/production.dart';
import '../../shared/widgets.dart';
import '../../shared/form_fields.dart';
import '../reports/report_service.dart';
import '../reports/export_actions.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key, required this.store});
  final AppStore store;
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime date = DateTime.now(),
      month = DateTime(DateTime.now().year, DateTime.now().month);
  String search = '', turn = 'Dia', line = 'Galletas';
  bool report = false;
  final selected = <String>{};
  Future<void> edit({String? type}) async {
    if (selected.isEmpty) return;
    await showDialog(
      context: context,
      builder: (_) => AttendanceEditor(
        store: widget.store,
        ids: selected.toList(),
        date: date,
        turn: turn,
        line: line,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summaries = attendanceReport(
      widget.store.rows('personal'),
      widget.store.rows('registro_asistencia'),
      month,
    );
    final people =
        widget.store
            .rows('personal')
            .where(
              (p) =>
                  p['activo'] != false &&
                  fullName(p).toLowerCase().contains(search.toLowerCase()),
            )
            .toList()
          ..sort((a, b) => fullName(a).compareTo(fullName(b)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeading('Asistencia', 'Registro diario y cierre mensual'),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Registro diario')),
            ButtonSegment(value: true, label: Text('Informe mensual')),
          ],
          selected: {report},
          onSelectionChanged: (s) => setState(() => report = s.first),
        ),
        const SizedBox(height: 16),
        if (report) ...[
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              MonthPicker(
                value: month,
                onChanged: (d) => setState(() => month = d),
              ),
              ExportButtons(
                name: 'Asistencia_${dateKey(month).substring(0, 7)}',
                enabled: summaries.isNotEmpty,
                pdf: () => ReportService.attendancePdf(
                  summaries,
                  DateFormat.yMMMM('es_PE').format(month),
                ),
                excel: () => ReportService.attendanceExcel(
                  summaries,
                  DateFormat.yMMMM('es_PE').format(month),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (summaries.any((r) => r.incomplete > 0))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${summaries.fold<int>(0, (s, r) => s + r.incomplete)} incidencias pendientes de revisión. Las horas incompletas no se suman.',
              ),
            ),
          Expanded(
            child: Card(
              child: summaries.isEmpty
                  ? const EmptyState('No hay marcaciones en este mes.')
                  : SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: attendanceColumns
                              .map((c) => DataColumn(label: Text(c)))
                              .toList(),
                          rows: [
                            for (var i = 0; i < summaries.length; i++)
                              DataRow(
                                cells: summaries[i]
                                    .cells(i + 1)
                                    .map((v) => DataCell(Text('$v')))
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ] else ...[
          Wrap(
            spacing: 12,
            children: [
              DateField(
                'Fecha de jornada',
                date,
                (d) => setState(() => date = d),
              ),
              SizedBox(
                width: 140,
                child: ChoiceField('Turno', turn, {
                  'Dia': 'Día',
                  'Noche': 'Noche',
                }, (s) => setState(() => turn = s!)),
              ),
              SizedBox(
                width: 160,
                child: ChoiceField('Línea', line, {
                  'Galletas': 'Galletas',
                  'Barras': 'Barras',
                }, (s) => setState(() => line = s!)),
              ),
            ],
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar personal',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (s) => setState(() => search = s),
          ),
          Row(
            children: [
              Checkbox(
                value:
                    people.isNotEmpty &&
                    people.every((p) => selected.contains(p['id_trabajador'])),
                onChanged: (v) => setState(() {
                  if (v == true) {
                    selected.addAll(
                      people.map((p) => p['id_trabajador'] as String),
                    );
                  } else {
                    selected.clear();
                  }
                }),
              ),
              const Text('Seleccionar todos'),
              const Spacer(),
              Text('${selected.length} seleccionados'),
            ],
          ),
          Expanded(
            child: Card(
              child: people.isEmpty
                  ? const EmptyState('No hay personal activo.')
                  : ListView.separated(
                      itemCount: people.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (c, i) {
                        final p = people[i], id = p['id_trabajador'] as String;
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(fullName(p)),
                          value: selected.contains(id),
                          onChanged: (v) => setState(
                            () => v == true
                                ? selected.add(id)
                                : selected.remove(id),
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: selected.isEmpty
                    ? null
                    : () => edit(type: 'ENTRADA'),
                icon: const Icon(Icons.login),
                label: const Text('Entrada'),
              ),
              FilledButton.icon(
                onPressed: selected.isEmpty ? null : () => edit(type: 'SALIDA'),
                icon: const Icon(Icons.logout),
                label: const Text('Salida'),
              ),
              OutlinedButton(
                onPressed: selected.isEmpty ? null : edit,
                child: const Text('Editar'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class AttendanceEditor extends StatefulWidget {
  const AttendanceEditor({
    super.key,
    required this.store,
    required this.ids,
    required this.date,
    required this.turn,
    required this.line,
    this.type,
  });
  final AppStore store;
  final List<String> ids;
  final DateTime date;
  final String turn, line;
  final String? type;
  @override
  State<AttendanceEditor> createState() => _AttendanceEditorState();
}

class _AttendanceEditorState extends State<AttendanceEditor> {
  late String type = widget.type ?? 'ENTRADA';
  late TimeOfDay time = TimeOfDay.now();
  bool saving = false;
  List<RowData> matches(String id) => widget.store
      .rows('registro_asistencia')
      .where(
        (r) =>
            r['id_trabajador'] == id &&
            workDate(r) == dateKey(widget.date) &&
            r['turno'] == widget.turn &&
            r['linea'] == widget.line &&
            r['tipo'] == type,
      )
      .toList();
  @override
  void initState() {
    super.initState();
    prefill();
  }

  void prefill() {
    if (widget.ids.length == 1) {
      final m = matches(widget.ids.first);
      if (m.length == 1) {
        time = TimeOfDay.fromDateTime(limaTime(m.first['fecha_hora']));
      }
    }
  }

  Future<void> save({bool remove = false}) async {
    if (saving) return;
    final ops = <(String, RowData)>[];
    for (final id in widget.ids) {
      final existing = matches(id);
      if (existing.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Hay varias marcaciones del mismo tipo. Revisa las marcaciones individuales antes de editar en bloque.',
            ),
          ),
        );
        return;
      }
      if (remove) {
        if (existing.isNotEmpty) {
          ops.add((
            'registro_asistencia',
            {
              ...existing.first,
              'deleted_at': DateTime.now().toUtc().toIso8601String(),
            },
          ));
        }
        continue;
      }
      if (widget.type != null && existing.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ya existe una marcación. Usa Editar para corregirla.',
            ),
          ),
        );
        return;
      }
      var d = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        time.hour,
        time.minute,
      );
      if (widget.turn == 'Noche' && time.hour < 12) {
        d = d.add(const Duration(days: 1));
      }
      // User-entered wall clock is always America/Lima, independent of device timezone.
      final stamp =
          '${dateKey(d)}T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00-05:00';
      ops.add((
        'registro_asistencia',
        {
          if (existing.isNotEmpty) ...existing.first,
          'id_registro': existing.isEmpty
              ? const Uuid().v4()
              : existing.first['id_registro'],
          'id_trabajador': id,
          'fecha_hora': stamp,
          'fecha_jornada': dateKey(widget.date),
          'tipo': type,
          'turno': widget.turn,
          'linea': widget.line,
        },
      ));
    }
    setState(() => saving = true);
    await guarded(context, () async {
      await widget.store.saveBatch(ops);
      if (mounted) Navigator.pop(context);
    });
    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      '${widget.type == null ? 'Editar' : 'Registrar'} · ${widget.ids.length} personas',
    ),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${dateKey(widget.date)} · ${widget.turn} · ${widget.line}'),
          const SizedBox(height: 16),
          ChoiceField(
            'Marcación',
            type,
            {'ENTRADA': 'Entrada', 'SALIDA': 'Salida'},
            (v) => setState(() {
              type = v!;
              prefill();
            }),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (t != null) setState(() => time = t);
            },
            icon: const Icon(Icons.schedule),
            label: Text('Hora: ${time.format(context)}'),
          ),
          if (widget.turn == 'Noche' && time.hour < 12)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'La hora corresponde a la madrugada del día siguiente.',
              ),
            ),
        ],
      ),
    ),
    actions: [
      if (widget.type == null)
        TextButton(
          onPressed: saving
              ? null
              : () async {
                  if (await confirm(
                    context,
                    'Anular marcación',
                    'Se anulará esta marcación de las personas seleccionadas.',
                  )) {
                    await save(remove: true);
                  }
                },
          child: const Text('Anular marcación'),
        ),
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: saving ? null : save,
        child: const Text('Guardar'),
      ),
    ],
  );
}
