import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/app_settings_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlueraApp());
}

class BlueraApp extends StatelessWidget {
  const BlueraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsService.instance,
      builder: (context, settings, _) {
        final Brightness systemBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;

        AppTheme.setThemeMode(
          settings.themeMode,
          systemBrightness: systemBrightness,
        );

        return MaterialApp(
          title: 'Bluera',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
