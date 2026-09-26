import 'package:flutter/material.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../shared/widgets.dart';
import '../reports/export_actions.dart';
import '../reports/report_service.dart';
import 'production_editor.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key, required this.store});
  final AppStore store;
  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  String line = 'Todas';
  DateTime? month;
  final selected = <String>{};
  @override
  Widget build(BuildContext context) {
    final list =
        widget.store
            .rows('jornadas_produccion')
            .where(
              (r) =>
                  (line == 'Todas' || r['tipo'] == line) &&
                  (month == null ||
                      '${r['fecha']}'.startsWith(
                        dateKey(month!).substring(0, 7),
                      )),
            )
            .map((r) => Production(widget.store, r))
            .toList()
          ..sort((a, b) => '${b.row['fecha']}'.compareTo('${a.row['fecha']}'));
    final chosen = list.where((j) => selected.contains(j.id)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeading(
          'Jornadas',
          'Producción, lotes y control de planta',
          actions: [
            FilledButton.icon(
              onPressed: () => openProductionEditor(context, widget.store),
              icon: const Icon(Icons.add),
              label: const Text('Nueva jornada'),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final f in ['Todas', 'Galletas', 'Barras'])
              ChoiceChip(
                label: Text(f),
                selected: line == f,
                onSelected: (_) => setState(() => line = f),
              ),
            FilterChip(
              label: const Text('Filtrar mes'),
              selected: month != null,
              onSelected: (v) =>
                  setState(() => month = v ? DateTime.now() : null),
            ),
            if (month != null)
              MonthPicker(
                value: month!,
                onChanged: (d) => setState(() => month = d),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextButton(
              onPressed: () => setState(() {
                if (list.every((j) => selected.contains(j.id))) {
                  selected.clear();
                } else {
                  selected.addAll(list.map((j) => j.id));
                }
              }),
              child: Text('Seleccionar todas · ${chosen.length} elegidas'),
            ),
            ExportButtons(
              name: 'Jornadas_${dateKey(DateTime.now())}',
              enabled: chosen.isNotEmpty,
              pdf: () => ReportService.productionPdf(chosen),
              excel: () => ReportService.productionExcel(chosen),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: list.isEmpty
              ? const EmptyState('No hay jornadas para este filtro.')
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (c, i) {
                    final j = list[i];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Checkbox(
                          value: selected.contains(j.id),
                          onChanged: (v) => setState(
                            () => v == true
                                ? selected.add(j.id)
                                : selected.remove(j.id),
                          ),
                        ),
                        title: Text(
                          '${j.row['fecha']} · ${j.row['tipo']}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${j.row['turno']} · ${j.lots.length} lotes · ${j.boxes.toStringAsFixed(0)} cajas',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            openProductionDetail(context, widget.store, j.id),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

Future<void> openProductionDetail(
  BuildContext context,
  AppStore store,
  String id,
) async {
  await Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final row = store.find('jornadas_produccion', id);
          if (row == null || row['deleted_at'] != null) {
            return Scaffold(
              appBar: AppBar(),
              body: const EmptyState('Jornada anulada.'),
            );
          }
          final j = Production(store, row);
          return Scaffold(
            appBar: AppBar(title: Text('Jornada · ${row['fecha']}')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1050),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeading(
                        '${row['tipo']} · ${row['turno']}',
                        j.supervisor,
                        actions: [
                          OutlinedButton(
                            onPressed: () =>
                                openProductionEditor(context, store, j),
                            child: const Text('Editar'),
                          ),
                          ExportButtons(
                            name: 'Jornada_${row['fecha']}_${row['turno']}',
                            pdf: () => ReportService.productionPdf([j]),
                            excel: () => ReportService.productionExcel([j]),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          Metric(
                            'Cajas',
                            j.boxes.toStringAsFixed(0),
                            Icons.inventory_2_outlined,
                          ),
                          Metric(
                            'Batches',
                            number(row['cant_batch']).toStringAsFixed(2),
                            Icons.layers_outlined,
                          ),
                          Metric(
                            'Merma alimentaria',
                            '${j.waste.toStringAsFixed(2)} kg',
                            Icons.scale_outlined,
                          ),
                          Metric(
                            'Rendimiento',
                            j.yieldPercent == null
                                ? 'Pendiente'
                                : '${j.yieldPercent!.toStringAsFixed(2)}%',
                            Icons.bar_chart,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        title: 'Lotes producidos',
                        child: Column(
                          children: [
                            for (final l in j.lots)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${l['numero_lote']} · ${j.product(l)}',
                                ),
                                subtitle: Text(
                                  '${l['presentacion']} · Vencimiento: ${l['f_vencimiento'] ?? '—'}',
                                ),
                                trailing: Text('${l['cantidad']} cajas'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        title: 'Bobinas de la jornada',
                        child: j.reels.isEmpty
                            ? const Text('Sin bobinas registradas.')
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns:
                                      [
                                            'N°',
                                            'Peso bruto',
                                            'Peso neto',
                                            'Tuco + envol.',
                                            'Sobra',
                                          ]
                                          .map(
                                            (s) => DataColumn(label: Text(s)),
                                          )
                                          .toList(),
                                  rows: j.reels
                                      .map(
                                        (r) => DataRow(
                                          cells:
                                              [
                                                    'numero_bobina',
                                                    'peso_bruto',
                                                    'peso_neto',
                                                    'tuco_envoltorio',
                                                    'sobra_bobina',
                                                  ]
                                                  .map(
                                                    (k) => DataCell(
                                                      Text('${r[k] ?? '—'}'),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        title: 'Parámetros y mermas',
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            for (final e in productionFields.entries.where(
                              (e) => row[e.key] != null,
                            ))
                              SizedBox(
                                width: 230,
                                child: Text('${e.value}: ${row[e.key]}'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        title: 'Observaciones',
                        child: Text(
                          '${row['observaciones'] ?? 'Sin observaciones.'}',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () async {
                          if (await confirm(
                            context,
                            'Anular jornada',
                            'Se conservará el registro para sincronizar su anulación.',
                          )) {
                            if (context.mounted) {
                              await guarded(context, () async {
                                await store.saveBatch([
                                  (
                                    'jornadas_produccion',
                                    {
                                      ...row,
                                      'deleted_at': DateTime.now()
                                          .toUtc()
                                          .toIso8601String(),
                                    },
                                  ),
                                  for (final l in j.lots)
                                    (
                                      'lotes_produccion',
                                      {
                                        ...l,
                                        'deleted_at': DateTime.now()
                                            .toUtc()
                                            .toIso8601String(),
                                      },
                                    ),
                                  for (final b in j.reels)
                                    (
                                      'bobinas_produccion',
                                      {
                                        ...b,
                                        'deleted_at': DateTime.now()
                                            .toUtc()
                                            .toIso8601String(),
                                      },
                                    ),
                                ]);
                                if (context.mounted) Navigator.pop(context);
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Anular jornada'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
