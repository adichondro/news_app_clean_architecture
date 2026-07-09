import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';
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
        const SizedBox(width: AppSpacing.base),
      ],
    );
  }

  BlocConsumer<RemoteArticlesBloc, RemoteArticleState> _buildBody() {
    return BlocConsumer<RemoteArticlesBloc, RemoteArticleState>(
      listener: (context, state) {
        if (state is RemoteArticlesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error?.message ?? 'An unexpected error occurred.',
              ),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const ArticleTile(
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error?.message ?? 'Failed to load articles',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RemoteArticlesBloc>().add(
                        const GetArticles(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is RemoteArticlesDone) {
          if (state.articles == null || state.articles!.isEmpty) {
            return const Center(
              child: Text(
                'No articles found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ArticleTile(
                article: state.articles![index],
                onArticleTilePressed: (article) =>
                    _onArticleTilePressed(context, article),
              );
            },
            itemCount: state.articles!.length,
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onArticleTilePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, AppRoutes.articleDetails, arguments: article);
  }

  void _onShowSavedArticleViewTapped(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.savedArticles);
  }
}
