import 'mock_athlete_data.dart';

enum BlueraLoadLevel { low, balanced, build, high }

enum BlueraRecoveryState { good, monitor, recoveryNeeded }

enum BlueraZoneState { onTarget, slightlyHigh, needsAdjustment }

class BlueraInsight {
  final String title;
  final String message;
  final bool positive;

  const BlueraInsight({
    required this.title,
    required this.message,
    required this.positive,
  });
}

class BlueraLoadAssessment {
  final BlueraLoadLevel loadLevel;
  final BlueraRecoveryState recoveryState;
  final BlueraZoneState zoneState;
  final String loadLabel;
  final String recoveryLabel;
  final String zoneLabel;
  final String todayFocus;
  final String engineDescription;
  final List<BlueraInsight> quickInsights;
  final List<AthleteRecommendation> recommendations;

  const BlueraLoadAssessment({
    required this.loadLevel,
    required this.recoveryState,
    required this.zoneState,
    required this.loadLabel,
    required this.recoveryLabel,
    required this.zoneLabel,
    required this.todayFocus,
    required this.engineDescription,
    required this.quickInsights,
    required this.recommendations,
  });
}

class BlueraLoadIntelligence {
  static BlueraLoadAssessment assess(MockAthleteData data) {
    final loadLevel = _loadLevel(data);
    final recoveryState = _recoveryState(data);
    final zoneState = _zoneState(data);

    final loadLabel = _loadLabel(loadLevel);
    final recoveryLabel = _recoveryLabel(recoveryState);
    final zoneLabel = _zoneLabel(zoneState);

    final todayFocus = _todayFocus(
      data: data,
      loadLevel: loadLevel,
      recoveryState: recoveryState,
      zoneState: zoneState,
    );

    final engineDescription = _engineDescription(
      data: data,
      loadLevel: loadLevel,
      recoveryState: recoveryState,
    );

    final quickInsights = _quickInsights(
      data: data,
      loadLevel: loadLevel,
      recoveryState: recoveryState,
      zoneState: zoneState,
    );

    final recommendations = _recommendations(
      data: data,
      loadLevel: loadLevel,
      recoveryState: recoveryState,
      zoneState: zoneState,
    );

    return BlueraLoadAssessment(
      loadLevel: loadLevel,
      recoveryState: recoveryState,
      zoneState: zoneState,
      loadLabel: loadLabel,
      recoveryLabel: recoveryLabel,
      zoneLabel: zoneLabel,
      todayFocus: todayFocus,
      engineDescription: engineDescription,
      quickInsights: quickInsights,
      recommendations: recommendations,
    );
  }

  static BlueraLoadLevel _loadLevel(MockAthleteData data) {
    if (data.fatigue >= 78 ||
        data.z3z5Percent >= 25 ||
        data.weeklyHours >= 12) {
      return BlueraLoadLevel.high;
    }
    if (data.weeklyHours >= 9 || data.fatigue >= 60) {
      return BlueraLoadLevel.build;
    }
    if (data.weeklyHours >= 6) {
      return BlueraLoadLevel.balanced;
    }
    return BlueraLoadLevel.low;
  }

  static BlueraRecoveryState _recoveryState(MockAthleteData data) {
    if (data.fatigue >= 78 || data.form < -5) {
      return BlueraRecoveryState.recoveryNeeded;
    }
    if (data.fatigue >= 68 || data.hrDrift > 5.5) {
      return BlueraRecoveryState.monitor;
    }
    return BlueraRecoveryState.good;
  }

  static BlueraZoneState _zoneState(MockAthleteData data) {
    if (data.z1z2Percent >= 80 && data.z3z5Percent <= 20) {
      return BlueraZoneState.onTarget;
    }
    if (data.z3z5Percent <= 24) {
      return BlueraZoneState.slightlyHigh;
    }
    return BlueraZoneState.needsAdjustment;
  }

  static String _loadLabel(BlueraLoadLevel level) {
    switch (level) {
      case BlueraLoadLevel.low:
        return 'Low';
      case BlueraLoadLevel.balanced:
        return 'Balanced';
      case BlueraLoadLevel.build:
        return 'Build';
      case BlueraLoadLevel.high:
        return 'High';
    }
  }

  static String _recoveryLabel(BlueraRecoveryState state) {
    switch (state) {
      case BlueraRecoveryState.good:
        return 'Good';
      case BlueraRecoveryState.monitor:
        return 'Monitor';
      case BlueraRecoveryState.recoveryNeeded:
        return 'Recovery needed';
    }
  }

  static String _zoneLabel(BlueraZoneState state) {
    switch (state) {
      case BlueraZoneState.onTarget:
        return 'On target';
      case BlueraZoneState.slightlyHigh:
        return 'Slightly high';
      case BlueraZoneState.needsAdjustment:
        return 'Needs adjustment';
    }
  }

