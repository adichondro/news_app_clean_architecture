import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

abstract class LocalArticleEvent {
  const LocalArticleEvent();
}

class GetSavedArticles extends LocalArticleEvent {
  const GetSavedArticles();
}

class SaveArticle extends LocalArticleEvent {
  final ArticleEntity article;
  const SaveArticle(this.article);
}

class RemoveArticle extends LocalArticleEvent {
  final ArticleEntity article;
  const RemoveArticle(this.article);
}

class ClearArticles extends LocalArticleEvent {
  const ClearArticles();
}