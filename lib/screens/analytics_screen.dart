import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_athlete_data.dart';
import '../services/load_intelligence.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = BlueraMockDataService.athlete;
    final durability = BlueraLoadIntelligence.assessDurability(data);
    final bool isMobile = MediaQuery.of(context).size.width < 700;

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
              constraints: const BoxConstraints(maxWidth: 980),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 16),
                  _buildDurabilityScoreCard(durability),
                  const SizedBox(height: 16),
                  _buildCoreInsightsCard(durability),
                  const SizedBox(height: 16),
                  _buildSupportMetricsCard(durability),
                  const SizedBox(height: 16),
                  _buildCoachingCard(durability),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
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
            'Durability Analytics',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 27 : 31,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Interpretation-first endurance durability from your latest mock workout.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.7),
              fontSize: isMobile ? 13.5 : 14,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurabilityScoreCard(BlueraDurabilityAssessment durability) {
    final bool positive = durability.state != BlueraDurabilityState.fading;

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
                child: Text(
                  'Durability Score',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _chip(
                text: durability.stateLabel,
                positive: positive,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${durability.score}',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              Text(
                '/100',
                style: TextStyle(
                  color: AppTheme.textPrimary.withOpacity(0.55),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: durability.score / 100,
              minHeight: 10,
              backgroundColor: AppTheme.textPrimary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                positive ? AppTheme.accent : Colors.orange.shade300,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            durability.stabilitySummary,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.8),
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreInsightsCard(BlueraDurabilityAssessment durability) {
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
            'Core Insights',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _insightTile(
            title: 'HR drift / decoupling',
            value: '${durability.hrDriftPercent.toStringAsFixed(1)}%',
            message: durability.hrDriftInsight,
            positive: durability.hrDriftPercent <= 5.5,
          ),
          const SizedBox(height: 10),
          _insightTile(
            title: 'Late-session fade',
            value: '${durability.lateSessionPowerDropPercent.toStringAsFixed(1)}%',
            message: durability.lateFadeInsight,
            positive: durability.lateSessionPowerDropPercent <= 7,
          ),
          const SizedBox(height: 10),
          _insightTile(
            title: 'Aerobic control',
            value: '${durability.aerobicControlPercent.toStringAsFixed(0)}%',
            message: durability.aerobicControlInsight,
            positive: durability.aerobicControlPercent >= 76,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportMetricsCard(BlueraDurabilityAssessment durability) {
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
            'Supporting Metrics',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _metricRow('First-half HR', '${durability.firstHalfHeartRate} bpm'),
          _metricRow('Second-half HR', '${durability.secondHalfHeartRate} bpm'),
          _metricRow('First-half power', '${durability.firstHalfPower} W'),
          _metricRow('Second-half power', '${durability.secondHalfPower} W'),
          _metricRow('Endurance stability', durability.stabilitySummary),
        ],
      ),
    );
  }

  Widget _buildCoachingCard(BlueraDurabilityAssessment durability) {
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
            'Coaching Recommendation',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            durability.coachingRecommendation,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.82),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({required String text, required bool positive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.accent.withOpacity(0.14)
            : Colors.orange.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: positive ? AppTheme.accent : Colors.orange.shade300,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _insightTile({
    required String title,
    required String value,
    required String message,
    required bool positive,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: positive ? AppTheme.accent : Colors.orange.shade300,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.72),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary.withOpacity(0.66),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
