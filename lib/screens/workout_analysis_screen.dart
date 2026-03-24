import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_athlete_data.dart';
import '../services/load_intelligence.dart';
import '../services/app_settings_service.dart';

class WorkoutAnalysisScreen extends StatelessWidget {
  const WorkoutAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final athlete = BlueraMockDataService.athlete;
    final data = athlete.latestWorkout;
    final intelligence = BlueraLoadIntelligence.assess(athlete);
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
                      _buildHeroCard(
                        data: data,
                        intelligence: intelligence,
                        settings: settings,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryGrid(
                        data: data,
                        settings: settings,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 16),
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildPerformanceCard(data)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildZoneCard(
                                    data: data,
                                    intelligence: intelligence,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildPerformanceCard(data),
                                const SizedBox(height: 16),
                                _buildZoneCard(
                                  data: data,
                                  intelligence: intelligence,
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                      _buildWorkoutInsightsCard(
                        data: data,
                        intelligence: intelligence,
                      ),
                      const SizedBox(height: 16),
                      _buildRecommendationsCard(intelligence),
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
    MockWorkoutAnalysis data,
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
                  'Workout Analysis',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: isMobile ? 28 : 32,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Review execution, durability, intensity balance and recovery impact.',
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
              AppSettingsService.distanceLabel(
                data.distanceKm,
                settings.unitSystem,
                decimals: 0,
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

  Widget _buildHeroCard({
    required MockWorkoutAnalysis data,
    required BlueraLoadAssessment intelligence,
    required AppSettingsData settings,
    required bool isMobile,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppTheme.accent.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.workoutType,
            style: TextStyle(
              color: AppTheme.accent,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.workoutTitle,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${AppSettingsService.distanceLabel(data.distanceKm, settings.unitSystem)} • ${AppSettingsService.elevationLabel(data.elevationM, settings.unitSystem)}',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            intelligence.todayFocus,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _statusPill(
            'Durability: ${data.durabilityStatus}',
            data.durabilityScore >= 70,
          ),
          const SizedBox(height: 10),
          _statusPill(
            'Execution: ${data.executionStatus}',
            data.executionScore >= 80,
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

  Widget _buildSummaryGrid({
    required MockWorkoutAnalysis data,
    required AppSettingsData settings,
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    final items = [
      _WorkoutSummaryItem(
        title: 'Duration',
        value: data.durationLabel,
        subtitle: 'Total ride time',
      ),
      _WorkoutSummaryItem(
        title: 'Distance',
        value: AppSettingsService.distanceLabel(
          data.distanceKm,
          settings.unitSystem,
        ),
        subtitle: 'Completed distance',
      ),
      _WorkoutSummaryItem(
        title: 'Elevation',
        value: AppSettingsService.elevationLabel(
          data.elevationM,
          settings.unitSystem,
        ),
        subtitle: 'Total climbing',
      ),
      _WorkoutSummaryItem(
        title: 'Training Load',
        value: '${data.trainingLoad}',
        subtitle: 'Session stress',
      ),
    ];

    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isDesktop
          ? 1.25
          : isTablet
          ? 1.12
          : 1.03,
      children: items
          .map(
            (item) => _summaryCard(
              title: item.title,
              value: item.value,
              subtitle: item.subtitle,
            ),
          )
          .toList(),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String subtitle,
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
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 24,
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

  Widget _buildPerformanceCard(MockWorkoutAnalysis data) {
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
            'Performance Metrics',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Key session outputs linked to quality and durability.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          _metricRow('Average Power', '${data.avgPower} W'),
          const SizedBox(height: 10),
          _metricRow('Normalized Power', '${data.normalizedPower} W'),
          const SizedBox(height: 10),
          _metricRow('Average Heart Rate', '${data.avgHeartRate} bpm'),
          const SizedBox(height: 10),
          _metricRow('Max Heart Rate', '${data.maxHeartRate} bpm'),
          const SizedBox(height: 10),
          _metricRow(
            'Intensity Factor',
            data.intensityFactor.toStringAsFixed(2),
          ),
          const SizedBox(height: 10),
          _metricRow('HR Drift', '${data.hrDrift.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.accent,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard({
    required MockWorkoutAnalysis data,
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
            'Zone Distribution',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'How the session was distributed across intensity zones.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 18,
              child: Row(
                children: [
                  Expanded(
                    flex: data.z1Percent.round(),
                    child: Container(color: AppTheme.accent.withOpacity(0.35)),
                  ),
                  Expanded(
                    flex: data.z2Percent.round(),
                    child: Container(color: AppTheme.accent),
                  ),
                  Expanded(
                    flex: data.z3Percent.round(),
                    child: Container(
                      color: AppTheme.textPrimary.withOpacity(0.32),
                    ),
                  ),
                  Expanded(
                    flex: data.z4Percent.round(),
                    child: Container(
                      color: AppTheme.textPrimary.withOpacity(0.22),
                    ),
                  ),
                  Expanded(
                    flex: data.z5Percent.round(),
                    child: Container(
                      color: AppTheme.textPrimary.withOpacity(0.14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _zoneRow('Z1', '${data.z1Percent.toStringAsFixed(0)}%'),
          const SizedBox(height: 10),
          _zoneRow('Z2', '${data.z2Percent.toStringAsFixed(0)}%'),
          const SizedBox(height: 10),
          _zoneRow('Z3', '${data.z3Percent.toStringAsFixed(0)}%'),
          const SizedBox(height: 10),
          _zoneRow('Z4', '${data.z4Percent.toStringAsFixed(0)}%'),
          const SizedBox(height: 10),
          _zoneRow('Z5', '${data.z5Percent.toStringAsFixed(0)}%'),
          const SizedBox(height: 14),
          _smallInfoPill(
            icon: Icons.pie_chart_outline_rounded,
            text: intelligence.zoneLabel,
            positive: intelligence.zoneState == BlueraZoneState.onTarget,
          ),
        ],
      ),
    );
  }

  Widget _zoneRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.accent,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutInsightsCard({
    required MockWorkoutAnalysis data,
    required BlueraLoadAssessment intelligence,
  }) {
    final insightCards = [
      _InsightCardData(
        title: 'Durability',
        message: data.durabilityScore >= 75
            ? 'Durability is responding well and the session stayed stable through the main work.'
            : 'Durability is improving, but there is still some late-session fade to work on.',
        positive: data.durabilityScore >= 75,
      ),
      _InsightCardData(
        title: 'Execution',
        message: data.executionScore >= 80
            ? 'The pacing matched the session goal and effort distribution was controlled.'
            : 'Execution was mixed and the effort profile can be tightened further.',
        positive: data.executionScore >= 80,
      ),
      _InsightCardData(
        title: 'Recovery Impact',
        message: intelligence.recoveryState == BlueraRecoveryState.good
            ? 'This workout fits well inside the current block without causing major recovery strain.'
            : intelligence.recoveryState == BlueraRecoveryState.monitor
            ? 'This session was productive, but the next hard day should be spaced carefully.'
            : 'Recovery cost is high enough that a lighter day is the smarter next move.',
        positive: intelligence.recoveryState == BlueraRecoveryState.good,
      ),
    ];

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
            'Workout Insights',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Session-specific coaching observations aligned with the load intelligence layer.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ...insightCards.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: item.positive
                      ? AppTheme.accent.withOpacity(0.08)
                      : AppTheme.background.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: item.positive
                        ? AppTheme.accent.withOpacity(0.20)
                        : AppTheme.textPrimary.withOpacity(0.08),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item.positive
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      color: item.positive
                          ? AppTheme.accent
                          : AppTheme.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.message,
                            style: TextStyle(
                              color: AppTheme.textPrimary.withOpacity(0.66),
                              fontSize: 12.8,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(BlueraLoadAssessment intelligence) {
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
            'Next-Step Recommendations',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Suggested response to this workout inside the Bluera coaching flow.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ...intelligence.recommendations.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: item.warning
                      ? AppTheme.background.withOpacity(0.55)
                      : AppTheme.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: item.warning
                        ? AppTheme.textPrimary.withOpacity(0.08)
                        : AppTheme.accent.withOpacity(0.20),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item.warning
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: item.warning
                          ? AppTheme.textPrimary
                          : AppTheme.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.message,
                            style: TextStyle(
                              color: AppTheme.textPrimary.withOpacity(0.66),
                              fontSize: 12.8,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  Widget _smallInfoPill({
    required IconData icon,
    required String text,
    required bool positive,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.accent.withOpacity(0.10)
            : AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: positive
              ? AppTheme.accent.withOpacity(0.22)
              : AppTheme.textPrimary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: positive ? AppTheme.accent : AppTheme.textPrimary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutSummaryItem {
  final String title;
  final String value;
  final String subtitle;

  const _WorkoutSummaryItem({
    required this.title,
    required this.value,
    required this.subtitle,
  });
}

class _InsightCardData {
  final String title;
  final String message;
  final bool positive;

  const _InsightCardData({
    required this.title,
    required this.message,
    required this.positive,
  });
}
