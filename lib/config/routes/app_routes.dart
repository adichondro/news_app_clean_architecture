import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/article_detail/article_detail.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';

class AppRoutes {
  static const String home = '/home';
  static const String articleDetails = '/ArticleDetails';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _materialRoute(const DailyNews());

      case articleDetails:
        return _materialRoute(
          ArticleDetailView(article: settings.arguments as ArticleEntity),
        );

      default:
        return _materialRoute(const DailyNews());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
