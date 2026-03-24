import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_athlete_data.dart';
import '../services/load_intelligence.dart';
import '../services/app_settings_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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
                                Expanded(
                                  child: _buildTrendCard(
                                    title: 'Weekly Hours',
                                    subtitle:
                                        'Training time trend over recent weeks',
                                    data: data.weeklyHoursTrend,
                                    highlightValue:
                                        '${data.weeklyHours.toStringAsFixed(1)} h',
                                    positive: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTrendCard(
                                    title: 'Weekly Distance',
                                    subtitle:
                                        'Distance progression across recent weeks',
                                    data: data.weeklyDistanceTrend,
                                    highlightValue:
                                        AppSettingsService.distanceLabel(
                                          data.weeklyDistanceKm,
                                          settings.unitSystem,
                                          decimals: 0,
                                        ),
                                    positive: true,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildTrendCard(
                                  title: 'Weekly Hours',
                                  subtitle:
                                      'Training time trend over recent weeks',
                                  data: data.weeklyHoursTrend,
                                  highlightValue:
                                      '${data.weeklyHours.toStringAsFixed(1)} h',
                                  positive: true,
                                ),
                                const SizedBox(height: 16),
                                _buildTrendCard(
                                  title: 'Weekly Distance',
                                  subtitle:
                                      'Distance progression across recent weeks',
                                  data: data.weeklyDistanceTrend,
                                  highlightValue:
                                      AppSettingsService.distanceLabel(
                                        data.weeklyDistanceKm,
                                        settings.unitSystem,
                                        decimals: 0,
                                      ),
                                  positive: true,
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildMonthlyVolumeCard(
                                    data,
                                    settings,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildZoneDistributionCard(
                                    data: data,
                                    intelligence: intelligence,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildMonthlyVolumeCard(data, settings),
                                const SizedBox(height: 16),
                                _buildZoneDistributionCard(
                                  data: data,
                                  intelligence: intelligence,
                                ),
                              ],
                            ),
                      const SizedBox(height: 16),
                      _buildLoadManagementCard(
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
                  'Analytics',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: isMobile ? 28 : 32,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Volume, load balance, trend tracking and coaching signals in one view.',
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

  Widget _buildSummaryGrid({
    required MockAthleteData data,
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
          ? 1.35
          : isTablet
          ? 1.18
          : 1.08,
      children: [
        _summaryCard(
          title: 'Weekly Hours',
          value: '${data.weeklyHours.toStringAsFixed(1)} h',
          subtitle: 'Current week volume',
          icon: Icons.schedule_outlined,
        ),
        _summaryCard(
          title: 'Weekly Distance',
          value: AppSettingsService.distanceLabel(
            data.weeklyDistanceKm,
            settings.unitSystem,
            decimals: 0,
          ),
          subtitle: 'Current week distance',
          icon: Icons.route_outlined,
        ),
        _summaryCard(
          title: 'Monthly Hours',
          value: '${data.monthlyHours.toStringAsFixed(1)} h',
          subtitle: 'Rolling monthly total',
          icon: Icons.calendar_month_outlined,
        ),
        _summaryCard(
          title: 'Monthly Elevation',
          value: AppSettingsService.elevationLabel(
            data.monthlyElevationM,
            settings.unitSystem,
          ),
          subtitle: 'Rolling monthly climbing',
          icon: Icons.terrain_outlined,
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

  Widget _buildTrendCard({
    required String title,
    required String subtitle,
    required List<AthleteMetric> data,
    required String highlightValue,
    required bool positive,
  }) {
    final double maxValue = data
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.textPrimary.withOpacity(0.66),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  highlightValue,
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final double normalized = item.value / maxValue;
                final double barHeight = 36 + (normalized * 94);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          item.value % 1 == 0
                              ? '${item.value.toInt()}'
                              : item.value.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppTheme.textPrimary.withOpacity(0.60),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: positive
                                ? AppTheme.accent.withOpacity(0.90)
                                : AppTheme.textPrimary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: AppTheme.textPrimary.withOpacity(0.60),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Trend values are mock data for now and will later be driven by synced activity history.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.52),
              fontSize: 11.8,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyVolumeCard(
    MockAthleteData data,
    AppSettingsData settings,
  ) {
    final double maxValue = data.monthlyVolumeTrend
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

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
            'Monthly Volume',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rolling monthly training volume trend',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          ...data.monthlyVolumeTrend.map((item) {
            final double ratio = item.value / maxValue;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: AppTheme.textPrimary.withOpacity(0.62),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 12,
                        backgroundColor: AppTheme.background.withOpacity(0.60),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 44,
                    child: Text(
                      item.value.toStringAsFixed(1),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          _smallInfoPill(
            icon: Icons.terrain_outlined,
            text: AppSettingsService.elevationLabel(
              data.monthlyElevationM,
              settings.unitSystem,
            ),
            positive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildZoneDistributionCard({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
  }) {
    final double z1z2 = data.z1z2Percent / 100;
    final double z3z5 = data.z3z5Percent / 100;

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
            'Target split for endurance development',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 18,
              child: Row(
                children: [
                  Expanded(
                    flex: (z1z2 * 100).round(),
                    child: Container(color: AppTheme.accent),
                  ),
                  Expanded(
                    flex: (z3z5 * 100).round(),
                    child: Container(
                      color: AppTheme.textPrimary.withOpacity(0.18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _zoneRow(
            label: 'Z1 + Z2',
            value: '${data.z1z2Percent.toStringAsFixed(0)}%',
            positive: true,
          ),
          const SizedBox(height: 10),
          _zoneRow(
            label: 'Z3 + Z4 + Z5',
            value: '${data.z3z5Percent.toStringAsFixed(0)}%',
            positive: false,
          ),
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

  Widget _zoneRow({
    required String label,
    required String value,
    required bool positive,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.accent.withOpacity(0.08)
            : AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: positive
              ? AppTheme.accent.withOpacity(0.25)
              : AppTheme.textPrimary.withOpacity(0.08),
        ),
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
              color: positive ? AppTheme.accent : AppTheme.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadManagementCard({
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
            'Load Management',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Current coaching signals from weekly and monthly load data',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.66),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          _statusTile(
            icon: Icons.auto_graph_outlined,
            title: 'Load Status',
            value: intelligence.loadLabel,
            positive: intelligence.loadLevel != BlueraLoadLevel.high,
          ),
          const SizedBox(height: 12),
          _statusTile(
            icon: Icons.local_fire_department_outlined,
            title: 'Fatigue',
            value: intelligence.recoveryLabel,
            positive: intelligence.recoveryState == BlueraRecoveryState.good,
          ),
          const SizedBox(height: 12),
          _statusTile(
            icon: Icons.wb_sunny_outlined,
            title: 'Form',
            value: data.formStatus,
            positive: data.form >= 0,
          ),
          const SizedBox(height: 12),
          _statusTile(
            icon: Icons.monitor_heart_outlined,
            title: 'HR Drift',
            value: '${data.hrDrift.toStringAsFixed(1)}%',
            positive: data.hrDrift <= 5.0,
          ),
        ],
      ),
    );
  }

  Widget _statusTile({
    required IconData icon,
    required String title,
    required String value,
    required bool positive,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.accent.withOpacity(0.08)
            : AppTheme.background.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: positive
              ? AppTheme.accent.withOpacity(0.20)
              : AppTheme.textPrimary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: positive
                  ? AppTheme.accent.withOpacity(0.14)
                  : AppTheme.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: positive ? AppTheme.accent : AppTheme.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: positive ? AppTheme.accent : AppTheme.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
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
            'Smart Recommendations',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Shared coaching outputs from the load intelligence layer',
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
