import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class AppColors {
  static const lightPrimary = Color(0xff27741b),
      darkPrimary = Color(0xff2b0e9c);
  static const lightBackground = Color(0xfff5f7f4),
      darkBackground = Color(0xff08090b);
  static const connected = Color(0xff259b50), disconnected = Color(0xffdc2626);
  static const good = Color(0xff389654), warning = Color(0xffde8c28);
  static const palette = [
    Color(0xff27741b),
    Color(0xff2b0e9c),
    Color(0xff2563eb),
    Color(0xffa34816),
    Color(0xffa32262),
    Color(0xff167c80),
  ];
}

abstract final class AppSpacing {
  static const small = 8.0, medium = 16.0, large = 24.0, radius = 16.0;
}

class Appearance extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;
  String font = 'Inter';
  Color? primary, button;
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    mode = p.getBool('dark') == true ? ThemeMode.dark : ThemeMode.light;
    font = p.getString('font') ?? 'Inter';
    final a = p.getInt('primary'), b = p.getInt('button');
    if (a != null) primary = Color(a);
    if (b != null) button = Color(b);
  }

  Future<void> save() async {
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark', mode == ThemeMode.dark);
    await p.setString('font', font);
    if (primary != null) {
      await p.setInt('primary', primary!.toARGB32());
    } else {
      await p.remove('primary');
    }
    if (button != null) {
      await p.setInt('button', button!.toARGB32());
    } else {
      await p.remove('button');
    }
  }

  ThemeData theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final seed =
        primary ?? (dark ? AppColors.darkPrimary : AppColors.lightPrimary);
    final colors = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    ).copyWith(primary: seed, onPrimary: Colors.white);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colors,
      fontFamily: font,
      scaffoldBackgroundColor: dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: dark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: dark ? const Color(0xff121418) : Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: .5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: button ?? seed,
          foregroundColor: (button ?? seed).computeLuminance() > .5
              ? Colors.black
              : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant.withValues(alpha: .5),
      ),
    );
  }
}
