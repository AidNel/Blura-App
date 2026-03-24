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
  double get highIntensityPercent => z3Percent + z4Percent + z5Percent;

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
  });

  bool get isOverreaching => fatigue >= 78 || z3z5Percent > 24;
  bool get isBalanced => z1z2Percent >= 78 && z1z2Percent <= 84 && fatigue < 78;

  String get loadStatus {
    if (isOverreaching) return 'High';
    if (weeklyHours >= 9) return 'Build';
    return 'Balanced';
  }

  String get zoneStatus {
    if (z3z5Percent > 22) return 'Above target';
    if (z1z2Percent >= 80) return 'On target';
    return 'Needs adjustment';
  }

  String get recoveryStatus {
    if (fatigue >= 78) return 'Recovery needed';
    if (fatigue >= 68) return 'Monitor';
    return 'Good';
  }

  String get formStatus {
    if (form >= 5) return 'Fresh';
    if (form >= 0) return 'Stable';
    return 'Loaded';
  }

  int get completedSessions =>
      weeklyCalendar.where((item) => item.completed).length;

  int get remainingSessions =>
      weeklyCalendar.where((item) => !item.completed).length;

  int get restDays => weeklyCalendar.where((item) => item.isRestDay).length;

  int get unlockedAchievements =>
      achievements.where((item) => item.unlocked).length;

  double get totalBikeDistanceKm =>
      bikes.fold(0, (sum, item) => sum + item.distanceKm);

  int get totalBikeRides => bikes.fold(0, (sum, item) => sum + item.rides);
}

