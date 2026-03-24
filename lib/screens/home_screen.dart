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
                      isDesktop
                          ? _buildDesktopHero(data, intelligence, settings)
                          : _buildMobileHero(
                              data: data,
                              intelligence: intelligence,
                              settings: settings,
                              isTablet: isTablet,
                              isMobile: isMobile,
                            ),
                      const SizedBox(height: 14),
                      _buildSupportingCards(
                        data: data,
                        intelligence: intelligence,
                        isDesktop: isDesktop,
                        isTablet: isTablet,
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
                  color: AppTheme.textPrimary.withOpacity(0.68),
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

  Widget _buildDesktopHero(
    MockAthleteData data,
    BlueraLoadAssessment intelligence,
    AppSettingsData settings,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.accent.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(
                  'BLURA',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                EngineRing(score: data.engineScore),
                const SizedBox(height: 14),
                Text(
                  'Train in the Blue.\nSimplify Training.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.72),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _engineLabel(data.engineScore),
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppSettingsService.distanceLabel(
                    data.weeklyDistanceKm,
                    settings.unitSystem,
                    decimals: 0,
                  ),
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.70),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(flex: 6, child: _buildHeroContent(intelligence, data.engineScore)),
        ],
      ),
    );
  }

  Widget _buildMobileHero({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
    required AppSettingsData settings,
    required bool isTablet,
    required bool isMobile,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppTheme.accent.withOpacity(0.10)),
      ),
      child: Column(
        children: [
          Text(
            'BLURA',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: isMobile ? 13 : 14,
              letterSpacing: isMobile ? 2.8 : 3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          EngineRing(score: data.engineScore),
          const SizedBox(height: 12),
          Text(
            'Train in the Blue.\nSimplify Training.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.72),
              fontSize: isMobile ? 12.5 : 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _engineLabel(data.engineScore),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Week: ${AppSettingsService.shortDistanceLabel(data.weeklyDistanceKm, settings.unitSystem)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.58),
                    fontSize: 11.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _statusPill(
            'Load: ${intelligence.loadLabel}',
            intelligence.loadLevel != BlueraLoadLevel.high,
          ),
          const SizedBox(height: 10),
          _statusPill(
            '80 / 20 balance: ${intelligence.zoneLabel}',
            intelligence.zoneState == BlueraZoneState.onTarget,
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

  Widget _buildHeroContent(BlueraLoadAssessment intelligence, int engineScore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Engine $engineScore',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          intelligence.engineDescription,
          style: TextStyle(
            color: AppTheme.textPrimary.withOpacity(0.70),
            fontSize: 14,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        _statusPill(
          'Load: ${intelligence.loadLabel}',
          intelligence.loadLevel != BlueraLoadLevel.high,
        ),
        const SizedBox(height: 10),
        _statusPill(
          '80 / 20 balance: ${intelligence.zoneLabel}',
          intelligence.zoneState == BlueraZoneState.onTarget,
        ),
        const SizedBox(height: 10),
        _statusPill(
          'Recovery: ${intelligence.recoveryLabel}',
          intelligence.recoveryState == BlueraRecoveryState.good,
        ),
      ],
    );
  }

  Widget _buildSupportingCards({
    required MockAthleteData data,
    required BlueraLoadAssessment intelligence,
    required bool isDesktop,
    required bool isTablet,
  }) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: isDesktop
          ? 1.55
          : isTablet
          ? 1.45
          : 1.35,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: AppTheme.accent),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.textPrimary.withOpacity(0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.60),
              fontSize: 11.5,
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
              color: AppTheme.textPrimary.withOpacity(0.70),
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
                    color: AppTheme.textPrimary.withOpacity(0.68),
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

  String _engineLabel(int score) {
    if (score >= 80) return 'Elite';
    if (score >= 70) return 'Strong';
    if (score >= 60) return 'Building';
    return 'Developing';
  }
}
