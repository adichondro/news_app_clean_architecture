import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class RemoveArticleUseCase {
  final ArticleRepository _repository;

  RemoveArticleUseCase(this._repository);

  Future<void> call(ArticleEntity article) async {
    return await _repository.removeArticle(article);
  }
}
