import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/custom_snackbar.dart';
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonPressed(context),
          child: const Icon(Icons.chevron_left, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ArticleHeroSection(
            imageUrl: article?.urlToImage,
            category: 'NEWS',
            title: article?.title ?? 'No Title',
            authorName: article?.author ?? 'Unknown Author',
            dateAndReadTime: _formatDate(article?.publishedAt),
          ),
          _buildArticleDescription(),
        ],
      ),
    );
  }

  Widget _buildArticleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Text(
        '${article!.description ?? ''}\n\n${article!.content ?? ''}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<LocalArticleBloc, LocalArticleState>(
      builder: (context, state) {
        final savedArticles =
            state.articles?.where((element) => element.url == article?.url) ??
            [];
        final isSaved = savedArticles.isNotEmpty;
        final savedArticle = isSaved ? savedArticles.first : null;
        return FloatingActionButton(
          onPressed: () =>
              _onFloatingActionButtonPressed(context, isSaved, savedArticle),
          child: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
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

  //TODO: Buat Ini Menjadi Global
  // (Helper Method Baru) Untuk merapikan format tanggal agar lebih enak dibaca
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Just now • 5 min read';
    // Contoh parse sederhana dari ISO8601 (2024-09-12T...) ke (2024-09-12)
    final date = dateStr.split('T').first;
    return '$date • 8 min read';
  }
}
