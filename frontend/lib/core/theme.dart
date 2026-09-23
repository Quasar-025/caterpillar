import 'package:flutter/material.dart';

class CatTheme {
  static const Color yellow = Color(0xFFFFCD11);
  static const Color black = Color(0xFF0B0B0B);
  static const Color panel = Color(0xFF161616);
  static const Color attention = Color(0xFFF5A524);
  static const Color action = Color(0xFFE85D04);
  static const Color critical = Color(0xFFD90429);
  static const Color safe = Color(0xFF2A9D4A);

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: yellow,
      onPrimary: black,
      surface: black,
      onSurface: Colors.white,
      secondary: panel,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: black,
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: yellow,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: yellow,
        height: 80,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 64),
          backgroundColor: yellow,
          foregroundColor: black,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
