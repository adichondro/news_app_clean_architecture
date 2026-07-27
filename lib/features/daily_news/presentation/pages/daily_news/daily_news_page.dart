import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/util/failure_extension.dart';
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

class DailyNewsPage extends StatelessWidget {
  const DailyNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody());
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      title: AppStrings.appTitle,
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
            message: state.error.toUserMessage(),
            isError: true,
          );
        } else if (state is LocalArticlesDone && state.messageType != null) {
          CustomSnackbar.show(
            context,
            message: state.messageType!.toText(),
          );
        }
      },
      child: BlocConsumer<RemoteArticlesBloc, RemoteArticleState>(
        listener: (context, state) {
          if (state is RemoteArticlesError) {
            CustomSnackbar.show(
              context,
              message: state.error?.toUserMessage() ?? AppStrings.unexpectedError,
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
                      title: AppStrings.placeholderTitle,
                      description: AppStrings.placeholderDescription,
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
              title: AppStrings.connectionErrorTitle,
              message: AppStrings.connectionErrorMessage,
              onActionPressed: () =>
                  context.read<RemoteArticlesBloc>().add(const GetArticles()),
              actionLabel: AppStrings.tryAgain,
            );
          }

          if (state is RemoteArticlesDone) {
            if (state.articles == null || state.articles!.isEmpty) {
              return EmptyStateView(
                illustration: SvgPicture.asset(
                  'assets/illustrations/no_articles_illustration.svg',
                ),
                title: AppStrings.noArticlesFoundTitle,
                message: AppStrings.noArticlesFoundMessage,
                onActionPressed: () =>
                    context.read<RemoteArticlesBloc>().add(const GetArticles()),
                actionLabel: AppStrings.tryAgain,
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
                    return localState.isArticleSaved(article);
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
                        } else {
                          context.read<LocalArticleBloc>().add(
                            SaveArticle(article),
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
