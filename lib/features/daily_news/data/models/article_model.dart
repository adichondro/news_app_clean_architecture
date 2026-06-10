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
      author: data['author'] ?? "",
      title: data['title'] ?? "",
      description: data['description'] ?? "",
      url: data['url'] ?? "",
      urlToImage: data['urlToImage'] ?? "",
      publishedAt: data['publishedAt'] ?? "",
      content: data['content'] ?? "",
    );
  }
}
