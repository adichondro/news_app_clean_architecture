import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';

class ClearAllSavedButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ClearAllSavedButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.stackMd,
            vertical: AppSpacing.stackSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              const Icon(
                Icons.delete_sweep_rounded,
                size: 20,
                color: AppColors.error,
              ),
              const SizedBox(width: AppSpacing.stackSm),
              Text(
                'Clear All',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
