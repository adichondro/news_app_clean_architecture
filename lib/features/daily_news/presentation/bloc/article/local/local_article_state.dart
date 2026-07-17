import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

abstract class LocalArticleState extends Equatable {
  final List<ArticleEntity>? articles;

  const LocalArticleState({this.articles});

  bool isArticleSaved(ArticleEntity article) {
    if (articles == null || articles!.isEmpty) return false;
    return articles!.any((element) => element.url == article.url);
  }

  @override
  List<Object?> get props => [articles];
}

class LocalArticlesLoading extends LocalArticleState {
  const LocalArticlesLoading();
}

class LocalArticlesDone extends LocalArticleState {
  const LocalArticlesDone(List<ArticleEntity> article)
    : super(articles: article);
}

class LocalArticlesError extends LocalArticleState {
  final Failure error;
  const LocalArticlesError(this.error);
}
