import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/util/date_extension.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_radius.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_shadow.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/category_chip.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/save_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/atoms/article_thumbnail.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/molecules/article_info.dart';

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
                  const Positioned(
                    left: 12,
                    top: 12,
                    child: CategoryChip(label: 'TECHNOLOGY'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArticleInfo(
                      title: article.title,
                      description: article.description,
                    ),
                    const SizedBox(height: AppSpacing.stackSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.secondaryContainer,
                              child: const Icon(
                                Icons.person,
                                size: 14,
                                color: AppColors.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.stackSm),
                            Text(
                              '${article.author ?? 'Unknown'} • ${article.publishedAt.toTimeAgo()}',
                              style: AppTypography.labelMedium,
                            ),
                          ],
                        ),
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
