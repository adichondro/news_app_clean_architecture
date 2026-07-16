import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/util/string_extension.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/custom_snackbar.dart';
import 'package:news_app_clean_architecture/core/util/date_extension.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/article_hero_section.dart';

class ArticleDetailView extends HookWidget {
  final ArticleEntity? article;

  const ArticleDetailView({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Daily News',
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.primary, size: 28),
        onPressed: () => _onBackButtonPressed(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.primary),
          onPressed: () {
            // TODO: implement share functionality
            CustomSnackbar.show(context, message: 'Share coming soon!');
          },
        ),
        _buildBookmarkAction(),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ArticleHeroSection(
            imageUrl: article?.urlToImage,
            category: 'NEWS',
            title: (article?.title).valueOr('No Title'),
            authorName: (article?.author).valueOr('Unknown Author'),
            dateAndReadTime: '${(article?.publishedAt).toTimeAgo()} • 8 min read',
          ),
          _buildArticleDescription(),
        ],
      ),
    );
  }

  Widget _buildArticleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Text(
        '${article?.description.valueOr('')}\n\n${article?.content.valueOr('')}'.trim(),
        style: AppTypography.bodyMedium,
      ),
    );
  }

  Widget _buildBookmarkAction() {
    return BlocBuilder<LocalArticleBloc, LocalArticleState>(
      builder: (context, state) {
        final savedArticles =
            state.articles?.where((element) => element.url == article?.url) ??
            [];
        final isSaved = savedArticles.isNotEmpty;
        final savedArticle = isSaved ? savedArticles.first : null;
        return IconButton(
          onPressed: () =>
              _onFloatingActionButtonPressed(context, isSaved, savedArticle),
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.primary,
          ),
        );
      },
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFloatingActionButtonPressed(
    BuildContext context,
    bool isSaved,
    ArticleEntity? savedArticle,
  ) {
    if (isSaved && savedArticle != null) {
      BlocProvider.of<LocalArticleBloc>(
        context,
      ).add(RemoveArticle(savedArticle));
      CustomSnackbar.show(context, message: 'Article removed!');
    } else {
      BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));
      CustomSnackbar.show(context, message: 'Article saved!');
    }
  }
}
