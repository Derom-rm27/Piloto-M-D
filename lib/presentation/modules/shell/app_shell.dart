import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/app_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../state/attendance_provider.dart';
import '../../state/personnel_provider.dart';
import '../../state/production_provider.dart';
import '../../state/theme_provider.dart';
import '../dashboard/dashboard_view.dart';
import '../attendance/attendance_view.dart';
import '../personnel/personnel_view.dart';
import '../production/production_view.dart';
import '../settings/settings_view.dart';

final currentModuleProvider = StateProvider<String>((ref) => 'dashboard');

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(themeColorsProvider);
    final themeState = ref.watch(themeProvider);
    final currentModule = ref.watch(currentModuleProvider);
    final isWide = MediaQuery.of(context).size.width >= 900;

    final titles = {
      'dashboard': 'Rendimiento',
      'asistencia': 'Asistencia',
      'personal': 'Personal',
      'jornadas': 'Jornadas',
      'configuracion': 'Configuración',
    };

    Widget activeView;
    switch (currentModule) {
      case 'asistencia':
        activeView = const AttendanceView();
        break;
      case 'personal':
        activeView = const PersonnelView();
        break;
      case 'jornadas':
        activeView = const ProductionView();
        break;
      case 'configuracion':
        activeView = const SettingsView();
        break;
      case 'dashboard':
      default:
        activeView = const DashboardView();
        break;
    }

    return Scaffold(
      backgroundColor: colors.background,
      drawer: isWide ? null : _buildMobileDrawer(context, ref, colors, currentModule),
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior móvil (md:hidden en HTML)
            if (!isWide)
              _buildMobileHeader(context, ref, colors, themeState.isDark, titles[currentModule] ?? 'M&D'),

            // Cuerpo principal con Sidebar en pantalla ancha
            Expanded(
              child: Row(
                children: [
                  if (isWide)
                    _buildSidebar(context, ref, colors, currentModule, themeState.isDark),
                  Expanded(
                    child: Container(
                      color: colors.background,
                      child: activeView,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context, WidgetRef ref, ThemeColors colors, bool isDark, String sectionTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (ctx) => Tooltip(
                  message: 'Abrir menú de navegación',
                  child: GestureDetector(
                    onTap: () => Scaffold.of(ctx).openDrawer(),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.menu, size: 18, color: colors.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/logo_app.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'M&D',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón de sincronización y estado de BD
              _HeaderSyncButton(colors: colors),
              const SizedBox(width: 5),
              // Botón rápido de alternar tema
              GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.borderMedium),
                  ),
                  child: Icon(
                    isDark ? Icons.wb_sunny : Icons.nightlight_round,
                    size: 13,
                    color: isDark ? AppTokens.amberText : colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                constraints: const BoxConstraints(maxWidth: 85),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surfaceDeep,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Text(
                  sectionTitle,
                  style: TextStyle(
                    color: colors.accentText,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, ThemeColors colors, String currentModule, bool isDark) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        border: Border(right: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        children: [
          // Logo de la marca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/logo_app.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PILOTO M&D',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Control & Trazabilidad',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),

          // Enlaces de navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              children: [
                _navItem(ref, colors, 'dashboard', 'Rendimiento (Dashboard)', Icons.pie_chart_outline, currentModule),
                const SizedBox(height: 4),
                _navItem(ref, colors, 'asistencia', 'Control de Asistencia', Icons.fact_check_outlined, currentModule),
                const SizedBox(height: 4),
                _navItem(ref, colors, 'personal', 'Personal', Icons.people_outline, currentModule),
                const SizedBox(height: 4),
                _navItem(ref, colors, 'jornadas', 'Jornadas & Lotes', Icons.precision_manufacturing_outlined, currentModule),
                const SizedBox(height: 4),
                _navItem(ref, colors, 'configuracion', 'Configuración', Icons.tune, currentModule),
              ],
            ),
          ),

          // Pie de barra lateral (Estado BD & Toggle tema)
          _DatabaseFooter(colors: colors, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context, WidgetRef ref, ThemeColors colors, String currentModule) {
    return Drawer(
      backgroundColor: colors.surfaceCard,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo_app.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('PILOTO M&D', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2)),
                ],
              ),
            ),
            Divider(height: 1, color: colors.borderSubtle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _navItem(ref, colors, 'dashboard', 'Rendimiento (Dashboard)', Icons.pie_chart_outline, currentModule, closeDrawer: true, context: context),
                  const SizedBox(height: 4),
                  _navItem(ref, colors, 'asistencia', 'Control de Asistencia', Icons.fact_check_outlined, currentModule, closeDrawer: true, context: context),
                  const SizedBox(height: 4),
                  _navItem(ref, colors, 'personal', 'Personal', Icons.people_outline, currentModule, closeDrawer: true, context: context),
                  const SizedBox(height: 4),
                  _navItem(ref, colors, 'jornadas', 'Jornadas & Lotes', Icons.precision_manufacturing_outlined, currentModule, closeDrawer: true, context: context),
                  const SizedBox(height: 4),
                  _navItem(ref, colors, 'configuracion', 'Configuración', Icons.tune, currentModule, closeDrawer: true, context: context),
                ],
              ),
            ),
            _DatabaseFooter(colors: colors, isDark: ref.watch(themeProvider).isDark),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    WidgetRef ref,
    ThemeColors colors,
    String moduleId,
    String label,
    IconData icon,
    String currentModule, {
    bool closeDrawer = false,
    BuildContext? context,
  }) {
    final isSelected = currentModule == moduleId;
    return GestureDetector(
      onTap: () {
        ref.read(currentModuleProvider.notifier).state = moduleId;
        if (closeDrawer && context != null) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.accent.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected ? Colors.white : colors.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSyncButton extends ConsumerStatefulWidget {
  const _HeaderSyncButton({required this.colors});
  final ThemeColors colors;

  @override
  ConsumerState<_HeaderSyncButton> createState() => _HeaderSyncButtonState();
}

class _HeaderSyncButtonState extends ConsumerState<_HeaderSyncButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _performSync(BuildContext context, AppStore? store) async {
    if (store != null && store.syncing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sincronización en curso...'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    _animController.repeat();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sincronizando con la nube...'),
        duration: Duration(milliseconds: 900),
      ),
    );

    try {
      if (store != null) {
        await store.sync();
        await store.load();
      }
      ref.invalidate(attendanceProvider);
      ref.invalidate(personnelProvider);
      ref.invalidate(productionProvider);

      if (context.mounted) {
        final statusMsg = store != null ? store.status : 'Datos locales actualizados';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  (store?.connected ?? true) ? Icons.cloud_done : Icons.cloud_off,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(statusMsg)),
              ],
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al refrescar: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        _animController.stop();
        _animController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(appStoreProvider);
    final colors = widget.colors;

    Widget buildButtonBody(AppStore? st) {
      final isSyncing = st?.syncing ?? false;
      final isConnected = st?.connected ?? false;
      final hasError = st?.syncError != null;
      final pending = st?.pending ?? 0;

      if (isSyncing && !_animController.isAnimating) {
        _animController.repeat();
      } else if (!isSyncing && _animController.isAnimating) {
        _animController.stop();
        _animController.reset();
      }

      Color statusDotColor;
      if (isSyncing) {
        statusDotColor = AppTokens.amberText;
      } else if (hasError) {
        statusDotColor = const Color(0xFFEF4444);
      } else if (isConnected) {
        statusDotColor = AppTokens.emeraldPrimary;
      } else {
        statusDotColor = colors.textMuted;
      }

      return Tooltip(
        message: st != null ? '${st.status}\n(Toca para refrescar y sincronizar)' : 'Refrescar datos locales',
        child: GestureDetector(
          onTap: () => _performSync(context, st),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSyncing ? AppTokens.amberBorderDark : colors.borderMedium,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _animController,
                  child: Icon(
                    Icons.sync,
                    size: 14,
                    color: isSyncing ? AppTokens.amberText : colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (pending > 0) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTokens.amberText.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$pending',
                      style: const TextStyle(
                        color: AppTokens.amberText,
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
      );
    }

    if (store != null) {
      return ListenableBuilder(
        listenable: store,
        builder: (context, _) => buildButtonBody(store),
      );
    }
    return buildButtonBody(null);
  }
}

class _DatabaseFooter extends ConsumerWidget {
  const _DatabaseFooter({required this.colors, required this.isDark});
  final ThemeColors colors;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(appStoreProvider);

    Widget buildContent(AppStore? st) {
      final isSyncing = st?.syncing ?? false;
      final isConnected = st?.connected ?? false;
      final hasError = st?.syncError != null;
      final pending = st?.pending ?? 0;

      Color dotColor;
      String statusText;
      if (isSyncing) {
        dotColor = AppTokens.amberText;
        statusText = 'Sincronizando...';
      } else if (hasError) {
        dotColor = const Color(0xFFEF4444);
        statusText = 'Error de sincronización';
      } else if (isConnected) {
        dotColor = AppTokens.emeraldPrimary;
        statusText = 'Conectado';
      } else {
        dotColor = colors.textMuted;
        statusText = 'Copia Local';
      }

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surfaceDeep,
          border: Border(top: BorderSide(color: colors.borderSubtle)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: isConnected
                                ? AppTokens.emeraldDarkText
                                : (hasError ? const Color(0xFFEF4444) : colors.textSecondary),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () async {
                    if (st != null && st.syncing) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sincronizando con la nube...'),
                        duration: Duration(milliseconds: 900),
                      ),
                    );
                    if (st != null) {
                      await st.sync();
                      await st.load();
                    }
                    ref.invalidate(attendanceProvider);
                    ref.invalidate(personnelProvider);
                    ref.invalidate(productionProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(st != null ? st.status : 'Datos locales actualizados')),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.borderMedium),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sync, size: 12, color: colors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          'Sincronizar',
                          style: TextStyle(color: colors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        if (pending > 0) ...[
                          const SizedBox(width: 3),
                          Text(
                            '($pending)',
                            style: const TextStyle(color: AppTokens.amberText, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Tema Oficial',
                    style: TextStyle(color: colors.textMuted, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.borderMedium),
                    ),
                    child: Text(
                      isDark ? 'Modo Claro' : 'Modo Oscuro',
                      style: TextStyle(color: colors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (store != null) {
      return ListenableBuilder(
        listenable: store,
        builder: (context, _) => buildContent(store),
      );
    }
    return buildContent(null);
  }
}

