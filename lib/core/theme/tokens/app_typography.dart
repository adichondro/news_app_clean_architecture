import 'package:flutter/material.dart';

/// Centralized design system typography scale tokens using WorkSans and Inter Google Fonts.
class AppTypography {
  AppTypography._();

// Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.96,
  );

  // Headline Styles
  static const TextStyle headlinesLarge = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.32,
  );

  static const TextStyle headlinesLargeMobile = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
  );

  static const TextStyle headlinesMedium = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  static const TextStyle headlinesSmall = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  // Body Copy Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  // Label & Caption Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
  );
}
