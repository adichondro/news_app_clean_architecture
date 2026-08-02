import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/category_chip.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/molecules/author_meta_info.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleHeroSection extends StatelessWidget {
  final String? imageUrl;
  final String category;
  final String title;
  final String authorName;
  final String dateAndReadTime;

  const ArticleHeroSection({
    super.key,
    this.imageUrl,
    required this.category,
    required this.title,
    required this.authorName,
    required this.dateAndReadTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: Container(
                  color: AppColors.primaryContainer,
                ),
              ),
              errorWidget: (context, url, error) => _buildFallbackImage(),
            )
          else
            _buildFallbackImage(),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.0),
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CategoryChip(label: category),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: AppTypography.headlinesLargeMobile.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AuthorMetaInfo(
                  authorName: authorName,
                  dateAndReadTime: dateAndReadTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported,
            size: 50,
            color: AppColors.onPrimaryContainer,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No Image Available',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
