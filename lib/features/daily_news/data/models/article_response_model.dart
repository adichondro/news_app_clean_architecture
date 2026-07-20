import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';


class ArticleResponseModel {
  final String? status;
  final int? totalResults;
  final List<ArticleModel>? articles;
  const ArticleResponseModel({
    this.status,
    this.totalResults,
    this.articles,
  });


  factory ArticleResponseModel.fromJson(Map<String, dynamic> json) {
    return ArticleResponseModel(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      articles: json['articles'] != null
          ? (json['articles'] as List)
              .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}