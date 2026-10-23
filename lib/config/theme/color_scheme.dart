import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFF246B8E);
  static const Color lightBlue = Color(0xFFE8F4F8);
  static const Color accent = Color(0xFFFFC928);

  // Background and surfaces
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F3F5);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // Borders and dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEEF0F2);

  // Status colors
  static const Color success = Color(0xFF16A34A);
  static const Color successBackground = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFD97706);
  static const Color warningBackground = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFDC2626);
  static const Color errorBackground = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF0284C7);
  static const Color infoBackground = Color(0xFFE0F2FE);

  // Attendance-specific colors
  static const Color present = Color(0xFF16A34A);
  static const Color absent = Color(0xFFDC2626);
  static const Color late = Color(0xFFD97706);
  static const Color onLeave = Color(0xFF7C3AED);
}

class AppColorSchemes {
  AppColorSchemes._();

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.lightBlue,
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.accent,
    onSecondary: Color(0xFF332800),
    secondaryContainer: Color(0xFFFFF3C4),
    onSecondaryContainer: Color(0xFF664D00),
    tertiary: Color(0xFF5B67A5),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE8EAF9),
    onTertiaryContainer: Color(0xFF28346B),
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorBackground,
    onErrorContainer: Color(0xFF7F1D1D),
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    outline: Color(0xFF9CA3AF),
    outlineVariant: AppColors.border,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF29313A),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF9BD7F0),
  );
}
