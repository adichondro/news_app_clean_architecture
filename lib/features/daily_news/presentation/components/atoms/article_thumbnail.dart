import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_radius.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double aspectRatio;
  final BorderRadiusGeometry? borderRadius;

  const ArticleThumbnail({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.mediumRadius;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: radius,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: ClipRRect(borderRadius: radius, child: _buildImage()),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const Center(
        child: Icon(Icons.image_outlined, color: AppColors.outline, size: 40),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Skeletonizer(
        enabled: true,
        child: Container(color: AppColors.surfaceVariant),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.broken_image, color: AppColors.outline),
      ),
    );
  }
}
