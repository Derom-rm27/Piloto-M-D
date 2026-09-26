import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/usecases/production_metrics.dart';

class DonutChartWidget extends StatelessWidget {
  const DonutChartWidget({
    super.key,
    required this.slices,
    required this.totalKg,
    required this.colors,
  });

  final List<MermaSlice> slices;
  final double totalKg;
  final ThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 170,
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(170, 170),
                  painter: _DonutChartPainter(slices: slices, isDark: colors.isDark),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${totalKg.toStringAsFixed(1)} kg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        color: AppTokens.dangerDarkText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Desglose de leyenda
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: slices.map((s) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  s.name,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${s.percent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: colors.textMuted,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({required this.slices, required this.isDark});
  final List<MermaSlice> slices;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 18.0;

    // Fondo del anillo
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    double startAngle = -math.pi / 2; // Arriba (12 en punto)

    for (final slice in slices) {
      if (slice.percent <= 0) continue;
      final sweepAngle = (slice.percent / 100) * 2 * math.pi;

      final slicePaint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        slicePaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.slices != slices || oldDelegate.isDark != isDark;
  }
}
