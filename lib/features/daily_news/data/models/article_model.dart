import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.id,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> data) {
    return ArticleModel(
      author: data['author'] as String?,
      title: data['title'] as String?,
      description: data['description'] as String?,
      url: data['url'] as String?,
      urlToImage: data['urlToImage'] as String?,
      publishedAt: data['publishedAt'] as String?,
      content: data['content'] as String?,
    );
  }

  factory ArticleModel.fromTableData(ArticleTableData data) {
    return ArticleModel(
      id: data.id,
      author: data.author,
      title: data.title,
      description: data.description,
      url: data.url,
      urlToImage: data.urlToImage,
      publishedAt: data.publishedAt,
      content: data.content,
    );
  }
}
