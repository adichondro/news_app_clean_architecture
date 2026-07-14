import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_primary_button.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/atoms/topic_chip.dart';

class SavedArticlesEmptyState extends StatelessWidget {
  final VoidCallback onExploreTapped;

  const SavedArticlesEmptyState({super.key, required this.onExploreTapped});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerMargin,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/illustrations/saved_articles_illustration.svg',
              ),
              const SizedBox(height: AppSpacing.stackLg),
              Text(
                'No Saved Articles',
                textAlign: TextAlign.center,
                style: AppTypography.headlinesMedium,
              ),
              const SizedBox(height: AppSpacing.stackSm),
              Text(
                'Articles you save will appear here to read later. Find interesting news and save it using the bookmark icon.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.stackLg),
              AppPrimaryButton(
                text: 'Explore News',
                icon: Icons.explore_outlined,
                onPressed: onExploreTapped,
              ),
              const SizedBox(height: AppSpacing.sectionPaddingXl),
              Text(
                'Popular Topics for You'.toUpperCase(),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.outline,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.stackLg),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.gutter,
                runSpacing: AppSpacing.stackSm,
                children: [
                  TopicChip(label: 'Politics'),
                  TopicChip(label: 'Technology'),
                  TopicChip(label: 'Science'),
                  TopicChip(label: 'Health'),
                  TopicChip(label: 'Business'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
