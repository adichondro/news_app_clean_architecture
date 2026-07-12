import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';

class CategoryBadge extends StatelessWidget {
  final String text;
  const CategoryBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: AppColors.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.onSecondaryContainer,
        ),
      ),
    );
  }
}
