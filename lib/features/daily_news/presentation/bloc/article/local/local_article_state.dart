import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_message_type.dart';

/// Abstract base state for local bookmarked article BLoC operations.
abstract class LocalArticleState extends Equatable {
  final List<ArticleEntity>? articles;

  const LocalArticleState({this.articles});

  /// Evaluates whether a given [article] is already present in the saved articles list.
  bool isArticleSaved(ArticleEntity article) {
    if (articles == null || articles!.isEmpty) return false;
    return articles!.any((element) => element.url == article.url);
  }

  @override
  List<Object?> get props => [articles];
}

/// Represents the loading state when fetching or mutating local articles.
class LocalArticlesLoading extends LocalArticleState {
  const LocalArticlesLoading();
}

/// Represents the successful completion state holding saved articles and an optional feedback [messageType].
class LocalArticlesDone extends LocalArticleState {
  final LocalArticleMessageType? messageType;

  const LocalArticlesDone(List<ArticleEntity> articles, {this.messageType})
      : super(articles: articles);

  @override
  List<Object?> get props => [articles, messageType];
}

/// Represents an error state holding a [Failure] and preserving previous [articles].
class LocalArticlesError extends LocalArticleState {
  final Failure error;

  const LocalArticlesError(this.error, {super.articles});

  @override
  List<Object?> get props => [error, articles];
}
