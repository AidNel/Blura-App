import 'mock_athlete_data.dart';

enum BlueraLoadLevel { low, balanced, build, high }

enum BlueraRecoveryState { good, monitor, recoveryNeeded }

enum BlueraZoneState { onTarget, slightlyHigh, needsAdjustment }

enum BlueraEngineState { blue, green, red }

enum BlueraDurabilityState { stable, building, fading }

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

class BlueraCalendarRecommendation {
  final String sessionTitle;
  final String workoutType;
  final String durationLabel;
  final String intensityLabel;
  final String reason;
  final String weeklyFocus;
  final String readinessSummary;

  const BlueraCalendarRecommendation({
    required this.sessionTitle,
    required this.workoutType,
    required this.durationLabel,
    required this.intensityLabel,
    required this.reason,
    required this.weeklyFocus,
    required this.readinessSummary,
  });
}

class BlueraDurabilityAssessment {
  final int score;
  final BlueraDurabilityState state;
  final String stateLabel;
  final double hrDriftPercent;
  final int firstHalfHeartRate;
  final int secondHalfHeartRate;
  final int firstHalfPower;
  final int secondHalfPower;
  final double lateSessionPowerDropPercent;
  final double aerobicControlPercent;
  final String hrDriftInsight;
  final String lateFadeInsight;
  final String aerobicControlInsight;
  final String stabilitySummary;
  final String coachingRecommendation;

  const BlueraDurabilityAssessment({
    required this.score,
    required this.state,
    required this.stateLabel,
    required this.hrDriftPercent,
    required this.firstHalfHeartRate,
    required this.secondHalfHeartRate,
    required this.firstHalfPower,
    required this.secondHalfPower,
    required this.lateSessionPowerDropPercent,
    required this.aerobicControlPercent,
    required this.hrDriftInsight,
    required this.lateFadeInsight,
    required this.aerobicControlInsight,
    required this.stabilitySummary,
    required this.coachingRecommendation,
  });
}

class BlueraLoadAssessment {
  final int engineScore;
  final int fatigueScore;
  final int recoveryScore;
  final int blueBalanceScore;
  final BlueraEngineState engineState;
  final BlueraLoadLevel loadLevel;
  final BlueraRecoveryState recoveryState;
  final BlueraZoneState zoneState;
  final String loadLabel;
  final String recoveryLabel;
  final String zoneLabel;
  final String todayFocus;
  final String recommendationTitle;
  final String recommendationDetail;
  final String engineDescription;
  final List<BlueraInsight> quickInsights;
  final List<AthleteRecommendation> recommendations;

  const BlueraLoadAssessment({
    required this.engineScore,
    required this.fatigueScore,
    required this.recoveryScore,
    required this.blueBalanceScore,
    required this.engineState,
    required this.loadLevel,
    required this.recoveryState,
    required this.zoneState,
    required this.loadLabel,
    required this.recoveryLabel,
    required this.zoneLabel,
    required this.todayFocus,
    required this.recommendationTitle,
    required this.recommendationDetail,
    required this.engineDescription,
    required this.quickInsights,
    required this.recommendations,
  });
}

