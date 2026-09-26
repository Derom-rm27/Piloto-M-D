import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/domain/attendance.dart';
import '../../../core/domain/production.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../domain/models/worker.dart';
import '../../../features/reports/export_actions.dart';
import '../../../features/reports/report_service.dart';
import '../../state/attendance_provider.dart';
import '../../state/personnel_provider.dart';
import '../../state/theme_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';
import '../../widgets/pdf_preview_screen.dart';
import 'attendance_modals.dart';

class AttendanceView extends ConsumerStatefulWidget {
  const AttendanceView({super.key});

  @override
  ConsumerState<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends ConsumerState<AttendanceView> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _handleRefresh() async {
    final store = ref.read(appStoreProvider);
    if (store != null) {
      await store.sync();
      await store.load();
    }
    ref.invalidate(attendanceProvider);
    ref.invalidate(personnelProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(themeColorsProvider);
    final asisState = ref.watch(attendanceProvider);
    final persState = ref.watch(personnelProvider);

    // Regla 1: Excluir estrictamente a los trabajadores inactivos (activo = false)
    final activeWorkers = persState.workers.where((w) => w.activo).toList();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera con Subtabs responsivos (Marcación Rápida vs Reporte de Horas)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                border: Border(bottom: BorderSide(color: colors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _subtabBtn(
                      colors: colors,
                      label: 'Marcación Rápida',
                      isSelected: asisState.currentSubtab == 'marcacion',
                      onTap: () => ref.read(attendanceProvider.notifier).setSubtab('marcacion'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _subtabBtn(
                      colors: colors,
                      label: 'Reporte de Horas',
                      isSelected: asisState.currentSubtab == 'reporte',
                      onTap: () => ref.read(attendanceProvider.notifier).setSubtab('reporte'),
                    ),
                  ),
                ],
              ),
            ),

            // Vista del Subtab activo
            Expanded(
              child: asisState.currentSubtab == 'marcacion'
                  ? _buildMarcacionTab(context, colors, asisState, activeWorkers)
                  : _buildReporteTab(context, colors, asisState, activeWorkers),
            ),
          ],
        ),

