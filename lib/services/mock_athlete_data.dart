class AthleteMetric {
  final String label;
  final double value;

  const AthleteMetric({required this.label, required this.value});
}

class AthleteRecommendation {
  final String title;
  final String message;
  final bool warning;

  const AthleteRecommendation({
    required this.title,
    required this.message,
    this.warning = false,
  });
}

class WorkoutBlock {
  final String label;
  final String value;
  final String subtitle;

  const WorkoutBlock({
    required this.label,
    required this.value,
    required this.subtitle,
  });
}

class WorkoutInsight {
  final String title;
  final String message;
  final bool positive;

  const WorkoutInsight({
    required this.title,
    required this.message,
    required this.positive,
  });
}

class CalendarWorkout {
  final String dayLabel;
  final String dayNumber;
  final String title;
  final String type;
  final String durationLabel;
  final String intensityLabel;
  final bool completed;
  final bool isToday;
  final bool isRestDay;

  const CalendarWorkout({
    required this.dayLabel,
    required this.dayNumber,
    required this.title,
    required this.type,
    required this.durationLabel,
    required this.intensityLabel,
    required this.completed,
    required this.isToday,
    required this.isRestDay,
  });
}

class GarageAchievement {
  final String title;
  final String subtitle;
  final String value;
  final IconDataData icon;
  final bool unlocked;

  const GarageAchievement({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.unlocked,
  });
}

class GarageBike {
  final String name;
  final String type;
  final String notes;
  final int rides;
  final double distanceKm;
  final int elevationM;
  final bool primaryBike;

  const GarageBike({
    required this.name,
    required this.type,
    required this.notes,
    required this.rides,
    required this.distanceKm,
    required this.elevationM,
    required this.primaryBike,
  });
}

class GarageMilestone {
  final String title;
  final String subtitle;
  final String dateLabel;
  final bool completed;

  const GarageMilestone({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.completed,
  });
}

class MockWorkoutAnalysis {
  final String workoutTitle;
  final String workoutType;
  final String dateLabel;
  final Duration duration;
  final double distanceKm;
  final int elevationM;
  final int avgPower;
  final int normalizedPower;
  final int avgHeartRate;
  final int maxHeartRate;
  final double intensityFactor;
  final int trainingLoad;
  final double hrDrift;
  final int durabilityScore;
  final int executionScore;
  final int recoveryCost;
  final double z1Percent;
  final double z2Percent;
  final double z3Percent;
  final double z4Percent;
  final double z5Percent;
  final List<WorkoutBlock> summaryBlocks;
  final List<WorkoutInsight> insights;
  final List<AthleteRecommendation> recommendations;

  const MockWorkoutAnalysis({
    required this.workoutTitle,
    required this.workoutType,
    required this.dateLabel,
    required this.duration,
    required this.distanceKm,
    required this.elevationM,
    required this.avgPower,
    required this.normalizedPower,
    required this.avgHeartRate,
    required this.maxHeartRate,
    required this.intensityFactor,
    required this.trainingLoad,
    required this.hrDrift,
    required this.durabilityScore,
    required this.executionScore,
    required this.recoveryCost,
    required this.z1Percent,
    required this.z2Percent,
    required this.z3Percent,
    required this.z4Percent,
    required this.z5Percent,
    required this.summaryBlocks,
    required this.insights,
    required this.recommendations,
  });

  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${duration.inMinutes}m';
  }

  double get lowIntensityPercent => z1Percent + z2Percent;

  double get blueTimePercent => lowIntensityPercent;

  String get durabilityStatus {
    if (durabilityScore >= 80) return 'Strong';
    if (durabilityScore >= 65) return 'Good';
    return 'Needs work';
  }

  String get executionStatus {
    if (executionScore >= 85) return 'Well paced';
    if (executionScore >= 70) return 'Mostly controlled';
    return 'Inconsistent';
  }

  String get recoveryStatus {
    if (recoveryCost >= 80) return 'High cost';
    if (recoveryCost >= 60) return 'Moderate cost';
    return 'Low cost';
  }

  String get durabilityInsight {
    if (durabilityScore >= 82 && hrDrift <= 4.5) {
      return 'Strong aerobic control';
    }
    if (durabilityScore >= 72 && hrDrift <= 6) {
      return 'Blue session executed well';
    }
    if (durabilityScore >= 62) {
      return 'Durability faded late';
    }
    return 'Too much drift for a controlled endurance session';
  }

  String get recommendationText {
    if (recoveryCost >= 75 || hrDrift > 7.0) {
      return 'Use a low-pressure recovery ride tomorrow and keep intensity below threshold.';
    }
    if (blueTimePercent >= 70 && executionScore >= 80) {
      return 'Suitable recovery load for this block. Keep the next session aerobic or skills-focused.';
    }
    return 'Hold the next ride mostly in blue zones and reduce surges to improve control.';
  }
}

