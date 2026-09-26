import 'package:flutter/material.dart';
import '../../core/data/app_store.dart';
import '../../core/domain/production.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets.dart';
import '../production/production_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.store,
    this.performanceOnly = false,
  });
  final AppStore store;
  final bool performanceOnly;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime? month;
  String line = 'Todas';
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
          ..sort((a, b) => '${a.row['fecha']}'.compareTo('${b.row['fecha']}'));
    final valid = list.where((j) => j.yieldPercent != null).toList();
    final input = valid.fold<double>(0, (s, j) => s + j.inputKg!);
    final output = valid.fold<double>(0, (s, j) => s + j.kilograms!);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            widget.performanceOnly ? 'Rendimiento' : 'Resumen de planta',
            widget.performanceOnly
                ? 'Balance de materia y producción terminada'
                : 'Una mirada a tu producción',
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
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Metric('Jornadas', '${list.length}', Icons.factory_outlined),
              Metric(
                'Cajas producidas',
                list.fold<double>(0, (s, j) => s + j.boxes).toStringAsFixed(0),
                Icons.inventory_2_outlined,
              ),
              Metric(
                'Rendimiento galletas',
                input > 0
                    ? '${(output / input * 100).toStringAsFixed(2)}%'
                    : 'Sin datos',
                Icons.trending_up,
              ),
              if (!widget.performanceOnly)
                Metric(
                  'Personal activo',
                  '${widget.store.rows('personal').where((p) => p['activo'] != false).length}',
                  Icons.people_outline,
                ),
            ],
          ),
          const SizedBox(height: 24),
          SectionCard(
            title: 'Rendimiento por jornada',
            child: list.isEmpty
                ? const EmptyState(
                    'Las jornadas aparecerán aquí al descargar o registrar producción.',
                  )
                : Column(
                    children: [
                      for (final j in list)
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () =>
                              openProductionDetail(context, widget.store, j.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      '${j.row['fecha']} · ${j.row['turno']} · ${j.row['tipo']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      j.yieldPercent == null
                                          ? j.isCookies ? 'Faltan batches por producto' : 'Balance pendiente'
                                          : '${j.yieldPercent!.toStringAsFixed(2)}%${j.yieldPercent! > 100 ? ' · Revisar datos' : ''}',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (j.yieldPercent != null)
                                  LinearProgressIndicator(
                                    value: (j.yieldPercent! / 100).clamp(0, 1),
                                    minHeight: 15,
                                    borderRadius: BorderRadius.circular(5),
                                    color: j.goodYield
                                        ? AppColors.good
                                        : AppColors.warning,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  '${j.boxes.toStringAsFixed(0)} cajas${j.expectedBoxes != null ? ' · Mínimo esperado: ${j.expectedBoxes!.toStringAsFixed(2)} cajas' : ''}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          if (!widget.performanceOnly)
            SectionCard(
              title: 'Producción por línea',
              child: Wrap(
                spacing: 32,
                runSpacing: 16,
                children: [
                  for (final type in ['Galletas', 'Barras'])
                    SizedBox(
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${list.where((j) => j.row['tipo'] == type).fold<double>(0, (s, j) => s + j.boxes).toStringAsFixed(0)} cajas',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
