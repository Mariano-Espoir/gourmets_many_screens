import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark
              ? 'Activer le thème clair'
              : 'Activer le thème sombre',
          onPressed: ThemeController.toggle,
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        );
      },
    );
  }
}
