import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/article_detail/article_detail_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/daily_news/daily_news_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/saved_articles/saved_articles_page.dart';

/// Centralized route configuration and generator for application navigation.
class AppRoutes {
  /// Private constructor to prevent class instantiation.
  const AppRoutes._();

  /// Route name for the main daily news feed home page.
  static const String home = '/home';

  /// Route name for the article detail view page.
  static const String articleDetails = '/article-details';

  /// Route name for the bookmarked saved articles page.
  static const String savedArticles = '/saved-articles';

  /// Generates application routes dynamically based on [settings].
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Map requested route names to corresponding page widgets
    switch (settings.name) {
      case home:
        return _materialRoute(const DailyNewsPage());

      case articleDetails:
        // Extract required ArticleEntity passed via route arguments
        final article = settings.arguments as ArticleEntity;
        return _materialRoute(ArticleDetailPage(article: article));

      case savedArticles:
        return _materialRoute(const SavedArticlesPage());

      default:
        // Fallback route for unhandled route names
        return _materialRoute(const DailyNewsPage());
    }
  }

  /// Wraps a target [view] widget inside a standard [MaterialPageRoute].
  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}

