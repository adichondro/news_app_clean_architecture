import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';

class ArticleInfo extends StatelessWidget {
  final String? title;
  final String? description;
  final String? publishedAt;

  const ArticleInfo({
    super.key,
    this.title,
    this.description,
    this.publishedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.headlinesSmall,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          description ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (publishedAt != null && publishedAt!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timeline_outlined,
                size: 16,
                color: AppColors.outline,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  publishedAt!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
