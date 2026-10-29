import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../state/personnel_provider.dart';
import '../../state/theme_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';
import 'personnel_modals.dart';

class PersonnelView extends ConsumerWidget {
  const PersonnelView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(themeColorsProvider);
    final persState = ref.watch(personnelProvider);
    final filtered = persState.filteredWorkers;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado del Directorio
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceCard,
                border: Border(bottom: BorderSide(color: colors.borderSubtle)),
              ),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 460;
                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'DIRECTORIO DE PERSONAL',
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
                                  text: '${persState.countTotal} total',
                                  bg: colors.surfaceElevated,
                                  fg: colors.textMuted,
                                  border: colors.borderMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomButton(
                                variant: ButtonVariant.primary,
                                text: 'Nuevo personal',
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                fontSize: 11,
                                icon: const Icon(Icons.add, size: 14, color: Colors.white),
                                onTap: () => PersonnelModals.showNewPersonalModal(context: context, ref: ref, colors: colors),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'DIRECTORIO DE PERSONAL',
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomBadge(
                                text: '${persState.countTotal} total (${persState.countActivos} activos)',
                                bg: colors.surfaceElevated,
                                fg: colors.textMuted,
                                border: colors.borderMedium,
                              ),
                            ],
                          ),
                          CustomButton(
                            variant: ButtonVariant.primary,
                            text: 'Nuevo personal',
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            fontSize: 11,
                            icon: const Icon(Icons.add, size: 14, color: Colors.white),
                            onTap: () => PersonnelModals.showNewPersonalModal(context: context, ref: ref, colors: colors),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Barra de Búsqueda
                  CustomInputField(
                    colors: colors,
                    placeholder: 'Buscar trabajador por nombre o apellido...',
                    prefixIcon: Icon(Icons.search, size: 16, color: colors.textMuted),
                    onChanged: (val) => ref.read(personnelProvider.notifier).setSearchQuery(val),
                  ),
                  const SizedBox(height: 10),

                  // Filtros de Estado: Todos, Activos en Planta, Inactivos (Regla 1)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _tabFilter(
                          colors: colors,
                          label: 'Todos (${persState.countTotal})',
                          icon: Icons.groups_outlined,
                          isSelected: persState.statusFilter == 'todos',
                          onTap: () => ref.read(personnelProvider.notifier).setFilter('todos'),
                        ),
                        const SizedBox(width: 6),
                        _tabFilter(
                          colors: colors,
                          label: 'Activos en Planta (${persState.countActivos})',
                          icon: Icons.check_circle_outline,
                          isSelected: persState.statusFilter == 'activos',
                          textColor: AppTokens.emeraldDarkText,
                          onTap: () => ref.read(personnelProvider.notifier).setFilter('activos'),
                        ),
                        const SizedBox(width: 6),
                        _tabFilter(
                          colors: colors,
                          label: 'Inactivos (${persState.countInactivos})',
                          icon: Icons.person_off_outlined,
                          isSelected: persState.statusFilter == 'inactivos',
                          textColor: colors.textMuted,
                          onTap: () => ref.read(personnelProvider.notifier).setFilter('inactivos'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Banner guia intuitivo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.surfaceDeep,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 14, color: colors.textMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Toca a cualquier trabajador para ver su ficha, editar o dar de baja',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Lista Ultra-Limpia ("Solo Nombre")
            // Regla 4: En la primera vista, las tarjetas muestran estrictamente el nombre completo
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_search_outlined, size: 44, color: colors.textMuted.withValues(alpha: 0.5)),
                            const SizedBox(height: 10),
                            Text(
                              'No se encontró personal',
                              style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'No hay registros que coincidan con la búsqueda o el filtro actual.',
                              style: TextStyle(color: colors.textMuted, fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final w = filtered[i];
                        final isActivo = w.activo;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Opacity(
                            opacity: isActivo ? 1.0 : 0.55,
                            child: InkWell(
                              onTap: () => PersonnelModals.showFichaModal(
                                context: context,
                                ref: ref,
                                colors: colors,
                                worker: w,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                                decoration: BoxDecoration(
                                  color: colors.surfaceCard,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: colors.borderSubtle, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: colors.isDark ? 0.15 : 0.02),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Avatar de Iniciales
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: colors.surfaceElevated,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: colors.borderMedium),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        w.initials,
                                        style: TextStyle(
                                          color: colors.textSecondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Regla 4: Estrictamente el nombre completo del trabajador
                                    Expanded(
                                      child: Text(
                                        w.fullName,
                                        style: TextStyle(
                                          color: colors.textPrimary,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Flecha Chevron amigable
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: colors.surfaceElevated,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.chevron_right, size: 15, color: colors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),

        // Botón de Acción Flotante (+) para registrar nuevo personal
        Positioned(
          right: 20,
          bottom: 20,
          child: GestureDetector(
            onTap: () => PersonnelModals.showNewPersonalModal(context: context, ref: ref, colors: colors),
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

  Widget _tabFilter({
    required ThemeColors colors,
    required String label,
    required bool isSelected,
    Color? textColor,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (colors.isDark ? colors.surfaceElevated : colors.accent.withValues(alpha: 0.12))
              : colors.surfaceDeep,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.accent : colors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: isSelected
                    ? (textColor ?? (colors.isDark ? colors.textPrimary : colors.accentText))
                    : colors.textMuted,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? (textColor ?? (colors.isDark ? colors.textPrimary : colors.accentText)) : colors.textMuted,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
