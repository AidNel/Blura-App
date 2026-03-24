import 'package:flutter/material.dart';

class AppTheme {
  static bool _isDark = true;

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

  static Color get accent => const Color(0xFF4DA3FF);

  static Color get background =>
      _isDark ? const Color(0xFF0E1116) : const Color(0xFFF5F7FB);

  static Color get card =>
      _isDark ? const Color(0xFF171B22) : const Color(0xFFFFFFFF);

  static Color get textPrimary =>
      _isDark ? const Color(0xFFF5F7FA) : const Color(0xFF111827);

  static Color get textSecondary =>
      _isDark ? const Color(0xFF9AA4B2) : const Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4DA3FF),
        secondary: Color(0xFF4DA3FF),
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
        selectedItemColor: Color(0xFF4DA3FF),
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Color(0xFF4DA3FF)
              : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0E1116),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4DA3FF),
        secondary: Color(0xFF4DA3FF),
        surface: Color(0xFF171B22),
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0E1116),
        foregroundColor: Color(0xFFF5F7FA),
        elevation: 0,
      ),
      cardColor: const Color(0xFF171B22),
      dividerColor: Color(0x33F5F7FA),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF5F7FA)),
        bodyMedium: TextStyle(color: Color(0xFFF5F7FA)),
        titleLarge: TextStyle(color: Color(0xFFF5F7FA)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF171B22),
        selectedItemColor: Color(0xFF4DA3FF),
        unselectedItemColor: Color(0xFF9AA4B2),
        type: BottomNavigationBarType.fixed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Color(0xFF4DA3FF)
              : const Color(0xFF374151),
        ),
      ),
    );
  }
}
