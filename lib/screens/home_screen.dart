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
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insights_outlined),
                activeIcon: Icon(Icons.insights),
                label: 'Analysis',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_outlined),
                activeIcon: Icon(Icons.show_chart),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium_outlined),
                activeIcon: Icon(Icons.workspace_premium),
                label: 'Garage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
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
              padding: EdgeInsets.fromLTRB(isMobile ? 14 : 22, 12, isMobile ? 14 : 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _heroSection(data, intelligence, settings, isMobile),
                  const SizedBox(height: 20),
                  _recentActivitiesSection(settings, isMobile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _heroSection(
    MockAthleteData data,
    BlueraLoadAssessment intelligence,
    AppSettingsData settings,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111827), Color(0xFF0A101D)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80FF).withOpacity(0.14),
            blurRadius: 38,
            spreadRadius: 3,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 18, isMobile ? 16 : 24, 20),
      child: Column(
        children: [
          Text(
            'BLURA',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 30 : 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ENDURANCE READINESS',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.55),
              fontSize: isMobile ? 11 : 12,
              letterSpacing: 2.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          EngineRing(
            score: intelligence.engineScore,
            state: intelligence.engineState,
            innerProgress: intelligence.engineScore / 100,
            middleProgress: intelligence.fatigueScore / 100,
            outerProgress: intelligence.recoveryScore / 100,
            centerChild: _ringCenterAvatar(intelligence.engineScore, isMobile),
          ),
          const SizedBox(height: 14),
          Text(
            intelligence.recommendationTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 22 : 25,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            intelligence.recommendationDetail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: isMobile ? 13 : 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _heroChip('Engine ${intelligence.engineScore}'),
              _heroChip('Fatigue ${intelligence.fatigueScore}'),
              _heroChip('Durability ${intelligence.recoveryScore}'),
              _heroChip(AppSettingsService.shortDistanceLabel(data.weeklyDistanceKm, settings.unitSystem)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ringCenterAvatar(int engineScore, bool isMobile) {
    final double avatarSize = isMobile ? 104 : 116;

    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.20), width: 1.4),
              color: const Color(0xFF121A2B),
            ),
            child: Icon(Icons.person, size: isMobile ? 50 : 56, color: Colors.white.withOpacity(0.86)),
          ),
          Positioned(
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: const Color(0xFF0C1321),
                border: Border.all(color: const Color(0xFF2F80FF).withOpacity(0.8)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F80FF).withOpacity(0.32),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'ENGINE $engineScore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 10.5 : 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
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

  Widget _recentActivitiesSection(AppSettingsData settings, bool isMobile) {
    final activities = _mockActivities(settings);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 20 : 22,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Imported sessions and readiness impact',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...activities.map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _activityCard(activity),
            )),
      ],
    );
  }

  Widget _activityCard(_ActivitySummary activity) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  activity.name,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              _pill(activity.recency, const Color(0xFF1B2A43)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            activity.dateLabel,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metric('Duration', activity.duration),
              _metric('Distance', activity.distance),
              _metric('Avg Speed', activity.avgSpeed),
              _metric('Avg HR', activity.avgHeartRate),
              _metric('Power', activity.power),
              _metric('TSS', activity.tss),
              _metric('Durability', activity.durability),
              _metric('Zones', activity.zoneSummary),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0C1321),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2F80FF).withOpacity(0.35)),
            ),
            child: Text(
              activity.insight,
              style: TextStyle(color: AppTheme.textPrimary.withOpacity(0.94), fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 11.5, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  List<_ActivitySummary> _mockActivities(AppSettingsData settings) {
    final data = BlueraMockDataService.athlete;
    final distanceLabel = AppSettingsService.shortDistanceLabel(data.weeklyDistanceKm, settings.unitSystem);

    return [
      _ActivitySummary(
        name: 'Threshold Build Ride',
        recency: 'Today',
        dateLabel: 'Apr 1 • Imported from Strava',
        duration: '1h 28m',
        distance: '42.7 km',
        avgSpeed: '29.1 km/h',
        avgHeartRate: '148 bpm',
        power: '224 W',
        tss: '88',
        durability: '81/100',
        zoneSummary: 'Z2 48m • Z3 26m • Z4 11m',
        insight: 'Strong aerobic base with controlled threshold exposure. Engine trending positive for tomorrow.',
      ),
      _ActivitySummary(
        name: 'Endurance Maintenance',
        recency: 'Yesterday',
        dateLabel: 'Mar 31 • Imported from Strava',
        duration: '54m',
        distance: '26.2 km',
        avgSpeed: '28.7 km/h',
        avgHeartRate: '137 bpm',
        power: '192 W',
        tss: '49',
        durability: '76/100',
        zoneSummary: 'Z2 41m • Z3 8m',
        insight: 'Efficient low-stress ride that preserved freshness while maintaining load consistency.',
      ),
      _ActivitySummary(
        name: 'Long Ride Progression',
        recency: '2 days ago',
        dateLabel: 'Mar 30 • Imported from Strava',
        duration: '2h 42m',
        distance: distanceLabel,
        avgSpeed: '27.5 km/h',
        avgHeartRate: '141 bpm',
        power: '205 W',
        tss: '134',
        durability: '84/100',
        zoneSummary: 'Z2 1h 56m • Z3 32m • Z4 14m',
        insight: 'High durability stimulus. Keep tomorrow easy to absorb the long-session strain.',
      ),
    ];
  }
}

class _ActivitySummary {
  final String name;
  final String recency;
  final String dateLabel;
  final String duration;
  final String distance;
  final String avgSpeed;
  final String avgHeartRate;
  final String power;
  final String tss;
  final String durability;
  final String zoneSummary;
  final String insight;

  const _ActivitySummary({
    required this.name,
    required this.recency,
    required this.dateLabel,
    required this.duration,
    required this.distance,
    required this.avgSpeed,
    required this.avgHeartRate,
    required this.power,
    required this.tss,
    required this.durability,
    required this.zoneSummary,
    required this.insight,
  });
}
