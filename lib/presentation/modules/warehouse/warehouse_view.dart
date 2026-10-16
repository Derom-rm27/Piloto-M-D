import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/warehouse_model.dart';
import '../../../features/reports/warehouse_report_service.dart';
import '../../state/theme_provider.dart';
import '../../state/warehouse_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/pdf_preview_screen.dart';
import 'warehouse_modals.dart';

class WarehouseView extends ConsumerWidget {
  const WarehouseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(themeColorsProvider);
    final wState = ref.watch(warehouseProvider);
    final wNotifier = ref.watch(warehouseProvider.notifier);
    final isWide = MediaQuery.of(context).size.width >= 960;

    // Filtrar insumos según categoría, texto de búsqueda y filtro de alertas rojas
    final insumosFiltrados = wState.insumos.where((ins) {
      if (wState.categoriaActiva != 'TODOS' && ins.categoria != wState.categoriaActiva) {
        return false;
      }
      if (wState.soloRojas) {
        if (!wNotifier.calcularCobertura(ins).esAlertaRoja) return false;
      }
      if (wState.textoBusqueda.trim().isNotEmpty) {
        final query = wState.textoBusqueda.toLowerCase();
        final matchNom = ins.nombre.toLowerCase().contains(query);
        final lotes = wNotifier.getLotesPeps(ins.id);
        final matchLote = lotes.any((l) => l.nroLote.contains(query));
        if (!matchNom && !matchLote) return false;
      }
      return true;
    }).toList();

    final totalRojos = wNotifier.countRojas;
    final nombresRojos = wNotifier.nombresRojos;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Barra de Encabezado Superior
            _buildTopBar(context, ref, colors, wState, wNotifier, isWide),

            // 2. Banner de Alerta Roja si algún insumo tiene stock < 1 turno
            if (totalRojos > 0)
              _buildAlertBanner(context, colors, wState, wNotifier, totalRojos, nombresRojos),

            // 3. Barra de Acciones y Búsqueda
            _buildActionSearchRow(context, ref, colors, wNotifier, isWide),

            // 4. Pastillas de Filtro por Categoría
            _buildCategoryPills(colors, wState, wNotifier, totalRojos, isWide),

