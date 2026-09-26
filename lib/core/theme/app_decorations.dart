import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Decoraciones y estilos visuales basados estrictamente en Container y BoxDecoration,
/// replicando las clases de Tailwind CSS sin usar los temas genéricos de Material Design.
abstract final class AppDecorations {
  /// Tarjeta contenedora estándar (ej. métricas KPI, paneles principales)
  /// Corresponde a: `bg-slate-900 border border-slate-800 rounded-2xl`
  static BoxDecoration card(ThemeColors colors, {BorderRadius? radius}) => BoxDecoration(
    color: colors.surfaceCard,
    borderRadius: radius ?? BorderRadius.circular(16),
    border: Border.all(color: colors.borderSubtle, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: colors.isDark ? 0.25 : 0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Tarjeta elevada o secundaria (ej. filtros, chips interactivos, avatares)
  /// Corresponde a: `bg-slate-800 border border-slate-700 rounded-xl`
  static BoxDecoration elevated(ThemeColors colors, {BorderRadius? radius}) => BoxDecoration(
    color: colors.surfaceElevated,
    borderRadius: radius ?? BorderRadius.circular(12),
    border: Border.all(color: colors.borderMedium, width: 1),
  );

  /// Tarjeta seleccionada (ej. trabajador seleccionado en lista de asistencia)
  /// Corresponde a: `bg-indigo-950/50 border-indigo-500/70 shadow-sm`
  static BoxDecoration selected(ThemeColors colors, {BorderRadius? radius}) => BoxDecoration(
    color: colors.accentSubtle,
    borderRadius: radius ?? BorderRadius.circular(12),
    border: Border.all(color: colors.borderHighlight, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: colors.accent.withValues(alpha: 0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  /// Barra flotante inferior de asistencia (Dock)
  /// Corresponde a: `bg-slate-900/95 border border-slate-700/80 rounded-2xl shadow-2xl`
  static BoxDecoration floatingDock(ThemeColors colors) => BoxDecoration(
    color: colors.isDark
        ? const Color(0xF20B0C13) // ~95% opacity
        : const Color(0xF2FFFFFF),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: colors.isDark ? AppTokens.darkBorderMedium : AppTokens.lightBorderMedium,
      width: 1.2,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: colors.isDark ? 0.6 : 0.15),
        blurRadius: 25,
        spreadRadius: 1,
        offset: const Offset(0, 8),
      ),
    ],
  );

  /// Contenedor de Ventana Modal (Ficha de personal, formulario jornada, etc.)
  static BoxDecoration modal(ThemeColors colors) => BoxDecoration(
    color: colors.surfaceCard,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: colors.borderSubtle, width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: colors.isDark ? 0.7 : 0.2),
        blurRadius: 30,
        spreadRadius: 2,
        offset: const Offset(0, 10),
      ),
    ],
  );

  /// Contenedor de Input de texto / selector
  static BoxDecoration input(ThemeColors colors, {bool isFocused = false}) => BoxDecoration(
    color: colors.inputBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isFocused ? colors.accent : colors.borderSubtle,
      width: isFocused ? 1.5 : 1.0,
    ),
  );

  /// Pastilla / Badge pequeña (ej. "Activo", "En Nómina", "46 total")
  static BoxDecoration badge({
    required Color background,
    required Color borderColor,
    double radius = 999,
  }) => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor, width: 1),
  );
}
