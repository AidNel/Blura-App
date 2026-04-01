import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/load_intelligence.dart';
import '../theme/app_theme.dart';

class EngineRing extends StatelessWidget {
  final int score;
  final BlueraEngineState state;
  final double? innerProgress;
  final double? middleProgress;
  final double? outerProgress;
  final Widget? centerChild;

  const EngineRing({
    super.key,
    required this.score,
    this.state = BlueraEngineState.blue,
    this.innerProgress,
    this.middleProgress,
    this.outerProgress,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final double size = isMobile ? 232 : 276;
    final int clampedScore = score.clamp(0, 100);

    final double resolvedInner = (innerProgress ?? (clampedScore / 100)).clamp(0.0, 1.0);
    final double resolvedMiddle = (middleProgress ?? (clampedScore / 100)).clamp(0.0, 1.0);
    final double resolvedOuter = (outerProgress ?? (clampedScore / 100)).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _EngineRingPainter(
                  innerProgress: resolvedInner * animationValue,
                  middleProgress: resolvedMiddle * animationValue,
                  outerProgress: resolvedOuter * animationValue,
                  state: state,
                  isMobile: isMobile,
                ),
              ),
              centerChild ?? _DefaultCenter(state: state, score: clampedScore, isMobile: isMobile),
            ],
          ),
        );
      },
    );
  }
}

class _DefaultCenter extends StatelessWidget {
  final BlueraEngineState state;
  final int score;
  final bool isMobile;

  const _DefaultCenter({
    required this.state,
    required this.score,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final _RingPalette palette = _RingPalette.fromState(state);
    final double diameter = isMobile ? 104 : 124;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            palette.core.withOpacity(0.28),
            AppTheme.card.withOpacity(0.97),
          ],
          stops: const [0.0, 1.0],
        ),
        border: Border.all(color: palette.core.withOpacity(0.34), width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$score',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: isMobile ? 34 : 40,
          height: 1,
        ),
      ),
    );
  }
}

class _EngineRingPainter extends CustomPainter {
  final double innerProgress;
  final double middleProgress;
  final double outerProgress;
  final BlueraEngineState state;
  final bool isMobile;

  _EngineRingPainter({
    required this.innerProgress,
    required this.middleProgress,
    required this.outerProgress,
    required this.state,
    required this.isMobile,
  });

  static const Color _innerColor = Color(0xFF2F80FF);
  static const Color _middleColor = Color(0xFFFF4A62);
  static const Color _outerColor = Color(0xFF1ED183);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double outerStroke = isMobile ? 11 : 12;
    final double middleStroke = isMobile ? 10 : 11;
    final double innerStroke = isMobile ? 9 : 10;

    final double gap = isMobile ? 9 : 10;
    final double outerRadius = (size.width / 2) - outerStroke;
    final double middleRadius = outerRadius - outerStroke - gap;
    final double innerRadius = middleRadius - middleStroke - gap;

    _drawRing(
      canvas,
      center,
      outerRadius,
      outerStroke,
      outerProgress,
      _outerColor,
      glow: 0.22,
    );
    _drawRing(
      canvas,
      center,
      middleRadius,
      middleStroke,
      middleProgress,
      _middleColor,
      glow: 0.20,
    );
    _drawRing(
      canvas,
      center,
      innerRadius,
      innerStroke,
      innerProgress,
      _innerColor,
      glow: 0.18,
    );

    _drawArrow(canvas, center, outerRadius + outerStroke * 0.6);
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double progress,
    Color color, {
    double glow = 0.2,
  }) {
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    const double startAngle = -math.pi / 2;
    const double fullSweep = 2 * math.pi;

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.textPrimary.withOpacity(0.09);

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..color = color.withOpacity(glow);

    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawArc(rect, startAngle, fullSweep, false, trackPaint);
    if (progress > 0) {
      final double sweep = fullSweep * progress.clamp(0.0, 1.0);
      canvas.drawArc(rect, startAngle, sweep, false, glowPaint);
      canvas.drawArc(rect, startAngle, sweep, false, progressPaint);
    }
  }

  void _drawArrow(Canvas canvas, Offset center, double distance) {
    final _RingPalette palette = _RingPalette.fromState(state);
    final double arrowAngle = -math.pi / 3.0;
    final Offset tip = center + Offset(math.cos(arrowAngle) * distance, math.sin(arrowAngle) * distance);

    final Offset base = center + Offset(math.cos(arrowAngle) * (distance - 12), math.sin(arrowAngle) * (distance - 12));
    final double halfWidth = isMobile ? 4.8 : 5.6;
    final double perpAngle = arrowAngle + math.pi / 2;

    final Offset left = base + Offset(math.cos(perpAngle) * halfWidth, math.sin(perpAngle) * halfWidth);
    final Offset right = base - Offset(math.cos(perpAngle) * halfWidth, math.sin(perpAngle) * halfWidth);

    final Path arrow = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    final Paint arrowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = palette.highlight;

    canvas.drawPath(arrow, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant _EngineRingPainter oldDelegate) {
    return oldDelegate.innerProgress != innerProgress ||
        oldDelegate.middleProgress != middleProgress ||
        oldDelegate.outerProgress != outerProgress ||
        oldDelegate.state != state ||
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
}
