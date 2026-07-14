import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_radius.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryBadge extends StatelessWidget {
  final String text;
  const CategoryBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Skeleton.replace(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        decoration: ShapeDecoration(
          color: AppColors.secondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.pillRadius,
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
