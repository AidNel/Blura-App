import 'package:flutter/material.dart';

enum AppUnitSystem { metric, imperial }

class AppSettingsData {
  final ThemeMode themeMode;
  final AppUnitSystem unitSystem;

  const AppSettingsData({required this.themeMode, required this.unitSystem});

  AppSettingsData copyWith({ThemeMode? themeMode, AppUnitSystem? unitSystem}) {
    return AppSettingsData(
      themeMode: themeMode ?? this.themeMode,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }
}

class AppSettingsService extends ValueNotifier<AppSettingsData> {
  AppSettingsService._()
    : super(
        const AppSettingsData(
          themeMode: ThemeMode.dark,
          unitSystem: AppUnitSystem.metric,
        ),
      );

  static final AppSettingsService instance = AppSettingsService._();

  void updateThemeMode(ThemeMode mode) {
    value = value.copyWith(themeMode: mode);
  }

  void updateUnitSystem(AppUnitSystem units) {
    value = value.copyWith(unitSystem: units);
  }

  static bool isMetric(AppUnitSystem unitSystem) {
    return unitSystem == AppUnitSystem.metric;
  }

  static String distanceLabel(
    double km,
    AppUnitSystem unitSystem, {
    int decimals = 1,
  }) {
    if (unitSystem == AppUnitSystem.metric) {
      return '${km.toStringAsFixed(decimals)} km';
    }
    final miles = km * 0.621371;
    return '${miles.toStringAsFixed(decimals)} mi';
  }

  static String shortDistanceLabel(
    double km,
    AppUnitSystem unitSystem, {
    int decimals = 0,
  }) {
    if (unitSystem == AppUnitSystem.metric) {
      return '${km.toStringAsFixed(decimals)} km';
    }
    final miles = km * 0.621371;
    return '${miles.toStringAsFixed(decimals)} mi';
  }

  static String elevationLabel(int meters, AppUnitSystem unitSystem) {
    if (unitSystem == AppUnitSystem.metric) {
      return '$meters m';
    }
    final feet = meters * 3.28084;
    return '${feet.round()} ft';
  }

  static String shortElevationLabel(int meters, AppUnitSystem unitSystem) {
    if (unitSystem == AppUnitSystem.metric) {
      return '$meters m';
    }
    final feet = meters * 3.28084;
    return '${feet.round()} ft';
  }
}
