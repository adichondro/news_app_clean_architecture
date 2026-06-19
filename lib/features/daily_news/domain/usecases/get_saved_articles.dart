import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class GetSavedArticlesUseCase {
  final ArticleRepository _articleRepository;

  GetSavedArticlesUseCase(this._articleRepository);
  Future<List<ArticleEntity>> call() async {
    return await _articleRepository.getSavedArticles();
  }
}