class BlueraMockDataService {
  static const MockAthleteData athlete = MockAthleteData(
    engineScore: 82,
    fitness: 74,
    fatigue: 61,
    form: 8,
    hrDrift: 4.2,
    weeklyHours: 9.6,
    weeklyDistanceKm: 286.4,
    weeklyElevationM: 3120,
    monthlyHours: 38.4,
    monthlyDistanceKm: 1118.7,
    monthlyElevationM: 12840,
    z1z2Percent: 81.0,
    z3z5Percent: 19.0,
    weeklyHoursTrend: [
      AthleteMetric(label: 'W1', value: 6.8),
      AthleteMetric(label: 'W2', value: 7.4),
      AthleteMetric(label: 'W3', value: 8.9),
      AthleteMetric(label: 'W4', value: 9.6),
    ],
    weeklyDistanceTrend: [
      AthleteMetric(label: 'W1', value: 182),
      AthleteMetric(label: 'W2', value: 214),
      AthleteMetric(label: 'W3', value: 248),
      AthleteMetric(label: 'W4', value: 286),
    ],
    monthlyVolumeTrend: [
      AthleteMetric(label: 'Jan', value: 26),
      AthleteMetric(label: 'Feb', value: 31),
      AthleteMetric(label: 'Mar', value: 35),
      AthleteMetric(label: 'Apr', value: 38.4),
    ],
    recommendations: [
      AthleteRecommendation(
        title: 'Load is building well',
        message:
            'Your weekly training volume is progressing without showing clear signs of overload.',
      ),
      AthleteRecommendation(
        title: '80 / 20 distribution is on target',
        message:
            'Most of your work remains in Z1 and Z2, which supports durability and aerobic development.',
      ),
      AthleteRecommendation(
        title: 'Keep tomorrow mostly aerobic',
        message:
            'A lower intensity session tomorrow would help preserve freshness before the next hard workout.',
      ),
    ],
    latestWorkout: MockWorkoutAnalysis(
      workoutTitle: '3 x 10 min Tempo / Threshold Build',
      workoutType: 'Structured Intervals',
      dateLabel: 'Today',
      duration: Duration(hours: 1, minutes: 34),
      distanceKm: 46.8,
      elevationM: 540,
      avgPower: 218,
      normalizedPower: 246,
      avgHeartRate: 148,
      maxHeartRate: 171,
      intensityFactor: 0.84,
      trainingLoad: 92,
      hrDrift: 5.1,
      durabilityScore: 72,
      executionScore: 84,
      recoveryCost: 67,
      z1Percent: 24,
      z2Percent: 48,
      z3Percent: 14,
      z4Percent: 11,
      z5Percent: 3,
      summaryBlocks: [
        WorkoutBlock(
          label: 'Duration',
          value: '1h 34m',
          subtitle: 'Total ride time',
        ),
        WorkoutBlock(
          label: 'Distance',
          value: '46.8 km',
          subtitle: 'Completed distance',
        ),
        WorkoutBlock(
          label: 'Training Load',
          value: '92',
          subtitle: 'Session stress',
        ),
        WorkoutBlock(label: 'IF', value: '0.84', subtitle: 'Intensity factor'),
      ],
      insights: [
        WorkoutInsight(
          title: 'Durability held reasonably well',
          message:
              'Power and heart rate stayed controlled for most of the main work, but there was some drift late in the session.',
          positive: true,
        ),
        WorkoutInsight(
          title: 'Execution was strong',
          message:
              'The intervals were paced well overall, with no major drop-off between early and late efforts.',
          positive: true,
        ),
        WorkoutInsight(
          title: 'Recovery cost is moderate',
          message:
              'This session added useful stimulus, but tomorrow should probably stay low intensity.',
          positive: false,
        ),
      ],
      recommendations: [
        AthleteRecommendation(
          title: 'Tomorrow should stay aerobic',
          message:
              'Use Z1 to low Z2 tomorrow to absorb this session before adding more quality.',
        ),
        AthleteRecommendation(
          title: 'Durability can improve further',
          message:
              'Continue with steady aerobic work and controlled tempo sessions to reduce late-session drift.',
        ),
        AthleteRecommendation(
          title: 'Good session execution',
          message:
              'This was a productive workout and the pacing matched the intent of the session.',
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
        title: '3 x 10 min Tempo / Threshold Build',
        type: 'Intervals',
        durationLabel: '1h 34m',
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
        durationLabel: '1h 30m',
        intensityLabel: 'Z2',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Thu',
        dayNumber: '21',
        title: 'Durability Tempo Session',
        type: 'Tempo',
        durationLabel: '1h 20m',
        intensityLabel: 'Z3',
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
        intensityLabel: 'Recovery',
        completed: false,
        isToday: false,
        isRestDay: true,
      ),
      CalendarWorkout(
        dayLabel: 'Sat',
        dayNumber: '23',
        title: 'Long Endurance Ride',
        type: 'Long Ride',
        durationLabel: '3h 45m',
        intensityLabel: 'Z2',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
      CalendarWorkout(
        dayLabel: 'Sun',
        dayNumber: '24',
        title: 'Easy Spin + Skills',
        type: 'Skills',
        durationLabel: '1h 00m',
        intensityLabel: 'Z1 / Z2',
        completed: false,
        isToday: false,
        isRestDay: false,
      ),
    ],
    achievements: [
      GarageAchievement(
        title: 'Engine Level',
        subtitle: 'Current athlete status',
        value: 'Elite',
        icon: IconDataData.trophy,
        unlocked: true,
      ),
      GarageAchievement(
        title: '1,000 km Month',
        subtitle: 'Monthly distance milestone',
        value: 'Unlocked',
        icon: IconDataData.road,
        unlocked: true,
      ),
      GarageAchievement(
        title: 'Durability Builder',
        subtitle: 'Consistent aerobic focus',
        value: 'Unlocked',
        icon: IconDataData.shield,
        unlocked: true,
      ),
      GarageAchievement(
        title: 'Peak Week',
        subtitle: '10h training week',
        value: 'In Progress',
        icon: IconDataData.bolt,
        unlocked: false,
      ),
    ],
    bikes: [
      GarageBike(
        name: 'Factor LS',
        type: 'Gravel',
        notes: 'Primary endurance and mixed-terrain bike',
        rides: 28,
        distanceKm: 842.6,
        elevationM: 9480,
        primaryBike: true,
      ),
      GarageBike(
        name: 'Specialized Diverge',
        type: 'Road / Gravel',
        notes: 'Used for long aerobic rides and backup sessions',
        rides: 12,
        distanceKm: 276.4,
        elevationM: 2410,
        primaryBike: false,
      ),
    ],
    milestones: [
      GarageMilestone(
        title: 'Weekly consistency streak',
        subtitle: 'Completed planned sessions 3 weeks in a row',
        dateLabel: 'This month',
        completed: true,
      ),
      GarageMilestone(
        title: 'Sub-5% HR drift ride',
        subtitle: 'Stable aerobic efficiency on long endurance ride',
        dateLabel: 'Last week',
        completed: true,
      ),
      GarageMilestone(
        title: 'Durability score above 80',
        subtitle: 'Target for next training block',
        dateLabel: 'Upcoming',
        completed: false,
      ),
    ],
  );
}

enum IconDataData { trophy, road, shield, bolt }
