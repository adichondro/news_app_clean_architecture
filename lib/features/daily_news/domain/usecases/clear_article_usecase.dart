import 'package:news_app_clean_architecture/core/usecases/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class ClearArticleUseCase implements UseCase<void, void> {
  final ArticleRepository _articleRepository;

  ClearArticleUseCase(this._articleRepository);

  @override
  Future<void> call({void params}) async {
    return await _articleRepository.clearSavedArticles();
  }
}