  static String _todayFocus({
    required MockAthleteData data,
    required BlueraLoadLevel loadLevel,
    required BlueraRecoveryState recoveryState,
    required BlueraZoneState zoneState,
  }) {
    if (recoveryState == BlueraRecoveryState.recoveryNeeded) {
      return 'Keep today light and mostly aerobic. Prioritise recovery and avoid stacking more intensity.';
    }

    if (loadLevel == BlueraLoadLevel.high) {
      return 'Your load is high right now. Keep the next session controlled and avoid turning endurance work into tempo.';
    }

    if (zoneState == BlueraZoneState.needsAdjustment) {
      return 'Bring the week back toward an 80 / 20 split by keeping the next session mostly Z1 and Z2.';
    }

    if (data.latestWorkout.recoveryCost >= 65) {
      return 'Absorb the last key session with low-intensity work before adding more quality.';
    }

    return 'Load and recovery are in a good place. Continue building durability through controlled aerobic work.';
  }

  static String _engineDescription({
    required MockAthleteData data,
    required BlueraLoadLevel loadLevel,
    required BlueraRecoveryState recoveryState,
  }) {
    if (data.engineScore >= 80 &&
        recoveryState == BlueraRecoveryState.good &&
        loadLevel != BlueraLoadLevel.high) {
      return 'Strong endurance readiness with good freshness, stable load progression and solid durability support.';
    }

    if (data.engineScore >= 80) {
      return 'Strong endurance readiness with some recovery and load management still needed to keep momentum.';
    }

    if (data.engineScore >= 70) {
      return 'Good endurance foundation with room to improve durability and consistency under load.';
    }

    return 'Developing endurance foundation with focus needed on consistency, aerobic support and recovery balance.';
  }

  static List<BlueraInsight> _quickInsights({
    required MockAthleteData data,
    required BlueraLoadLevel loadLevel,
    required BlueraRecoveryState recoveryState,
    required BlueraZoneState zoneState,
  }) {
    return [
      BlueraInsight(
        title: 'Load trend',
        message: loadLevel == BlueraLoadLevel.high
            ? 'Training load is elevated and needs closer monitoring.'
            : loadLevel == BlueraLoadLevel.build
            ? 'Weekly load is building at a productive rate.'
            : 'Current load is stable and manageable.',
        positive: loadLevel != BlueraLoadLevel.high,
      ),
      BlueraInsight(
        title: 'Zone balance',
        message: zoneState == BlueraZoneState.onTarget
            ? 'Your recent distribution is aligned well with the 80 / 20 endurance model.'
            : zoneState == BlueraZoneState.slightlyHigh
            ? 'Intensity is slightly above target and worth watching.'
            : 'Your intensity mix is drifting too high and needs correction.',
        positive: zoneState == BlueraZoneState.onTarget,
      ),
      BlueraInsight(
        title: 'Recovery',
        message: recoveryState == BlueraRecoveryState.good
            ? 'Recovery markers support continued training.'
            : recoveryState == BlueraRecoveryState.monitor
            ? 'Recovery is acceptable, but the next hard session should be managed carefully.'
            : 'Recovery is compromised. A lighter day is the better choice.',
        positive: recoveryState == BlueraRecoveryState.good,
      ),
    ];
  }

  static List<AthleteRecommendation> _recommendations({
    required MockAthleteData data,
    required BlueraLoadLevel loadLevel,
    required BlueraRecoveryState recoveryState,
    required BlueraZoneState zoneState,
  }) {
    final List<AthleteRecommendation> items = [];

    if (recoveryState == BlueraRecoveryState.recoveryNeeded) {
      items.add(
        const AthleteRecommendation(
          title: 'Recovery first',
          message:
              'Use an easy Z1 session or full rest to absorb training before adding more load.',
          warning: true,
        ),
      );
    } else if (recoveryState == BlueraRecoveryState.monitor) {
      items.add(
        const AthleteRecommendation(
          title: 'Keep the next day controlled',
          message:
              'Stay mostly aerobic next session so fatigue does not drift upward too quickly.',
        ),
      );
    } else {
      items.add(
        const AthleteRecommendation(
          title: 'Continue building',
          message:
              'You are responding well to the current load, so controlled progression remains appropriate.',
        ),
      );
    }

    if (zoneState == BlueraZoneState.needsAdjustment) {
      items.add(
        const AthleteRecommendation(
          title: 'Rebalance intensity',
          message:
              'Shift the next sessions toward Z1 and Z2 to bring the week back toward the 80 / 20 target.',
          warning: true,
        ),
      );
    } else if (zoneState == BlueraZoneState.slightlyHigh) {
      items.add(
        const AthleteRecommendation(
          title: 'Watch intensity drift',
          message:
              'Intensity is slightly high, so keep endurance sessions disciplined and easy.',
        ),
      );
    } else {
      items.add(
        const AthleteRecommendation(
          title: '80 / 20 is working',
          message:
              'Your zone distribution is supporting durability and aerobic development well.',
        ),
      );
    }

    if (data.latestWorkout.durabilityScore < 75) {
      items.add(
        const AthleteRecommendation(
          title: 'Keep improving durability',
          message:
              'Continue steady endurance and controlled tempo work to improve late-session stability.',
        ),
      );
    } else {
      items.add(
        const AthleteRecommendation(
          title: 'Durability is trending well',
          message:
              'Your recent sessions suggest that your ability to hold quality deeper into workouts is improving.',
        ),
      );
    }

    return items;
  }
}
