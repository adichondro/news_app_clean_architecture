import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';

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
        const SizedBox(height: AppSpacing.stackSm),
        Text(
          description ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: AppSpacing.stackMd),
        if (publishedAt != null && publishedAt!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timeline_outlined,
                size: 16,
                color: AppColors.outline,
              ),
              const SizedBox(width: AppSpacing.stackSm),
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
