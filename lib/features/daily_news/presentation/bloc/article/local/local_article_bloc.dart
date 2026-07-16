import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_usecase.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticleState> {
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final ClearArticleUseCase _clearArticleUseCase;
  LocalArticleBloc(
    this._getSavedArticlesUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
    this._clearArticleUseCase,
  ) : super(const LocalArticlesLoading()) {
    on<GetSavedArticles>(onGetSavedArticles);
    on<SaveArticle>(onSaveArticle);
    on<RemoveArticle>(onRemoveArticle);
    on<ClearArticles>(onClearArticles);
  }

  Future<void> onGetSavedArticles(
    GetSavedArticles event,
    Emitter<LocalArticleState> emit,
  ) async {
    final dataState = await _getSavedArticlesUseCase();

    if (dataState is DataSuccess) {
      emit(LocalArticlesDone(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(LocalArticlesError(dataState.error!));
    }
  }

  Future<void> onSaveArticle(
    SaveArticle event,
    Emitter<LocalArticleState> emit,
  ) async {
    try {
      await _saveArticleUseCase(params: event.article);

      final dataState = await _getSavedArticlesUseCase();

      if (dataState is DataSuccess) {
        emit(LocalArticlesDone(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(LocalArticlesError(dataState.error!));
      }
    } catch (e) {
      emit(LocalArticlesError(CacheFailure('Failed to save article: $e')));
    }
  }

  Future<void> onRemoveArticle(
    RemoveArticle event,
    Emitter<LocalArticleState> emit,
  ) async {
    try {
      await _removeArticleUseCase(params: event.article);
      final dataState = await _getSavedArticlesUseCase();

      if (dataState is DataSuccess) {
        emit(LocalArticlesDone(dataState.data!));
      } else if (dataState is DataFailed) {
        emit(LocalArticlesError(dataState.error!));
      }
    } catch (e) {
      emit(LocalArticlesError(CacheFailure('Failed to remove article: $e')));
    }
  }

  Future<void> onClearArticles(
    ClearArticles event,
    Emitter<LocalArticleState> emit,
  ) async {
    try {
      await _clearArticleUseCase.call();
      emit(const LocalArticlesDone([]));
    } catch (e) {
      emit(LocalArticlesError(CacheFailure('Failed to clear articles: $e')));
    }
  }
}
