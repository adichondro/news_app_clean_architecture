import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/article_detail/article_detail_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/daily_news/daily_news_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/saved_articles/saved_articles_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String articleDetails = '/article-details';
  static const String savedArticles = '/saved-articles';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _materialRoute(const DailyNewsPage());

      case articleDetails:
        return _materialRoute(
          ArticleDetailPage(article: settings.arguments as ArticleEntity),
        );

      case savedArticles:
        return _materialRoute(const SavedArticlesPage());

      default:
        return _materialRoute(const DailyNewsPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
