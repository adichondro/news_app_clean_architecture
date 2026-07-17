import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_radius.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';

class AuthorMetaInfo extends StatelessWidget {
  final String authorName;
  final String dateAndReadTime;

  const AuthorMetaInfo({
    super.key,
    required this.authorName,
    required this.dateAndReadTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: ShapeDecoration(
            color: AppColors.surfaceVariant,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: AppColors.onPrimary.withValues(alpha: 0.20),
              ),
              borderRadius: AppRadius.pillRadius,
            ),
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                dateAndReadTime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.80),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
