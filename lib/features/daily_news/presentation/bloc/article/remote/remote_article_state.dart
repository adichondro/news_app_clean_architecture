import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

/// Abstract base state for remote news article BLoC operations.
abstract class RemoteArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  final Failure? error;

  const RemoteArticleState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

/// Represents the loading state when fetching remote news articles.
class RemoteArticlesLoading extends RemoteArticleState {
  const RemoteArticlesLoading();
}

/// Represents the successful completion state holding fetched remote [articles].
class RemoteArticlesDone extends RemoteArticleState {
  const RemoteArticlesDone(List<ArticleEntity> articles) : super(articles: articles);
}

/// Represents an error state holding a network or server [error].
class RemoteArticlesError extends RemoteArticleState {
  const RemoteArticlesError(Failure error) : super(error: error);
}
