import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class ClearArticleUseCase {
  final ArticleRepository _articleRepository;

  ClearArticleUseCase(this._articleRepository);

  Future<void> call() async {
    return await _articleRepository.clearSavedArticles();
  }
}
