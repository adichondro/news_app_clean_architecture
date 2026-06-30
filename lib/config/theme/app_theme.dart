import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    ),
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.primary),
    titleTextStyle: AppTypography.headlinesMedium,
  );
}