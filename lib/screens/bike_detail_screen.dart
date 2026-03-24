import 'package:flutter/material.dart';

import '../services/app_settings_service.dart';
import '../services/mock_athlete_data.dart';

class BikeDetailScreen extends StatelessWidget {
  final GarageBike bike;

  const BikeDetailScreen({super.key, required this.bike});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsService.instance;

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isMetric = _isMetric(settings);

        final distanceLabel = _formatDistance(bike.distanceKm, isMetric);
        final elevationLabel = _formatElevation(
          bike.elevationM.toDouble(),
          isMetric,
        );

        final avgDistancePerRideKm = bike.rides == 0
            ? 0.0
            : bike.distanceKm / bike.rides;
        final avgClimbPerRideM = bike.rides == 0
            ? 0.0
            : bike.elevationM / bike.rides;

        final avgDistanceLabel = _formatDistance(
          avgDistancePerRideKm,
          isMetric,
        );
        final avgClimbLabel = _formatElevation(avgClimbPerRideM, isMetric);

        return Scaffold(
          appBar: AppBar(title: const Text('Bike Detail')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              children: [
                Container(
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
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(18),
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
                                Text(
                                  bike.name,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  bike.type,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (bike.primaryBike)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
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
                      const SizedBox(height: 16),
                      Text(
                        bike.notes,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionCard(
                  title: 'Usage Overview',
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.08,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _MetricCard(
                        title: 'Distance',
                        value: distanceLabel,
                        subtitle: 'Total ridden',
                        icon: Icons.route_rounded,
                      ),
                      _MetricCard(
                        title: 'Elevation',
                        value: elevationLabel,
                        subtitle: 'Total climbed',
                        icon: Icons.terrain_rounded,
                      ),
                      _MetricCard(
                        title: 'Rides',
                        value: '${bike.rides}',
                        subtitle: 'Completed sessions',
                        icon: Icons.repeat_rounded,
                      ),
                      _MetricCard(
                        title: 'Role',
                        value: bike.primaryBike ? 'Primary' : 'Support',
                        subtitle: 'Training importance',
                        icon: Icons.flag_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionCard(
                  title: 'Efficiency Per Ride',
                  child: Column(
                    children: [
                      _InsightRow(
                        icon: Icons.straighten_rounded,
                        title: 'Average distance per ride',
                        value: avgDistanceLabel,
                        subtitle: 'Distance ÷ rides',
                      ),
                      const SizedBox(height: 12),
                      _InsightRow(
                        icon: Icons.landscape_rounded,
                        title: 'Average climbing per ride',
                        value: avgClimbLabel,
                        subtitle: 'Elevation ÷ rides',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionCard(
                  title: 'Blura Interpretation',
                  child: Column(
                    children: [
                      _NarrativeTile(
                        title: 'Training role',
                        message: bike.primaryBike
                            ? 'This bike is currently the main engine-builder in your setup and carries the largest share of your riding history.'
                            : 'This bike supports your broader training ecosystem and adds depth, flexibility, and backup value.',
                      ),
                      const SizedBox(height: 12),
                      _NarrativeTile(
                        title: 'Best use case',
                        message: _bestUseCase(bike),
                      ),
                      const SizedBox(height: 12),
                      _NarrativeTile(
                        title: 'Durability value',
                        message:
                            'Consistent usage on this bike contributes to long-term durability through accumulated distance, elevation, and repeat exposure to load.',
                      ),
                    ],
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

    try {
      final unitSystem = settings.unitSystem.toString().toLowerCase();
      if (unitSystem.contains('imperial')) return false;
      if (unitSystem.contains('metric')) return true;
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

  static String _bestUseCase(GarageBike bike) {
    final type = bike.type.toLowerCase();

    if (type.contains('gravel')) {
      return 'Strong choice for endurance, mixed terrain, resilience, and longer engine-building rides.';
    }
    if (type.contains('road')) {
      return 'Best suited to aerobic volume, tempo work, and controlled endurance sessions.';
    }

    return 'A versatile asset in the garage that adds useful range to your training options.';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

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
            blurRadius: 18,
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _MetricCard({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
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
        color: colorScheme.surfaceVariant.withOpacity(0.30),
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
                    color: colorScheme.onSurfaceVariant,
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

class _NarrativeTile extends StatelessWidget {
  final String title;
  final String message;

  const _NarrativeTile({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.30),
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
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
