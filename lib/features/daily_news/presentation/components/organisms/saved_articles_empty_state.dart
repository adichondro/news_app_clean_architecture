import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/empty_state_view.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/atoms/topic_chip.dart';

class SavedArticlesEmptyState extends StatelessWidget {
  final VoidCallback onExploreTapped;

  const SavedArticlesEmptyState({super.key, required this.onExploreTapped});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            EmptyStateView(
              illustration: SvgPicture.asset(
                'assets/illustrations/saved_articles_illustration.svg',
              ),
              title: AppStrings.noSavedArticlesTitle,
              message: AppStrings.noSavedArticlesMessage,
              actionLabel: AppStrings.exploreNews,
              actionIcon: Icons.explore_outlined,
              onActionPressed: onExploreTapped,
            ),
            const SizedBox(height: AppSpacing.sectionXl),
            Text(
              AppStrings.popularTopicsTitle.toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.outline,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.xxs,
                children: const [
                  TopicChip(label: AppStrings.topicPolitics),
                  TopicChip(label: AppStrings.topicTechnology),
                  TopicChip(label: AppStrings.topicScience),
                  TopicChip(label: AppStrings.topicHealth),
                  TopicChip(label: AppStrings.topicBusiness),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
