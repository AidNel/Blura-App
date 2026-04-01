import 'package:flutter/material.dart';

import '../services/app_settings_service.dart';
import '../services/load_intelligence.dart';
import '../services/mock_athlete_data.dart';
import '../theme/app_theme.dart';
import '../widgets/engine_ring.dart';
import 'analytics_screen.dart';
import 'calendar_screen.dart';
import 'garage_screen.dart';
import 'settings_screen.dart';
import 'workout_analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get _screens => [
    const _DashboardTab(),
    const CalendarScreen(),
    const WorkoutAnalysisScreen(),
    const AnalyticsScreen(),
    const GarageScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(index: selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          border: Border(top: BorderSide(color: AppTheme.textPrimary.withOpacity(0.08))),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onTabSelected,
            backgroundColor: AppTheme.card,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: AppTheme.accent,
            unselectedItemColor: AppTheme.textPrimary.withOpacity(0.55),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.insights_outlined), activeIcon: Icon(Icons.insights), label: 'Analysis'),
              BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined), activeIcon: Icon(Icons.show_chart), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_outlined), activeIcon: Icon(Icons.workspace_premium), label: 'Garage'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final data = BlueraMockDataService.athlete;
    final intelligence = BlueraLoadIntelligence.assess(data);
    final isMobile = MediaQuery.of(context).size.width < 700;

    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsService.instance,
      builder: (context, settings, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(isMobile ? 14 : 20, 14, isMobile ? 14 : 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(isMobile),
                  const SizedBox(height: 14),
                  _heroRecommendationCard(data, intelligence, settings, isMobile),
                  const SizedBox(height: 12),
                  _keySignals(intelligence, data, isMobile),
                  const SizedBox(height: 12),
                  _secondaryInsight(intelligence),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BLURA',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: isMobile ? 30 : 34,
            letterSpacing: 2.8,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Today at a glance',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: isMobile ? 13 : 14,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _heroRecommendationCard(
    MockAthleteData data,
    BlueraLoadAssessment intelligence,
    AppSettingsData settings,
    bool isMobile,
  ) {
    final int engineScore = intelligence.engineScore;
    final BlueraEngineState engineState = intelligence.engineState;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accent.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s recommendation',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            intelligence.recommendationTitle,
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: isMobile ? 20 : 22),
          ),
          const SizedBox(height: 8),
          Text(
            intelligence.recommendationDetail,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13.5, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Engine state',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$engineScore · ${intelligence.engineDescription}',
                      style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w700, height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    _chip(AppSettingsService.shortDistanceLabel(data.weeklyDistanceKm, settings.unitSystem)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: EngineRing(score: engineScore, state: engineState),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keySignals(BlueraLoadAssessment intelligence, MockAthleteData data, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key signals', style: TextStyle(color: AppTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _signalCard('Recovery', '${intelligence.recoveryScore}/100', intelligence.recoveryLabel),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _signalCard('Fatigue', '${intelligence.fatigueScore}/100', intelligence.loadLabel),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 8),
              Expanded(
                child: _signalCard('Blue balance', '${intelligence.blueBalanceScore}/100', intelligence.zoneLabel),
              ),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 8),
          _signalCard('Blue balance', '${intelligence.blueBalanceScore}/100', '${intelligence.zoneLabel} · ${data.snapshot.zones.bluePercent.toStringAsFixed(0)}% blue'),
        ],
      ],
    );
  }

  Widget _secondaryInsight(BlueraLoadAssessment intelligence) {
    final insight = intelligence.quickInsights.isNotEmpty ? intelligence.quickInsights.first : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly focus', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          Text(
            insight?.title ?? 'Stay consistent in your blue sessions.',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            insight?.message ?? intelligence.engineDescription,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _signalCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.1)),
      ),
      child: Text(text, style: TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
