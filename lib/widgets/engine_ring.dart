import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum EngineRingState { blue, optimized, fatigue }

class EngineRing extends StatelessWidget {
  final int score;
  final EngineRingState state;

  const EngineRing({
    super.key,
    required this.score,
    this.state = EngineRingState.blue,
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
      duration: const Duration(milliseconds: 950),
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
    final double diameter = isMobile ? 86 : 106;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            palette.core.withOpacity(0.22),
            palette.core.withOpacity(0.08),
          ],
        ),
        border: Border.all(
          width: 1.2,
          color: palette.core.withOpacity(0.30),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$score',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: isMobile ? 28 : 34,
          letterSpacing: 0.3,
          height: 1,
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
    final double gap = (isMobile ? 7.5 : 8.5) / radius;
    final double segmentSweep = (sweepTotal - (gap * _segments)) / _segments;

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = AppTheme.textPrimary.withOpacity(0.09);

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth + 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0)
      ..color = palette.glow.withOpacity(0.30);

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepTotal,
        colors: [
          palette.core.withOpacity(0.88),
          palette.highlight,
          palette.core,
          palette.core.withOpacity(0.88),
        ],
        stops: const [0.00, 0.30, 0.78, 1.00],
      ).createShader(ringRect);

    final double progressScaled = progress.clamp(0.0, 1.0) * _segments;

    for (int i = 0; i < _segments; i++) {
      final double angleStart = startAngle + i * (segmentSweep + gap);
      canvas.drawArc(ringRect, angleStart, segmentSweep, false, trackPaint);

      final double fill = (progressScaled - i).clamp(0.0, 1.0);
      if (fill > 0) {
        final double fillSweep = segmentSweep * fill;
        canvas.drawArc(ringRect, angleStart, fillSweep, false, glowPaint);
        canvas.drawArc(ringRect, angleStart, fillSweep, false, progressPaint);
      }
    }

    _drawArrow(canvas, center, radius, strokeWidth);
  }

  void _drawArrow(Canvas canvas, Offset center, double radius, double strokeWidth) {
    final double arrowAngle = -math.pi / 3.0;
    final double arrowDistance = radius + strokeWidth * 0.50;
    final Offset tip = center +
        Offset(math.cos(arrowAngle) * arrowDistance, math.sin(arrowAngle) * arrowDistance);

    final double baseDistance = arrowDistance - (isMobile ? 10 : 12);
    final Offset baseCenter = center +
        Offset(math.cos(arrowAngle) * baseDistance, math.sin(arrowAngle) * baseDistance);

    final double halfWidth = isMobile ? 4.8 : 5.6;
    final double perpAngle = arrowAngle + math.pi / 2;

    final Offset left = baseCenter +
        Offset(math.cos(perpAngle) * halfWidth, math.sin(perpAngle) * halfWidth);
    final Offset right = baseCenter -
        Offset(math.cos(perpAngle) * halfWidth, math.sin(perpAngle) * halfWidth);

    final Path arrow = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    final Paint arrowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = palette.highlight;

    final Paint arrowGlowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
      ..color = palette.glow.withOpacity(0.72);

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

  factory _RingPalette.fromState(EngineRingState state) {
    switch (state) {
      case EngineRingState.optimized:
        return const _RingPalette(
          core: Color(0xFF35D99E),
          highlight: Color(0xFF75F7C3),
          glow: Color(0xFF2FBF8A),
        );
      case EngineRingState.fatigue:
        return const _RingPalette(
          core: Color(0xFFFF5A73),
          highlight: Color(0xFFFF8A9E),
          glow: Color(0xFFFF4865),
        );
      case EngineRingState.blue:
        return const _RingPalette(
          core: Color(0xFF4DA3FF),
          highlight: Color(0xFF88C5FF),
          glow: Color(0xFF3B8DE6),
        );
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _RingPalette &&
        other.core == core &&
        other.highlight == highlight &&
        other.glow == glow;
  }

  @override
  int get hashCode => Object.hash(core, highlight, glow);
}
