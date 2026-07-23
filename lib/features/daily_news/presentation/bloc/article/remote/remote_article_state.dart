import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

abstract class RemoteArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  final Failure? error;

  const RemoteArticleState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

class RemoteArticlesLoading extends RemoteArticleState {
  const RemoteArticlesLoading();
  
}

class RemoteArticlesDone extends RemoteArticleState {
  const RemoteArticlesDone(List<ArticleEntity> articles) : super(articles: articles);

}

class RemoteArticlesError extends RemoteArticleState {
  const RemoteArticlesError(Failure error) : super(error: error);
}
