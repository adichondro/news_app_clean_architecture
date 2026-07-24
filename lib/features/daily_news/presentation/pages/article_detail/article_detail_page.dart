import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/util/string_extension.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/organisms/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_spacing.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/custom_snackbar.dart';
import 'package:news_app_clean_architecture/core/util/date_extension.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/article_hero_section.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity? article;

  const ArticleDetailPage({super.key, this.article});

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
    return BlocListener<LocalArticleBloc, LocalArticleState>(
      listener: (context, state) {
        if (state is LocalArticlesError) {
          CustomSnackbar.show(
            context,
            message: state.error.message,
            isError: true,
          );
        } else if (state is LocalArticlesDone && state.message != null) {
          CustomSnackbar.show(
            context,
            message: state.message!,
          );
        }
      },
      child: SingleChildScrollView(
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
        final isSaved = article != null && state.isArticleSaved(article!);
        return IconButton(
          onPressed: () => _onBookmarkPressed(context, isSaved),
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

  void _onBookmarkPressed(BuildContext context, bool isSaved) {
    if (article == null) return;
    if (isSaved) {
      context.read<LocalArticleBloc>().add(RemoveArticle(article!));
    } else {
      context.read<LocalArticleBloc>().add(SaveArticle(article!));
    }
  }
}
