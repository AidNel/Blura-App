import 'package:flutter/material.dart';
import '../services/app_settings_service.dart';
import '../services/load_intelligence.dart';
import '../services/mock_athlete_data.dart';
import '../theme/app_theme.dart';

class WorkoutAnalysisScreen extends StatelessWidget {
  const WorkoutAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final athlete = BlueraMockDataService.athlete;
    final workout = athlete.latestWorkout;
    final intelligence = BlueraLoadIntelligence.assess(athlete);
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 920;

    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsService.instance,
      builder: (context, settings, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 26),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerCard(workout: workout, settings: settings),
                      const SizedBox(height: 14),
                      _metricsGrid(workout: workout, settings: settings),
                      const SizedBox(height: 14),
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _zoneCard(workout: workout)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _insightCard(
                                    workout: workout,
                                    intelligence: intelligence,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _zoneCard(workout: workout),
                                const SizedBox(height: 14),
                                _insightCard(
                                  workout: workout,
                                  intelligence: intelligence,
                                ),
                              ],
                            ),
                      const SizedBox(height: 14),
                      _recommendationCard(workout: workout),
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

  Widget _headerCard({
    required MockWorkoutAnalysis workout,
    required AppSettingsData settings,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.workoutType,
            style: TextStyle(
              color: AppTheme.accent,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            workout.workoutTitle,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${workout.dateLabel} • ${workout.durationLabel} • '
            '${AppSettingsService.distanceLabel(workout.distanceKm, settings.unitSystem)}',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 13.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricsGrid({
    required MockWorkoutAnalysis workout,
    required AppSettingsData settings,
  }) {
    final items = <_MetricItem>[
      _MetricItem('Duration', workout.durationLabel),
      _MetricItem('Distance', AppSettingsService.distanceLabel(workout.distanceKm, settings.unitSystem)),
      _MetricItem('Elevation', AppSettingsService.elevationLabel(workout.elevationM, settings.unitSystem)),
      _MetricItem('Avg Heart Rate', '${workout.avgHeartRate} bpm'),
      _MetricItem('Avg Power', '${workout.avgPower} W'),
      _MetricItem('Blue Time', '${workout.blueTimePercent.toStringAsFixed(0)}%'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.0,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: TextStyle(
                  color: AppTheme.textPrimary.withOpacity(0.66),
                  fontSize: 12.2,
                ),
              ),
              const Spacer(),
              Text(
                item.value,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _zoneCard({required MockWorkoutAnalysis workout}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
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
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 16,
              child: Row(
                children: [
                  _zoneBar(workout.z1Percent, AppTheme.accent.withOpacity(0.35)),
                  _zoneBar(workout.z2Percent, AppTheme.accent),
                  _zoneBar(workout.z3Percent, AppTheme.textPrimary.withOpacity(0.30)),
                  _zoneBar(workout.z4Percent, AppTheme.textPrimary.withOpacity(0.20)),
                  _zoneBar(workout.z5Percent, AppTheme.textPrimary.withOpacity(0.12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _line('Z1', '${workout.z1Percent.toStringAsFixed(0)}%'),
          _line('Z2', '${workout.z2Percent.toStringAsFixed(0)}%'),
          _line('Z3', '${workout.z3Percent.toStringAsFixed(0)}%'),
          _line('Z4', '${workout.z4Percent.toStringAsFixed(0)}%'),
          _line('Z5', '${workout.z5Percent.toStringAsFixed(0)}%'),
        ],
      ),
    );
  }

  Widget _insightCard({
    required MockWorkoutAnalysis workout,
    required BlueraLoadAssessment intelligence,
  }) {
    final insightRows = [
      _InsightRow('Durability', workout.durabilityInsight, workout.durabilityScore >= 70),
      _InsightRow(
        'Drift',
        workout.hrDrift <= 5.5
            ? 'Blue session executed well'
            : 'Too much drift for a controlled endurance session',
        workout.hrDrift <= 5.5,
      ),
      _InsightRow(
        'Recovery Load',
        workout.recoveryCost <= 65 ? 'Suitable recovery load' : 'Recovery cost elevated',
        workout.recoveryCost <= 65,
      ),
      _InsightRow('Coach Signal', intelligence.todayFocus, true),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blura Interpretation',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...insightRows.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.positive ? AppTheme.accent.withOpacity(0.09) : AppTheme.background.withOpacity(0.55),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: item.positive ? AppTheme.accent.withOpacity(0.25) : AppTheme.textPrimary.withOpacity(0.08),
                ),
              ),
              child: _line(item.title, item.message),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard({required MockWorkoutAnalysis workout}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Recommendation',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            workout.recommendationText,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.7),
              fontSize: 13.2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.72),
              fontSize: 12.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _zoneBar(double percent, Color color) {
    return Expanded(
      flex: percent.round().clamp(1, 100),
      child: Container(color: color),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppTheme.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;

  const _MetricItem(this.label, this.value);
}

class _InsightRow {
  final String title;
  final String message;
  final bool positive;

  const _InsightRow(this.title, this.message, this.positive);
}
