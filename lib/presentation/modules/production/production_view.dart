import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/app_store.dart';
import '../../../core/domain/production.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/production/production_editor.dart';
import '../../../features/reports/export_actions.dart';
import '../../../features/reports/report_service.dart';
import '../../state/personnel_provider.dart';
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
              child: SingleChildScrollView(
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
              ),
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
}
