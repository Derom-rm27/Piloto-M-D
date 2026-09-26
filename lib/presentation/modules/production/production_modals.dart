import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/data/app_store.dart';
import '../../../core/domain/production.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/production_run.dart';
import '../../../features/production/production_editor.dart';
import '../../../features/reports/report_service.dart';
import '../../state/production_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/pdf_preview_screen.dart';

abstract final class ProductionModals {
  /// Modal Detalle de Jornada (Inspección completa de mermas, lotes y bobinas)
  static void showJornadaDetail(
    BuildContext context,
    ThemeColors colors,
    ProductionRun j, {
    AppStore? store,
    WidgetRef? ref,
  }) {
    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Detalle de Jornada',
      badgeText: '${j.fecha} (${j.turno})',
      badgeColor: colors.accent,
      maxWidth: 520,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Resumen Superior
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceDeep,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Línea de Producción:', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                      Text(j.tipo, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Supervisor:', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                      Text(j.supervisor, style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Métricas Clave
          LayoutBuilder(
            builder: (ctx, constraints) {
              final isSmall = constraints.maxWidth < 420;
              if (isSmall) {
                return Column(
                  children: [
                    Row(
                      children: [
                        _metricPill(colors, 'Rendimiento', '${j.rendimiento}%', AppTokens.emeraldDarkText),
                        const SizedBox(width: 8),
                        _metricPill(colors, 'Batches', '${j.cantBatch}', colors.textPrimary),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _metricPill(colors, 'Cajas Total', '${j.totalCajas}', colors.accentText),
                        const SizedBox(width: 8),
                        _metricPill(colors, 'Merma Total', '${j.mermaTotal} kg', AppTokens.dangerDarkText),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  _metricPill(colors, 'Rendimiento', '${j.rendimiento}%', AppTokens.emeraldDarkText),
                  const SizedBox(width: 8),
                  _metricPill(colors, 'Batches', '${j.cantBatch}', colors.textPrimary),
                  const SizedBox(width: 8),
                  _metricPill(colors, 'Cajas Total', '${j.totalCajas}', colors.accentText),
                  const SizedBox(width: 8),
                  _metricPill(colors, 'Merma Total', '${j.mermaTotal} kg', AppTokens.dangerDarkText),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Desglose de Mermas
          Text('DESGLOSE DE MERMAS', style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Column(
              children: j.mermasDetalle.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(e.key.replaceAll('_', ' ').toUpperCase(), style: TextStyle(color: colors.textSecondary, fontSize: 11), overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Text('${e.value} kg', style: const TextStyle(color: AppTokens.dangerDarkText, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Lotes Producidos
          Text('LOTES FABRICADOS', style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
          const SizedBox(height: 8),
          ...j.lotes.map((l) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lote #${l.numero} • ${l.producto}', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 11), overflow: TextOverflow.ellipsis),
                      Text('Vence: ${l.fVencimiento.isNotEmpty ? l.fVencimiento : "No especificado"}', style: TextStyle(color: colors.textMuted, fontSize: 10), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('${l.cantidad} cajas', style: TextStyle(color: colors.accentText, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12)),
              ],
            ),
          )),
          const SizedBox(height: 14),

          // Observaciones
          if (j.observaciones.isNotEmpty) ...[
            Text('OBSERVACIONES', style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surfaceDeep,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Text(
                j.observaciones,
                style: TextStyle(color: colors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (ref != null)
          CustomButton(
            variant: ButtonVariant.danger,
            text: 'Eliminar',
            icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
            onTap: () => _confirmDeleteJornada(context, ref, colors, j, store),
          ),
        if (store != null)
          CustomButton(
            variant: ButtonVariant.secondary,
            text: 'Editar',
            icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.white),
            onTap: () async {
              Navigator.of(context).pop();
              final jobRow = store.find('jornadas_produccion', j.id) ?? {
                'id_jornada': j.id,
                'fecha': j.fecha,
                'turno': j.turno,
                'tipo': j.tipo,
                'cant_batch': j.cantBatch,
                'observaciones': j.observaciones,
              };
              await openProductionEditor(context, store, Production(store, jobRow));
              if (ref != null) {
                ref.read(productionProvider.notifier).reloadFromStore();
              }
            },
          ),
        if (store != null)
          CustomButton(
            variant: ButtonVariant.primary,
            text: 'Descargar Formato PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 14, color: Colors.white),
            onTap: () async {
              try {
                final jobRow = store.find('jornadas_produccion', j.id);
                if (jobRow == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No se encontraron los datos de la jornada en el almacenamiento local.')),
                  );
                  return;
                }
                final productionJob = Production(store, jobRow);
                final bytes = await ReportService.productionPdf([productionJob]);
                if (context.mounted) {
                  PdfViewerScreen.open(
                    context: context,
                    title: 'Formato Planta - ${j.fecha} (${j.tipo})',
                    fileName: 'Formato_${j.tipo}_${j.fecha}_${j.turno}',
                    bytes: bytes,
                    colors: colors,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al generar PDF: $e')),
                  );
                }
              }
            },
          ),
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cerrar',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  /// Diálogo de confirmación antes de eliminar una jornada (Regla 6: Botón rojo #DC2626)
  static void _confirmDeleteJornada(
    BuildContext context,
    WidgetRef ref,
    ThemeColors colors,
    ProductionRun j,
    AppStore? store,
  ) {
    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Confirmar Eliminación',
      badgeText: 'Advertencia',
      badgeColor: AppTokens.dangerSolid,
      maxWidth: 420,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Estás seguro de que deseas eliminar esta jornada de producción?',
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surfaceDeep,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha: ${j.fecha} • Turno: ${j.turno} • Línea: ${j.tipo}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (j.lotes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Lotes asociados: ${j.lotes.length} (${j.totalCajas} cajas fabricadas)',
                    style: TextStyle(color: colors.textMuted, fontSize: 10),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Esta acción no se puede deshacer y retirará permanentemente la jornada y sus lotes de producción.',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cancelar',
          onTap: () => Navigator.of(context).pop(),
        ),
        CustomButton(
          variant: ButtonVariant.danger,
          text: 'Eliminar',
          icon: const Icon(Icons.delete_forever, size: 14, color: Colors.white),
          onTap: () async {
            Navigator.of(context).pop(); // Cierra modal de advertencia
            Navigator.of(context).pop(); // Cierra modal de detalle
            await ref.read(productionProvider.notifier).deleteRun(j.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppTokens.dangerSolid,
                  content: Text(
                    'Jornada del ${j.fecha} (${j.turno}) eliminada correctamente.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  static Widget _metricPill(ThemeColors colors, String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: colors.textMuted, fontSize: 9)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12)),
          ],
        ),
      ),
    );
  }

  /// Modal Formulario de Jornada Dinámico (Galletas vs Barras)
  static void showNewJornadaModal(BuildContext context, WidgetRef ref, ThemeColors colors) {
    String tipo = 'Galletas';
    String turno = 'Dia';
    final now = DateTime.now();
    final fechaCtrl = TextEditingController(text: DateFormat('yyyy-MM-dd').format(now));
    final supervisorCtrl = TextEditingController(text: 'Ing. Jhon Alex Quispe Puma');
    final batchesCtrl = TextEditingController(text: '12');
    final mermaCtrl = TextEditingController(text: '18.5');
    final rendimientoCtrl = TextEditingController(text: '95.5');
    final obsCtrl = TextEditingController();

    // Campos Galletas
    final extruidoCtrl = TextEditingController(text: '8.0');

    // Campos Barras
    final batchJarabeCtrl = TextEditingController(text: '10.0');
    final tinasCtrl = TextEditingController(text: '4');

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Registrar Jornada de Producción',
      badgeText: 'Ficha Planta',
      badgeColor: colors.accent,
      maxWidth: 520,
      content: StatefulBuilder(
        builder: (ctx, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selección de Línea (Galletas vs Barras)
            Text('Línea de Producción *:', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => tipo = 'Galletas'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: tipo == 'Galletas' ? colors.surfaceElevated : colors.surfaceDeep,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: tipo == 'Galletas' ? colors.accent : colors.borderSubtle),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Galletas',
                        style: TextStyle(
                          color: tipo == 'Galletas' ? colors.textPrimary : colors.textMuted,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => tipo = 'Barras'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: tipo == 'Barras' ? colors.surfaceElevated : colors.surfaceDeep,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: tipo == 'Barras' ? colors.accent : colors.borderSubtle),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Barras',
                        style: TextStyle(
                          color: tipo == 'Barras' ? colors.textPrimary : colors.textMuted,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Fecha y Turno
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha *:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: fechaCtrl),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Turno *:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.borderSubtle),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: turno,
                            isExpanded: true,
                            dropdownColor: colors.surfaceCard,
                            style: TextStyle(color: colors.textSecondary, fontSize: 11),
                            onChanged: (v) => setState(() => turno = v!),
                            items: const [
                              DropdownMenuItem(value: 'Dia', child: Text('Turno Día')),
                              DropdownMenuItem(value: 'Noche', child: Text('Turno Noche')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Supervisor
            Text('Supervisor de Turno:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            CustomInputField(colors: colors, controller: supervisorCtrl),
            const SizedBox(height: 12),

            // Campos específicos para Galletas
            if (tipo == 'Galletas') ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Batches Galletas:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        CustomInputField(colors: colors, controller: batchesCtrl, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Extruido en Tolva (kg):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        CustomInputField(colors: colors, controller: extruidoCtrl, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
            ]
            // Campos específicos para Barras
            else ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Batch Jarabe:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        CustomInputField(colors: colors, controller: batchJarabeCtrl, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cant. Tinas:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        CustomInputField(colors: colors, controller: tinasCtrl, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),

            // Merma Total y Rendimiento
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Merma Total (kg):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: mermaCtrl, keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rendimiento estimado (%):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: rendimientoCtrl, keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Observaciones
            Text('Observaciones:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            CustomInputField(colors: colors, controller: obsCtrl, maxLines: 2),
          ],
        ),
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cancelar',
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        CustomButton(
          variant: ButtonVariant.primary,
          text: 'Guardar Jornada',
          onTap: () async {
            final newRun = ProductionRun(
              id: 'jor_${DateTime.now().millisecondsSinceEpoch}',
              fecha: fechaCtrl.text.trim(),
              turno: turno,
              tipo: tipo,
              supervisor: supervisorCtrl.text.trim(),
              cantBatch: double.tryParse(batchesCtrl.text) ?? 10.0,
              mermaTotal: double.tryParse(mermaCtrl.text) ?? 20.0,
              rendimiento: double.tryParse(rendimientoCtrl.text) ?? 95.0,
              observaciones: obsCtrl.text.trim(),
              mermasDetalle: {
                'piso_crudo': 5.0,
                'maquina': 6.0,
                'bobinas': 4.0,
              },
              lotes: [
                ProductionLote(
                  idProducto: 'prod_auto',
                  numero: '9901',
                  producto: tipo == 'Galletas' ? 'Galleta con Quinua' : 'Barra con Kiwicha',
                  cantidad: 150,
                ),
              ],
            );

            await ref.read(productionProvider.notifier).addRun(newRun);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Jornada de $tipo registrada exitosamente.')),
              );
            }
          },
        ),
      ],
    );
  }
}
