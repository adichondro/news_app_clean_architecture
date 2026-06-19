import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class SaveArticleUseCase {
  final ArticleRepository _articleRepository;

  SaveArticleUseCase(this._articleRepository);

  Future<void> call(ArticleEntity article) async {
    await _articleRepository.saveArticle(article);
  }
}
