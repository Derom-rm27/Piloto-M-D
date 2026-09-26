import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/worker.dart';
import '../../state/personnel_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';
import '../../widgets/custom_modal.dart';

abstract final class PersonnelModals {
  /// Regla 4: Ficha del Trabajador (Modal)
  /// Al hacer clic sobre cualquier trabajador se abre su Ficha con DNI, Cargo,
  /// estado activo/inactivo y los botones de edición, desactivación/reactivación en 1 clic y eliminación.
  static void showFichaModal({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
    required Worker worker,
  }) {
    final isActivo = worker.activo;

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Ficha del Trabajador',
      badgeText: isActivo ? 'ACTIVO' : 'INACTIVO',
      badgeColor: isActivo ? AppTokens.emeraldPrimary : colors.textMuted,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tarjeta de Identidad
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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.accentSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderHighlight),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    worker.initials,
                    style: TextStyle(
                      color: colors.accentText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.fullName,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        worker.cargo,
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Campos de Detalle
          _detailRow(colors, 'Estado en Planta:', isActivo ? 'Activo (En Nómina)' : 'Inactivo (No labora)', isBadge: true, isActivo: isActivo),
          _detailRow(colors, 'DNI:', worker.dni ?? 'No registrado'),
          _detailRow(colors, 'Teléfono:', worker.telefono ?? 'No registrado'),
          _detailRow(colors, 'Dirección:', worker.direccion ?? 'No registrada (referencial)'),
          _detailRow(colors, 'Cargo:', worker.cargo),
          const SizedBox(height: 18),

          // Botón de Reactivación / Desactivación en 1 clic (Regla 1)
          CustomButton(
            variant: isActivo ? ButtonVariant.secondary : ButtonVariant.success,
            text: isActivo ? 'Desactivar Trabajador' : 'Reactivar en 1 Clic',
            icon: Icon(isActivo ? Icons.pause_circle_outline : Icons.play_circle_outline, size: 16, color: Colors.white),
            isFullWidth: true,
            onTap: () async {
              await ref.read(personnelProvider.notifier).toggleActive(worker.id);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${worker.fullName} ahora está ${!isActivo ? 'ACTIVO' : 'INACTIVO'}.')),
                );
              }
            },
          ),
          const SizedBox(height: 8),

          // Botón de Edición
          CustomButton(
            variant: ButtonVariant.primary,
            text: 'Editar Datos',
            icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
            isFullWidth: true,
            onTap: () {
              Navigator.of(context).pop();
              showEditModal(context: context, ref: ref, colors: colors, worker: worker);
            },
          ),
          const SizedBox(height: 8),

          // Botón de Eliminación (Regla 6: Rojo sólido vivo #DC2626 con texto blanco puro #FFFFFF)
          CustomButton(
            variant: ButtonVariant.danger,
            text: 'Eliminar Trabajador',
            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.white),
            isFullWidth: true,
            onTap: () {
              Navigator.of(context).pop();
              showDeleteConfirmDialog(context: context, ref: ref, colors: colors, worker: worker);
            },
          ),
        ],
      ),
    );
  }

  static Widget _detailRow(ThemeColors colors, String label, String value, {bool isBadge = false, bool isActivo = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.textMuted, fontSize: 11)),
          if (isBadge)
            CustomBadge(
              text: value,
              bg: isActivo ? AppTokens.emeraldDarkBg : colors.surfaceElevated,
              fg: isActivo ? AppTokens.emeraldDarkText : colors.textMuted,
              border: isActivo ? AppTokens.emeraldDarkBorder : colors.borderMedium,
            )
          else
            Text(
              value,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 11,
                fontFamily: label.contains('DNI') || label.contains('Teléfono') ? 'monospace' : null,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  /// Modal Nuevo Personal
  static void showNewPersonalModal({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
  }) {
    final nomCtrl = TextEditingController();
    final patCtrl = TextEditingController();
    final matCtrl = TextEditingController();
    final dniCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final dirCtrl = TextEditingController();
    String cargo = 'Operario';

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Nuevo Trabajador',
      badgeText: 'Registro',
      badgeColor: colors.accent,
      content: StatefulBuilder(
        builder: (ctx, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nombres *:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            CustomInputField(colors: colors, controller: nomCtrl, placeholder: 'Ej. Juan Carlos'),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ap. Paterno *:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: patCtrl, placeholder: 'Ej. Quispe'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ap. Materno:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: matCtrl, placeholder: 'Ej. Puma'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DNI:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: dniCtrl, placeholder: '8 dígitos', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teléfono:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: telCtrl, placeholder: '9 dígitos', keyboardType: TextInputType.phone),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text('Dirección (referencial):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            CustomInputField(colors: colors, controller: dirCtrl, placeholder: 'Ej. Jr. Las Américas 456, Juliaca'),
            const SizedBox(height: 10),

            Text('Cargo:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
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
                  value: cargo,
                  isExpanded: true,
                  dropdownColor: colors.surfaceCard,
                  style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  onChanged: (v) => setState(() => cargo = v!),
                  items: const [
                    DropdownMenuItem(value: 'Operario', child: Text('Operario')),
                    DropdownMenuItem(value: 'Maquinista', child: Text('Maquinista')),
                    DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
                    DropdownMenuItem(value: 'Ingeniero', child: Text('Ingeniero')),
                  ],
                ),
              ),
            ),
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
          text: 'Guardar Trabajador',
          onTap: () async {
            final nom = nomCtrl.text.trim();
            final pat = patCtrl.text.trim();
            if (nom.isEmpty || pat.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nombres y Apellido Paterno son obligatorios.')),
              );
              return;
            }

            final newWorker = Worker(
              id: const Uuid().v4(),
              nombre: nom,
              apPaterno: pat,
              apMaterno: matCtrl.text.trim(),
              dni: dniCtrl.text.trim().isNotEmpty ? dniCtrl.text.trim() : null,
              telefono: telCtrl.text.trim().isNotEmpty ? telCtrl.text.trim() : null,
              direccion: dirCtrl.text.trim().isNotEmpty ? dirCtrl.text.trim() : null,
              cargo: cargo,
              activo: true,
            );

            await ref.read(personnelProvider.notifier).addWorker(newWorker);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trabajador ${newWorker.fullName} registrado.')),
              );
            }
          },
        ),
      ],
    );
  }

  /// Modal Editar Personal
  static void showEditModal({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
    required Worker worker,
  }) {
    final nomCtrl = TextEditingController(text: worker.nombre);
    final patCtrl = TextEditingController(text: worker.apPaterno);
    final matCtrl = TextEditingController(text: worker.apMaterno);
    final dniCtrl = TextEditingController(text: worker.dni ?? '');
    final telCtrl = TextEditingController(text: worker.telefono ?? '');
    final dirCtrl = TextEditingController(text: worker.direccion ?? '');
    String cargo = worker.cargo;

    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Editar Trabajador',
      badgeText: worker.initials,
      badgeColor: colors.accent,
      content: StatefulBuilder(
        builder: (ctx, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nombres *:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            CustomInputField(colors: colors, controller: nomCtrl),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ap. Paterno *:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: patCtrl),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ap. Materno:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: matCtrl),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DNI:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: dniCtrl),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teléfono:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                      const SizedBox(height: 4),
                      CustomInputField(colors: colors, controller: telCtrl),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text('Dirección (referencial):', style: TextStyle(color: colors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            CustomInputField(colors: colors, controller: dirCtrl, placeholder: 'Ej. Jr. Las Américas 456, Juliaca'),
            const SizedBox(height: 10),

            Text('Cargo:', style: TextStyle(color: colors.textMuted, fontSize: 11)),
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
                  value: cargo,
                  isExpanded: true,
                  dropdownColor: colors.surfaceCard,
                  style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  onChanged: (v) => setState(() => cargo = v!),
                  items: const [
                    DropdownMenuItem(value: 'Operario', child: Text('Operario')),
                    DropdownMenuItem(value: 'Maquinista', child: Text('Maquinista')),
                    DropdownMenuItem(value: 'Supervisor', child: Text('Supervisor')),
                    DropdownMenuItem(value: 'Ingeniero', child: Text('Ingeniero')),
                  ],
                ),
              ),
            ),
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
          text: 'Guardar Cambios',
          onTap: () async {
            final updated = worker.copyWith(
              nombre: nomCtrl.text.trim(),
              apPaterno: patCtrl.text.trim(),
              apMaterno: matCtrl.text.trim(),
              dni: dniCtrl.text.trim().isNotEmpty ? dniCtrl.text.trim() : null,
              telefono: telCtrl.text.trim().isNotEmpty ? telCtrl.text.trim() : null,
              direccion: dirCtrl.text.trim().isNotEmpty ? dirCtrl.text.trim() : null,
              cargo: cargo,
            );
            await ref.read(personnelProvider.notifier).updateWorker(updated);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trabajador ${updated.fullName} actualizado.')),
              );
            }
          },
        ),
      ],
    );
  }

  /// Confirmación de Eliminación
  static void showDeleteConfirmDialog({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeColors colors,
    required Worker worker,
  }) {
    CustomModal.show(
      context: context,
      colors: colors,
      title: 'Confirmar Eliminación',
      badgeText: 'Peligro',
      badgeColor: AppTokens.dangerSolid,
      content: Text(
        '¿Estás seguro de que deseas eliminar a ${worker.fullName}?\n\nEsta acción no se puede deshacer si no cuenta con histórico.',
        style: TextStyle(color: colors.textSecondary, fontSize: 12),
      ),
      actions: [
        CustomButton(
          variant: ButtonVariant.subtle,
          text: 'Cancelar',
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 8),
        CustomButton(
          variant: ButtonVariant.danger,
          text: 'Sí, Eliminar',
          onTap: () async {
            await ref.read(personnelProvider.notifier).deleteWorker(worker.id);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${worker.fullName} ha sido eliminado.')),
              );
            }
          },
        ),
      ],
    );
  }
}
