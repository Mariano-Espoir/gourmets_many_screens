import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static void toggle() {
    mode.value = mode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      cardTheme: const CardThemeData(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      cardTheme: const CardThemeData(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
    );
  }
}
