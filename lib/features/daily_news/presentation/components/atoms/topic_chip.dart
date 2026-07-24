import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_radius.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';

/// Atom component untuk topik interaktif (pill chip) yang dapat di-tap.
class TopicChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const TopicChip({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
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
      ),
    );
  }
}
