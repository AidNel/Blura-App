import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/load_intelligence.dart';
import '../theme/app_theme.dart';

class EngineRing extends StatelessWidget {
  final int score;
  final BlueraEngineState state;

  const EngineRing({
    super.key,
    required this.score,
    this.state = BlueraEngineState.blue,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final double size = isMobile ? 152 : 188;
    final int clampedScore = score.clamp(0, 100);
    final _RingPalette palette = _RingPalette.fromState(state);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clampedScore / 100),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _EngineRingPainter(
                  progress: value,
                  palette: palette,
                  isMobile: isMobile,
                ),
              ),
              _CenterScore(
                score: clampedScore,
                palette: palette,
                isMobile: isMobile,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CenterScore extends StatelessWidget {
  final int score;
  final _RingPalette palette;
  final bool isMobile;

  const _CenterScore({
    required this.score,
    required this.palette,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final double diameter = isMobile ? 92 : 112;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: palette.glow.withOpacity(0.2),
            blurRadius: 18,
            spreadRadius: 1.2,
          ),
        ],
        gradient: RadialGradient(
          colors: [
            palette.core.withOpacity(0.26),
            AppTheme.card.withOpacity(0.94),
          ],
          stops: const [0.0, 1.0],
        ),
        border: Border.all(
          width: 1.2,
          color: palette.core.withOpacity(0.36),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.card.withOpacity(0.78),
          border: Border.all(
            color: AppTheme.textPrimary.withOpacity(0.08),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          '$score',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 30 : 36,
            letterSpacing: 0.2,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _EngineRingPainter extends CustomPainter {
  final double progress;
  final _RingPalette palette;
  final bool isMobile;

  _EngineRingPainter({
    required this.progress,
    required this.palette,
    required this.isMobile,
  });

  static const int _segments = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double strokeWidth = isMobile ? 12 : 14;
    final double radius = (size.width / 2) - strokeWidth;
    final Rect ringRect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = -math.pi / 2;
    const double sweepTotal = math.pi * 2;
    final double gap = (isMobile ? 7.2 : 8.2) / radius;
    final double segmentSweep = (sweepTotal - (gap * _segments)) / _segments;

    final Paint outerGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth + 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..color = palette.glow.withOpacity(0.14);

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = AppTheme.textPrimary.withOpacity(0.10);

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth + 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.5)
      ..color = palette.glow.withOpacity(0.34);

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepTotal,
        colors: [
          palette.core.withOpacity(0.82),
          palette.highlight,
          palette.core,
          palette.core.withOpacity(0.82),
        ],
        stops: const [0.0, 0.28, 0.75, 1.0],
      ).createShader(ringRect);

    final double progressScaled = progress.clamp(0.0, 1.0) * _segments;

    for (int i = 0; i < _segments; i++) {
      final double angleStart = startAngle + i * (segmentSweep + gap);
      canvas.drawArc(ringRect, angleStart, segmentSweep, false, trackPaint);

      final double fill = (progressScaled - i).clamp(0.0, 1.0);
      if (fill > 0) {
        final double fillSweep = segmentSweep * fill;
        canvas.drawArc(ringRect, angleStart, fillSweep, false, outerGlow);
        canvas.drawArc(ringRect, angleStart, fillSweep, false, glowPaint);
        canvas.drawArc(ringRect, angleStart, fillSweep, false, progressPaint);
      }
    }

    _drawArrow(canvas, center, radius, strokeWidth);
  }

  void _drawArrow(Canvas canvas, Offset center, double radius, double strokeWidth) {
    final double arrowAngle = -math.pi / 3.0;
    final double arrowDistance = radius + strokeWidth * 0.52;
    final Offset tip = center + Offset(math.cos(arrowAngle) * arrowDistance, math.sin(arrowAngle) * arrowDistance);

    final double baseDistance = arrowDistance - (isMobile ? 10 : 12);
    final Offset baseCenter =
        center + Offset(math.cos(arrowAngle) * baseDistance, math.sin(arrowAngle) * baseDistance);

    final double halfWidth = isMobile ? 4.8 : 5.6;
    final double perpAngle = arrowAngle + math.pi / 2;

    final Offset left = baseCenter + Offset(math.cos(perpAngle) * halfWidth, math.sin(perpAngle) * halfWidth);
    final Offset right = baseCenter - Offset(math.cos(perpAngle) * halfWidth, math.sin(perpAngle) * halfWidth);

    final Path arrow = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    final Paint arrowGlowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
      ..color = palette.glow.withOpacity(0.75);

    final Paint arrowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = palette.highlight;

    canvas.drawPath(arrow, arrowGlowPaint);
    canvas.drawPath(arrow, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant _EngineRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.palette != palette ||
        oldDelegate.isMobile != isMobile;
  }
}

class _RingPalette {
  final Color core;
  final Color highlight;
  final Color glow;

  const _RingPalette({
    required this.core,
    required this.highlight,
    required this.glow,
  });

  factory _RingPalette.fromState(BlueraEngineState state) {
    switch (state) {
      case BlueraEngineState.green:
        return const _RingPalette(
          core: Color(0xFF16C47F),
          highlight: Color(0xFF66E5B2),
          glow: Color(0xFF10A66B),
        );
      case BlueraEngineState.red:
        return const _RingPalette(
          core: Color(0xFFFF3D5E),
          highlight: Color(0xFFFF8BA0),
          glow: Color(0xFFE62C4C),
        );
      case BlueraEngineState.blue:
        return const _RingPalette(
          core: Color(0xFF2F80FF),
          highlight: Color(0xFF7CB4FF),
          glow: Color(0xFF1D66D8),
        );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _RingPalette && other.core == core && other.highlight == highlight && other.glow == glow;
  }

  @override
  int get hashCode => Object.hash(core, highlight, glow);
}