class BlueraLoadIntelligence {
  static BlueraLoadAssessment assess(MockAthleteData data) {
    final recoveryScore = _recoveryScore(data);
    final fatigueScore = _fatigueScore(data);
    final blueBalanceScore = _blueBalanceScore(data);
    final engineScore = _engineScore(
      recoveryScore: recoveryScore,
      fatigueScore: fatigueScore,
      blueBalanceScore: blueBalanceScore,
      fitness: data.fitness,
    );

    final recoveryState = _recoveryState(recoveryScore);
    final loadLevel = _loadLevel(data, fatigueScore);
    final zoneState = _zoneState(blueBalanceScore);
    final engineState = _engineState(
      engineScore: engineScore,
      recoveryState: recoveryState,
      loadLevel: loadLevel,
    );

    final recommendation = _dailyRecommendation(
      recoveryState: recoveryState,
      fatigueScore: fatigueScore,
      blueBalanceScore: blueBalanceScore,
      context: data.snapshot.context,
    );

    return BlueraLoadAssessment(
      engineScore: engineScore,
      fatigueScore: fatigueScore,
      recoveryScore: recoveryScore,
      blueBalanceScore: blueBalanceScore,
      engineState: engineState,
      loadLevel: loadLevel,
      recoveryState: recoveryState,
      zoneState: zoneState,
      loadLabel: _loadLabel(loadLevel),
      recoveryLabel: _recoveryLabel(recoveryState),
      zoneLabel: _zoneLabel(zoneState),
      todayFocus: recommendation.$2,
      recommendationTitle: recommendation.$1,
      recommendationDetail: recommendation.$2,
      engineDescription: _engineDescription(
        engineScore,
        recoveryScore,
        fatigueScore,
      ),
      quickInsights: _quickInsights(
        data,
        fatigueScore,
        recoveryScore,
        blueBalanceScore,
      ),
      recommendations: _recommendations(data, recommendation.$1, recommendation.$2),
    );
  }

  static BlueraDurabilityAssessment assessDurability(MockAthleteData data) {
    final workout = data.latestWorkout;
    final hrDrift = workout.hrDrift;

    final firstHalfHeartRate = (workout.avgHeartRate - 2).clamp(80, 220).toInt();
    final secondHalfHeartRate = (workout.avgHeartRate + 4).clamp(80, 220).toInt();

    final firstHalfPower = (workout.avgPower + 8).clamp(80, 600).toInt();
    final secondHalfPower = (workout.avgPower - 10).clamp(80, 600).toInt();

    final lateSessionPowerDropPercent =
        (((firstHalfPower - secondHalfPower) / firstHalfPower) * 100).clamp(0, 25).toDouble();

    final aerobicControlPercent = (100 - (hrDrift * 4.0) - (lateSessionPowerDropPercent * 1.5))
        .clamp(45, 97)
        .toDouble();

    final score =
        (workout.durabilityScore * 0.55 + aerobicControlPercent * 0.30 + (100 - hrDrift * 6) * 0.15)
            .round()
            .clamp(0, 100);

    final state = _durabilityState(score: score, hrDrift: hrDrift, powerDrop: lateSessionPowerDropPercent);

    return BlueraDurabilityAssessment(
      score: score,
      state: state,
      stateLabel: _durabilityLabel(state),
      hrDriftPercent: hrDrift,
      firstHalfHeartRate: firstHalfHeartRate,
      secondHalfHeartRate: secondHalfHeartRate,
      firstHalfPower: firstHalfPower,
      secondHalfPower: secondHalfPower,
      lateSessionPowerDropPercent: lateSessionPowerDropPercent,
      aerobicControlPercent: aerobicControlPercent,
      hrDriftInsight: _hrDriftInsight(hrDrift),
      lateFadeInsight: _lateFadeInsight(lateSessionPowerDropPercent),
      aerobicControlInsight: _aerobicControlInsight(aerobicControlPercent),
      stabilitySummary: _stabilitySummary(state, hrDrift, lateSessionPowerDropPercent),
      coachingRecommendation: _durabilityRecommendation(state, hrDrift, lateSessionPowerDropPercent),
    );
  }

