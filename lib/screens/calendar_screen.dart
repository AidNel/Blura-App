import 'package:flutter/material.dart';
import '../services/load_intelligence.dart';
import '../services/mock_athlete_data.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = BlueraMockDataService.athlete;
    final assessment = BlueraLoadIntelligence.assess(data);
    final recommendation = BlueraLoadIntelligence.calendarRecommendation(
      data,
      assessment,
    );
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calendar',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'What to do today, why it fits your current load, and where this week is heading.',
                          style: TextStyle(
                            color: AppTheme.textPrimary.withOpacity(0.68),
                            fontSize: 13.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _sectionCard(
                    accent: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Recommended Workout',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recommendation.sessionTitle,
                          style: TextStyle(
                            color: AppTheme.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _pill('Type: ${recommendation.workoutType}'),
                            _pill('Duration: ${recommendation.durationLabel}'),
                            _pill('Intensity: ${recommendation.intensityLabel}'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          recommendation.reason,
                          style: TextStyle(
                            color: AppTheme.textPrimary.withOpacity(0.72),
                            fontSize: 13.2,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  isMobile
                      ? Column(
                          children: [
                            _summaryCard(
                              title: 'Weekly Focus',
                              body: recommendation.weeklyFocus,
                              icon: Icons.flag_outlined,
                            ),
                            const SizedBox(height: 12),
                            _summaryCard(
                              title: 'Readiness Summary',
                              body: recommendation.readinessSummary,
                              icon: Icons.insights_outlined,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _summaryCard(
                                title: 'Weekly Focus',
                                body: recommendation.weeklyFocus,
                                icon: Icons.flag_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _summaryCard(
                                title: 'Readiness Summary',
                                body: recommendation.readinessSummary,
                                icon: Icons.insights_outlined,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 14),
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '7-Day Training Schedule',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Mock plan with load-aware structure for the current week.',
                          style: TextStyle(
                            color: AppTheme.textPrimary.withOpacity(0.66),
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...data.weeklyCalendar.map(_scheduleTile),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child, bool accent = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: accent
              ? AppTheme.accent.withOpacity(0.3)
              : AppTheme.textPrimary.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }

  Widget _summaryCard({
    required String title,
    required String body,
    required IconData icon,
  }) {
    return _sectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppTheme.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.72),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleTile(CalendarWorkout item) {
    final isToday = item.isToday;
    final isDone = item.completed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isToday
              ? AppTheme.accent.withOpacity(0.10)
              : AppTheme.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isToday
                ? AppTheme.accent.withOpacity(0.35)
                : AppTheme.textPrimary.withOpacity(0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 46,
              child: Column(
                children: [
                  Text(
                    item.dayLabel,
                    style: TextStyle(
                      color: AppTheme.textPrimary.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.dayNumber,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isToday) _pill('Today', tight: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.type,
                    style: TextStyle(
                      color: AppTheme.textPrimary.withOpacity(0.62),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _pill(item.durationLabel, tight: true),
                      _pill(item.intensityLabel, tight: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isDone
                  ? Icons.check_circle
                  : item.isRestDay
                  ? Icons.bedtime_outlined
                  : Icons.chevron_right_rounded,
              color: isDone ? AppTheme.accent : AppTheme.textPrimary.withOpacity(0.55),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, {bool tight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tight ? 8 : 10,
        vertical: tight ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.textPrimary.withOpacity(0.72),
          fontSize: tight ? 11 : 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
