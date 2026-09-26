import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';

class ThemeState {
  const ThemeState({
    this.isDark = true,
    this.fontFamily = 'system',
    this.fontScale = 'normal',
  });

  final bool isDark;
  final String fontFamily; // 'system' | 'roboto' | 'mono'
  final String fontScale;  // 'compact' | 'normal' | 'large'

  String get effectiveFontFamily {
    switch (fontFamily) {
      case 'roboto':
        return 'Roboto';
      case 'mono':
        return 'monospace';
      case 'system':
      default:
        return 'Inter';
    }
  }

  double get scaleFactor {
    switch (fontScale) {
      case 'compact':
        return 0.9;
      case 'large':
        return 1.1;
      case 'normal':
      default:
        return 1.0;
    }
  }

  ThemeState copyWith({
    bool? isDark,
    String? fontFamily,
    String? fontScale,
  }) => ThemeState(
    isDark: isDark ?? this.isDark,
    fontFamily: fontFamily ?? this.fontFamily,
    fontScale: fontScale ?? this.fontScale,
  );
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState()) {
    _loadPreferences();
  }

  static const _keyDark = 'theme_is_dark';
  static const _keyFont = 'theme_font_family';
  static const _keyScale = 'theme_font_scale';

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_keyDark) ?? true;
    final font = prefs.getString(_keyFont) ?? 'system';
    final scale = prefs.getString(_keyScale) ?? 'normal';
    state = ThemeState(isDark: isDark, fontFamily: font, fontScale: scale);
  }

  Future<void> toggleTheme() async {
    await setTheme(!state.isDark);
  }

  Future<void> setTheme(bool isDark) async {
    state = state.copyWith(isDark: isDark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDark, isDark);
  }

  Future<void> setFontFamily(String font) async {
    state = state.copyWith(fontFamily: font);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFont, font);
  }

  Future<void> setFontScale(String scale) async {
    state = state.copyWith(fontScale: scale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyScale, scale);
  }

  Future<void> resetDefaults() async {
    state = const ThemeState(isDark: true, fontFamily: 'system', fontScale: 'normal');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDark, true);
    await prefs.setString(_keyFont, 'system');
    await prefs.setString(_keyScale, 'normal');
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

final themeColorsProvider = Provider<ThemeColors>((ref) {
  final themeState = ref.watch(themeProvider);
  return ThemeColors(isDark: themeState.isDark);
});