            // 5. Contenido Principal: Tabla de Existencias y Lotes PEPS
            Expanded(
              child: insumosFiltrados.isEmpty
                  ? Center(
                      child: Text(
                        'No se encontraron insumos que coincidan con la búsqueda.',
                        style: TextStyle(color: colors.textMuted, fontSize: 13),
                      ),
                    )
                  : isWide
                      ? _buildWideTable(context, ref, colors, insumosFiltrados, wNotifier)
                      : _buildMobileList(context, ref, colors, insumosFiltrados, wNotifier),
            ),
          ],
        ),

        // 6. Barra Flotante Inferior (Floating Dock)
        Positioned(
          bottom: 18,
          right: 20,
          child: _buildFloatingDock(context, ref, colors, wState, wNotifier),
        ),
      ],
    );
  }

  // --- 1. TOP BAR ---
  Widget _buildTopBar(
    BuildContext context,
    WidgetRef ref,
    ThemeColors colors,
    WarehouseState state,
    WarehouseNotifier notifier,
    bool isWide,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: colors.isDark ? AppTokens.darkAccent : AppTokens.lightAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warehouse_outlined, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Almacén M&D Planta',
                        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Text('· Control PEPS', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                    ],
                  ),
                  Text('Control de Insumos y Trazabilidad de Producción', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                ],
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selector de Fecha
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.inputBg,
                  border: Border.all(color: colors.borderMedium),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: colors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      state.fechaOperativa,
                      style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        final now = DateTime.now();
                        notifier.setFechaOperativa('${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(color: colors.surfaceElevated, borderRadius: BorderRadius.circular(4)),
                        child: Text('Hoy', style: TextStyle(color: colors.textPrimary, fontSize: 9.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Selector de Batches
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.inputBg,
                  border: Border.all(color: colors.borderMedium),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: state.batchesPorTurno,
                    dropdownColor: colors.surfaceCard,
                    style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 20, child: Text('20 Batches (Estándar)')),
                      DropdownMenuItem(value: 18, child: Text('18 Batches')),
                      DropdownMenuItem(value: 15, child: Text('15 Batches (Mínimo)')),
                    ],
                    onChanged: (v) {
                      if (v != null) notifier.setBatchesPorTurno(v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Botón PDF Stock
              CustomButton(
                variant: ButtonVariant.subtle,
                text: 'PDF Stock',
                icon: Icon(Icons.picture_as_pdf_outlined, size: 14, color: colors.isDark ? AppTokens.darkAccentText : AppTokens.lightAccent),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                fontSize: 11,
                onTap: () => _generarPdfStock(context, colors, state, notifier),
              ),
              const SizedBox(width: 8),

              // Botón Historial
              CustomButton(
                variant: ButtonVariant.subtle,
                text: 'Historial',
                icon: const Icon(Icons.history_outlined, size: 14),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                fontSize: 11,
                onTap: () => WarehouseModals.showHistorial(context: context, ref: ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. ALERT BANNER ---
  Widget _buildAlertBanner(
    BuildContext context,
    ThemeColors colors,
    WarehouseState state,
    WarehouseNotifier notifier,
    int totalRojos,
    List<String> nombres,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.isDark ? const Color(0x2E4C0519) : const Color(0xFFFEE2E2),
        border: Border(bottom: BorderSide(color: AppTokens.dangerSolid.withValues(alpha: 0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 16, color: AppTokens.dangerSolid),
                const SizedBox(width: 6),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 11, color: AppTokens.dangerSolid),
                      children: [
                        const TextSpan(text: 'Insumos con stock menor a 1 turno: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: '${nombres.take(4).join(', ')}${nombres.length > 4 ? ' y otros' : ''}. Requieren pedido de reposición a compras.',
                          style: TextStyle(color: colors.isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C)),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => notifier.toggleSoloRojas(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              state.soloRojas ? 'Ver todos los insumos' : 'Ver solo insumos que requieren pedido',
              style: TextStyle(color: AppTokens.dangerSolid, fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. ACCIONES Y BÚSQUEDA ---
  Widget _buildActionSearchRow(
    BuildContext context,
    WidgetRef ref,
    ThemeColors colors,
    WarehouseNotifier notifier,
    bool isWide,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                variant: ButtonVariant.success,
                text: 'Registrar Entrada',
                icon: const Icon(Icons.add_circle_outline, size: 14, color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                fontSize: 11.5,
                onTap: () => WarehouseModals.showEntrada(context: context, ref: ref),
              ),
              const SizedBox(width: 8),
              CustomButton(
                variant: ButtonVariant.primary,
                text: 'Registrar Salida PEPS',
                icon: const Icon(Icons.remove_circle_outline, size: 14, color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                fontSize: 11.5,
                onTap: () => WarehouseModals.showSalida(context: context, ref: ref),
              ),
            ],
          ),

          // Buscador
          SizedBox(
            width: isWide ? 260 : 160,
            height: 34,
            child: TextField(
              onChanged: (q) => notifier.setBusqueda(q),
              style: TextStyle(color: colors.textPrimary, fontSize: 11.5),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Buscar insumo o lote...',
                hintStyle: TextStyle(color: colors.textMuted, fontSize: 11),
                prefixIcon: Icon(Icons.search, size: 16, color: colors.textMuted),
                filled: true,
                fillColor: colors.inputBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.borderMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.borderHighlight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. CATEGORY PILLS ---
  Widget _buildCategoryPills(
    ThemeColors colors,
    WarehouseState state,
    WarehouseNotifier notifier,
    int totalRojos,
    bool isWide,
  ) {
    final harinasCount = state.insumos.where((i) => i.categoria == 'MATERIA_PRIMA').length;
    final insumosCount = state.insumos.where((i) => i.categoria == 'INSUMOS').length;
    final empaquesCount = state.insumos.where((i) => i.categoria == 'EMPAQUES').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: colors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 6,
            children: [
              _buildPill(colors, 'Todos (${state.insumos.length})', state.categoriaActiva == 'TODOS', () => notifier.setCategoria('TODOS')),
              _buildPill(colors, 'Harinas y Granos ($harinasCount)', state.categoriaActiva == 'MATERIA_PRIMA', () => notifier.setCategoria('MATERIA_PRIMA')),
              _buildPill(colors, 'Insumos y Grasas ($insumosCount)', state.categoriaActiva == 'INSUMOS', () => notifier.setCategoria('INSUMOS')),
              _buildPill(colors, 'Material de Empaque ($empaquesCount)', state.categoriaActiva == 'EMPAQUES', () => notifier.setCategoria('EMPAQUES')),
            ],
          ),

          if (isWide && totalRojos > 0)
            Text(
              '$totalRojos insumos requieren pedido urgente',
              style: TextStyle(color: AppTokens.dangerSolid, fontWeight: FontWeight.bold, fontSize: 11),
            ),
        ],
      ),
    );
  }

  Widget _buildPill(ThemeColors colors, String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? (colors.isDark ? AppTokens.darkAccent : AppTokens.lightAccent) : colors.surfaceCard,
          border: Border.all(color: active ? Colors.transparent : colors.borderMedium),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : colors.textMuted,
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  // --- 5. TABLA ANCHA (DESKTOP) ---
  Widget _buildWideTable(
    BuildContext context,
    WidgetRef ref,
    ThemeColors colors,
    List<InsumoItem> insumos,
    WarehouseNotifier notifier,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border.all(color: colors.borderMedium),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header de la Tabla
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                border: Border(bottom: BorderSide(color: colors.borderMedium)),
              ),
              child: Row(
                children: [
                  _colHeader(colors, 'N°', width: 34, align: TextAlign.center),
                  _colHeader(colors, 'Insumo / Materia Prima', flex: 3),
                  _colHeader(colors, 'Gasto x Batch', flex: 2, align: TextAlign.right),
                  _colHeader(colors, 'Necesario x Turno', flex: 2, align: TextAlign.right),
                  _colHeader(colors, 'Stock Actual', flex: 2, align: TextAlign.right),
                  _colHeader(colors, 'Estado de Turno', flex: 3, align: TextAlign.center),
                  _colHeader(colors, 'Lote PEPS (Próxima Salida)', flex: 3),
                  _colHeader(colors, 'Acciones', width: 155, align: TextAlign.center),
                ],
              ),
            ),

            // Filas
            Expanded(
              child: ListView.separated(
                itemCount: insumos.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: colors.borderSubtle),
                itemBuilder: (ctx, idx) {
                  final ins = insumos[idx];
                  final cob = notifier.calcularCobertura(ins);
                  final lotes = notifier.getLotesPeps(ins.id);
                  final lotePeps = lotes.isNotEmpty ? lotes.first : null;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: idx % 2 == 1 ? (colors.isDark ? const Color(0x0AFFFFFF) : const Color(0x03000000)) : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // N°
                        SizedBox(
                          width: 34,
                          child: Text('${idx + 1}', textAlign: TextAlign.center, style: TextStyle(color: colors.textMuted, fontSize: 11, fontFamily: 'monospace')),
                        ),

                        // Insumo
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ins.nombre, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(ins.unidad, style: TextStyle(color: colors.textMuted, fontSize: 10)),
                            ],
                          ),
                        ),

                        // Gasto x Batch
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${ins.kgPorBatch.toStringAsFixed(2)} kg',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: colors.textPrimary, fontSize: 11.5, fontFamily: 'monospace'),
                          ),
                        ),

                        // Req. Turno
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${cob.kgNecesariosTurno.toStringAsFixed(1)} kg', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11.5)),
                              Text('(~${cob.unidadesNecesariasTurno} ${ins.unidad.split(' ').first})', style: TextStyle(color: colors.textMuted, fontSize: 9.5)),
                            ],
                          ),
                        ),

                        // Stock Actual
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                cob.stockUnidades.toStringAsFixed(0),
                                style: TextStyle(
                                  color: cob.esAlertaRoja ? AppTokens.dangerSolid : colors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                              Text('${cob.stockKg.toStringAsFixed(1)} kg', style: TextStyle(color: colors.textMuted, fontSize: 9.5, fontFamily: 'monospace')),
                            ],
                          ),
                        ),

                        // Estado de Turno (Regla: Solo Texto en Rojo sin aspas)
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: cob.esAlertaRoja
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Pedido urgente', style: TextStyle(color: AppTokens.dangerSolid, fontWeight: FontWeight.bold, fontSize: 11)),
                                      Text(
                                        'Faltan ${cob.faltaParaTurnoUnidades} ${ins.unidad.split(' ').first} (rinde ${cob.turnosRinde} t.)',
                                        style: TextStyle(color: colors.isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C), fontSize: 9.5),
                                      ),
                                    ],
                                  )
                                : Text(
                                    cob.turnosRinde <= 1.5
                                        ? 'Stock para ${cob.turnosRinde} turnos'
                                        : 'Suficiente (${cob.turnosRinde} turnos)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: cob.turnosRinde <= 1.5 ? AppTokens.amberText : colors.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                          ),
                        ),

                        // Lote PEPS
                        Expanded(
                          flex: 3,
                          child: lotePeps == null
                              ? Text('Sin stock', style: TextStyle(color: colors.textMuted, fontStyle: FontStyle.italic, fontSize: 11))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Lote ${lotePeps.nroLote}', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 12)),
                                        Text('(${lotePeps.saldo.toStringAsFixed(0)} disp.)', style: TextStyle(color: colors.textMuted, fontSize: 9.5)),
                                      ],
                                    ),
                                    Text('Vence: ${lotePeps.fVence}', style: TextStyle(color: colors.textMuted, fontSize: 9.5)),
                                  ],
                                ),
                        ),

                        // Acciones
                        SizedBox(
                          width: 155,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _actionBtn('Salida', AppTokens.amberBgDark, AppTokens.amberText, () {
                                WarehouseModals.showSalida(context: context, ref: ref, preselectedInsumoId: ins.id);
                              }),
                              const SizedBox(width: 4),
                              _actionBtn('Entrada', colors.isDark ? AppTokens.darkAccent : AppTokens.lightAccent, Colors.white, () {
                                WarehouseModals.showEntrada(context: context, ref: ref, preselectedInsumoId: ins.id);
                              }),
                              const SizedBox(width: 4),
                              _actionBtn('Lotes', colors.surfaceElevated, colors.textPrimary, () {
                                WarehouseModals.showVerLotes(context: context, ref: ref, insumo: ins);
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5B. LISTA MÓVIL (RESPONSIVE CARDS) ---
  Widget _buildMobileList(
    BuildContext context,
    WidgetRef ref,
    ThemeColors colors,
    List<InsumoItem> insumos,
    WarehouseNotifier notifier,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
      itemCount: insumos.length,
      itemBuilder: (ctx, idx) {
        final ins = insumos[idx];
        final cob = notifier.calcularCobertura(ins);
        final lotes = notifier.getLotesPeps(ins.id);
        final lotePeps = lotes.isNotEmpty ? lotes.first : null;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: colors.surfaceCard,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: cob.esAlertaRoja ? AppTokens.dangerSolid.withValues(alpha: 0.5) : colors.borderMedium,
              width: cob.esAlertaRoja ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ins.nombre,
                        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${cob.stockUnidades.toStringAsFixed(0)} ${ins.unidad.split(' ').first}',
                      style: TextStyle(
                        color: cob.esAlertaRoja ? AppTokens.dangerSolid : colors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ins.unidad, style: TextStyle(color: colors.textMuted, fontSize: 10.5)),
                    Text('${cob.stockKg.toStringAsFixed(1)} kg disponibles', style: TextStyle(color: colors.textMuted, fontSize: 10.5)),
                  ],
                ),
                const SizedBox(height: 8),

                // Cobertura y Lote PEPS
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lote PEPS Próximo:', style: TextStyle(color: colors.textMuted, fontSize: 9.5)),
                          Text(
                            lotePeps != null ? 'Lote ${lotePeps.nroLote} (${lotePeps.fVence})' : 'Sin stock',
                            style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Estado:', style: TextStyle(color: colors.textMuted, fontSize: 9.5)),
                          Text(
                            cob.esAlertaRoja ? 'Pedido urgente' : '${cob.turnosRinde} turnos',
                            style: TextStyle(
                              color: cob.esAlertaRoja ? AppTokens.dangerSolid : AppTokens.emeraldPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Botones Rápidos
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _actionBtn('Lotes', colors.surfaceElevated, colors.textPrimary, () {
                      WarehouseModals.showVerLotes(context: context, ref: ref, insumo: ins);
                    }),
                    const SizedBox(width: 6),
                    _actionBtn('Entrada', colors.isDark ? AppTokens.darkAccent : AppTokens.lightAccent, Colors.white, () {
                      WarehouseModals.showEntrada(context: context, ref: ref, preselectedInsumoId: ins.id);
                    }),
                    const SizedBox(width: 6),
                    _actionBtn('Salida PEPS', AppTokens.amberBgDark, AppTokens.amberText, () {
                      WarehouseModals.showSalida(context: context, ref: ref, preselectedInsumoId: ins.id);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 6. FLOATING DOCK ---
  Widget _buildFloatingDock(
    BuildContext context,
    WidgetRef ref,
    ThemeColors colors,
    WarehouseState state,
    WarehouseNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceCard.withValues(alpha: 0.95),
        border: Border.all(color: colors.borderHighlight.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            variant: ButtonVariant.success,
            text: 'Nuevo Ingreso',
            icon: const Icon(Icons.add, size: 14, color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            fontSize: 11,
            onTap: () => WarehouseModals.showEntrada(context: context, ref: ref),
          ),
          const SizedBox(width: 6),
          CustomButton(
            variant: ButtonVariant.primary,
            text: 'Salida PEPS',
            icon: const Icon(Icons.remove, size: 14, color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            fontSize: 11,
            onTap: () => WarehouseModals.showSalida(context: context, ref: ref),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => _generarPdfStock(context, colors, state, notifier),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: colors.isDark ? AppTokens.darkAccent : AppTokens.lightAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.print, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- GENERACIÓN DE PDF STOCK ---
  void _generarPdfStock(
    BuildContext context,
    ThemeColors colors,
    WarehouseState state,
    WarehouseNotifier notifier,
  ) async {
    final bytes = await WarehouseReportService.generateStockActualPdf(
      insumos: state.insumos,
      fechaCorte: state.fechaOperativa,
      batchesPorTurno: state.batchesPorTurno,
      getCobertura: notifier.calcularCobertura,
      getLotePeps: (id) {
        final lotes = notifier.getLotesPeps(id);
        return lotes.isNotEmpty ? lotes.first : null;
      },
    );

    if (!context.mounted) return;
    PdfViewerScreen.open(
      context: context,
      title: 'Estado de Existencias de Almacén',
      fileName: 'Stock_Almacen_${state.fechaOperativa}.pdf',
      bytes: bytes,
      colors: colors,
    );
  }

  // --- HELPERS UI ---
  Widget _colHeader(ThemeColors colors, String text, {int flex = 1, double? width, TextAlign align = TextAlign.left}) {
    final w = Text(
      text,
      textAlign: align,
      style: TextStyle(color: colors.textMuted, fontWeight: FontWeight.bold, fontSize: 10.5, letterSpacing: 0.3),
    );
    if (width != null) return SizedBox(width: width, child: w);
    return Expanded(flex: flex, child: w);
  }

  Widget _actionBtn(String label, Color bg, Color fg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
    );
  }
}
