import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';

class AppTypography {
  //prevent class instantiation
  AppTypography._();

  static const TextStyle headlinesLarge = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlinesMedium = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );
}
