import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

/// Abstract base event for local bookmarked article BLoC operations.
abstract class LocalArticleEvent {
  const LocalArticleEvent();
}

/// Event triggering retrieval of saved bookmarked articles from local database.
class GetSavedArticles extends LocalArticleEvent {
  const GetSavedArticles();
}

/// Event triggering saving of a news article into local database.
class SaveArticle extends LocalArticleEvent {
  final ArticleEntity article;

  const SaveArticle(this.article);
}

/// Event triggering removal of a bookmarked article from local database.
class RemoveArticle extends LocalArticleEvent {
  final ArticleEntity article;

  const RemoveArticle(this.article);
}

/// Event triggering clearing of all bookmarked articles from local database.
class ClearArticles extends LocalArticleEvent {
  const ClearArticles();
}