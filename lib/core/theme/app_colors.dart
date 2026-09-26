import 'package:flutter/material.dart';

/// Paleta exacta de colores traducida de Tailwind CSS y reglas de negocio del proyecto.
abstract final class AppTokens {
  // --- PALETA BASE MODO OSCURO (Negro #050508 + Azul #2B0E9C) ---
  static const darkBackground = Color(0xFF050508);
  static const darkSurfaceCard = Color(0xFF0B0C13); // bg-slate-900
  static const darkSurfaceElevated = Color(0xFF121520); // bg-slate-800
  static const darkSurfaceDeep = Color(0xFF050508); // bg-slate-950
  static const darkSurfaceOverlay = Color(0xCC090A12); // bg-slate-950/80
  static const darkInputBackground = Color(0xFF07080E);
  
  static const darkBorderSubtle = Color(0xFF1A1E2E); // border-slate-800
  static const darkBorderMedium = Color(0xFF23293E); // border-slate-700
  static const darkBorderHighlight = Color(0xFF3E1BCF); // border-indigo-500

  static const darkTextPrimary = Color(0xFFFFFFFF); // text-white
  static const darkTextSecondary = Color(0xFFCBD5E1); // text-slate-200/300
  static const darkTextMuted = Color(0xFF94A3B8); // text-slate-400
  static const darkTextFaint = Color(0xFF64748B); // text-slate-500

  static const darkAccent = Color(0xFF2B0E9C); // Azul Noche Oficial
  static const darkAccentHover = Color(0xFF3714B8);
  static const darkAccentSubtle = Color(0x4D2B0E9C); // bg-indigo-950/50
  static const darkAccentText = Color(0xFF9C94F8); // text-indigo-400

  // --- PALETA BASE MODO CLARO (Blanco + Verde #27741B) ---
  static const lightBackground = Color(0xFFF4F6F8);
  static const lightSurfaceCard = Color(0xFFFFFFFF); // bg-slate-900
  static const lightSurfaceElevated = Color(0xFFF1F5F9); // bg-slate-800
  static const lightSurfaceDeep = Color(0xFFF8FAFC); // bg-slate-950
  static const lightSurfaceOverlay = Color(0xA60F172A); // bg-slate-950/65
  static const lightInputBackground = Color(0xFFF8FAFC);

  static const lightBorderSubtle = Color(0xFFE2E8F0); // border-slate-800
  static const lightBorderMedium = Color(0xFFCBD5E1); // border-slate-700
  static const lightBorderHighlight = Color(0xFF27741B); // border-indigo-500

  static const lightTextPrimary = Color(0xFF0F172A); // text-slate-900
  static const lightTextSecondary = Color(0xFF1E293B); // text-slate-800
  static const lightTextMuted = Color(0xFF475569); // text-slate-600
  static const lightTextFaint = Color(0xFF64748B); // text-slate-500

  static const lightAccent = Color(0xFF27741B); // Verde Industrial Oficial
  static const lightAccentHover = Color(0xFF1F5E15);
  static const lightAccentSubtle = Color(0x1F27741B); // bg-indigo-950/50
  static const lightAccentText = Color(0xFF27741B);

  // --- ESTADOS Y ACCIONES (UNIVERSALES / SEGÚN REGLAS GEMINI.MD) ---
  // Éxito / Entrada / En Planta
  static const emeraldPrimary = Color(0xFF10B981);
  static const emeraldDarkBg = Color(0xFF064E3B);
  static const emeraldDarkBorder = Color(0xFF065F46);
  static const emeraldDarkText = Color(0xFF34D399);
  static const emeraldLightBg = Color(0xFFD1FAE5);
  static const emeraldLightText = Color(0xFF065F46);

  // Peligro / Salida / Eliminar (Regla 6: Rojo sólido vivo sin tonos rosas)
  static const dangerSolid = Color(0xFFDC2626);
  static const dangerDarkHover = Color(0xFFB91C1C);
  static const dangerDarkBg = Color(0xFF4C0519);
  static const dangerDarkBorder = Color(0xFF9F1239);
  static const dangerDarkText = Color(0xFFFB7185);
  static const dangerLightBg = Color(0xFFFEE2E2);
  static const dangerLightBorder = Color(0xFFFCA5A5);
  static const dangerLightText = Color(0xFFB91C1C);

  // Ámbar / Turno Día / Advertencias
  static const amberText = Color(0xFFFBBF24);
  static const amberBgDark = Color(0xFF451A03);
  static const amberBorderDark = Color(0xFF78350F);

  // Colores para el Gráfico Donut de Mermas
  static const mermaPisoCrudo = Color(0xFFEF4444); // Rojo 500
  static const mermaMaquina = Color(0xFFF97316);   // Naranja 500
  static const mermaQuemados = Color(0xFFEAB308);  // Amarillo 500
  static const mermaCaja = Color(0xFF3B82F6);      // Azul 500
  static const mermaPisoCocido = Color(0xFF8B5CF6);// Violeta 500
  static const mermaBobinas = Color(0xFFEC4899);   // Rosa 500
}

/// Contenedor de colores dinámico dependiente del estado del tema.
class ThemeColors {
  const ThemeColors({required this.isDark});
  final bool isDark;

  Color get background => isDark ? AppTokens.darkBackground : AppTokens.lightBackground;
  Color get surfaceCard => isDark ? AppTokens.darkSurfaceCard : AppTokens.lightSurfaceCard;
  Color get surfaceElevated => isDark ? AppTokens.darkSurfaceElevated : AppTokens.lightSurfaceElevated;
  Color get surfaceDeep => isDark ? AppTokens.darkSurfaceDeep : AppTokens.lightSurfaceDeep;
  Color get surfaceOverlay => isDark ? AppTokens.darkSurfaceOverlay : AppTokens.lightSurfaceOverlay;
  Color get inputBg => isDark ? AppTokens.darkInputBackground : AppTokens.lightInputBackground;

  Color get borderSubtle => isDark ? AppTokens.darkBorderSubtle : AppTokens.lightBorderSubtle;
  Color get borderMedium => isDark ? AppTokens.darkBorderMedium : AppTokens.lightBorderMedium;
  Color get borderHighlight => isDark ? AppTokens.darkBorderHighlight : AppTokens.lightBorderHighlight;

  Color get textPrimary => isDark ? AppTokens.darkTextPrimary : AppTokens.lightTextPrimary;
  Color get textSecondary => isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary;
  Color get textMuted => isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted;
  Color get textFaint => isDark ? AppTokens.darkTextFaint : AppTokens.lightTextFaint;

  Color get accent => isDark ? AppTokens.darkAccent : AppTokens.lightAccent;
  Color get accentHover => isDark ? AppTokens.darkAccentHover : AppTokens.lightAccentHover;
  Color get accentSubtle => isDark ? AppTokens.darkAccentSubtle : AppTokens.lightAccentSubtle;
  Color get accentText => isDark ? AppTokens.darkAccentText : AppTokens.lightAccentText;

  // Botones de acción
  Color get btnPrimary => accent;
  Color get btnPrimaryText => Colors.white;
  Color get btnSuccess => isDark ? AppTokens.emeraldPrimary : AppTokens.lightAccent;
  Color get btnSuccessText => Colors.white;
  Color get btnDanger => AppTokens.dangerSolid;
  Color get btnDangerText => Colors.white;
}
