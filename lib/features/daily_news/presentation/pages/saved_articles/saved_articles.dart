import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/custom_snackbar.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/empty_state_view.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/horizontal_article_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SavedArticles extends HookWidget {
  const SavedArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'Saved Articles',
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
    return BlocBuilder<LocalArticleBloc, LocalArticleState>(
      builder: (context, state) {
        if (state is LocalArticlesLoading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.containerMargin),
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.stackMd),
              itemBuilder: (context, index) {
                return const HorizontalArticleCard(
                  article: ArticleEntity(
                    title:
                        'This is the placeholder title of the article loading',
                    publishedAt: 'YYYY-MM-DD',
                    urlToImage: '',
                  ),
                );
              },
            ),
          );
        } else if (state is LocalArticlesDone) {
          return _buildArticlesList(state.articles!);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildArticlesList(List<ArticleEntity> articles) {
    if (articles.isEmpty) {
      return const EmptyStateView(
        icon: Icons.bookmark_border_rounded,
        message: 'No saved articles yet.\nStart reading and save some!',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.containerMargin),
      itemCount: articles.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.stackMd),
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
}
