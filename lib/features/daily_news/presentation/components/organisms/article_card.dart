import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/util/date_extension.dart';
import 'package:news_app_clean_architecture/core/util/string_extension.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_radius.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_shadow.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/source_chip.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/save_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/atoms/article_thumbnail.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/molecules/article_info.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final bool isSaved;
  final ValueChanged<ArticleEntity>? onArticlePressed;
  final ValueChanged<ArticleEntity>? onSavePressed;

  const ArticleCard({
    super.key,
    required this.article,
    this.isSaved = false,
    this.onArticlePressed,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppShadow.level1,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.mediumRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onArticlePressed?.call(article),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ArticleThumbnail(
                    imageUrl: article.urlToImage,
                    aspectRatio: 16 / 9,
                    borderRadius: BorderRadius.zero,
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: SourceChip(
                      label: (article.sourceName ?? article.author).valueOr('NEWS').toUpperCase(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArticleInfo(
                      title: article.title,
                      description: article.description,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Skeleton.replace(
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColors.secondaryContainer,
                                  child: const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: AppColors.onSecondaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xxs),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        article.author.valueOr('Unknown Author'),
                                        style: AppTypography.labelMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      ' • ${article.publishedAt.toTimeAgo()}',
                                      style: AppTypography.labelMedium,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        SaveButton(
                          isSaved: isSaved,
                          onSave: () => onSavePressed?.call(article),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
