import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

/// Data Transfer Object (DTO) for news articles supporting JSON serialization and SQLite mapping.
class ArticleModel {
  final int? id;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final String? sourceName;

  const ArticleModel({
    this.id,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> data) {
    return ArticleModel(
      sourceName: data['source'] != null ? data['source']['name'] as String? : null,
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
      sourceName: data.author,
    );
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      sourceName: sourceName,
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
      sourceName: entity.sourceName,
    );
  }
}
