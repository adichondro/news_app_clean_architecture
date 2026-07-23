import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/custom_snackbar.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/empty_state_view.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/article_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody());
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      title: 'Daily News',
      actions: [
        IconButton(
          onPressed: () => _onShowSavedArticleViewTapped(context),
          icon: const Icon(Icons.bookmark),
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  Widget _buildBody() {
    return BlocListener<LocalArticleBloc, LocalArticleState>(
      listener: (context, state) {
        if (state is LocalArticlesError) {
          CustomSnackbar.show(
            context,
            message: state.error.message,
            isError: true,
          );
        }
      },
      child: BlocConsumer<RemoteArticlesBloc, RemoteArticleState>(
        listener: (context, state) {
          if (state is RemoteArticlesError) {
            CustomSnackbar.show(
              context,
              message: state.error?.message ?? 'An unexpected error occurred.',
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state is RemoteArticlesLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.xl),
                itemBuilder: (context, index) {
                  return const ArticleCard(
                    article: ArticleEntity(
                      title:
                          'This is the placeholder title of the article loading',
                      description:
                          'This is a placeholder description for loading articles so that the skeleton layout is formed proportionally.',
                      publishedAt: 'YYYY-MM-DD',
                      urlToImage: '',
                    ),
                  );
                },
              ),
            );
          }

          if (state is RemoteArticlesError) {
            return EmptyStateView(
              illustration: SvgPicture.asset(
                'assets/illustrations/connection_error_illustration.svg',
              ),
              title: 'Connection Error',
              message: 'Failed to load articles. Please check your connection.',
              onActionPressed: () =>
                  context.read<RemoteArticlesBloc>().add(const GetArticles()),
              actionLabel: 'Try Again',
            );
          }

          if (state is RemoteArticlesDone) {
            if (state.articles == null || state.articles!.isEmpty) {
              return EmptyStateView(
                illustration: SvgPicture.asset(
                  'assets/illustrations/no_articles_illustration.svg',
                ),
                title: 'No Articles Found',
                message:
                    'No articles are currently available. Please check back later for updates.',
                onActionPressed: () =>
                    context.read<RemoteArticlesBloc>().add(const GetArticles()),
                actionLabel: 'Try Again',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.articles!.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.xl),
              itemBuilder: (context, index) {
                final article = state.articles![index];
                return BlocSelector<LocalArticleBloc, LocalArticleState, bool>(
                  selector: (localState) {
                    return localState is LocalArticlesDone &&
                        localState.isArticleSaved(article);
                  },
                  builder: (context, isSaved) {
                    return ArticleCard(
                      article: article,
                      isSaved: isSaved,
                      onArticlePressed: (article) =>
                          _onArticleTilePressed(context, article),
                      onSavePressed: (article) {
                        if (isSaved) {
                          context.read<LocalArticleBloc>().add(
                            RemoveArticle(article),
                          );
                          CustomSnackbar.show(
                            context,
                            message: 'Article removed!',
                          );
                        } else {
                          context.read<LocalArticleBloc>().add(
                            SaveArticle(article),
                          );
                          CustomSnackbar.show(
                            context,
                            message: 'Article saved!',
                          );
                        }
                      },
                    );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _onArticleTilePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, AppRoutes.articleDetails, arguments: article);
  }

  void _onShowSavedArticleViewTapped(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.savedArticles);
  }
}
