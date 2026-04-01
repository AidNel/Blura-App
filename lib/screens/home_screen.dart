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
          border:
              Border(top: BorderSide(color: AppTheme.textPrimary.withOpacity(0.08))),
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  activeIcon: Icon(Icons.calendar_month),
                  label: 'Calendar'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.insights_outlined),
                  activeIcon: Icon(Icons.insights),
                  label: 'Analysis'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart_outlined),
                  activeIcon: Icon(Icons.show_chart),
                  label: 'Analytics'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium_outlined),
                  activeIcon: Icon(Icons.workspace_premium),
                  label: 'Garage'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings'),
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
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 20,
                14,
                isMobile ? 14 : 20,
                28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(isMobile),
                  const SizedBox(height: 14),
                  _heroRecommendationCard(data, intelligence, settings, isMobile),
                  const SizedBox(height: 14),
                  _keySignals(intelligence, data, isMobile),
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
          'Your next best decision',
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

    final List<String> tags = [
      'Recovery ${intelligence.recoveryLabel}',
      'Blue ${intelligence.zoneLabel}',
      'Load ${intelligence.loadLabel}',
      AppSettingsService.shortDistanceLabel(data.weeklyDistanceKm, settings.unitSystem),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 22, 18, isMobile ? 16 : 22, 18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accent.withOpacity(0.24)),
      ),
      child: Column(
        children: [
          EngineRing(score: engineScore, state: engineState),
          const SizedBox(height: 16),
          Text(
            intelligence.recommendationTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 23 : 25,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            intelligence.recommendationDetail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: isMobile ? 13.5 : 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => _chip(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _keySignals(
    BlueraLoadAssessment intelligence,
    MockAthleteData data,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supporting signals',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _signalCard(
                'Recovery',
                '${intelligence.recoveryScore}/100',
                intelligence.recoveryLabel,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _signalCard(
                'Fatigue',
                '${intelligence.fatigueScore}/100',
                intelligence.loadLabel,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _signalCard(
                'Blue balance',
                '${intelligence.blueBalanceScore}/100',
                isMobile
                    ? '${data.snapshot.zones.bluePercent.toStringAsFixed(0)}% blue'
                    : intelligence.zoneLabel,
              ),
            ),
          ],
        ),
      ],
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
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.10)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
