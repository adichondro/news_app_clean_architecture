import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';

class AppTypography {
  // Prevent class instantiation
  AppTypography._();
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48, // Line height 56px
    letterSpacing: -0.96, // -0.02em * 48
    color: AppColors.textPrimary,
  );
  static const TextStyle headlinesLarge = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32, // Line height 40px
    letterSpacing: -0.32, // -0.01em * 32
    color: AppColors.textPrimary,
  );
  static const TextStyle headlinesLargeMobile = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28, // Line height 36px
    color: AppColors.textPrimary,
  );
  static const TextStyle headlinesMedium = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24, // Line height 32px
    color: AppColors.textPrimary,
  );
  static const TextStyle headlinesSmall = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20, // Line height 28px
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18, // Line height 28px
    color: AppColors.textSecondary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16, // Line height 24px
    color: AppColors.textSecondary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14, // Line height 20px
    color: AppColors.textSecondary,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14, // Line height 20px
    letterSpacing: 0.1,
    color: AppColors.textSecondary,
  );
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12, // Line height 16px
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );
}
