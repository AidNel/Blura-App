import 'package:flutter/material.dart';

class AppTheme {
  static bool _isDark = true;

  // Blura color system
  static const Color bluePrimary = Color(0xFF2F80FF);
  static const Color cyanAccent = Color(0xFF00E0FF);
  static const Color greenPrimary = Color(0xFF22C55E);
  static const Color greenAccent = Color(0xFF86EFAC);
  static const Color redPrimary = Color(0xFFEF4444);
  static const Color redAccent = Color(0xFFFCA5A5);
  static const Color backgroundDark = Color(0xFF08152D);
  static const Color backgroundNavy = Color(0xFF0B1F3B);
  static const Color textPrimaryDark = Color(0xFFEAF2FF);
  static const Color textSecondaryDark = Color(0xFF9FB3D1);

  static void setThemeMode(
    ThemeMode mode, {
    Brightness systemBrightness = Brightness.dark,
  }) {
    switch (mode) {
      case ThemeMode.dark:
        _isDark = true;
        break;
      case ThemeMode.light:
        _isDark = false;
        break;
      case ThemeMode.system:
        _isDark = systemBrightness == Brightness.dark;
        break;
    }
  }

  static bool get isDark => _isDark;

  static Color get accent => bluePrimary;

  static Color get background =>
      _isDark ? backgroundDark : const Color(0xFFF5F7FB);

  static Color get card =>
      _isDark ? backgroundNavy : const Color(0xFFFFFFFF);

  static Color get textPrimary =>
      _isDark ? textPrimaryDark : const Color(0xFF111827);

  static Color get textSecondary =>
      _isDark ? textSecondaryDark : const Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      colorScheme: const ColorScheme.light(
        primary: bluePrimary,
        secondary: cyanAccent,
        surface: Color(0xFFFFFFFF),
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F7FB),
        foregroundColor: Color(0xFF111827),
        elevation: 0,
      ),
      cardColor: const Color(0xFFFFFFFF),
      dividerColor: const Color(0xFFE5E7EB),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF111827)),
        bodyMedium: TextStyle(color: Color(0xFF111827)),
        titleLarge: TextStyle(color: Color(0xFF111827)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        selectedItemColor: bluePrimary,
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? bluePrimary
              : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: bluePrimary,
        secondary: cyanAccent,
        surface: backgroundNavy,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
      ),
      cardColor: backgroundNavy,
      dividerColor: Color(0x33EAF2FF),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimaryDark),
        bodyMedium: TextStyle(color: textPrimaryDark),
        titleLarge: TextStyle(color: textPrimaryDark),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundNavy,
        selectedItemColor: bluePrimary,
        unselectedItemColor: textSecondaryDark,
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? cyanAccent
              : textSecondaryDark,
        ),
      ),
    );
  }
}
