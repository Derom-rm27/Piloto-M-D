import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/domain/attendance.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/worker.dart';
import '../../../features/reports/report_service.dart';
import '../../state/attendance_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_modal.dart';
import '../../widgets/pdf_preview_screen.dart';

abstract final class AttendanceModals {
  /// Modal para Confirmar Registro en Bloque (Entrada / Salida)
  static void showBatchConfirmModal({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
    required String tipo, // 'ENTRADA' | 'SALIDA'
  }) {
    final asisState = ref.read(attendanceProvider);
    final count = asisState.selectedIds.length;
    if (count == 0) return;

    final isEntrada = tipo == 'ENTRADA';
    String turno = asisState.selectedTurno;
    String linea = asisState.selectedLinea;

    final now = DateTime.now();
    DateTime selectedDate = now;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(now);

    CustomModal.show(
      context: context,
      colors: colors,
      title: isEntrada ? 'Confirmar Entrada' : 'Confirmar Salida',
      badgeText: isEntrada ? 'ENTRADA' : 'SALIDA',
      badgeColor: isEntrada ? AppTokens.emeraldPrimary : AppTokens.dangerSolid,
      content: StatefulBuilder(
        builder: (ctx, setState) {
          final isNightSalida = !isEntrada && turno == 'Noche';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registrando marcación masiva para $count trabajador(es) seleccionado(s).',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Banner Turno Noche (Regla GEMINI.md: cruce de medianoche)
              if (isNightSalida) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.accentSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderHighlight),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌙', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cierre de Turno Noche: Esta salida cerrará la jornada iniciada en la fecha anterior. Se computa como 1 jornada continua.',
                          style: TextStyle(
                            color: colors.accentText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Selector de Turno
              Text('Turno:', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => turno = 'Dia'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: turno == 'Dia' ? colors.surfaceElevated : colors.surfaceDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: turno == 'Dia' ? AppTokens.amberText : colors.borderSubtle),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Turno Día',
                          style: TextStyle(
                            color: turno == 'Dia' ? AppTokens.amberText : colors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => turno = 'Noche'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: turno == 'Noche' ? colors.accentSubtle : colors.surfaceDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: turno == 'Noche' ? colors.accent : colors.borderSubtle),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Turno Noche',
                          style: TextStyle(
                            color: turno == 'Noche' ? colors.accentText : colors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Selector de Línea
              Text('Línea de Producción:', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => linea = 'Galletas'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: linea == 'Galletas' ? colors.surfaceElevated : colors.surfaceDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: linea == 'Galletas' ? colors.accent : colors.borderSubtle),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Galletas',
                          style: TextStyle(
                            color: linea == 'Galletas' ? colors.textPrimary : colors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => linea = 'Barras'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: linea == 'Barras' ? colors.surfaceElevated : colors.surfaceDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: linea == 'Barras' ? colors.accent : colors.borderSubtle),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Barras',
                          style: TextStyle(
                            color: linea == 'Barras' ? colors.textPrimary : colors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fecha y Hora con Calendario y Reloj
              _buildDateTimePickerRow(
                context: context,
                colors: colors,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateChanged: (d) => setState(() => selectedDate = d),
                onTimeChanged: (t) => setState(() => selectedTime = t),
              ),
            ],
          );
        },
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cancelar',
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        CustomButton(
          variant: isEntrada ? ButtonVariant.success : ButtonVariant.danger,
          text: isEntrada ? 'Confirmar Entrada' : 'Confirmar Salida',
          onTap: () {
            final fStr = DateFormat('yyyy-MM-dd').format(selectedDate);
            final hStr = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
            ref.read(attendanceProvider.notifier).registerBatch(
              tipo: tipo,
              turno: turno,
              linea: linea,
              fecha: fStr,
              hora: hStr,
            );
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Marcación $tipo registrada para $count trabajador(es).')),
            );
          },
        ),
      ],
    );
  }

  /// Modal Unificado "Editar" (Adaptativo para 1 o varios trabajadores seleccionados)
  static void showUnifiedEditModal({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
    required List<Worker> selectedWorkers,
  }) {
    if (selectedWorkers.isEmpty) return;
    final count = selectedWorkers.length;
    final isSingle = count == 1;
    final singleWorker = isSingle ? selectedWorkers.first : null;

    final asisState = ref.read(attendanceProvider);
    final singleStatus = isSingle ? asisState.workerStatus[singleWorker!.id] : null;

    String tipo = singleStatus?.tipo ?? 'ENTRADA';
    String turno = singleStatus?.turno ?? 'Dia';
    String linea = singleStatus?.linea ?? 'Galletas';

    final now = DateTime.now();
    DateTime selectedDate = singleStatus?.fecha != null
        ? (DateTime.tryParse(singleStatus!.fecha!) ?? now)
        : now;
    TimeOfDay selectedTime = _parseTime(singleStatus?.hora, now);

    CustomModal.show(
      context: context,
      colors: colors,
      title: isSingle ? 'Editar Marcación' : 'Editar Marcaciones en Bloque',
      badgeText: isSingle ? singleWorker!.fullName : '$count trabajadores',
      badgeColor: colors.accent,
      content: StatefulBuilder(
        builder: (ctx, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isSingle
                    ? 'Ajusta los datos de marcación o anula el registro para ${singleWorker!.fullName}.'
                    : 'Modificando marcaciones para los $count trabajadores seleccionados.',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 14),

              // Tipo de Marcación
              Text('Tipo:', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => tipo = 'ENTRADA'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: tipo == 'ENTRADA' ? AppTokens.emeraldDarkBg : colors.surfaceDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: tipo == 'ENTRADA' ? AppTokens.emeraldPrimary : colors.borderSubtle),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'ENTRADA',
                          style: TextStyle(
                            color: tipo == 'ENTRADA' ? AppTokens.emeraldDarkText : colors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => tipo = 'SALIDA'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: tipo == 'SALIDA' ? AppTokens.dangerDarkBg : colors.surfaceDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: tipo == 'SALIDA' ? AppTokens.dangerSolid : colors.borderSubtle),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'SALIDA',
                          style: TextStyle(
                            color: tipo == 'SALIDA' ? AppTokens.dangerDarkText : colors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Turno y Línea
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Turno:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Línea:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
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
                              value: linea,
                              isExpanded: true,
                              dropdownColor: colors.surfaceCard,
                              style: TextStyle(color: colors.textSecondary, fontSize: 11),
                              onChanged: (v) => setState(() => linea = v!),
                              items: const [
                                DropdownMenuItem(value: 'Galletas', child: Text('Galletas')),
                                DropdownMenuItem(value: 'Barras', child: Text('Barras')),
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

              // Fecha y Hora con Calendario y Reloj
              _buildDateTimePickerRow(
                context: context,
                colors: colors,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateChanged: (d) => setState(() => selectedDate = d),
                onTimeChanged: (t) => setState(() => selectedTime = t),
              ),
              const SizedBox(height: 18),

              // Botón de Anular / Eliminar Marcación (Regla 5: reside dentro del formulario de Editar)
              CustomButton(
                variant: ButtonVariant.danger,
                text: isSingle ? 'Anular Marcación de este Trabajador' : 'Anular Marcación de Seleccionados',
                isFullWidth: true,
                onTap: () {
                  final idsToClear = selectedWorkers.map((w) => w.id).toSet();
                  ref.read(attendanceProvider.notifier).clearMarks(idsToClear);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Marcación anulada para $count trabajador(es).')),
                  );
                },
              ),
            ],
          );
        },
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
          text: 'Guardar Cambios',
          onTap: () {
            final fStr = DateFormat('yyyy-MM-dd').format(selectedDate);
            final hStr = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
            ref.read(attendanceProvider.notifier).registerBatch(
              tipo: tipo,
              turno: turno,
              linea: linea,
              fecha: fStr,
              hora: hStr,
            );
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Marcaciones actualizadas con éxito.')),
            );
          },
        ),
      ],
    );
  }

  /// Modal para ver el Detalle de Incidencias de Asistencia
  static void showAttendanceIncidentsModal({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
    required List<AttendanceIncident> incidents,
    required List<Worker> allWorkers,
  }) {
    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Detalle de Incidencias',
      badgeText: '${incidents.length} pendientes',
      badgeColor: AppTokens.amberText,
      content: SizedBox(
        width: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner pedagógico explicativo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.isDark ? AppTokens.amberBgDark : const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.isDark ? AppTokens.amberBorderDark : const Color(0xFFFFE082)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppTokens.amberText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¿De qué tratan estas alertas?\nOcurren cuando una marcación no tiene coherencia lógica (ej. una Salida registrada sin Entrada previa, o dos Entradas seguidas sin salida). Puedes tocar "Resolver" para abrir la jornada y corregirla.',
                      style: TextStyle(
                        color: colors.isDark ? AppTokens.amberText : const Color(0xFF795548),
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            if (incidents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No hay incidencias pendientes en este período.',
                    style: TextStyle(color: colors.textMuted, fontSize: 12),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: incidents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final inc = incidents[i];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.surfaceCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  inc.workerName,
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.isDark ? AppTokens.amberBgDark : const Color(0xFFFFF8E1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppTokens.amberBorderDark),
                                ),
                                child: Text(
                                  inc.tipo,
                                  style: const TextStyle(
                                    color: AppTokens.amberText,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${inc.date} · Turno ${inc.turno} · ${inc.linea}',
                            style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace'),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            inc.descripcion,
                            style: TextStyle(color: colors.textSecondary, fontSize: 11),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              variant: ButtonVariant.subtle,
                              text: 'Resolver / Editar',
                              fontSize: 10,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              icon: const Icon(Icons.edit_outlined, size: 12),
                              onTap: () {
                                Navigator.of(context).pop();
                                final target = allWorkers.where((w) => w.id == inc.workerId).toList();
                                showUnifiedEditModal(
                                  context: context,
                                  ref: ref,
                                  colors: colors,
                                  selectedWorkers: target.isNotEmpty
                                      ? target
                                      : [
                                          Worker(
                                            id: inc.workerId,
                                            nombre: inc.workerName,
                                            apPaterno: '',
                                            cargo: 'Operario',
                                          )
                                        ],
                                );
                              },
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
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cerrar',
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  static TimeOfDay _parseTime(String? timeStr, DateTime fallback) {
    if (timeStr != null && timeStr.contains(':')) {
      final parts = timeStr.split(':');
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h != null && m != null) return TimeOfDay(hour: h, minute: m);
    }
    return TimeOfDay.fromDateTime(fallback);
  }

  static Widget _buildDateTimePickerRow({
    required BuildContext context,
    required ThemeColors colors,
    required DateTime selectedDate,
    required TimeOfDay selectedTime,
    required void Function(DateTime) onDateChanged,
    required void Function(TimeOfDay) onTimeChanged,
  }) {
    final dateFormatted = DateFormat('dd/MM/yyyy').format(selectedDate);
    final timeFormatted = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fecha (Calendario):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                    builder: (ctx, child) {
                      return Theme(
                        data: (colors.isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
                          colorScheme: ColorScheme(
                            brightness: colors.isDark ? Brightness.dark : Brightness.light,
                            primary: colors.accent,
                            onPrimary: Colors.white,
                            surface: colors.surfaceCard,
                            onSurface: colors.textPrimary,
                            secondary: colors.accent,
                            onSecondary: Colors.white,
                            error: AppTokens.dangerSolid,
                            onError: Colors.white,
                          ),
                          dialogTheme: DialogThemeData(backgroundColor: colors.surfaceCard),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) onDateChanged(picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 16, color: colors.accentText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateFormatted,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, size: 18, color: colors.textMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hora (Reloj):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (ctx, child) {
                      return Theme(
                        data: (colors.isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
                          colorScheme: ColorScheme(
                            brightness: colors.isDark ? Brightness.dark : Brightness.light,
                            primary: colors.accent,
                            onPrimary: Colors.white,
                            surface: colors.surfaceCard,
                            onSurface: colors.textPrimary,
                            secondary: colors.accent,
                            onSecondary: Colors.white,
                            error: AppTokens.dangerSolid,
                            onError: Colors.white,
                          ),
                          dialogTheme: DialogThemeData(backgroundColor: colors.surfaceCard),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) onTimeChanged(picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_filled_outlined, size: 16, color: colors.accentText),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          timeFormatted,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, size: 18, color: colors.textMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Modal para Reporte Individual de Asistencia con Calendario Mensual y Ficha PDF
  static void showIndividualAttendanceModal({
    required BuildContext context,
    required ThemeColors colors,
    required AttendanceSummary summary,
    required DateTime month,
  }) {
    final monthLabel = DateFormat.yMMMM('es_PE').format(month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday; // 1: Lun, 7: Dom
    final diasLaborados = summary.dates.length;
    final diasDescanso = (daysInMonth - diasLaborados).clamp(0, 31);

    // Mapeo rápido de registros por fecha (yyyy-MM-dd)
    final recordMap = <String, AttendanceDayRecord>{};
    for (final r in summary.dailyRecords) {
      recordMap[r.date] = r;
    }

    // Lista completa de todos los días del mes para la vista tabla
    final allDaysList = <_DaySummaryItem>[];
    for (int day = 1; day <= daysInMonth; day++) {
      final d = DateTime(month.year, month.month, day);
      final dStr =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      final rec = recordMap[dStr];
      allDaysList.add(_DaySummaryItem(
        day: day,
        date: d,
        dateStr: dStr,
        record: rec,
      ));
    }

    String activeTab = 'calendario'; // 'calendario' | 'tabla'
    String filter = 'todos'; // 'todos' | 'laborados' | 'descansos'

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Historial de Asistencia Individual',
      badgeText: summary.name,
      badgeColor: colors.accent,
      content: SizedBox(
        width: 540,
        child: StatefulBuilder(
          builder: (ctx, setStateModal) {
            final filteredDays = allDaysList.where((item) {
              if (filter == 'laborados') return item.record != null;
              if (filter == 'descansos') return item.record == null;
              return true;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ficha cabecera del trabajador con botón directo de Compartir PDF
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceDeep,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.accentSubtle,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.borderHighlight),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          summary.name.isNotEmpty
                              ? summary.name
                                  .split(' ')
                                  .map((s) => s.isNotEmpty ? s[0] : '')
                                  .take(2)
                                  .join()
                                  .toUpperCase()
                              : 'TR',
                          style: TextStyle(
                            color: colors.accentText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary.name,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${summary.person['cargo'] ?? 'Operario'} · Periodo: $monthLabel',
                              style: TextStyle(color: colors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botón rápido de PDF en cabecera
                      InkWell(
                        onTap: () async {
                          final bytes =
                              await ReportService.individualAttendancePdf(summary, month);
                          if (!context.mounted) return;
                          final fileName =
                              'Asistencia_${summary.name.replaceAll(' ', '_')}_${DateFormat('yyyy_MM').format(month)}.pdf';
                          PdfViewerScreen.open(
                            context: context,
                            title: 'Ficha PDF - ${summary.name}',
                            fileName: fileName,
                            bytes: bytes,
                            colors: colors,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.picture_as_pdf_outlined, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'PDF',
                                style: TextStyle(
                                  color: Colors.white,
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
                ),
                const SizedBox(height: 10),

                // Tarjetas KPI de resumen
                Row(
                  children: [
                    _kpiBox(colors, 'Laborados', '$diasLaborados d', AppTokens.emeraldDarkText),
                    const SizedBox(width: 5),
                    _kpiBox(colors, 'Descanso', '$diasDescanso d', colors.textMuted),
                    const SizedBox(width: 5),
                    _kpiBox(colors, 'Turno Día', '${summary.dayShifts.length}', AppTokens.amberText),
                    const SizedBox(width: 5),
                    _kpiBox(colors, 'Turno Noche', '${summary.nightShifts.length}', colors.accentText),
                    const SizedBox(width: 5),
                    _kpiBox(colors, 'Horas', '${summary.hours.toStringAsFixed(1)} h', colors.accent),
                  ],
                ),
                const SizedBox(height: 10),

                // Selector de modo de vista (Calendario vs Tabla Resumen)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setStateModal(() => activeTab = 'calendario'),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: activeTab == 'calendario' ? colors.surfaceCard : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: activeTab == 'calendario'
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 13,
                                  color: activeTab == 'calendario' ? colors.accent : colors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Calendario',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: activeTab == 'calendario' ? colors.textPrimary : colors.textMuted,
                                      fontSize: 11,
                                      fontWeight: activeTab == 'calendario' ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setStateModal(() => activeTab = 'tabla'),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: activeTab == 'tabla' ? colors.surfaceCard : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: activeTab == 'tabla'
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.view_list_outlined,
                                  size: 13,
                                  color: activeTab == 'tabla' ? colors.accent : colors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Resumen',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: activeTab == 'tabla' ? colors.textPrimary : colors.textMuted,
                                      fontSize: 11,
                                      fontWeight: activeTab == 'tabla' ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Vista 1: Calendario Mensual
                if (activeTab == 'calendario') ...[
                  _buildCalendarGrid(
                    context: context,
                    colors: colors,
                    month: month,
                    daysInMonth: daysInMonth,
                    firstWeekday: firstWeekday,
                    recordMap: recordMap,
                  ),
                  const SizedBox(height: 8),
                  // Leyenda del Calendario
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: [
                      _legendChip(
                        colors: colors,
                        bg: colors.isDark ? const Color(0xFF0F3320) : const Color(0xFFE8F5E9),
                        border: colors.isDark ? const Color(0xFF1B5E20) : const Color(0xFFA5D6A7),
                        text: 'Turno Día (${summary.dayShifts.length})',
                        textColor: colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20),
                      ),
                      _legendChip(
                        colors: colors,
                        bg: colors.isDark ? const Color(0xFF1E1A3D) : const Color(0xFFEDE7F6),
                        border: colors.isDark ? const Color(0xFF3F3D8F) : const Color(0xFFB39DDB),
                        text: 'Turno Noche (${summary.nightShifts.length})',
                        textColor: colors.isDark ? const Color(0xFFB39DDB) : const Color(0xFF4527A0),
                      ),
                      _legendChip(
                        colors: colors,
                        bg: colors.surfaceDeep,
                        border: colors.borderSubtle,
                        text: 'Descanso ($diasDescanso)',
                        textColor: colors.textMuted,
                      ),
                    ],
                  ),
                ] else ...[
                  // Vista 2: Tabla Resumen Día a Día
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Detalle Día por Día',
                          style: TextStyle(color: colors.textPrimary, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Cómputo efectivo',
                        style: TextStyle(color: colors.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Filtros rápidos con Wrap anti-desbordamiento
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _filterChip(
                        label: 'Todos ($daysInMonth)',
                        selected: filter == 'todos',
                        colors: colors,
                        onTap: () => setStateModal(() => filter = 'todos'),
                      ),
                      _filterChip(
                        label: 'Laborados ($diasLaborados)',
                        selected: filter == 'laborados',
                        colors: colors,
                        onTap: () => setStateModal(() => filter = 'laborados'),
                      ),
                      _filterChip(
                        label: 'Descansos ($diasDescanso)',
                        selected: filter == 'descansos',
                        colors: colors,
                        onTap: () => setStateModal(() => filter = 'descansos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredDays.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 5),
                      itemBuilder: (ctx, i) {
                        final item = filteredDays[i];
                        final r = item.record;
                        final dt = item.date;
                        final dateName =
                            '${DateFormat('EEEE', 'es_PE').format(dt)[0].toUpperCase()}${DateFormat('EEEE', 'es_PE').format(dt).substring(1)}, ${DateFormat('dd/MM/yyyy').format(dt)}';

                        if (r == null) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: colors.surfaceDeep,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.borderSubtle),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dateName,
                                    style: TextStyle(color: colors.textMuted, fontSize: 11),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceElevated,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: colors.borderSubtle),
                                  ),
                                  child: Text(
                                    'DESCANSO',
                                    style: TextStyle(
                                      color: colors.textMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final isNoche = r.turno == 'Noche';
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: colors.surfaceCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isNoche
                                  ? (colors.isDark ? const Color(0xFF3F3D8F) : const Color(0xFFB39DDB))
                                  : (colors.isDark ? const Color(0xFF1B5E20) : const Color(0xFFA5D6A7)),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dateName,
                                      style: TextStyle(
                                        color: colors.textPrimary,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isNoche
                                          ? (colors.isDark ? const Color(0xFF1E1A3D) : const Color(0xFFEDE7F6))
                                          : (colors.isDark ? const Color(0xFF0F3320) : const Color(0xFFE8F5E9)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${r.horas.toStringAsFixed(1)} hrs',
                                      style: TextStyle(
                                        color: isNoche
                                            ? (colors.isDark ? const Color(0xFFB39DDB) : const Color(0xFF4527A0))
                                            : (colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20)),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: isNoche
                                          ? colors.accentSubtle
                                          : (colors.isDark ? AppTokens.amberBgDark : const Color(0xFFFFF8E1)),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isNoche ? colors.borderHighlight : AppTokens.amberBorderDark,
                                      ),
                                    ),
                                    child: Text(
                                      r.turno.toUpperCase(),
                                      style: TextStyle(
                                        color: isNoche ? colors.accentText : AppTokens.amberText,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (r.linea.isNotEmpty)
                                    Text(
                                      r.linea,
                                      style: TextStyle(color: colors.textMuted, fontSize: 10),
                                    ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.login, size: 11, color: AppTokens.emeraldPrimary),
                                      const SizedBox(width: 3),
                                      Text(
                                        'Entrada: ${r.entradaHora}',
                                        style: TextStyle(
                                          color: colors.textSecondary,
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        r.isEnPlanta ? Icons.work_outline : Icons.logout,
                                        size: 11,
                                        color: r.isEnPlanta ? AppTokens.emeraldPrimary : colors.textMuted,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        r.isEnPlanta ? 'En Planta' : 'Salida: ${r.salidaHora ?? '--:--'}',
                                        style: TextStyle(
                                          color: r.isEnPlanta
                                              ? (colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20))
                                              : colors.textSecondary,
                                          fontSize: 10,
                                          fontFamily: 'monospace',
                                          fontWeight: r.isEnPlanta ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
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
        const SizedBox(width: 8),
        CustomButton(
          variant: ButtonVariant.primary,
          icon: const Icon(Icons.picture_as_pdf_outlined, size: 16, color: Colors.white),
          text: 'Compartir PDF',
          onTap: () async {
            final bytes = await ReportService.individualAttendancePdf(summary, month);
            if (!context.mounted) return;
            final fileName =
                'Asistencia_${summary.name.replaceAll(' ', '_')}_${DateFormat('yyyy_MM').format(month)}.pdf';
            PdfViewerScreen.open(
              context: context,
              title: 'Ficha PDF - ${summary.name}',
              fileName: fileName,
              bytes: bytes,
              colors: colors,
            );
          },
        ),
      ],
    );
  }

  static Widget _buildCalendarGrid({
    required BuildContext context,
    required ThemeColors colors,
    required DateTime month,
    required int daysInMonth,
    required int firstWeekday,
    required Map<String, AttendanceDayRecord> recordMap,
  }) {
    final weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    // Total casillas: espacios iniciales antes del día 1 + días del mes
    final totalSlots = (firstWeekday - 1) + daysInMonth;
    final totalRows = (totalSlots / 7).ceil();

    final tableRows = <TableRow>[];

    // Fila de encabezados de semana
    tableRows.add(
      TableRow(
        children: [
          for (final w in weekdays)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              child: Text(
                w,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );

    // Filas del calendario mensual
    for (int row = 0; row < totalRows; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        final slotIndex = row * 7 + col;
        final dayNumber = slotIndex - (firstWeekday - 1) + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          cells.add(const SizedBox(height: 42));
        } else {
          final date = DateTime(month.year, month.month, dayNumber);
          final dateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final rec = recordMap[dateStr];
          final isWorked = rec != null;
          final isNoche = isWorked && rec.turno == 'Noche';

          cells.add(
            GestureDetector(
              onTap: () {
                final msg = isWorked
                    ? 'Día $dayNumber (${rec.turno}): Entrada ${rec.entradaHora} - Salida ${rec.isEnPlanta ? "En Planta" : (rec.salidaHora ?? "--:--")} (${rec.horas.toStringAsFixed(1)} hrs)'
                    : 'Día $dayNumber: Descanso / Sin marcación de asistencia';
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg, style: const TextStyle(fontSize: 11.5)),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(1.5),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
                decoration: BoxDecoration(
                  color: isWorked
                      ? (isNoche
                          ? (colors.isDark ? const Color(0xFF1E1A3D) : const Color(0xFFEDE7F6))
                          : (colors.isDark ? const Color(0xFF0F3320) : const Color(0xFFE8F5E9)))
                      : colors.surfaceDeep,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isWorked
                        ? (isNoche
                            ? (colors.isDark ? const Color(0xFF3F3D8F) : const Color(0xFFB39DDB))
                            : (colors.isDark ? const Color(0xFF1B5E20) : const Color(0xFFA5D6A7)))
                        : colors.borderSubtle,
                    width: isWorked ? 1.2 : 0.8,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: isWorked ? colors.textPrimary : colors.textMuted,
                        fontSize: 10,
                        fontWeight: isWorked ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 1),
                    if (isWorked) ...[
                      Text(
                        isNoche ? 'Noche' : 'Día',
                        style: TextStyle(
                          color: isNoche
                              ? (colors.isDark ? const Color(0xFFB39DDB) : const Color(0xFF4527A0))
                              : (colors.isDark ? AppTokens.emeraldDarkText : const Color(0xFF1B5E20)),
                          fontSize: 7.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        '${rec.horas.toStringAsFixed(0)}h',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 7.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ] else ...[
                      Text(
                        '-',
                        style: TextStyle(color: colors.textMuted, fontSize: 7.5),
                      ),
                      const SizedBox(height: 9),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
      }
      tableRows.add(TableRow(children: cells));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: tableRows,
      ),
    );
  }

  static Widget _legendChip({
    required ThemeColors colors,
    required Color bg,
    required Color border,
    required String text,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 9.5, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _filterChip({
    required String label,
    required bool selected,
    required ThemeColors colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? colors.accent : colors.borderSubtle),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.textMuted,
            fontSize: 10,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  static Widget _kpiBox(ThemeColors colors, String title, String val, Color valColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: colors.surfaceDeep,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: TextStyle(
                color: valColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(color: colors.textMuted, fontSize: 8.5),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DaySummaryItem {
  _DaySummaryItem({
    required this.day,
    required this.date,
    required this.dateStr,
    required this.record,
  });
  final int day;
  final DateTime date;
  final String dateStr;
  final AttendanceDayRecord? record;
}
