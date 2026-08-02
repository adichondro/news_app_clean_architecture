import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecases/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

/// UseCase responsible for saving a news article into local bookmarked storage.
class SaveArticleUseCase implements UseCase<DataState<void>, ArticleEntity> {
  final ArticleRepository _articleRepository;

  SaveArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({ArticleEntity? params}) {
    return _articleRepository.saveArticle(params!);
  }
}
