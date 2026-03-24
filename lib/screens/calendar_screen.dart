import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_athlete_data.dart';
import '../services/load_intelligence.dart';
import '../services/app_settings_service.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = BlueraMockDataService.athlete;
    final intelligence = BlueraLoadIntelligence.assess(data);
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 650 && width < 900;
    final bool isMobile = width < 650;

    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsService.instance,
      builder: (context, settings, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 18,
                isMobile ? 14 : 18,
                isMobile ? 14 : 18,
                isMobile ? 24 : 28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(data, settings, isMobile),
                      const SizedBox(height: 16),
                      _buildWeeklyOverview(
                        data: data,
                        intelligence: intelligence,
                        settings: settings,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 16),
                      _buildWeekStrip(data),
                      const SizedBox(height: 16),
                      _buildScheduleCard(data, settings),
                      const SizedBox(height: 16),
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildTodayCard(
                                    data: data,
                                    intelligence: intelligence,
                                    settings: settings,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildCoachNoteCard(
                                    data: data,
                                    intelligence: intelligence,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildTodayCard(
                                  data: data,
                                  intelligence: intelligence,
                                  settings: settings,
                                ),
                                const SizedBox(height: 16),
                                _buildCoachNoteCard(
                                  data: data,
                                  intelligence: intelligence,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    MockAthleteData data,
    AppSettingsData settings,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calendar',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: isMobile ? 28 : 32,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your current training week, upcoming sessions and load-aware structure.',
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.68),
                    fontSize: isMobile ? 13.5 : 14.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              AppSettingsService.shortDistanceLabel(
                data.weeklyDistanceKm,
                settings.unitSystem,
              ),
              style: TextStyle(
                color: AppTheme.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyOverview({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
    required AppSettingsData settings,
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isDesktop
          ? 1.30
          : isTablet
          ? 1.12
          : 1.04,
      children: [
        _summaryCard(
          title: 'Planned Hours',
          value: '${data.weeklyHours.toStringAsFixed(1)} h',
          subtitle: 'Weekly target volume',
          icon: Icons.schedule_outlined,
        ),
        _summaryCard(
          title: 'Completed',
          value: '${data.completedSessions}',
          subtitle: 'Sessions done',
          icon: Icons.check_circle_outline,
        ),
        _summaryCard(
          title: 'Distance',
          value: AppSettingsService.distanceLabel(
            data.weeklyDistanceKm,
            settings.unitSystem,
            decimals: 0,
          ),
          subtitle: 'Weekly target distance',
          icon: Icons.route_outlined,
        ),
        _summaryCard(
          title: 'Recovery',
          value: intelligence.recoveryLabel,
          subtitle: 'Current readiness state',
          icon: Icons.bedtime_outlined,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.accent, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.56),
              fontSize: 11.8,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStrip(MockAthleteData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        children: data.weeklyCalendar.map((item) {
          final bool selected = item.isToday;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.accent.withOpacity(0.14)
                      : item.completed
                      ? AppTheme.background.withOpacity(0.55)
                      : AppTheme.background.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppTheme.accent.withOpacity(0.45)
                        : AppTheme.textPrimary.withOpacity(0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      item.dayLabel,
                      style: TextStyle(
                        color: selected
                            ? AppTheme.accent
                            : AppTheme.textPrimary.withOpacity(0.70),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.dayNumber,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Icon(
                      item.completed
                          ? Icons.check_circle
                          : item.isRestDay
                          ? Icons.bedtime_outlined
                          : Icons.radio_button_unchecked,
                      color: item.completed
                          ? AppTheme.accent
                          : AppTheme.textPrimary.withOpacity(0.55),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScheduleCard(MockAthleteData data, AppSettingsData settings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Schedule',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Structured training flow for the current week.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ...data.weeklyCalendar.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _scheduleTile(item, settings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleTile(CalendarWorkout item, AppSettingsData settings) {
    final bool positive = item.completed || item.isToday;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isToday
            ? AppTheme.accent.withOpacity(0.10)
            : AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.isToday
              ? AppTheme.accent.withOpacity(0.28)
              : AppTheme.textPrimary.withOpacity(0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: positive
                  ? AppTheme.accent.withOpacity(0.14)
                  : AppTheme.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.dayLabel,
                  style: TextStyle(
                    color: positive ? AppTheme.accent : AppTheme.textPrimary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.dayNumber,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (item.isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            color: AppTheme.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.type,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.60),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _miniPill(item.durationLabel),
                    const SizedBox(width: 8),
                    _miniPill(item.intensityLabel),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            item.completed
                ? Icons.check_circle
                : item.isRestDay
                ? Icons.bedtime_outlined
                : Icons.chevron_right_rounded,
            color: item.completed
                ? AppTheme.accent
                : AppTheme.textPrimary.withOpacity(0.55),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _miniPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.textPrimary.withOpacity(0.72),
          fontSize: 11.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTodayCard({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
    required AppSettingsData settings,
  }) {
    final today = data.weeklyCalendar.firstWhere((item) => item.isToday);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accent.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today’s Session',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            today.title,
            style: TextStyle(
              color: AppTheme.accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Distance: ${AppSettingsService.distanceLabel(data.latestWorkout.distanceKm, settings.unitSystem)} • Elevation: ${AppSettingsService.elevationLabel(data.latestWorkout.elevationM, settings.unitSystem)}',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _statusPill(
            'Execution: ${data.latestWorkout.executionStatus}',
            data.latestWorkout.executionScore >= 80,
          ),
          const SizedBox(height: 10),
          _statusPill(
            'Recovery: ${intelligence.recoveryLabel}',
            intelligence.recoveryState == BlueraRecoveryState.good,
          ),
        ],
      ),
    );
  }

  Widget _buildCoachNoteCard({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coach Note',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Planned direction based on current load and readiness.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            intelligence.todayFocus,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.70),
              fontSize: 13.2,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          _statusPill(
            'Load: ${intelligence.loadLabel}',
            intelligence.loadLevel != BlueraLoadLevel.high,
          ),
          const SizedBox(height: 10),
          _statusPill(
            'Zones: ${intelligence.zoneLabel}',
            intelligence.zoneState == BlueraZoneState.onTarget,
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text, bool positive) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.accent.withOpacity(0.10)
            : AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: positive
              ? AppTheme.accent.withOpacity(0.45)
              : AppTheme.textPrimary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            positive ? Icons.check_circle_outline : Icons.info_outline,
            color: positive ? AppTheme.accent : AppTheme.textPrimary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
