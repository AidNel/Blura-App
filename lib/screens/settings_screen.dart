import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _workoutReminders = true;
  bool _recoveryAlerts = true;
  bool _weeklySummary = true;

  String _selectedAvatar = 'A';
  String _trainingGoal = 'Endurance';
  String _experienceLevel = 'Intermediate';

  final List<String> _avatars = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> _trainingGoals = [
    'Endurance',
    'Race Prep',
    'Durability',
    'Weight Loss',
    'General Fitness',
  ];
  final List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Elite',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsService.instance,
      builder: (context, settings, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildHeader(),
                                  const SizedBox(height: 16),
                                  _buildAppearanceCard(settings),
                                  const SizedBox(height: 16),
                                  _buildUnitsCard(settings),
                                  const SizedBox(height: 16),
                                  _buildProfileCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTrainingPreferencesCard(),
                                  const SizedBox(height: 16),
                                  _buildNotificationsCard(),
                                  const SizedBox(height: 16),
                                  _buildIntegrationsCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 16),
                            _buildAppearanceCard(settings),
                            const SizedBox(height: 16),
                            _buildUnitsCard(settings),
                            const SizedBox(height: 16),
                            _buildProfileCard(),
                            const SizedBox(height: 16),
                            _buildTrainingPreferencesCard(),
                            const SizedBox(height: 16),
                            _buildNotificationsCard(),
                            const SizedBox(height: 16),
                            _buildIntegrationsCard(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage appearance, units, profile, preferences, notifications and future integrations.',
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.70),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(AppSettingsData settings) {
    return _sectionCard(
      title: 'Appearance',
      subtitle: 'Choose how Bluera looks on your device.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _segmentedSelector<ThemeMode>(
            value: settings.themeMode,
            options: const {
              ThemeMode.system: 'System',
              ThemeMode.dark: 'Dark',
              ThemeMode.light: 'Light',
            },
            onChanged: (value) {
              AppSettingsService.instance.updateThemeMode(value);
            },
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.palette_outlined,
            title: 'Active preference',
            value: _themeLabel(settings.themeMode),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsCard(AppSettingsData settings) {
    return _sectionCard(
      title: 'Units',
      subtitle: 'Select how distance, speed and elevation are displayed.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _segmentedSelector<AppUnitSystem>(
            value: settings.unitSystem,
            options: const {
              AppUnitSystem.metric: 'Metric',
              AppUnitSystem.imperial: 'Imperial',
            },
            onChanged: (value) {
              AppSettingsService.instance.updateUnitSystem(value);
            },
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.straighten_outlined,
            title: 'Display format',
            value: settings.unitSystem == AppUnitSystem.metric
                ? 'km / m / kg'
                : 'mi / ft / lb',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return _sectionCard(
      title: 'Profile',
      subtitle: 'Avatar and athlete identity settings.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avatar',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _avatars.map((avatar) {
              final bool isSelected = _selectedAvatar == avatar;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accent.withOpacity(0.18)
                        : AppTheme.background,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accent
                          : AppTheme.textPrimary.withOpacity(0.10),
                      width: isSelected ? 1.6 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      avatar,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          _placeholderInput(
            label: 'Athlete name',
            value: 'Charles / Aiden',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _placeholderInput(
            label: 'Primary sport',
            value: 'Cycling',
            icon: Icons.directions_bike_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingPreferencesCard() {
    return _sectionCard(
      title: 'Training Preferences',
      subtitle:
          'Future-ready structure for coaching logic and workout planning.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dropdownCard(
            label: 'Main goal',
            value: _trainingGoal,
            options: _trainingGoals,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _trainingGoal = value;
              });
            },
            icon: Icons.flag_outlined,
          ),
          const SizedBox(height: 12),
          _dropdownCard(
            label: 'Experience level',
            value: _experienceLevel,
            options: _experienceLevels,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _experienceLevel = value;
              });
            },
            icon: Icons.trending_up_outlined,
          ),
          const SizedBox(height: 12),
          _toggleTile(
            icon: Icons.auto_graph_outlined,
            title: 'Smart recommendations',
            subtitle:
                'Allow Bluera to recommend workout intensity and recovery.',
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          _toggleTile(
            icon: Icons.pie_chart_outline,
            title: '80 / 20 load guidance',
            subtitle:
                'Keep weekly distribution aligned to endurance best practice.',
            value: true,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return _sectionCard(
      title: 'Notifications',
      subtitle: 'UI only for now. Ready for later backend connection.',
      child: Column(
        children: [
          _toggleTile(
            icon: Icons.notifications_active_outlined,
            title: 'Push notifications',
            subtitle: 'Enable app notifications.',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _toggleTile(
            icon: Icons.alarm_outlined,
            title: 'Workout reminders',
            subtitle: 'Reminders for scheduled sessions.',
            value: _workoutReminders,
            onChanged: (value) {
              setState(() {
                _workoutReminders = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _toggleTile(
            icon: Icons.favorite_border,
            title: 'Recovery alerts',
            subtitle: 'Notify when fatigue or freshness needs attention.',
            value: _recoveryAlerts,
            onChanged: (value) {
              setState(() {
                _recoveryAlerts = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _toggleTile(
            icon: Icons.calendar_view_week_outlined,
            title: 'Weekly summary',
            subtitle: 'Send a weekly training overview.',
            value: _weeklySummary,
            onChanged: (value) {
              setState(() {
                _weeklySummary = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationsCard() {
    return _sectionCard(
      title: 'Integrations',
      subtitle: 'Placeholder area for future syncing and data connections.',
      child: Column(
        children: [
          _integrationTile(
            icon: Icons.sync_outlined,
            title: 'Strava',
            subtitle: 'Connect activities and segment goals',
            status: 'Coming soon',
          ),
          const SizedBox(height: 12),
          _integrationTile(
            icon: Icons.watch_outlined,
            title: 'Garmin',
            subtitle: 'Sync workouts, HR and power data',
            status: 'Coming soon',
          ),
          const SizedBox(height: 12),
          _integrationTile(
            icon: Icons.directions_bike_outlined,
            title: 'TrainingPeaks',
            subtitle: 'Import workout structure and planning data',
            status: 'Coming soon',
          ),
          const SizedBox(height: 12),
          _integrationTile(
            icon: Icons.monitor_heart_outlined,
            title: 'Health platforms',
            subtitle: 'Future support for Apple Health and Google Fit',
            status: 'Planned',
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accent.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _segmentedSelector<T>({
    required T value,
    required Map<T, String> options,
    required ValueChanged<T> onChanged,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.entries.map((entry) {
        final bool isSelected = entry.key == value;
        return GestureDetector(
          onTap: () => onChanged(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.accent.withOpacity(0.16)
                  : AppTheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.accent
                    : AppTheme.textPrimary.withOpacity(0.10),
                width: isSelected ? 1.4 : 1,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.68),
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(
            value: value,
            activeColor: AppTheme.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _integrationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.68),
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownCard({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
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
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                dropdownColor: AppTheme.card,
                iconEnabledColor: AppTheme.textPrimary,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                items: options
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textPrimary.withOpacity(0.58),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderInput({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textPrimary.withOpacity(0.58),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit_outlined,
            color: AppTheme.textPrimary.withOpacity(0.45),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.textPrimary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 20),
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
              color: AppTheme.textPrimary.withOpacity(0.68),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'SYSTEM';
      case ThemeMode.dark:
        return 'DARK';
      case ThemeMode.light:
        return 'LIGHT';
    }
  }
}