  static BlueraCalendarRecommendation calendarRecommendation(
    MockAthleteData data,
    BlueraLoadAssessment assessment,
  ) {
    final todaySession = data.weeklyCalendar.firstWhere(
      (session) => session.isToday,
      orElse: () => data.weeklyCalendar.first,
    );

    final nextQuality = data.weeklyCalendar.firstWhere(
      (session) => !session.completed && !session.isRestDay,
      orElse: () => todaySession,
    );

    final isRecoveryDay = assessment.recoveryState == BlueraRecoveryState.recoveryNeeded ||
        assessment.fatigueScore >= 80;

    final String weeklyFocus;
    if (assessment.zoneState == BlueraZoneState.needsAdjustment) {
      weeklyFocus = 'Re-center the week in Z1-Z2. Prioritize aerobic consistency before adding more intensity.';
    } else if (assessment.loadLevel == BlueraLoadLevel.high) {
      weeklyFocus =
          'Absorb recent load with controlled endurance and one key quality stimulus when freshness is stable.';
    } else {
      weeklyFocus = 'Progress endurance with mostly blue sessions and one controlled quality day.';
    }

    final String readinessSummary =
        'Readiness ${assessment.recoveryLabel.toLowerCase()} • Fatigue ${assessment.fatigueScore}/100 • Engine ${assessment.engineScore}/100';

    if (isRecoveryDay) {
      return BlueraCalendarRecommendation(
        sessionTitle: 'Recovery spin recommended',
        workoutType: 'Recovery',
        durationLabel: '40-55 min',
        intensityLabel: 'Z1',
        reason:
            'Fatigue and recovery markers suggest keeping stress low today so you can respond better to upcoming work.',
        weeklyFocus: weeklyFocus,
        readinessSummary: readinessSummary,
      );
    }

    if (assessment.zoneState == BlueraZoneState.slightlyHigh ||
        data.snapshot.context.travelFatigue ||
        data.snapshot.context.heatStress) {
      return BlueraCalendarRecommendation(
        sessionTitle: 'Stay aerobic today',
        workoutType: 'Endurance',
        durationLabel: todaySession.durationLabel,
        intensityLabel: 'Z1-Z2',
        reason:
            'Recent load is manageable, but keeping this session aerobic protects consistency and keeps the week on track.',
        weeklyFocus: weeklyFocus,
        readinessSummary: readinessSummary,
      );
    }

    return BlueraCalendarRecommendation(
      sessionTitle: 'You are ready for quality work',
      workoutType: nextQuality.type,
      durationLabel: nextQuality.durationLabel,
      intensityLabel: nextQuality.intensityLabel,
      reason:
          'Recovery and load balance are aligned. A controlled quality session is appropriate and should be well absorbed.',
      weeklyFocus: weeklyFocus,
      readinessSummary: readinessSummary,
    );
  }

  static int _recoveryScore(MockAthleteData data) {
    final recovery = data.snapshot.recovery;
    final rhrPenalty = ((recovery.restingHeartRate - recovery.restingHeartRateBaseline) * 6)
        .clamp(0, 20)
        .toDouble();
    final hrvBonus = ((recovery.hrvMs - recovery.hrvBaselineMs) * 2).clamp(-14, 14).toDouble();
    final sleepScore = ((recovery.sleepHours / recovery.sleepNeedHours) * 22).clamp(0, 22).toDouble();
    final sorenessPenalty = (recovery.soreness * 4).clamp(0, 24).toDouble();

    final score = (62 + hrvBonus + sleepScore - rhrPenalty - sorenessPenalty).round();
    return score.clamp(0, 100);
  }

  static int _fatigueScore(MockAthleteData data) {
    final load = data.snapshot.load;
    final ratioPenalty = ((load.acuteChronicRatio - 1.0) * 70).clamp(0, 24).toDouble();
    final monotonyPenalty = ((load.monotony - 1.2) * 22).clamp(0, 20).toDouble();
    final driftPenalty = ((load.hrDriftPercent - 3.5) * 6).clamp(0, 18).toDouble();
    final base = data.fatigue.toDouble();

    return (base + ratioPenalty + monotonyPenalty + driftPenalty).round().clamp(0, 100);
  }