class RecoveryMarkers {
  final int restingHeartRate;
  final int restingHeartRateBaseline;
  final int hrvMs;
  final int hrvBaselineMs;
  final double sleepHours;
  final double sleepNeedHours;
  final int soreness;

  const RecoveryMarkers({
    required this.restingHeartRate,
    required this.restingHeartRateBaseline,
    required this.hrvMs,
    required this.hrvBaselineMs,
    required this.sleepHours,
    required this.sleepNeedHours,
    required this.soreness,
  });
}

class LoadMarkers {
  final int acuteLoad;
  final int chronicLoad;
  final double monotony;
  final int trainingStressWeek;
  final double hrDriftPercent;

  const LoadMarkers({
    required this.acuteLoad,
    required this.chronicLoad,
    required this.monotony,
    required this.trainingStressWeek,
    required this.hrDriftPercent,
  });

  double get acuteChronicRatio => chronicLoad == 0 ? 0 : acuteLoad / chronicLoad;
}

class WeeklyZoneDistribution {
  final double z1;
  final double z2;
  final double z3;
  final double z4;
  final double z5;

  const WeeklyZoneDistribution({
    required this.z1,
    required this.z2,
    required this.z3,
    required this.z4,
    required this.z5,
  });

  double get bluePercent => z1 + z2;

  double get highPercent => z3 + z4 + z5;
}

class DashboardContext {
  final bool keySessionTomorrow;
  final bool travelFatigue;
  final bool heatStress;
  final bool raceInDays;
  final int nextEventDays;

  const DashboardContext({
    required this.keySessionTomorrow,
    required this.travelFatigue,
    required this.heatStress,
    required this.raceInDays,
    required this.nextEventDays,
  });
}

class MockAthleteSnapshot {
  final RecoveryMarkers recovery;
  final LoadMarkers load;
  final WeeklyZoneDistribution zones;
  final DashboardContext context;

  const MockAthleteSnapshot({
    required this.recovery,
    required this.load,
    required this.zones,
    required this.context,
  });
}

class MockAthleteData {
  final int engineScore;
  final int fitness;
  final int fatigue;
  final int form;
  final double hrDrift;
  final double weeklyHours;
  final double weeklyDistanceKm;
  final int weeklyElevationM;
  final double monthlyHours;
  final double monthlyDistanceKm;
  final int monthlyElevationM;
  final double z1z2Percent;
  final double z3z5Percent;
  final List<AthleteMetric> weeklyHoursTrend;
  final List<AthleteMetric> weeklyDistanceTrend;
  final List<AthleteMetric> monthlyVolumeTrend;
  final List<AthleteRecommendation> recommendations;
  final MockWorkoutAnalysis latestWorkout;
  final List<CalendarWorkout> weeklyCalendar;
  final List<GarageAchievement> achievements;
  final List<GarageBike> bikes;
  final List<GarageMilestone> milestones;
  final MockAthleteSnapshot snapshot;

