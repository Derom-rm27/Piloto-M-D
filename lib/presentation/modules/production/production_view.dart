import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/app_store.dart';
import '../../../core/domain/production.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/production/production_editor.dart';
import '../../../features/reports/export_actions.dart';
import '../../../features/reports/report_service.dart';
import '../../state/personnel_provider.dart';
import '../../../domain/models/production_run.dart';
import '../../state/production_provider.dart';
import '../../state/theme_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';
import '../../widgets/pdf_preview_screen.dart';
import 'production_modals.dart';

class ProductionView extends ConsumerWidget {
  const ProductionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(themeColorsProvider);
    final prodState = ref.watch(productionProvider);
    final runs = prodState.runs;
    final store = ref.watch(appStoreProvider);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barra Superior de Informes Responsiva
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                border: Border(bottom: BorderSide(color: colors.borderSubtle)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 500;

                  final titleSection = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'INFORMES DE PRODUCCIÓN',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomBadge(
                        text: '${runs.length} jornadas',
                        bg: colors.surfaceElevated,
                        fg: colors.textMuted,
                        border: colors.borderMedium,
                      ),
                    ],
                  );

                  final exportActions = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        variant: ButtonVariant.success,
                        text: 'Excel',
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        fontSize: 11,
                        icon: const Icon(Icons.table_view_outlined, size: 14, color: Colors.white),
                        onTap: () => _exportExcel(context, store),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        variant: ButtonVariant.primary,
                        text: 'PDF',
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        fontSize: 11,
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 14, color: Colors.white),
                        onTap: () => _exportPdf(context, store, colors),
                      ),
                    ],
                  );

                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        titleSection,
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: exportActions,
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleSection,
                      exportActions,
                    ],
                  );
                },
              ),
            ),

            // Contenido de la Tabla de Informes
            Expanded(
              child: runs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                        child: CustomCard(
                          colors: colors,
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.accent.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.precision_manufacturing_outlined, size: 48, color: colors.accentText),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aún no hay jornadas registradas',
                                style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Registra el primer lote de producción con datos de amasado, horneado, insumos y mermas.',
                                style: TextStyle(color: colors.textMuted, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),
                              CustomButton(
                                variant: ButtonVariant.primary,
                                text: 'Registrar Nueva Jornada',
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                onTap: () async {
                                  if (store != null) {
                                    await openProductionEditor(context, store);
                                    ref.read(productionProvider.notifier).reloadFromStore();
                                  } else {
                                    ProductionModals.showNewJornadaModal(context, ref, colors);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 760;
                        if (isMobile) {
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
                            itemCount: runs.length,
                            itemBuilder: (ctx, i) => _buildJornadaMobileCard(context, colors, runs[i], store, ref),
                          );
                        }
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
                          child: CustomCard(
                            colors: colors,
                            padding: EdgeInsets.zero,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowHeight: 34,
                                dataRowMinHeight: 38,
                                dataRowMaxHeight: 44,
                                columnSpacing: 18,
                                columns: [
                                  DataColumn(label: Text('Jornada / Fecha', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Turno / Línea', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Batches', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Producción Total', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Merma Total', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Rendimiento', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                  DataColumn(label: Text('Acción', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                                ],
                                rows: runs.map((j) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(j.fecha, style: TextStyle(color: colors.accentText, fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold))),
                                      DataCell(Text('${j.turno} • ${j.tipo}', style: TextStyle(color: colors.textSecondary, fontSize: 11))),
                                      DataCell(Text('${j.cantBatch}', style: TextStyle(color: colors.textSecondary, fontFamily: 'monospace', fontSize: 11))),
                                      DataCell(Text('${j.totalCajas} cajas', style: TextStyle(color: colors.textPrimary, fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold))),
                                      DataCell(Text('${j.mermaTotal} kg', style: const TextStyle(color: AppTokens.dangerDarkText, fontFamily: 'monospace', fontSize: 11))),
                                      DataCell(Text('${j.rendimiento}%', style: const TextStyle(color: AppTokens.emeraldDarkText, fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold))),
                                      DataCell(
                                        CustomButton(
                                          variant: ButtonVariant.secondary,
                                          text: 'Detalle',
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          fontSize: 10,
                                          onTap: () => ProductionModals.showJornadaDetail(context, colors, j, store: store, ref: ref),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    )
            ),
          ],
        ),

        // Floating Action Button (+) para nueva jornada
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: () async {
              if (store != null) {
                await openProductionEditor(context, store);
                ref.read(productionProvider.notifier).reloadFromStore();
              } else {
                ProductionModals.showNewJornadaModal(context, ref, colors);
              }
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _exportPdf(BuildContext context, AppStore? store, ThemeColors colors) async {
    if (store == null || store.rows('jornadas_produccion').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay registros de jornadas en base de datos para exportar.')),
      );
      return;
    }

    try {
      final jobs = store.rows('jornadas_produccion').map((r) => Production(store, r)).toList();
      final bytes = await ReportService.productionPdf(jobs);
      if (context.mounted) {
        PdfViewerScreen.open(
          context: context,
          title: 'Informe General de Producción',
          fileName: 'Informe_Produccion_${DateTime.now().year}_${DateTime.now().month}',
          bytes: bytes,
          colors: colors,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar PDF de producción: $e')),
        );
      }
    }
  }

  void _exportExcel(BuildContext context, AppStore? store) async {
    if (store == null || store.rows('jornadas_produccion').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay registros de jornadas en base de datos para exportar.')),
      );
      return;
    }

    try {
      final jobs = store.rows('jornadas_produccion').map((r) => Production(store, r)).toList();
      final bytes = ReportService.productionExcel(jobs);
      final fileName = 'Informe_Produccion_${DateTime.now().year}_${DateTime.now().month}.xlsx';
      await saveBytes(bytes, fileName, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reporte Excel generado: $fileName')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar Excel: $e')),
        );
      }
    }
  }


  Widget _buildJornadaMobileCard(
    BuildContext context,
    ThemeColors colors,
    ProductionRun j,
    AppStore? store,
    WidgetRef ref,
  ) {
    final isDia = j.turno == 'Dia' || j.turno == 'Día';
    final rend = j.rendimiento;
    final bool isGood = rend >= 90.0;
    final bool isMid = rend >= 80.0 && rend < 90.0;

    final rendColor = isGood
        ? AppTokens.emeraldDarkText
        : (isMid ? AppTokens.amberText : AppTokens.dangerDarkText);
    final rendBg = isGood
        ? AppTokens.emeraldDarkBg
        : (isMid ? AppTokens.amberBgDark : AppTokens.dangerDarkBg);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: colors.isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => ProductionModals.showJornadaDetail(context, colors, j, store: store, ref: ref),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera: Fecha + Pastillas de Turno y Línea
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.calendar_today_outlined, size: 14, color: colors.accentText),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        j.fecha,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Turno pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDia ? AppTokens.amberBgDark : colors.accentSubtle,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isDia ? AppTokens.amberBorderDark : colors.borderHighlight,
                          ),
                        ),
                        child: Text(
                          j.turno,
                          style: TextStyle(
                            color: isDia ? AppTokens.amberText : colors.accentText,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Línea pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: colors.borderMedium),
                        ),
                        child: Text(
                          j.tipo,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: colors.borderSubtle),
              const SizedBox(height: 12),

              // Métricas en 3 cajas limpias y visuales
              Row(
                children: [
                  // Cajas terminadas
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRODUCCIÓN',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${j.totalCajas} cajas',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          '${j.cantBatch} batches',
                          style: TextStyle(color: colors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  // Merma total
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MERMA',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${j.mermaTotal} kg',
                          style: const TextStyle(
                            color: AppTokens.dangerDarkText,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          'en proceso',
                          style: TextStyle(color: colors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  // Rendimiento con Semáforo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RENDIMIENTO',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: rendBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${j.rendimiento}%',
                            style: TextStyle(
                              color: rendColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
