import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/engine_ring.dart';
import '../services/mock_athlete_data.dart';
import '../services/load_intelligence.dart';
import '../services/app_settings_service.dart';
import 'calendar_screen.dart';
import 'workout_analysis_screen.dart';
import 'analytics_screen.dart';
import 'garage_screen.dart';
import 'settings_screen.dart';

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
          border: Border(
            top: BorderSide(color: AppTheme.textPrimary.withOpacity(0.08)),
          ),
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
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
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
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 650 && width < 900;
    final bool isMobile = width < 650;
    final data = BlueraMockDataService.athlete;
    final intelligence = BlueraLoadIntelligence.assess(data);

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
                      _buildTopHeader(isMobile, settings),
                      const SizedBox(height: 16),
                      _buildPremiumHero(
                        data: data,
                        intelligence: intelligence,
                        settings: settings,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 12),
                      _buildSupportingCards(
                        data: data,
                        intelligence: intelligence,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
                        isMobile: isMobile,
                      ),
                      const SizedBox(height: 16),
                      _buildFocusCard(intelligence),
                      const SizedBox(height: 16),
                      _buildQuickInsights(
                        intelligence: intelligence,
                        isMobile: isMobile,
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

  Widget _buildTopHeader(bool isMobile, AppSettingsData settings) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bluera',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: isMobile ? 28 : 32,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppSettingsService.isMetric(settings.unitSystem)
                    ? 'Train smarter. Build durability. Manage load.'
                    : 'Train smarter. Build durability. Manage load.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: isMobile ? 13.5 : 14.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: isMobile ? 46 : 52,
          height: isMobile ? 46 : 52,
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppTheme.textPrimary,
            size: isMobile ? 22 : 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumHero({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
    required AppSettingsData settings,
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    final double padding = isMobile ? 16 : 22;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 30),
        border: Border.all(color: AppTheme.accent.withOpacity(0.18)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accent.withOpacity(0.14),
            AppTheme.card,
            AppTheme.card,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: -10,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'BLURA',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 13 : 15,
              letterSpacing: isMobile ? 3 : 3.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 14),
          EngineRing(score: data.engineScore),
          SizedBox(height: isMobile ? 12 : 14),
          Text(
            'Train in the Blue.\nSimplify Training.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: isMobile ? 12.5 : 13.5,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip(
                icon: Icons.workspace_premium_outlined,
                label: _engineLabel(data.engineScore),
              ),
              _heroChip(
                icon: Icons.route_outlined,
                label: AppSettingsService.shortDistanceLabel(
                  data.weeklyDistanceKm,
                  settings.unitSystem,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 14),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 560 : 520),
            child: Column(
              children: [
                _statusPill(
                  'Load: ${intelligence.loadLabel}',
                  intelligence.loadLevel != BlueraLoadLevel.high,
                ),
                const SizedBox(height: 8),
                _statusPill(
                  '80 / 20 balance: ${intelligence.zoneLabel}',
                  intelligence.zoneState == BlueraZoneState.onTarget,
                ),
                const SizedBox(height: 8),
                _statusPill(
                  'Recovery: ${intelligence.recoveryLabel}',
                  intelligence.recoveryState == BlueraRecoveryState.good,
                ),
              ],
            ),
          ),
          if (!isMobile && isTablet) const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _heroChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.accent.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportingCards({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 9,
      mainAxisSpacing: 9,
      childAspectRatio: isDesktop
          ? 1.8
          : isTablet
          ? 1.65
          : isMobile
          ? 1.55
          : 1.6,
      children: [
        _supportingMetricCard(
          title: 'Durability',
          value: '${data.fitness}',
          subtitle: 'Built from consistent aerobic work',
          icon: Icons.shield_outlined,
        ),
        _supportingMetricCard(
          title: 'Fatigue',
          value: '${data.fatigue}',
          subtitle: intelligence.loadLabel,
          icon: Icons.bolt_outlined,
        ),
        _supportingMetricCard(
          title: 'Blue Time',
          value: intelligence.zoneLabel,
          subtitle: '80 / 20 balance alignment',
          icon: Icons.water_drop_outlined,
        ),
        _supportingMetricCard(
          title: 'Recovery',
          value: intelligence.recoveryLabel,
          subtitle: 'Readiness for upcoming sessions',
          icon: Icons.nightlight_outlined,
        ),
      ],
    );
  }

  Widget _supportingMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: AppTheme.accent),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11.2,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusCard(BlueraLoadAssessment intelligence) {
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
            'Today\'s Focus',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            intelligence.todayFocus,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInsights({
    required BlueraLoadAssessment intelligence,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Insights',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...intelligence.quickInsights.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _insightCard(
              icon: item.positive
                  ? Icons.trending_up_rounded
                  : Icons.info_outline_rounded,
              title: item.title,
              subtitle: item.message,
            ),
          ),
        ),
      ],
    );
  }

  Widget _insightCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
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

  Widget _statusPill(String text, bool positive) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.accent.withOpacity(0.11)
            : AppTheme.background.withOpacity(0.50),
        borderRadius: BorderRadius.circular(14),
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
            size: 17,
          ),
          const SizedBox(width: 9),
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

  String _engineLabel(int score) {
    if (score >= 80) return 'Elite';
    if (score >= 70) return 'Strong';
    if (score >= 60) return 'Building';
    return 'Developing';
  }
}
