import 'package:flutter/material.dart';

class CatTheme {
  static const Color yellow = Color(0xFFFFCD11);
  static const Color black = Color(0xFF090A0A);
  static const Color panel = Color(0xFF141617);
  static const Color panelRaised = Color(0xFF1C1F20);
  static const Color panelHighlight = Color(0xFF242829);
  static const Color divider = Color(0xFF343839);
  static const Color textPrimary = Color(0xFFF7F6F2);
  static const Color textMuted = Color(0xFFA8AEAE);
  static const Color attention = Color(0xFFFFC400);
  static const Color action = Color(0xFFF47B20);
  static const Color critical = Color(0xFFD82920);
  static const Color safe = Color(0xFF48A868);
  static const double panelRadius = 12;

  static double pagePadding(double width) => width >= 900 ? 28 : 18;

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: yellow,
      onPrimary: black,
      surface: black,
      onSurface: textPrimary,
      secondary: yellow,
      onSecondary: black,
      error: critical,
      onError: Colors.white,
      surfaceContainer: panel,
      surfaceContainerHigh: panelRaised,
      outline: divider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: black,
      dividerColor: divider,
      splashColor: yellow.withValues(alpha: 0.12),
      highlightColor: yellow.withValues(alpha: 0.08),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 48,
          height: 0.98,
          letterSpacing: -1.6,
          fontWeight: FontWeight.w800,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 36,
          height: 1,
          letterSpacing: -1,
          fontWeight: FontWeight.w800,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          height: 1.08,
          letterSpacing: -0.5,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          height: 1.15,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          height: 1.2,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16, height: 1.4),
        bodyMedium: TextStyle(color: textMuted, fontSize: 14, height: 1.35),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: textMuted,
          fontSize: 12,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: panel,
        indicatorColor: yellow,
        height: 76,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        iconTheme: WidgetStatePropertyAll(IconThemeData(size: 26)),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: panel,
        indicatorColor: yellow,
        minWidth: 88,
        groupAlignment: -0.55,
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: IconThemeData(color: black, size: 28),
        unselectedIconTheme: IconThemeData(color: textMuted, size: 26),
        selectedLabelTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 64),
          backgroundColor: yellow,
          foregroundColor: black,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: panel,
        elevation: 2,
        shadowColor: Color(0x66000000),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: divider),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
