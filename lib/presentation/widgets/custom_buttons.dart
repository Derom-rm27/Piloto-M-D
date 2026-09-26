import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ButtonVariant { primary, success, danger, secondary, subtle }

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.borderRadius = 12.0,
    this.fontSize = 12.0,
    this.isFullWidth = false,
  });

  final VoidCallback onTap;
  final String text;
  final Widget? icon;
  final ButtonVariant variant;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;
  final bool isFullWidth;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Resolver colores según variante y modo claro/oscuro
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg;
    Color fg;
    Color? border;
    List<BoxShadow> shadows = [];

    switch (widget.variant) {
      case ButtonVariant.primary:
        bg = isDark ? AppTokens.darkAccent : AppTokens.lightAccent;
        fg = Colors.white;
        border = isDark ? const Color(0xFF3B18CB) : const Color(0xFF1F5E15);
        shadows = [
          BoxShadow(
            color: bg.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ];
        break;

      case ButtonVariant.success:
        bg = isDark ? AppTokens.emeraldPrimary : AppTokens.lightAccent;
        fg = Colors.white;
        border = isDark ? const Color(0xFF065F46) : const Color(0xFF1F5E15);
        shadows = [
          BoxShadow(
            color: bg.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ];
        break;

      case ButtonVariant.danger:
        // Regla 6: En Modo Claro, rojo sólido y vivo #DC2626 con texto blanco puro #FFFFFF
        bg = AppTokens.dangerSolid;
        fg = Colors.white;
        border = AppTokens.dangerDarkHover;
        shadows = [
          BoxShadow(
            color: bg.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ];
        break;

      case ButtonVariant.secondary:
        bg = isDark ? AppTokens.darkSurfaceElevated : AppTokens.lightSurfaceElevated;
        fg = isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary;
        border = isDark ? AppTokens.darkBorderMedium : AppTokens.lightBorderMedium;
        break;

      case ButtonVariant.subtle:
        bg = Colors.transparent;
        fg = isDark ? AppTokens.darkTextMuted : AppTokens.lightTextMuted;
        border = null;
        break;
    }

    final content = AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: border != null ? Border.all(color: border, width: 1) : null,
          boxShadow: shadows,
        ),
        child: Row(
          mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: fg,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: widget.isFullWidth ? SizedBox(width: double.infinity, child: content) : content,
    );
  }
}