  const MockAthleteData({
    required this.engineScore,
    required this.fitness,
    required this.fatigue,
    required this.form,
    required this.hrDrift,
    required this.weeklyHours,
    required this.weeklyDistanceKm,
    required this.weeklyElevationM,
    required this.monthlyHours,
    required this.monthlyDistanceKm,
    required this.monthlyElevationM,
    required this.z1z2Percent,
    required this.z3z5Percent,
    required this.weeklyHoursTrend,
    required this.weeklyDistanceTrend,
    required this.monthlyVolumeTrend,
    required this.recommendations,
    required this.latestWorkout,
    required this.weeklyCalendar,
    required this.achievements,
    required this.bikes,
    required this.milestones,
    required this.snapshot,
  });

  bool get isOverreaching => fatigue >= 78 || z3z5Percent > 24;

  String get formStatus {
    if (form >= 5) return 'Fresh';
    if (form >= 0) return 'Stable';
    return 'Loaded';
  }

  String get loadStatus {
    if (isOverreaching) return 'High';
    if (weeklyHours >= 9) return 'Build';
    return 'Balanced';
  }

  int get completedSessions => weeklyCalendar.where((item) => item.completed).length;

  int get unlockedAchievements => achievements.where((item) => item.unlocked).length;

  double get totalBikeDistanceKm => bikes.fold(0, (sum, item) => sum + item.distanceKm);

  int get totalBikeRides => bikes.fold(0, (sum, item) => sum + item.rides);
}

