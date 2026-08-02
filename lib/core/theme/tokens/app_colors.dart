import 'package:flutter/material.dart';

/// Centralized design system color tokens adhering to Material 3 palette specifications.
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF0F1C36);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF25314C);
  static const Color onPrimaryContainer = Color(0xFF8D99B9);

  // Secondary Colors
  static const Color secondary = Color(0xFF4355B9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF8596FF);
  static const Color onSecondaryContainer = Color(0xFF11278E);

  // Background & Surface Colors
  static const Color background = Color(0xFFFDF8FD);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color surface = Color(0xFFFDF8FD);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color surfaceVariant = Color(0xFFE5E1E7);
  static const Color onSurfaceVariant = Color(0xFF45464D);
  static const Color outline = Color(0xFF75777E);
  static const Color outlineVariant = Color(0xFFC5C6CE);

  // Semantic Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);

  // Aliases
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textLight = onPrimary;
}