  static int _blueBalanceScore(MockAthleteData data) {
    final zones = data.snapshot.zones;
    final blueGap = (zones.bluePercent - 80).abs();
    final highPenalty = (zones.highPercent - 20).abs() * 1.6;
    final score = 100 - ((blueGap * 2.1) + highPenalty);
    return score.round().clamp(0, 100);
  }

  static int _engineScore({
    required int recoveryScore,
    required int fatigueScore,
    required int blueBalanceScore,
    required int fitness,
  }) {
    final weighted = (fitness * 0.30) +
        ((100 - fatigueScore) * 0.30) +
        (recoveryScore * 0.25) +
        (blueBalanceScore * 0.15);
    return weighted.round().clamp(0, 100);
  }

  static BlueraRecoveryState _recoveryState(int recoveryScore) {
    if (recoveryScore >= 72) return BlueraRecoveryState.good;
    if (recoveryScore >= 55) return BlueraRecoveryState.monitor;
    return BlueraRecoveryState.recoveryNeeded;
  }

  static BlueraLoadLevel _loadLevel(MockAthleteData data, int fatigueScore) {
    final ratio = data.snapshot.load.acuteChronicRatio;
    if (fatigueScore >= 78 || ratio >= 1.22 || data.weeklyHours >= 11) {
      return BlueraLoadLevel.high;
    }
    if (fatigueScore >= 65 || data.weeklyHours >= 9) {
      return BlueraLoadLevel.build;
    }
    if (data.weeklyHours >= 6) return BlueraLoadLevel.balanced;
    return BlueraLoadLevel.low;
  }

  static BlueraZoneState _zoneState(int blueBalanceScore) {
    if (blueBalanceScore >= 82) return BlueraZoneState.onTarget;
    if (blueBalanceScore >= 68) return BlueraZoneState.slightlyHigh;
    return BlueraZoneState.needsAdjustment;
  }

  static BlueraEngineState _engineState({
    required int engineScore,
    required BlueraRecoveryState recoveryState,
    required BlueraLoadLevel loadLevel,
  }) {
    if (recoveryState == BlueraRecoveryState.recoveryNeeded || loadLevel == BlueraLoadLevel.high) {
      return BlueraEngineState.red;
    }
    if (engineScore >= 78 && recoveryState == BlueraRecoveryState.good) {
      return BlueraEngineState.green;
    }
    return BlueraEngineState.blue;
  }

  static BlueraDurabilityState _durabilityState({
    required int score,
    required double hrDrift,
    required double powerDrop,
  }) {
    if (score >= 80 && hrDrift <= 5.2 && powerDrop <= 6.5) {
      return BlueraDurabilityState.stable;
    }
    if (score >= 68 && hrDrift <= 6.8 && powerDrop <= 9.5) {
      return BlueraDurabilityState.building;
    }
    return BlueraDurabilityState.fading;
  }

  static String _durabilityLabel(BlueraDurabilityState state) {
    switch (state) {
      case BlueraDurabilityState.stable:
        return 'Stable';
      case BlueraDurabilityState.building:
        return 'Building';
      case BlueraDurabilityState.fading:
        return 'Fading';
    }
  }

  static String _hrDriftInsight(double hrDrift) {
    if (hrDrift <= 4.5) return 'HR drift remained controlled for this aerobic session.';
    if (hrDrift <= 6.0) return 'Moderate decoupling. Durability is building well with room to tighten control.';
    return 'Too much decoupling for a controlled aerobic session.';
  }

  static String _lateFadeInsight(double powerDrop) {
    if (powerDrop <= 5.5) return 'Power held well through the final third.';
    if (powerDrop <= 8.5) return 'Mild late fade appeared but remained manageable.';
    return 'Late fade suggests durability needs work.';
  }

  static String _aerobicControlInsight(double control) {
    if (control >= 82) return 'Stable aerobic durability across the session.';
    if (control >= 72) return 'Aerobic control is improving and trending in the right direction.';
    return 'Aerobic control dropped too much late. Keep sessions steadier.';
  }

