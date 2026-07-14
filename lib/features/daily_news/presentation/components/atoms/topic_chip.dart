import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_radius.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';

class TopicChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const TopicChip({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.pillRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.gutter,
          vertical: AppSpacing.base,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer.withValues(alpha: 0.3),
          borderRadius: AppRadius.pillRadius,
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
