import 'package:flutter/material.dart';

import '../services/app_settings_service.dart';
import '../services/mock_athlete_data.dart';
import 'bike_detail_screen.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsService.instance;
    final athlete = BlueraMockDataService.athlete;

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        final theme = Theme.of(context);
        final _ = theme.colorScheme;
        final isMetric = _isMetric(settings);

        final totalDistanceKm = athlete.totalBikeDistanceKm;
        final totalElevationM = athlete.bikes.fold<int>(
          0,
          (sum, bike) => sum + bike.elevationM,
        );
        final totalRides = athlete.totalBikeRides;
        final totalBikes = athlete.bikes.length;
        final unlockedAchievements = athlete.unlockedAchievements;

        final everestEquivalent = totalElevationM / 8848.0;
        final capeEpicEquivalent = totalDistanceKm / 700.0;

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: _HeroCard(
                      totalBikes: totalBikes,
                      totalRides: totalRides,
                      unlockedAchievements: unlockedAchievements,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                  sliver: SliverGrid(
                    delegate: SliverChildListDelegate([
                      _StatCard(
                        title: 'Distance',
                        value: _formatDistance(totalDistanceKm, isMetric),
                        subtitle: 'Across all bikes',
                        icon: Icons.route_rounded,
                      ),
                      _StatCard(
                        title: 'Elevation',
                        value: _formatElevation(
                          totalElevationM.toDouble(),
                          isMetric,
                        ),
                        subtitle: 'Total climbed',
                        icon: Icons.terrain_rounded,
                      ),
                      _StatCard(
                        title: 'Total Rides',
                        value: '$totalRides',
                        subtitle: 'Completed sessions',
                        icon: Icons.repeat_rounded,
                      ),
                      _StatCard(
                        title: 'Engine Score',
                        value: '${athlete.engineScore}',
                        subtitle: 'Current athlete level',
                        icon: Icons.bolt_rounded,
                      ),
                    ]),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.94,
                        ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: _SectionCard(
                      title: 'Value of Your Engine',
                      subtitle:
                          'Turn accumulated work into meaning and perspective.',
                      child: Column(
                        children: [
                          _InsightRow(
                            icon: Icons.landscape_rounded,
                            title: 'Everest Equivalent',
                            value: '${everestEquivalent.toStringAsFixed(1)} x',
                            subtitle:
                                '${_formatElevation(totalElevationM.toDouble(), isMetric)} climbed in total',
                          ),
                          const SizedBox(height: 12),
                          _InsightRow(
                            icon: Icons.flag_rounded,
                            title: 'Cape Epic Equivalent',
                            value: '${capeEpicEquivalent.toStringAsFixed(1)} x',
                            subtitle:
                                '${_formatDistance(totalDistanceKm, isMetric)} completed across all bikes',
                          ),
                          const SizedBox(height: 12),
                          _NarrativeBox(
                            title: 'Blura insight',
                            message: everestEquivalent >= 1
                                ? 'Your accumulated climbing already reflects serious durability and a strong endurance base.'
                                : 'Your training is building a meaningful aerobic and climbing base that will compound over time.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: _SectionCard(
                      title: 'Bike Garage',
                      subtitle: 'Tap a bike to view detailed usage.',
                      child: Column(
                        children: [
                          for (int i = 0; i < athlete.bikes.length; i++) ...[
                            _BikeTile(
                              bike: athlete.bikes[i],
                              isMetric: isMetric,
                              totalDistanceKm: totalDistanceKm,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BikeDetailScreen(
                                      bike: athlete.bikes[i],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (i != athlete.bikes.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: _SectionCard(
                      title: 'Achievements',
                      subtitle: '$unlockedAchievements unlocked',
                      child: Column(
                        children: [
                          for (
                            int i = 0;
                            i < athlete.achievements.length;
                            i++
                          ) ...[
                            _AchievementTile(
                              achievement: athlete.achievements[i],
                            ),
                            if (i != athlete.achievements.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    child: _SectionCard(
                      title: 'Milestones',
                      subtitle: 'Progress markers in your journey.',
                      child: Column(
                        children: [
                          for (
                            int i = 0;
                            i < athlete.milestones.length;
                            i++
                          ) ...[
                            _MilestoneTile(milestone: athlete.milestones[i]),
                            if (i != athlete.milestones.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static bool _isMetric(dynamic settings) {
    try {
      final direct = settings.isMetric;
      if (direct is bool) return direct;
    } catch (_) {}

    try {
      final direct = settings.useMetric;
      if (direct is bool) return direct;
    } catch (_) {}

    return true;
  }

  static String _formatDistance(double km, bool isMetric) {
    final value = isMetric ? km : km * 0.621371;
    final unit = isMetric ? 'km' : 'mi';
    return '${value.toStringAsFixed(1)} $unit';
  }

  static String _formatElevation(double meters, bool isMetric) {
    final value = isMetric ? meters : meters * 3.28084;
    final unit = isMetric ? 'm' : 'ft';
    return '${value.toStringAsFixed(0)} $unit';
  }
}

class _HeroCard extends StatelessWidget {
  final int totalBikes;
  final int totalRides;
  final int unlockedAchievements;

  const _HeroCard({
    required this.totalBikes,
    required this.totalRides,
    required this.unlockedAchievements,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.16),
            colorScheme.secondary.withOpacity(0.08),
            colorScheme.surface,
          ],
        ),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Garage',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your bikes, milestones, achievements and riding history in one premium view.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.72),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroPill(
                  icon: Icons.directions_bike_rounded,
                  label: '$totalBikes bikes',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroPill(
                  icon: Icons.repeat_rounded,
                  label: '$totalRides rides',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroPill(
                  icon: Icons.emoji_events_rounded,
                  label: '$unlockedAchievements unlocked',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.68),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.68),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _InsightRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.68),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NarrativeBox extends StatelessWidget {
  final String title;
  final String message;

  const _NarrativeBox({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.72),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BikeTile extends StatelessWidget {
  final GarageBike bike;
  final bool isMetric;
  final double totalDistanceKm;
  final VoidCallback onTap;

  const _BikeTile({
    required this.bike,
    required this.isMetric,
    required this.totalDistanceKm,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final distance = GarageScreen._formatDistance(bike.distanceKm, isMetric);
    final elevation = GarageScreen._formatElevation(
      bike.elevationM.toDouble(),
      isMetric,
    );
    final contribution = totalDistanceKm <= 0
        ? 0.0
        : bike.distanceKm / totalDistanceKm;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bike.primaryBike
                ? colorScheme.primary.withOpacity(0.07)
                : colorScheme.surface.withOpacity(0.94),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colorScheme.outline.withOpacity(0.07)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.directions_bike_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                bike.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (bike.primaryBike)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Primary',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bike.type,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.68),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bike.notes,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.68),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _BikeMiniStat(label: 'Distance', value: distance),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BikeMiniStat(label: 'Elevation', value: elevation),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BikeMiniStat(
                      label: 'Rides',
                      value: '${bike.rides}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _BikeContributionBar(progress: contribution),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Garage contribution',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.68),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(contribution * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BikeMiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _BikeMiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.62),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BikeContributionBar extends StatelessWidget {
  final double progress;

  const _BikeContributionBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final clamped = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: clamped,
        minHeight: 8,
        backgroundColor: colorScheme.outline.withOpacity(0.12),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final GarageAchievement achievement;

  const _AchievementTile({required this.achievement});

  IconData _resolveIcon(IconDataData icon) {
    switch (icon) {
      case IconDataData.trophy:
        return Icons.emoji_events_rounded;
      case IconDataData.road:
        return Icons.route_rounded;
      case IconDataData.shield:
        return Icons.shield_rounded;
      case IconDataData.bolt:
        return Icons.bolt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: achievement.unlocked
            ? colorScheme.primary.withOpacity(0.08)
            : colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: achievement.unlocked
                  ? colorScheme.primary.withOpacity(0.12)
                  : colorScheme.outline.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _resolveIcon(achievement.icon),
              color: achievement.unlocked
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.62),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.68),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            achievement.value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: achievement.unlocked
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.68),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  final GarageMilestone milestone;

  const _MilestoneTile({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: milestone.completed
            ? colorScheme.primary.withOpacity(0.07)
            : colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            milestone.completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: milestone.completed
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.62),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.68),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            milestone.dateLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.withOpacity(0.68),
            ),
          ),
        ],
      ),
    );
  }
}
