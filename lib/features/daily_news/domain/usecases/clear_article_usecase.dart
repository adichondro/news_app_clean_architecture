import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecases/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

/// UseCase responsible for clearing all user-saved bookmarked articles.
class ClearArticleUseCase implements UseCase<DataState<void>, void> {
  final ArticleRepository _articleRepository;

  ClearArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({void params}) {
    return _articleRepository.clearSavedArticles();
  }
}
