import 'package:news_app_clean_architecture/core/usecases/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class RemoveArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _repository;

  RemoveArticleUseCase(this._repository);

  @override
  Future<void> call({ArticleEntity? params}) {
    return _repository.removeArticle(params!);
  }
}
