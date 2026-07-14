import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_radius.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Skeleton.replace(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.stackMd,
          vertical: AppSpacing.stackSm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.9),
          borderRadius: AppRadius.pillRadius,
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.onPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