        // Barra Flotante Inferior (Dock)
        // Regla 5: Aparece ÚNICAMENTE cuando al menos 1 persona está seleccionada
        if (asisState.selectedIds.isNotEmpty && asisState.currentSubtab == 'marcacion')
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: _buildFloatingDock(context, colors, asisState, activeWorkers),
          ),
      ],
    );
  }

  Widget _subtabBtn({
    required ThemeColors colors,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : colors.textMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildMarcacionTab(
    BuildContext context,
    ThemeColors colors,
    AttendanceState asisState,
    List<Worker> activeWorkers,
  ) {
    final filtered = asisState.getFilteredWorkers(activeWorkers);
    final countTodos = activeWorkers.length;
    final countEnPlanta = asisState.countEnPlanta(activeWorkers);
    final countFuera = asisState.countFuera(activeWorkers);
    final isAllSelected = filtered.isNotEmpty && filtered.every((w) => asisState.selectedIds.contains(w.id));

    return Column(
      children: [
        // Barra de búsqueda y filtros rápidos adaptados para celular
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            border: Border(bottom: BorderSide(color: colors.borderSubtle)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      colors: colors,
                      placeholder: 'Buscar trabajador...',
                      prefixIcon: Icon(Icons.search, size: 16, color: colors.textMuted),
                      onChanged: (val) => ref.read(attendanceProvider.notifier).setSearchQuery(val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => ref.read(attendanceProvider.notifier).selectAll(filtered),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.surfaceDeep,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAllSelected ? Icons.deselect : Icons.select_all,
                            size: 14,
                            color: colors.accentText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isAllSelected ? 'Ninguno' : 'Todos',
                            style: TextStyle(
                              color: colors.accentText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Chips de Estado scrollables horizontalmente (evita desbordamiento en celular)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _statusFilterChip(
                      colors: colors,
                      label: 'Todos ($countTodos)',
                      isSelected: asisState.statusFilter == 'todos',
                      onTap: () => ref.read(attendanceProvider.notifier).setStatusFilter('todos'),
                    ),
                    const SizedBox(width: 6),
                    _statusFilterChip(
                      colors: colors,
                      label: 'En Planta ($countEnPlanta)',
                      isSelected: asisState.statusFilter == 'en_planta',
                      textColor: AppTokens.emeraldDarkText,
                      onTap: () => ref.read(attendanceProvider.notifier).setStatusFilter('en_planta'),
                    ),
                    const SizedBox(width: 6),
                    _statusFilterChip(
                      colors: colors,
                      label: 'Fuera ($countFuera)',
                      isSelected: asisState.statusFilter == 'fuera',
                      textColor: colors.textMuted,
                      onTap: () => ref.read(attendanceProvider.notifier).setStatusFilter('fuera'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lista de Personal Ultra-Limpia ("Solo Nombre") con Pull-to-Refresh
        Expanded(
          child: filtered.isEmpty
              ? RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: colors.accent,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'No hay trabajadores en este estado.',
                            style: TextStyle(color: colors.textMuted, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: colors.accent,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 120),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final w = filtered[i];
                      final st = asisState.workerStatus[w.id];
                      final isEnPlanta = st?.isEnPlanta == true;
                      final isSelected = asisState.selectedIds.contains(w.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: GestureDetector(
                          onTap: () => ref.read(attendanceProvider.notifier).toggleWorkerSelection(w.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: isSelected
                                ? AppDecorations.selected(colors)
                                : BoxDecoration(
                                    color: colors.surfaceCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: colors.borderSubtle, width: 1),
                                  ),
                            child: Row(
                              children: [
                                // Checkbox interactivo
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected ? colors.accent : colors.surfaceDeep,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected ? colors.accent : colors.borderMedium,
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 10),

                                // Avatar de Iniciales
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isEnPlanta ? AppTokens.emeraldDarkBg : colors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isEnPlanta ? AppTokens.emeraldDarkBorder : colors.borderMedium,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    w.initials,
                                    style: TextStyle(
                                      color: isEnPlanta ? AppTokens.emeraldDarkText : colors.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Regla 4: Lista Ultra-Limpia ("Solo Nombre")
                                Expanded(
                                  child: Text(
                                    w.fullName,
                                    style: TextStyle(
                                      color: isEnPlanta ? colors.textPrimary : colors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: isEnPlanta ? FontWeight.bold : FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Indicador de Entrada activa
                                if (isEnPlanta) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: colors.isDark ? AppTokens.emeraldDarkBg : const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: colors.isDark ? AppTokens.emeraldDarkBorder : const Color(0xFFA5D6A7),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: AppTokens.emeraldPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          st?.hora != null ? 'En Planta · ${st!.hora}' : 'En Planta',
                                          style: TextStyle(
                                            color: colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _statusFilterChip({
    required ThemeColors colors,
    required String label,
    required bool isSelected,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? colors.surfaceElevated : colors.surfaceDeep,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colors.accent : colors.borderSubtle,
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (textColor ?? colors.textPrimary)
                : colors.textMuted,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Barra Flotante Inferior Responsiva
  /// Regla 5: Botón unificado "Editar", "ENTRADA" y "SALIDA". En celular se distribuye en 2 filas
  /// para evitar que las opciones queden ocultas o desborden la pantalla.
  Widget _buildFloatingDock(
    BuildContext context,
    ThemeColors colors,
    AttendanceState asisState,
    List<Worker> activeWorkers,
  ) {
    final count = asisState.selectedIds.length;
    final selectedWorkers = activeWorkers.where((w) => asisState.selectedIds.contains(w.id)).toList();
    final isMobile = MediaQuery.of(context).size.width < 460;

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: AppDecorations.floatingDock(colors),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$count',
                        style: TextStyle(
                          color: colors.accentText,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'seleccionados',
                          style: TextStyle(color: colors.textSecondary, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(attendanceProvider.notifier).clearSelection(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      'Limpiar',
                      style: TextStyle(color: colors.textMuted, fontSize: 11, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    variant: ButtonVariant.primary,
                    text: 'Editar',
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    fontSize: 11,
                    icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.white),
                    onTap: () {
                      AttendanceModals.showUnifiedEditModal(
                        context: context,
                        ref: ref,
                        colors: colors,
                        selectedWorkers: selectedWorkers,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: CustomButton(
                    variant: ButtonVariant.success,
                    text: 'ENTRADA',
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    fontSize: 11,
                    icon: const Icon(Icons.login, size: 14, color: Colors.white),
                    onTap: () {
                      AttendanceModals.showBatchConfirmModal(
                        context: context,
                        ref: ref,
                        colors: colors,
                        tipo: 'ENTRADA',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: CustomButton(
                    variant: ButtonVariant.danger,
                    text: 'SALIDA',
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    fontSize: 11,
                    icon: const Icon(Icons.logout, size: 14, color: Colors.white),
                    onTap: () => _handleSalida(context, colors, selectedWorkers, asisState),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Modo Escritorio / Pantalla Ancha
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: AppDecorations.floatingDock(colors),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: TextStyle(
                  color: colors.accentText,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              Text('seleccionados', style: TextStyle(color: colors.textSecondary, fontSize: 11)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => ref.read(attendanceProvider.notifier).clearSelection(),
                child: Text(
                  'Limpiar',
                  style: TextStyle(color: colors.textMuted, fontSize: 10, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),

          Row(
            children: [
              CustomButton(
                variant: ButtonVariant.primary,
                text: 'Editar',
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                fontSize: 11,
                icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.white),
                onTap: () {
                  AttendanceModals.showUnifiedEditModal(
                    context: context,
                    ref: ref,
                    colors: colors,
                    selectedWorkers: selectedWorkers,
                  );
                },
              ),
              const SizedBox(width: 6),
              CustomButton(
                variant: ButtonVariant.success,
                text: 'ENTRADA',
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                fontSize: 11,
                icon: const Icon(Icons.login, size: 14, color: Colors.white),
                onTap: () {
                  AttendanceModals.showBatchConfirmModal(
                    context: context,
                    ref: ref,
                    colors: colors,
                    tipo: 'ENTRADA',
                  );
                },
              ),
              const SizedBox(width: 6),
              CustomButton(
                variant: ButtonVariant.danger,
                text: 'SALIDA',
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                fontSize: 11,
                icon: const Icon(Icons.logout, size: 14, color: Colors.white),
                onTap: () => _handleSalida(context, colors, selectedWorkers, asisState),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSalida(
    BuildContext context,
    ThemeColors colors,
    List<Worker> selectedWorkers,
    AttendanceState asisState,
  ) {
    final workersWithEntry = selectedWorkers.where((w) {
      final st = asisState.workerStatus[w.id];
      return st?.isEnPlanta == true;
    }).toList();

    if (workersWithEntry.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: colors.surfaceCard,
          title: Text('No se puede registrar Salida', style: TextStyle(color: colors.textPrimary, fontSize: 14)),
          content: Text(
            'Ninguno de los trabajadores seleccionados tiene una Entrada registrada previa en planta.\nDebe marcar primero la Entrada.',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Entendido', style: TextStyle(color: colors.accent)),
            ),
          ],
        ),
      );
      return;
    }

    AttendanceModals.showBatchConfirmModal(
      context: context,
      ref: ref,
      colors: colors,
      tipo: 'SALIDA',
    );
  }

  /// Subtab Reporte de Horas con selector de mes y exportaciones PDF/Excel
  Widget _buildReporteTab(
    BuildContext context,
    ThemeColors colors,
    AttendanceState asisState,
    List<Worker> activeWorkers,
  ) {
    final store = ref.watch(appStoreProvider);
    final persState = ref.watch(personnelProvider);

    final people = (store != null && store.rows('personal').isNotEmpty)
        ? store.rows('personal')
        : persState.workers.map((w) => w.toMap()).toList();
    final marks = (store != null && store.rows('registro_asistencia').isNotEmpty)
        ? store.rows('registro_asistencia')
        : asisState.records.map((r) => r.toMap()).toList();

    final summaries = attendanceReport(people, marks, _selectedMonth);
    final monthLabel = DateFormat.yMMMM('es_PE').format(_selectedMonth);
    final filePrefix = 'Asistencia_${dateKey(_selectedMonth).substring(0, 7)}';
    final totalIncomplete = summaries.fold<int>(0, (s, r) => s + r.incomplete);
    final totalSinSalida = summaries.fold<int>(0, (s, r) => s + r.sinSalida);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: colors.accent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Cabecera responsiva con selector de mes y botones de exportación
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 560;

              final titleInfo = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reporte Consolidado de Asistencia',
                    style: TextStyle(color: colors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Días laborados, turnos y balance total de horas computadas',
                    style: TextStyle(color: colors.textMuted, fontSize: 11),
                  ),
                ],
              );

              final controls = Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Selector de Mes
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: colors.textSecondary,
                          onPressed: () {
                            setState(() {
                              _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            monthLabel,
                            style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: colors.textSecondary,
                          onPressed: () {
                            setState(() {
                              _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Botón Excel
                  CustomButton(
                    variant: ButtonVariant.success,
                    text: 'Excel',
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    fontSize: 11,
                    icon: const Icon(Icons.table_view_outlined, size: 14, color: Colors.white),
                    onTap: summaries.isEmpty
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay marcaciones para exportar en este mes.')),
                            );
                          }
                        : () async {
                            try {
                              final bytes = ReportService.attendanceExcel(summaries, monthLabel);
                              await saveBytes(
                                bytes,
                                '$filePrefix.xlsx',
                                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Reporte Excel generado: $filePrefix.xlsx')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al exportar Excel: $e')),
                                );
                              }
                            }
                          },
                  ),

                  // Botón PDF
                  CustomButton(
                    variant: ButtonVariant.primary,
                    text: 'PDF',
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    fontSize: 11,
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 14, color: Colors.white),
                    onTap: summaries.isEmpty
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay marcaciones para exportar en este mes.')),
                            );
                          }
                        : () async {
                            try {
                              final bytes = await ReportService.attendancePdf(summaries, monthLabel);
                              if (context.mounted) {
                                PdfViewerScreen.open(
                                  context: context,
                                  title: 'Informe Asistencia - $monthLabel',
                                  fileName: filePrefix,
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
                ],
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleInfo,
                    const SizedBox(height: 10),
                    controls,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: titleInfo),
                  const SizedBox(width: 12),
                  controls,
                ],
              );
            },
          ),
          const SizedBox(height: 14),

          // Banner informativo de trabajadores con entrada registrada (sin salida aún)
          if (totalSinSalida > 0)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.isDark ? AppTokens.emeraldDarkBg : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.isDark ? AppTokens.emeraldDarkBorder : const Color(0xFFA5D6A7)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppTokens.emeraldPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$totalSinSalida trabajador(es) con Entrada registrada (turno en curso o sin salida). Se computan sus días y horas de jornada.',
                      style: TextStyle(
                        color: colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Alerta de incidencias pendientes si existen (Interactivo con modal explicativo)
          if (totalIncomplete > 0)
            GestureDetector(
              onTap: () {
                final allIncidents = summaries.expand((s) => s.incidents).toList();
                AttendanceModals.showAttendanceIncidentsModal(
                  context: context,
                  ref: ref,
                  colors: colors,
                  incidents: allIncidents,
                  allWorkers: activeWorkers,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: colors.isDark ? const Color(0xFF2A1B05) : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTokens.amberBorderDark),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 18, color: AppTokens.amberText),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$totalIncomplete incidencia(s) detectada(s) en este mes',
                            style: const TextStyle(
                              color: AppTokens.amberText,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Toca aquí para ver el detalle de cada alerta y corregir las marcaciones.',
                            style: TextStyle(
                              color: colors.isDark ? const Color(0xFFE0B070) : const Color(0xFF7A5200),
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTokens.amberText.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTokens.amberBorderDark.withValues(alpha: 0.5)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver',
                            style: TextStyle(color: AppTokens.amberText, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.chevron_right, size: 14, color: AppTokens.amberText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Hint de interacción
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.touch_app_outlined, size: 14, color: colors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Toca un trabajador o "Ver fechas" para ver sus días y turnos individuales.',
                    style: TextStyle(color: colors.textMuted, fontSize: 10.5, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),

          // Tabla con scroll horizontal
          CustomCard(
            colors: colors,
            padding: EdgeInsets.zero,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 34,
                dataRowMinHeight: 36,
                dataRowMaxHeight: 40,
                columnSpacing: 16,
                columns: [
                  DataColumn(label: Text('#', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Trabajador', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Días', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Turno Día', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Turno Noche', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Horas Totales', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Detalle', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.bold))),
                ],
                rows: summaries.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final r = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text('$idx', style: TextStyle(color: colors.textMuted, fontSize: 10))),
                      DataCell(
                        InkWell(
                          onTap: () => AttendanceModals.showIndividualAttendanceModal(
                            context: context,
                            colors: colors,
                            summary: r,
                            month: _selectedMonth,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                r.name,
                                style: TextStyle(
                                  color: colors.isDark ? const Color(0xFF90CAF9) : const Color(0xFF1565C0),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: colors.isDark ? const Color(0xFF90CAF9).withValues(alpha: 0.4) : const Color(0xFF1565C0).withValues(alpha: 0.4),
                                ),
                              ),
                              if (r.sinSalida > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: colors.isDark ? AppTokens.emeraldDarkBg : const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: colors.isDark ? AppTokens.emeraldDarkBorder : const Color(0xFFA5D6A7)),
                                  ),
                                  child: Text(
                                    'En Planta',
                                    style: TextStyle(
                                      color: colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      DataCell(Text('${r.dates.length}', style: TextStyle(color: colors.textSecondary, fontFamily: 'monospace', fontSize: 11))),
                      DataCell(Text('${r.dayShifts.length}', style: TextStyle(color: colors.textSecondary, fontFamily: 'monospace', fontSize: 11))),
                      DataCell(Text('${r.nightShifts.length}', style: TextStyle(color: colors.textSecondary, fontFamily: 'monospace', fontSize: 11))),
                      DataCell(Text('${r.hours.toStringAsFixed(1)} hrs', style: TextStyle(color: colors.accentText, fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold))),
                      DataCell(
                        InkWell(
                          onTap: () => AttendanceModals.showIndividualAttendanceModal(
                            context: context,
                            colors: colors,
                            summary: r,
                            month: _selectedMonth,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_month_outlined, size: 13, color: colors.accent),
                                const SizedBox(width: 4),
                                Text(
                                  'Ver fechas',
                                  style: TextStyle(
                                    color: colors.accent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
