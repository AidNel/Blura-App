import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EngineRing extends StatelessWidget {
  final int score;

  const EngineRing({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final double size = isMobile ? 140 : 180;
    final double stroke = isMobile ? 10 : 12;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: stroke,
              backgroundColor: AppTheme.textPrimary.withOpacity(0.10),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
            ),
          ),
          Container(
            width: size * 0.62,
            height: size * 0.62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent.withOpacity(0.18),
              border: Border.all(
                color: AppTheme.accent.withOpacity(0.25),
                width: 1.2,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: size * 0.24,
            ),
          ),
        ],
      ),
    );
  }
}
