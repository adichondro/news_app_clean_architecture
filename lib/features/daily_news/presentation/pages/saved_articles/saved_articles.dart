import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/clear_all_saved_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/custom_snackbar.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/empty_state_view.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/horizontal_article_card.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/saved_articles_empty_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SavedArticles extends HookWidget {
  const SavedArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'Daily News',
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => _onBackButtonTapped(context),
          icon: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: BlocBuilder<LocalArticleBloc, LocalArticleState>(
        builder: (context, state) {
          final articles = state.articles ?? [];
          final articleCount = articles.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Articles',
                        style: AppTypography.headlinesLargeMobile,
                      ),
                      Text(
                        '$articleCount articles bookmarked for later',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  if (articleCount > 0)
                    ClearAllSavedButton(
                      onTap: () => _onClearAllPressed(context),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(child: _buildStateView(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStateView(BuildContext context, LocalArticleState state) {
    if (state is LocalArticlesLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            return const HorizontalArticleCard(
              article: ArticleEntity(
                title: 'This is the placeholder title of the article loading',
                publishedAt: 'YYYY-MM-DD',
                urlToImage: '',
              ),
            );
          },
        ),
      );
    } else if (state is LocalArticlesDone) {
      if (state.articles!.isEmpty) {
        return SavedArticlesEmptyState(
          onExploreTapped: () {
            //TODO: Handle explore tapped
          },
        );
      }
      return _buildArticlesList(state.articles!);
    } else {
      return EmptyStateView(
        illustration: SvgPicture.asset(
          'assets/illustrations/error_saved_articles_illustration.svg',
        ),
        title: 'Oops! Something went wrong',
        message: 'Failed to load your saved articles. Please try again.',
        actionLabel: 'Refresh',
        actionIcon: Icons.refresh,
        onActionPressed: () {
          context.read<LocalArticleBloc>().add(const GetSavedArticles());
        },
      );
    }
  }

  Widget _buildArticlesList(List<ArticleEntity> articles) {
    return ListView.separated(
      itemCount: articles.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final article = articles[index];
        return HorizontalArticleCard(
          article: article,
          onDeletePressed: () => _onRemoveArticle(context, article),
          onPressed: () => _onArticlePressed(context, article),
        );
      },
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, AppRoutes.articleDetails, arguments: article);
  }

  void _onRemoveArticle(BuildContext context, ArticleEntity article) {
    BlocProvider.of<LocalArticleBloc>(context).add(RemoveArticle(article));
    CustomSnackbar.show(context, message: 'Article removed!');
  }

  void _onClearAllPressed(BuildContext context) {
    BlocProvider.of<LocalArticleBloc>(context).add(ClearArticles());
    CustomSnackbar.show(context, message: 'All articles cleared!');
  }
}
