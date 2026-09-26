import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.colors,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.onTap,
  });

  final ThemeColors colors;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding,
      decoration: AppDecorations.card(colors, radius: borderRadius),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: container,
      );
    }
    return container;
  }
}

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    required this.text,
    required this.bg,
    required this.fg,
    this.border,
    this.fontSize = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color? border;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: AppDecorations.badge(
        background: bg,
        borderColor: border ?? Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    required this.colors,
    this.controller,
    this.initialValue,
    this.placeholder,
    this.prefixIcon,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
  });

  final ThemeColors colors;
  final TextEditingController? controller;
  final String? initialValue;
  final String? placeholder;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.input(widget.colors, isFocused: _isFocused),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          if (widget.prefixIcon != null) ...[
            widget.prefixIcon!,
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              initialValue: widget.controller == null ? widget.initialValue : null,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              style: TextStyle(
                color: widget.colors.textPrimary,
                fontSize: 12,
              ),
              cursorColor: widget.colors.accent,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: TextStyle(
                  color: widget.colors.textFaint,
                  fontSize: 12,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
