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
                final info = Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.analytics_outlined, size: 20, color: colors.accentText),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Panel de Rendimiento',
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTokens.emeraldLightBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'PLANTA',
                                  style: TextStyle(
                                    color: AppTokens.emeraldLightText,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Balance de masa, aprovechamiento y mermas',
                            style: TextStyle(
                              color: colors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );                final selector = Container(
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
          const SizedBox(height: 14),

          // Semáforo Operativo de Planta (Data Storytelling inmediato para evaluación)
          _buildSemaforoPlanta(colors, metrics),
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
                    icon: Icons.trending_up,
                    valueColor: AppTokens.emeraldDarkText,
                    badge: '+1.2% meta',
                    subtext: 'Aprovechamiento de receta',
                  ),
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Cajas Terminadas',
                    value: '${metrics.totalCajas}',
                    icon: Icons.inventory_2_outlined,
                    unit: 'cajas',
                    valueColor: colors.textPrimary,
                    subtext: 'Galletas y Barras producidas',
                  ),
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Insumos Procesados',
                    value: '${metrics.totalInsumosKg.toInt()}',
                    icon: Icons.scale_outlined,
                    unit: 'kg',
                    valueColor: colors.accentText,
                    subtext: 'Batches acumulados',
                  ),
                  _kpiCard(
                    width: isSmall ? (constraints.maxWidth - 10) / 2 : (constraints.maxWidth - 30) / 4,
                    colors: colors,
                    title: 'Merma Total Acumulada',
                    value: '${metrics.totalMermaKg}',
                    icon: Icons.delete_outline,
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
    IconData? icon,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSubtle, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: colors.isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 14, color: valueColor),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              runSpacing: 2,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 19.5,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
                if (unit != null)
                  Text(unit, style: TextStyle(color: colors.textMuted, fontSize: 11)),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTokens.emeraldLightBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: AppTokens.emeraldLightText,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtext,
              style: TextStyle(color: colors.textSecondary, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemaforoPlanta(ThemeColors colors, dynamic metrics) {
    final rend = metrics.rendimientoAvg;
    final bool isOptimo = rend >= 90.0;
    final bool isAlerta = rend < 80.0 && rend > 0;

    final statusColor = isOptimo
        ? AppTokens.emeraldPrimary
        : (isAlerta ? const Color(0xFFEF4444) : AppTokens.amberText);
    final statusBg = isOptimo
        ? AppTokens.emeraldDarkBg
        : (isAlerta ? const Color(0xFFFEE2E2).withValues(alpha: 0.15) : AppTokens.amberText.withValues(alpha: 0.12));
    final statusBorder = isOptimo
        ? AppTokens.emeraldDarkBorder
        : (isAlerta ? const Color(0xFFFCA5A5) : AppTokens.amberBorderDark);

    final statusTitle = isOptimo
        ? 'PLANTA EN ESTADO ÓPTIMO'
        : (isAlerta ? 'ATENCIÓN: REVISIÓN DE MERMAS' : 'PLANTA EN RITMO ESTABLE');
    final statusDesc = isOptimo
        ? 'Rendimiento promedio superior al 90%. Masa aprovechada dentro del estándar de receta.'
        : (isAlerta
            ? 'Rendimiento por debajo del umbral del 80%. Se recomienda revisar mermas de masa.'
            : 'Rendimiento operativo estándar. Parámetros de pesaje y empaque balanceados.');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: statusBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.45),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusDesc,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 10.5,
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