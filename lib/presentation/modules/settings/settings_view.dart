import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../state/theme_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_containers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(themeColorsProvider);
    final themeState = ref.watch(themeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.borderSubtle)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Configuración del Sistema',
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomBadge(
                            text: 'Apariencia',
                            bg: colors.accentSubtle,
                            fg: colors.accentText,
                            border: colors.borderHighlight,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ajusta el modo visual y la tipografía para optimizar la visualización en planta',
                        style: TextStyle(color: colors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  variant: ButtonVariant.subtle,
                  text: 'Restablecer',
                  fontSize: 11,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  onTap: () async {
                    await ref.read(themeProvider.notifier).resetDefaults();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configuración restablecida por defecto.')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sección 1: Modo Claro u Oscuro
          CustomCard(
            colors: colors,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '1. MODO DE PANTALLA',
                        style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final isSmall = constraints.maxWidth < 600;
                    final cardWidth = isSmall ? constraints.maxWidth : (constraints.maxWidth - 12) / 2;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        // Opción Modo Oscuro
                        _themeCard(
                          width: cardWidth,
                          colors: colors,
                          title: 'Modo Oscuro',
                          icon: Icons.dark_mode_outlined,
                          isActive: themeState.isDark,
                          description: 'Fondo oscuro optimizado para turnos nocturnos, reduciendo la fatiga visual y ahorrando batería.',
                          onTap: () => ref.read(themeProvider.notifier).setTheme(true),
                        ),

                        // Opción Modo Claro
                        _themeCard(
                          width: cardWidth,
                          colors: colors,
                          title: 'Modo Claro',
                          icon: Icons.light_mode_outlined,
                          isActive: !themeState.isDark,
                          description: 'Fondo claro de alta luminosidad y contraste, ideal para supervisión con luz de día en planta.',
                          onTap: () => ref.read(themeProvider.notifier).setTheme(false),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sección 2: Tipo de Letra
          CustomCard(
            colors: colors,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '2. TIPO DE LETRA (TIPOGRAFÍA)',
                        style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                LayoutBuilder(
                  builder: (ctx, constraints) {
                    final isSmall = constraints.maxWidth < 450;
                    if (isSmall) {
                      return Column(
                        children: [
                          _fontOption(
                            colors: colors,
                            name: 'Inter / Sistema',
                            sub: 'Moderna y limpia',
                            fontFamily: 'system',
                            isSelected: themeState.fontFamily == 'system',
                            onTap: () => ref.read(themeProvider.notifier).setFontFamily('system'),
                          ),
                          const SizedBox(height: 8),
                          _fontOption(
                            colors: colors,
                            name: 'Roboto',
                            sub: 'Industrial planta',
                            fontFamily: 'roboto',
                            isSelected: themeState.fontFamily == 'roboto',
                            onTap: () => ref.read(themeProvider.notifier).setFontFamily('roboto'),
                          ),
                          const SizedBox(height: 8),
                          _fontOption(
                            colors: colors,
                            name: 'Monospace',
                            sub: 'Técnica / Datos',
                            fontFamily: 'mono',
                            isSelected: themeState.fontFamily == 'mono',
                            onTap: () => ref.read(themeProvider.notifier).setFontFamily('mono'),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: _fontOption(
                            colors: colors,
                            name: 'Inter / Sistema',
                            sub: 'Moderna y limpia',
                            fontFamily: 'system',
                            isSelected: themeState.fontFamily == 'system',
                            onTap: () => ref.read(themeProvider.notifier).setFontFamily('system'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _fontOption(
                            colors: colors,
                            name: 'Roboto',
                            sub: 'Industrial planta',
                            fontFamily: 'roboto',
                            isSelected: themeState.fontFamily == 'roboto',
                            onTap: () => ref.read(themeProvider.notifier).setFontFamily('roboto'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _fontOption(
                            colors: colors,
                            name: 'Monospace',
                            sub: 'Técnica / Datos',
                            fontFamily: 'mono',
                            isSelected: themeState.fontFamily == 'mono',
                            onTap: () => ref.read(themeProvider.notifier).setFontFamily('mono'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sección 3: Vista Previa en Tiempo Real
          CustomCard(
            colors: colors,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '3. VISTA PREVIA',
                              style: TextStyle(color: colors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Tiempo Real', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: 14),

                // Tarjeta de Muestra
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.borderMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: colors.accentSubtle,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors.accent),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'MD',
                                    style: TextStyle(color: colors.accentText, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Juan Alex Quispe',
                                        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Supervisor de Planta • Turno Día',
                                        style: TextStyle(color: colors.textMuted, fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          CustomBadge(
                            text: 'En Planta',
                            bg: colors.accentSubtle,
                            fg: colors.accentText,
                            border: colors.borderHighlight,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: colors.borderSubtle),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (ctx, constraints) {
                          final isNarrow = constraints.maxWidth < 340;
                          final kpiInfo = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rendimiento estimado:', style: TextStyle(color: colors.textMuted, fontSize: 10)),
                              Text('96.4%', style: TextStyle(color: colors.accentText, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 16)),
                            ],
                          );
                          final buttons = Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButton(
                                variant: ButtonVariant.subtle,
                                text: 'Cancelar',
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                fontSize: 11,
                                onTap: () {},
                              ),
                              const SizedBox(width: 6),
                              CustomButton(
                                variant: ButtonVariant.primary,
                                text: 'Confirmar',
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                fontSize: 11,
                                onTap: () {},
                              ),
                            ],
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                kpiInfo,
                                const SizedBox(height: 8),
                                Align(alignment: Alignment.centerRight, child: buttons),
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              kpiInfo,
                              buttons,
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeCard({
    required double width,
    required ThemeColors colors,
    required String title,
    required IconData icon,
    required bool isActive,
    required String description,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceDeep,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? colors.accent : colors.borderSubtle,
              width: isActive ? 2.0 : 1.0,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: isActive ? colors.accentText : colors.textMuted),
                      const SizedBox(width: 8),
                      Text(title, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  if (isActive)
                    CustomBadge(
                      text: 'Activo',
                      bg: colors.accent,
                      fg: Colors.white,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(description, style: TextStyle(color: colors.textMuted, fontSize: 11, height: 1.35)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fontOption({
    required ThemeColors colors,
    required String name,
    required String sub,
    required String fontFamily,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceDeep,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.accent : colors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(color: colors.textMuted, fontSize: 9)),
            const SizedBox(height: 6),
            Text(
              'Abc 123',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 12,
                fontFamily: fontFamily == 'mono' ? 'monospace' : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
