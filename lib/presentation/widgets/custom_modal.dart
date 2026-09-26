import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

class CustomModal extends StatelessWidget {
  const CustomModal({
    super.key,
    required this.colors,
    required this.title,
    this.badgeText,
    this.badgeColor,
    required this.content,
    this.actions,
    this.maxWidth = 460,
  });

  final ThemeColors colors;
  final String title;
  final String? badgeText;
  final Color? badgeColor;
  final Widget content;
  final List<Widget>? actions;
  final double maxWidth;

  static Future<T?> show<T>({
    required BuildContext context,
    required ThemeColors colors,
    required String title,
    String? badgeText,
    Color? badgeColor,
    required Widget content,
    List<Widget>? actions,
    double maxWidth = 460,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Modal',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) => CustomModal(
        colors: colors,
        title: title,
        badgeText: badgeText,
        badgeColor: badgeColor,
        content: content,
        actions: actions,
        maxWidth: maxWidth,
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Fondo difuminado (Backdrop blur)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: colors.surfaceOverlay),
              ),
            ),
          ),

          // Ventana Modal centrada
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  decoration: AppDecorations.modal(colors),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Encabezado
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 14, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        color: colors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (badgeText != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: badgeColor?.withValues(alpha: 0.2) ?? colors.accentSubtle,
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(
                                          color: badgeColor ?? colors.borderHighlight,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        badgeText!,
                                        style: TextStyle(
                                          color: badgeColor ?? colors.accentText,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, size: 18, color: colors.textMuted),
                              onPressed: () => Navigator.of(context).pop(),
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: colors.borderSubtle),

                      // Cuerpo
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(18),
                          child: content,
                        ),
                      ),

                      // Botones de acción inferiores
                      if (actions != null && actions!.isNotEmpty) ...[
                        Divider(height: 1, color: colors.borderSubtle),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: actions!.where((w) => w is! SizedBox || w.child != null).toList(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
