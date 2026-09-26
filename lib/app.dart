import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/data/app_store.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/modules/shell/app_shell.dart' as modern;
import 'presentation/state/personnel_provider.dart';
import 'presentation/state/theme_provider.dart';

class ProcesosApp extends StatelessWidget {
  const ProcesosApp({
    super.key,
    this.store,
    this.appearance,
  });

  final AppStore? store;
  final Appearance? appearance;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        if (store != null) appStoreProvider.overrideWith((ref) => store),
      ],
      child: _ProcesosAppContent(store: store),
    );
  }
}

class _ProcesosAppContent extends ConsumerStatefulWidget {
  const _ProcesosAppContent({this.store});
  final AppStore? store;

  @override
  ConsumerState<_ProcesosAppContent> createState() => _ProcesosAppContentState();
}

class _ProcesosAppContentState extends ConsumerState<_ProcesosAppContent> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && widget.store != null) {
      widget.store!.sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Sistema de Control de Planta - Piloto M&D',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'PE'),
      supportedLocales: const [Locale('es', 'PE')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppTokens.lightBackground,
        primaryColor: AppTokens.lightAccent,
        fontFamily: themeState.effectiveFontFamily,
        dividerColor: AppTokens.lightBorderSubtle,
        colorScheme: const ColorScheme.light(
          primary: AppTokens.lightAccent,
          secondary: AppTokens.lightAccentHover,
          surface: AppTokens.lightSurfaceCard,
          error: AppTokens.dangerSolid,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTokens.darkBackground,
        primaryColor: AppTokens.darkAccent,
        fontFamily: themeState.effectiveFontFamily,
        dividerColor: AppTokens.darkBorderSubtle,
        colorScheme: const ColorScheme.dark(
          primary: AppTokens.darkAccent,
          secondary: AppTokens.darkAccentHover,
          surface: AppTokens.darkSurfaceCard,
          error: AppTokens.dangerSolid,
        ),
      ),
      home: const modern.AppShell(),
    );
  }
}
