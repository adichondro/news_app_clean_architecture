import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/util/date_extension.dart';
import 'package:news_app_clean_architecture/core/util/string_extension.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_radius.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/atoms/article_thumbnail.dart';

class HorizontalArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback? onPressed;
  final VoidCallback? onDeletePressed;

  const HorizontalArticleCard({
    super.key,
    required this.article,
    this.onPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(width: 1, color: AppColors.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.mediumRadius,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ArticleThumbnail(
                    imageUrl: article.urlToImage,
                    aspectRatio: 1.0,
                    borderRadius: AppRadius.smallRadius,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TECHNOLOGY',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.60,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        article.title.valueOr('No Title'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlinesSmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Expanded(
                            child: Text(
                              article.publishedAt.toTimeAgo(),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onDeletePressed != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    onPressed: onDeletePressed,
                    icon: Icon(
                      Icons.bookmark_remove_outlined,
                      color: AppColors.primary,
                    ),
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
