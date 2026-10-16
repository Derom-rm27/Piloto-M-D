import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/warehouse_model.dart';
import '../../../features/reports/warehouse_report_service.dart';
import '../../state/personnel_provider.dart';
import '../../state/theme_provider.dart';
import '../../state/warehouse_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/pdf_preview_screen.dart';

class WarehouseModals {
  /// 1. MODAL REGISTRAR ENTRADA (NUEVO INGRESO)
  static void showEntrada({
    required BuildContext context,
    required WidgetRef ref,
    int? preselectedInsumoId,
  }) {
    final colors = ref.read(themeColorsProvider);
    final wState = ref.read(warehouseProvider);
    final wNotifier = ref.read(warehouseProvider.notifier);

    int selectedId = preselectedInsumoId ?? (wState.insumos.isNotEmpty ? wState.insumos.first.id : 1);
    final cantCtrl = TextEditingController(text: '20');
    final loteCtrl = TextEditingController(text: '${1000 + Random().nextInt(9000)}');
    final fIngresoCtrl = TextEditingController(text: wState.fechaOperativa);

    final fVenceBase = DateTime.tryParse(wState.fechaOperativa) ?? DateTime.now();
    final fVenceDefault = DateTime(fVenceBase.year, fVenceBase.month + 6, fVenceBase.day);
    final fVenceCtrl = TextEditingController(
      text: '${fVenceDefault.year.toString().padLeft(4, '0')}-${fVenceDefault.month.toString().padLeft(2, '0')}-${fVenceDefault.day.toString().padLeft(2, '0')}',
    );

    final provCtrl = TextEditingController(text: 'Molino del Sur S.A.');
    final guiaCtrl = TextEditingController(text: 'GR-001-${(1000 + Random().nextInt(9000))}');
    final respCtrl = TextEditingController(text: 'Amelia Evelyn Ticona Pari');

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Registrar Entrada (Nuevo Ingreso)',
      badgeText: 'Almacén Central',
      badgeColor: AppTokens.emeraldDarkBg,
      maxWidth: 520,
      content: StatefulBuilder(
        builder: (ctx, setState) {
          void sumarMeses(int meses) {
            final b = DateTime.tryParse(fIngresoCtrl.text) ?? DateTime.now();
            final nv = DateTime(b.year, b.month + meses, b.day);
            setState(() {
              fVenceCtrl.text = '${nv.year.toString().padLeft(4, '0')}-${nv.month.toString().padLeft(2, '0')}-${nv.day.toString().padLeft(2, '0')}';
            });
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLabel(colors, 'Insumo que ingresa:'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.inputBg,
                    border: Border.all(color: colors.borderMedium),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedId,
                      dropdownColor: colors.surfaceCard,
                      isExpanded: true,
                      style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                      items: wState.insumos.map((i) => DropdownMenuItem(
                        value: i.id,
                        child: Text('${i.nombre} (${i.unidad})', overflow: TextOverflow.ellipsis),
                      )).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => selectedId = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Cantidad que entra:'),
                          _buildInput(colors, cantCtrl, keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'N° Lote (Solo Números):'),
                          _buildInput(colors, loteCtrl, keyboardType: TextInputType.number, isMono: true),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Fecha de Ingreso:'),
                          _buildInput(colors, fIngresoCtrl),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Fecha Vencimiento:'),
                          _buildInput(colors, fVenceCtrl),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Vencimiento rápido
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Vencimiento rápido:', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                    _buildPillBtn(colors, '+6 Meses', () => sumarMeses(6)),
                    _buildPillBtn(colors, '+1 Año', () => sumarMeses(12)),
                    _buildPillBtn(colors, '+2 Años', () => sumarMeses(24)),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Proveedor:'),
                          _buildInput(colors, provCtrl),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'N° Guía / Factura:'),
                          _buildInput(colors, guiaCtrl, isMono: true),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _buildLabel(colors, 'Recibido por (Almacén):'),
                _buildInput(colors, respCtrl),
              ],
            ),
          );
        },
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cancelar',
          onTap: () => Navigator.of(context).pop(),
        ),
        CustomButton(
          variant: ButtonVariant.success,
          text: 'Guardar y Ver PDF',
          icon: const Icon(Icons.picture_as_pdf, size: 14, color: Colors.white),
          onTap: () async {
            final cant = double.tryParse(cantCtrl.text) ?? 0.0;
            final nroLote = loteCtrl.text.trim();
            if (cant <= 0 || nroLote.isEmpty || fVenceCtrl.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ingrese una cantidad válida, número de lote y fecha de vencimiento.')),
              );
              return;
            }

            final mov = await wNotifier.registrarEntrada(
              prodId: selectedId,
              cant: cant,
              nroLote: nroLote,
              fIngreso: fIngresoCtrl.text,
              fVence: fVenceCtrl.text,
              proveedor: provCtrl.text,
              guia: guiaCtrl.text,
              responsable: respCtrl.text,
            );

            if (!context.mounted) return;
            Navigator.of(context).pop();

            // Abrir visor de PDF de la Nota de Recepción
            final ins = wState.insumos.firstWhere((i) => i.id == selectedId);
            final lote = LoteItem(
              id: 'tmp',
              prodId: selectedId,
              nroLote: nroLote,
              fIngreso: fIngresoCtrl.text,
              fVence: fVenceCtrl.text,
              saldo: cant,
            );

            final bytes = await WarehouseReportService.generateNotaRecepcionPdf(mov, lote, ins);
            if (!context.mounted) return;
            PdfViewerScreen.open(
              context: context,
              title: 'Nota de Recepción ${mov.lote}',
              fileName: 'Nota_Recepcion_${mov.lote}.pdf',
              bytes: bytes,
              colors: colors,
            );
          },
        ),
      ],
    );
  }

  /// 2. MODAL REGISTRAR SALIDA PEPS (DESPACHO A TURNO)
  static void showSalida({
    required BuildContext context,
    required WidgetRef ref,
    int? preselectedInsumoId,
  }) {
    final colors = ref.read(themeColorsProvider);
    final wState = ref.read(warehouseProvider);
    final wNotifier = ref.read(warehouseProvider.notifier);
    final store = ref.read(appStoreProvider);

    int selectedId = preselectedInsumoId ?? (wState.insumos.isNotEmpty ? wState.insumos.first.id : 1);
    final cantCtrl = TextEditingController(text: '8');
    final fSalidaCtrl = TextEditingController(text: wState.fechaOperativa);
    String selectedDestino = 'Línea Galletas - Horno Túnel';
    String selectedOperario = 'Delfin Estanis Roque Mullisaca';

    final jornadas = store?.rows('jornadas_produccion') ?? [];
    String? selectedJornadaId = jornadas.isNotEmpty ? '${jornadas.first['id_jornada']}' : null;

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Registrar Salida PEPS (Despacho a Turno)',
      badgeText: 'Control PEPS',
      badgeColor: AppTokens.amberBgDark,
      maxWidth: 540,
      content: StatefulBuilder(
        builder: (ctx, setState) {
          final lotesPeps = wNotifier.getLotesPeps(selectedId);
          final cantPedida = double.tryParse(cantCtrl.text) ?? 0.0;

          // Cálculo PEPS en tiempo real
          double restante = cantPedida;
          final desgloses = <(LoteItem, double)>[];
          for (final l in lotesPeps) {
            if (restante <= 0) break;
            final aSacar = min(l.saldo, restante);
            desgloses.add((l, aSacar));
            restante -= aSacar;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLabel(colors, 'Insumo a retirar:'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.inputBg,
                    border: Border.all(color: colors.borderMedium),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedId,
                      dropdownColor: colors.surfaceCard,
                      isExpanded: true,
                      style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                      items: wState.insumos.map((i) => DropdownMenuItem(
                        value: i.id,
                        child: Text('${i.nombre} (${i.unidad})', overflow: TextOverflow.ellipsis),
                      )).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => selectedId = v);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Cantidad a sacar:'),
                          _buildInput(
                            colors,
                            cantCtrl,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Fecha Salida:'),
                          _buildInput(colors, fSalidaCtrl),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Destino y Operario
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Destino:'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: colors.inputBg,
                              border: Border.all(color: colors.borderMedium),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedDestino,
                                dropdownColor: colors.surfaceCard,
                                isExpanded: true,
                                style: TextStyle(color: colors.textPrimary, fontSize: 11),
                                items: const [
                                  DropdownMenuItem(value: 'Línea Galletas - Horno Túnel', child: Text('Línea Galletas')),
                                  DropdownMenuItem(value: 'Línea Barras - Marmita', child: Text('Línea Barras')),
                                  DropdownMenuItem(value: 'Área de Envasado', child: Text('Envasado')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setState(() => selectedDestino = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(colors, 'Quién Retira (Operario):'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: colors.inputBg,
                              border: Border.all(color: colors.borderMedium),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedOperario,
                                dropdownColor: colors.surfaceCard,
                                isExpanded: true,
                                style: TextStyle(color: colors.textPrimary, fontSize: 11),
                                items: const [
                                  DropdownMenuItem(value: 'Delfin Estanis Roque Mullisaca', child: Text('Delfin Estanis Roque')),
                                  DropdownMenuItem(value: 'Amelia Evelyn Ticona Pari', child: Text('Amelia Evelyn Ticona')),
                                  DropdownMenuItem(value: 'Vianet Charca Mamani', child: Text('Vianet Charca')),
                                  DropdownMenuItem(value: 'Marisol Huacasi Mamani', child: Text('Marisol Huacasi')),
                                  DropdownMenuItem(value: 'Miriam Tito Sanca', child: Text('Miriam Tito Sanca')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setState(() => selectedOperario = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Vincular con Jornada de Producción
                _buildLabel(colors, 'Vincular a Jornada / Turno:'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colors.inputBg,
                    border: Border.all(color: colors.borderMedium),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: selectedJornadaId,
                      dropdownColor: colors.surfaceCard,
                      isExpanded: true,
                      style: TextStyle(color: colors.textPrimary, fontSize: 11, fontFamily: 'monospace'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Sin vincular (Salida general)')),
                        ...jornadas.map((j) {
                          final f = j['fecha'] ?? '';
                          final t = j['turno'] ?? '';
                          final id = '${j['id_jornada']}';
                          final shortId = id.length > 15 ? id.substring(0, 15) : id;
                          return DropdownMenuItem(
                            value: id,
                            child: Text('$shortId ($f - $t)', overflow: TextOverflow.ellipsis),
                          );
                        }),
                      ],
                      onChanged: (v) => setState(() => selectedJornadaId = v),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Detalle del Lote asignado por PEPS
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.borderMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lotes asignados automáticamente por PEPS:',
                        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                      const SizedBox(height: 6),
                      if (lotesPeps.isEmpty)
                        Text('Sin stock disponible para este insumo.', style: TextStyle(color: AppTokens.dangerSolid, fontWeight: FontWeight.bold, fontSize: 11))
                      else if (desgloses.isEmpty)
                        Text('Ingrese una cantidad mayor a 0.', style: TextStyle(color: colors.textMuted, fontSize: 11))
                      else ...[
                        for (final (l, q) in desgloses)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Lote ${l.nroLote}', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12)),
                                    const SizedBox(width: 6),
                                    Text('(Vence: ${l.fVence})', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                                  ],
                                ),
                                Text('Retirar: ${q.toStringAsFixed(0)}', style: const TextStyle(color: AppTokens.amberText, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        if (restante > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Faltan ${restante.toStringAsFixed(0)} unidades para completar lo requerido.',
                              style: TextStyle(color: AppTokens.dangerSolid, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cancelar',
          onTap: () => Navigator.of(context).pop(),
        ),
        CustomButton(
          variant: ButtonVariant.primary,
          text: 'Confirmar Salida PEPS',
          icon: const Icon(Icons.outbox, size: 14, color: Colors.white),
          onTap: () async {
            final cant = double.tryParse(cantCtrl.text) ?? 0.0;
            if (cant <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ingrese una cantidad válida a retirar.')),
              );
              return;
            }

            final ins = wState.insumos.firstWhere((i) => i.id == selectedId);
            await wNotifier.registrarSalidaPeps(
              prodId: selectedId,
              cant: cant,
              fSalida: fSalidaCtrl.text,
              destino: selectedDestino,
              operario: selectedOperario,
              jornadaId: selectedJornadaId,
            );

            if (!context.mounted) return;
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Salida confirmada: Se retiraron ${cant.toStringAsFixed(0)} unidades de ${ins.nombre} bajo regla PEPS.')),
            );
          },
        ),
      ],
    );
  }

  /// 3. MODAL VER LOTES DE UN PRODUCTO
  static void showVerLotes({
    required BuildContext context,
    required WidgetRef ref,
    required InsumoItem insumo,
  }) {
    final colors = ref.read(themeColorsProvider);
    final wNotifier = ref.read(warehouseProvider.notifier);
    final lotes = wNotifier.getLotesPeps(insumo.id);

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Lotes de: ${insumo.nombre}',
      badgeText: 'PEPS',
      badgeColor: AppTokens.darkAccent,
      maxWidth: 560,
      content: SizedBox(
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ordenados de menor a mayor vencimiento (Regla PEPS de planta):',
              style: TextStyle(color: colors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceCard,
                  border: Border.all(color: colors.borderMedium),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: lotes.isEmpty
                    ? Center(
                        child: Text('Sin lotes activos en almacén.', style: TextStyle(color: colors.textMuted, fontStyle: FontStyle.italic)),
                      )
                    : ListView.separated(
                        itemCount: lotes.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: colors.borderSubtle),
                        itemBuilder: (ctx, idx) {
                          final l = lotes[idx];
                          final esPrimero = idx == 0;
                          return Container(
                            color: esPrimero ? (colors.isDark ? const Color(0x1F2B0E9C) : const Color(0x0F27741B)) : null,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: esPrimero ? (colors.isDark ? AppTokens.darkAccent : AppTokens.lightAccent) : colors.surfaceElevated,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${idx + 1}',
                                    style: TextStyle(
                                      color: esPrimero ? Colors.white : colors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Lote ${l.nroLote}',
                                            style: TextStyle(
                                              color: esPrimero ? (colors.isDark ? AppTokens.darkAccentText : AppTokens.lightAccent) : colors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'monospace',
                                              fontSize: 13,
                                            ),
                                          ),
                                          if (esPrimero) ...[
                                            const SizedBox(width: 8),
                                            CustomBadge(
                                              text: 'Próxima Salida',
                                              bg: colors.isDark ? AppTokens.darkAccentSubtle : AppTokens.lightAccentSubtle,
                                              fg: colors.isDark ? AppTokens.darkAccentText : AppTokens.lightAccent,
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Ingreso: ${l.fIngreso}  ·  Vence: ${l.fVence}',
                                        style: TextStyle(color: colors.textMuted, fontSize: 10.5),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${l.saldo.toStringAsFixed(0)} ${insumo.unidad.split(' ').first}',
                                      style: TextStyle(
                                        color: esPrimero ? AppTokens.amberText : colors.textPrimary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '${(l.saldo * insumo.kgPorUnidad).toStringAsFixed(1)} kg',
                                      style: TextStyle(color: colors.textMuted, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cerrar',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  /// 4. MODAL HISTORIAL DE MOVIMIENTOS & TRAZABILIDAD
  static void showHistorial({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final colors = ref.read(themeColorsProvider);
    final wState = ref.read(warehouseProvider);

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Historial de Movimientos de Almacén',
      badgeText: '${wState.movimientos.length} registros',
      maxWidth: 720,
      content: SizedBox(
        height: 380,
        child: wState.movimientos.isEmpty
            ? Center(child: Text('Sin movimientos registrados.', style: TextStyle(color: colors.textMuted)))
            : ListView.separated(
                itemCount: wState.movimientos.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: colors.borderSubtle),
                itemBuilder: (ctx, idx) {
                  final m = wState.movimientos[idx];
                  final esEntrada = m.esEntrada;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: esEntrada ? (colors.isDark ? AppTokens.emeraldDarkBg : AppTokens.emeraldLightBg) : (colors.isDark ? AppTokens.amberBgDark : const Color(0xFFFEF3C7)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            m.tipo,
                            style: TextStyle(
                              color: esEntrada ? AppTokens.emeraldPrimary : AppTokens.amberText,
                              fontWeight: FontWeight.bold,
                              fontSize: 9.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(m.prod, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11.5)),
                                  const SizedBox(width: 6),
                                  Text('Lote ${m.lote}', style: TextStyle(color: colors.textMuted, fontFamily: 'monospace', fontSize: 10.5)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${m.fechaHora} · Por: ${m.operario} · Destino: ${m.destino}',
                                style: TextStyle(color: colors.textMuted, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${m.cant.toStringAsFixed(0)} ${m.unidad}',
                          style: TextStyle(
                            color: esEntrada ? AppTokens.emeraldPrimary : AppTokens.amberText,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cerrar',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  // --- HELPERS UI ---
  static Widget _buildLabel(ThemeColors colors, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: TextStyle(color: colors.textMuted, fontWeight: FontWeight.bold, fontSize: 10.5),
        ),
      );

  static Widget _buildInput(
    ThemeColors colors,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool isMono = false,
    ValueChanged<String>? onChanged,
  }) =>
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: isMono ? 'monospace' : null,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: colors.inputBg,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colors.borderMedium),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: colors.borderHighlight, width: 1.5),
          ),
        ),
      );

  static Widget _buildPillBtn(ThemeColors colors, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.borderMedium),
          ),
          child: Text(
            label,
            style: TextStyle(color: colors.textPrimary, fontSize: 9.5, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