class BlueraMockDataService {
  static const MockAthleteData athlete = MockAthleteData(
    engineScore: 81,
    fitness: 90,
    fatigue: 58,
    form: 6,
    hrDrift: 4.3,
    weeklyHours: 9.4,
    weeklyDistanceKm: 278.2,
    weeklyElevationM: 2980,
    monthlyHours: 36.9,
    monthlyDistanceKm: 1092.5,
    monthlyElevationM: 11920,
    z1z2Percent: 80,
    z3z5Percent: 20,
    weeklyHoursTrend: [
      AthleteMetric(label: 'W1', value: 7.2),
      AthleteMetric(label: 'W2', value: 8.1),
      AthleteMetric(label: 'W3', value: 8.8),
      AthleteMetric(label: 'W4', value: 9.4),
    ],
    weeklyDistanceTrend: [
      AthleteMetric(label: 'W1', value: 212),
      AthleteMetric(label: 'W2', value: 236),
      AthleteMetric(label: 'W3', value: 257),
      AthleteMetric(label: 'W4', value: 278),
    ],
    monthlyVolumeTrend: [
      AthleteMetric(label: 'Jan', value: 27),
      AthleteMetric(label: 'Feb', value: 31),
      AthleteMetric(label: 'Mar', value: 34),
      AthleteMetric(label: 'Apr', value: 36.9),
    ],
    recommendations: [
      AthleteRecommendation(
        title: 'Solid blue-time consistency',
        message: 'You are holding an 80/20 profile that supports endurance growth.',
      ),
      AthleteRecommendation(
        title: 'Keep tomorrow aerobic',
        message: 'Low-intensity volume tomorrow will improve quality session outcomes later this week.',
      ),
    ],
    latestWorkout: MockWorkoutAnalysis(
      workoutTitle: 'Tempo Endurance Build',
      workoutType: 'Structured Intervals',
      dateLabel: 'Today',
      duration: Duration(hours: 1, minutes: 28),
      distanceKm: 43.6,
      elevationM: 490,
      avgPower: 224,
      normalizedPower: 242,
      avgHeartRate: 146,
      maxHeartRate: 169,
      intensityFactor: 0.82,
      trainingLoad: 87,
      hrDrift: 4.8,
      durabilityScore: 78,
      executionScore: 86,
      recoveryCost: 62,
      z1Percent: 26,
      z2Percent: 49,
      z3Percent: 13,
      z4Percent: 9,
      z5Percent: 3,
      summaryBlocks: [
        WorkoutBlock(label: 'Duration', value: '1h 28m', subtitle: 'Total ride time'),
        WorkoutBlock(label: 'Distance', value: '43.6 km', subtitle: 'Completed distance'),
        WorkoutBlock(label: 'Load', value: '87', subtitle: 'Session stress'),
      ],
      insights: [
        WorkoutInsight(
          title: 'Strong aerobic control',
          message: 'Power and heart-rate stayed aligned across the main work set.',
          positive: true,
        ),
        WorkoutInsight(
          title: 'Blue session executed well',
          message: '75% of this ride stayed in Z1/Z2, supporting endurance quality.',
          positive: true,
        ),
        WorkoutInsight(
          title: 'Durability faded late',
          message: 'Final block showed mild drift. Keep the next quality day controlled.',
          positive: false,
        ),
      ],
      recommendations: [
        AthleteRecommendation(
          title: 'Suitable recovery load',
          message: 'Plan an aerobic day next and avoid stacking threshold efforts.',
        ),
      ],
    ),
    weeklyCalendar: [
      CalendarWorkout(
        dayLabel: 'Mon',
        dayNumber: '18',
        title: 'Recovery Spin',
        type: 'Recovery',
        durationLabel: '45 min',
        intensityLabel: 'Z1',
        completed: true,
        isToday: false,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Tue',
        dayNumber: '19',
        title: 'Tempo Endurance Build',
        type: 'Intervals',
        durationLabel: '1h 28m',
        intensityLabel: 'Z3 / Z4',
        completed: true,
        isToday: true,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Wed',
        dayNumber: '20',
        title: 'Aerobic Endurance Ride',
        type: 'Endurance',
        durationLabel: '1h 20m',
        intensityLabel: 'Z2',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Thu',
        dayNumber: '21',
        title: 'VO2 Microbursts',
        type: 'Quality',
        durationLabel: '1h 05m',
        intensityLabel: 'Z4 / Z5',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Fri',
        dayNumber: '22',
        title: 'Rest Day',
        type: 'Recovery',
        durationLabel: 'Off',
        intensityLabel: 'Rest',
        completed: false,
        isToday: false,
        isRestDay: true,
      ),
      CalendarWorkout(
        dayLabel: 'Sat',
        dayNumber: '23',
        title: 'Long Endurance Ride',
        type: 'Endurance',
        durationLabel: '2h 40m',
        intensityLabel: 'Z2',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Sun',
        dayNumber: '24',
        title: 'Endurance + Skills',
        type: 'Skills',
        durationLabel: '1h 25m',
        intensityLabel: 'Z2',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
    ],
    achievements: [
      GarageAchievement(
        title: 'Engine Level',
        subtitle: 'Current athlete status',
        value: 'Strong',
        icon: IconDataData.trophy,
        unlocked: true,
      ),
      GarageAchievement(
        title: 'Blue Block',
        subtitle: '4 weeks in range',
        value: 'Unlocked',
        icon: IconDataData.shield,
        unlocked: true,
      ),
    ],
    bikes: [
      GarageBike(
        name: 'Factor LS',
        type: 'Gravel',
        notes: 'Primary endurance bike',
        rides: 27,
        distanceKm: 812.4,
        elevationM: 9010,
        primaryBike: true,
      ),
    ],
    milestones: [
      GarageMilestone(
        title: 'Weekly consistency streak',
        subtitle: 'Completed planned sessions for 3 consecutive weeks',
        dateLabel: 'This month',
        completed: true,
      ),
    ],
    snapshot: MockAthleteSnapshot(
      recovery: RecoveryMarkers(
        restingHeartRate: 49,
        restingHeartRateBaseline: 50,
        hrvMs: 78,
        hrvBaselineMs: 70,
        sleepHours: 8.0,
        sleepNeedHours: 8.0,
        soreness: 2,
      ),
      load: LoadMarkers(
        acuteLoad: 612,
        chronicLoad: 558,
        monotony: 1.34,
        trainingStressWeek: 487,
        hrDriftPercent: 4.3,
      ),
      zones: WeeklyZoneDistribution(z1: 31, z2: 49, z3: 12, z4: 6, z5: 2),
      context: DashboardContext(
        keySessionTomorrow: false,
        travelFatigue: false,
        heatStress: false,
        raceInDays: true,
        nextEventDays: 12,
      ),
    ),
  );
}

enum IconDataData { trophy, road, shield, bolt }