  static String _stabilitySummary(BlueraDurabilityState state, double hrDrift, double powerDrop) {
    switch (state) {
      case BlueraDurabilityState.stable:
        return 'Stable aerobic durability (${hrDrift.toStringAsFixed(1)}% drift, ${powerDrop.toStringAsFixed(1)}% late fade).';
      case BlueraDurabilityState.building:
        return 'Durability is building well but still sensitive to late-session fade.';
      case BlueraDurabilityState.fading:
        return 'Durability is fading late, driven by elevated decoupling and power drop.';
    }
  }

  static String _durabilityRecommendation(BlueraDurabilityState state, double hrDrift, double powerDrop) {
    if (state == BlueraDurabilityState.stable) {
      return 'Keep one longer steady Z2 session this week and avoid unnecessary surges. You are holding durability well.';
    }
    if (state == BlueraDurabilityState.building) {
      return 'Progress durability with controlled endurance: 75-90 min steady Z2 and finish with 10-15 min at upper aerobic pressure.';
    }
    if (hrDrift > 6.5 || powerDrop > 9.0) {
      return 'Reduce session intensity spikes and build durability through flatter power pacing before reintroducing hard finish work.';
    }
    return 'Prioritize a smooth aerobic ride next, then reassess durability trend after two consistent low-variability sessions.';
  }

  static (String, String) _dailyRecommendation({
    required BlueraRecoveryState recoveryState,
    required int fatigueScore,
    required int blueBalanceScore,
    required DashboardContext context,
  }) {
    if (recoveryState == BlueraRecoveryState.recoveryNeeded || fatigueScore >= 80) {
      return (
        'Recovery day recommended',
        'Keep training very light today. Favor easy spin or full rest to reduce stress and restore readiness.',
      );
    }

    if (blueBalanceScore < 75 || context.travelFatigue || context.heatStress) {
      return (
        'Stay aerobic today',
        'Hold most work in Z1-Z2 and avoid turning endurance work into tempo. This keeps your week back in the blue.',
      );
    }

    return (
      'You are ready for quality work',
      'Recovery, fatigue, and zone balance are aligned. A controlled quality session is appropriate today.',
    );
  }

  static String _engineDescription(int engineScore, int recoveryScore, int fatigueScore) {
    if (engineScore >= 80 && recoveryScore >= 70 && fatigueScore <= 65) {
      return 'Strong readiness with stable load and good freshness.';
    }
    if (engineScore >= 70) {
      return 'Good trajectory. Stay consistent in blue time to keep improving.';
    }
    return 'Engine is building. Prioritize recovery and aerobic consistency this week.';
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

  static List<BlueraInsight> _quickInsights(
    MockAthleteData data,
    int fatigueScore,
    int recoveryScore,
    int blueBalanceScore,
  ) {
    return [
      BlueraInsight(
        title: 'Fatigue state',
        message:
            'Current fatigue score is $fatigueScore/100 with AC ratio ${data.snapshot.load.acuteChronicRatio.toStringAsFixed(2)}.',
        positive: fatigueScore < 70,
      ),
      BlueraInsight(
        title: 'Recovery state',
        message: 'Recovery is $recoveryScore/100 from HRV, RHR, sleep and soreness markers.',
        positive: recoveryScore >= 65,
      ),
      BlueraInsight(
        title: 'Blue-time balance',
        message:
            'Blue balance is $blueBalanceScore/100 with ${data.snapshot.zones.bluePercent.toStringAsFixed(0)}% in Z1-Z2.',
        positive: blueBalanceScore >= 80,
      ),
    ];
  }

  static List<AthleteRecommendation> _recommendations(
    MockAthleteData data,
    String title,
    String detail,
  ) {
    return [
      AthleteRecommendation(
        title: title,
        message: detail,
        warning: title == 'Recovery day recommended',
      ),
      ...data.recommendations,
    ];
  }
}
