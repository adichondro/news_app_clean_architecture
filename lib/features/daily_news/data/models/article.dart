import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class ArticleModel extends ArticleEntity{
  const ArticleModel ({
  int? id,
  String? author,
  String? title,
  String? description,
  String? url,
  String? urlToImage,
  String? publishedAt,
  String? content,
  });


  factory ArticleModel.fromJson(Map<String,dynamic> data){
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