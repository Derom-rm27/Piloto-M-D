import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../state/production_provider.dart';
import '../../state/theme_provider.dart';
import '../../widgets/custom_containers.dart';
import '../../widgets/donut_chart.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(themeColorsProvider);
    final prodState = ref.watch(productionProvider);
    final metrics = prodState.metrics;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado de Rendimiento y Selector de filtro
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.borderSubtle)),
            ),
            child: LayoutBuilder(
              builder: (ctx, headerConstraints) {
                final isNarrow = headerConstraints.maxWidth < 650;
                final info = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rendimiento de Producción',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Balance de masa, aprovechamiento de insumos y mermas por jornada',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                );
                final selector = Container(
                  width: isNarrow ? double.infinity : 260,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderMedium),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: prodState.selectedRunFilterId,
                      isExpanded: true,
                      dropdownColor: colors.surfaceCard,
                      icon: Icon(Icons.keyboard_arrow_down, size: 16, color: colors.textMuted),
                      style: TextStyle(color: colors.textSecondary, fontSize: 11),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(productionProvider.notifier).setFilter(val);
                        }
                      },
                      items: [
                        const DropdownMenuItem(
                          value: 'all',
                          child: SizedBox(
                            width: 200,
                            child: Text('Todas las Jornadas (Promedio)', overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        ...prodState.runs.map((r) => DropdownMenuItem(
                          value: r.id,
                          child: SizedBox(
                            width: 200,
                            child: Text('${r.fecha} (${r.turno} - ${r.tipo})', overflow: TextOverflow.ellipsis),
                          ),
                        )),
                      ],
                    ),
                  ),
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      info,
                      const SizedBox(height: 10),
                      selector,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: info),
                    const SizedBox(width: 12),
                    selector,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Grilla de Métricas KPI (4 tarjetas)
          LayoutBuilder(
            builder: (ctx, constraints) {
              final isSmall = constraints.maxWidth < 600;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Rendimiento Promedio',
                    value: '${metrics.rendimientoAvg}%',
                    valueColor: AppTokens.emeraldDarkText,
                    badge: '+1.2% meta',
                    subtext: 'Aprovechamiento de receta',
                  ),
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Cajas Terminadas',
                    value: '${metrics.totalCajas}',
                    unit: 'cajas',
                    valueColor: colors.textPrimary,
                    subtext: 'Galletas y Barras producidas',
                  ),
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Insumos Procesados',
                    value: '${metrics.totalInsumosKg.toInt()}',
                    unit: 'kg',
                    valueColor: colors.accentText,
                    subtext: 'Batches acumulados',
                  ),
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Merma Total Acumulada',
                    value: '${metrics.totalMermaKg}',
                    unit: 'kg',
                    valueColor: AppTokens.dangerDarkText,
                    subtext: '3.1% del total de masa',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Fila de Gráfico y Tabla
          CustomCard(
            colors: colors,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'DISTRIBUCIÓN DE MERMAS',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: ${metrics.totalMermaKg} kg',
                      style: const TextStyle(
                        color: AppTokens.dangerDarkText,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DonutChartWidget(
                  slices: metrics.mermaSlices,
                  totalKg: metrics.totalMermaKg,
                  colors: colors,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard({
    required double width,
    required ThemeColors colors,
    required String title,
    required String value,
    String? unit,
    required Color valueColor,
    String? badge,
    required String subtext,
  }) {
    return SizedBox(
      width: width,
      child: CustomCard(
        colors: colors,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              runSpacing: 2,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
                if (unit != null)
                  Text(unit, style: TextStyle(color: colors.textMuted, fontSize: 10)),
                if (badge != null)
                  Text(badge, style: const TextStyle(color: AppTokens.emeraldDarkText, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtext,
              style: TextStyle(color: colors.textFaint, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
