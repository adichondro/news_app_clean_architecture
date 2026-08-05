import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_message_type.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

/// BLoC managing state for local bookmarked article operations (save, remove, fetch, clear).
class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticleState> {
  final GetSavedArticlesUseCase _getSavedArticlesUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final ClearArticleUseCase _clearArticleUseCase;

  /// Creates a [LocalArticleBloc] with required use case dependencies.
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

  /// Handles fetching bookmarked articles from local database.
  Future<void> onGetSavedArticles(
    GetSavedArticles event,
    Emitter<LocalArticleState> emit,
  ) async {
    final dataState = await _getSavedArticlesUseCase();
    dataState.fold(
      (failure) => emit(LocalArticlesError(failure, articles: state.articles)),
      (articles) => emit(LocalArticlesDone(articles)),
    );
  }

  /// Handles saving an article to local database and refreshing state.
  Future<void> onSaveArticle(
    SaveArticle event,
    Emitter<LocalArticleState> emit,
  ) async {
    final currentArticles = state.articles ?? [];
    
    // Guard against redundant save requests if article is already saved
    if (state.isArticleSaved(event.article)) return;

    // Optimistically update state so UI toggles instantly and handles rapid taps
    final updatedArticles = List<ArticleEntity>.from(currentArticles)..add(event.article);
    emit(LocalArticlesDone(
      updatedArticles,
      messageType: LocalArticleMessageType.saved,
    ));

    final saveState = await _saveArticleUseCase(params: event.article);
    
    await saveState.fold(
      (failure) async {
        // Revert optimistic state on DB failure
        emit(LocalArticlesError(failure, articles: currentArticles));
      },
      (_) async {
        // Silently synchronize state with source of truth from database
        final dataState = await _getSavedArticlesUseCase();
        dataState.fold(
          (failure) => emit(LocalArticlesError(failure, articles: currentArticles)),
          (articles) => emit(LocalArticlesDone(articles)),
        );
      },
    );
  }

  /// Handles removing an article from local database and refreshing state.
  Future<void> onRemoveArticle(
    RemoveArticle event,
    Emitter<LocalArticleState> emit,
  ) async {
    final currentArticles = state.articles ?? [];
    
    // Guard against redundant remove requests if article is already removed
    if (!state.isArticleSaved(event.article)) return;

    // Optimistically update state so UI toggles instantly and handles rapid taps
    final updatedArticles = List<ArticleEntity>.from(currentArticles)
      ..removeWhere((e) => e.url == event.article.url);
    emit(LocalArticlesDone(
      updatedArticles,
      messageType: LocalArticleMessageType.removed,
    ));

    final removeState = await _removeArticleUseCase(params: event.article);
    
    await removeState.fold(
      (failure) async {
        // Revert optimistic state on DB failure
        emit(LocalArticlesError(failure, articles: currentArticles));
      },
      (_) async {
        // Silently synchronize state with source of truth from database
        final dataState = await _getSavedArticlesUseCase();
        dataState.fold(
          (failure) => emit(LocalArticlesError(failure, articles: currentArticles)),
          (articles) => emit(LocalArticlesDone(articles)),
        );
      },
    );
  }

  /// Handles clearing all bookmarked articles from local database.
  Future<void> onClearArticles(
    ClearArticles event,
    Emitter<LocalArticleState> emit,
  ) async {
    final currentArticles = state.articles;
    // Optimistically clear all articles
    emit(const LocalArticlesDone(
      [],
      messageType: LocalArticleMessageType.cleared,
    ));

    final clearState = await _clearArticleUseCase.call();
    clearState.fold(
      (failure) => emit(LocalArticlesError(failure, articles: currentArticles)),
      (_) {},
    );
  }
}

