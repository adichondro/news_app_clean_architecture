import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_message_type.dart';
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
    dataState.fold(
      (failure) => emit(LocalArticlesError(failure, articles: state.articles)),
      (articles) => emit(LocalArticlesDone(articles)),
    );
  }

  Future<void> onSaveArticle(
    SaveArticle event,
    Emitter<LocalArticleState> emit,
  ) async {
    final currentArticles = state.articles;
    final saveState = await _saveArticleUseCase(params: event.article);
    await saveState.fold(
      (failure) async => emit(LocalArticlesError(failure, articles: currentArticles)),
      (_) async {
        final dataState = await _getSavedArticlesUseCase();
        dataState.fold(
          (failure) => emit(LocalArticlesError(failure, articles: currentArticles)),
          (articles) => emit(LocalArticlesDone(
            articles,
            messageType: LocalArticleMessageType.saved,
          )),
        );
      },
    );
  }

  Future<void> onRemoveArticle(
    RemoveArticle event,
    Emitter<LocalArticleState> emit,
  ) async {
    final currentArticles = state.articles;
    final removeState = await _removeArticleUseCase(params: event.article);
    await removeState.fold(
      (failure) async => emit(LocalArticlesError(failure, articles: currentArticles)),
      (_) async {
        final dataState = await _getSavedArticlesUseCase();
        dataState.fold(
          (failure) => emit(LocalArticlesError(failure, articles: currentArticles)),
          (articles) => emit(LocalArticlesDone(
            articles,
            messageType: LocalArticleMessageType.removed,
          )),
        );
      },
    );
  }

  Future<void> onClearArticles(
    ClearArticles event,
    Emitter<LocalArticleState> emit,
  ) async {
    final currentArticles = state.articles;
    final clearState = await _clearArticleUseCase.call();
    clearState.fold(
      (failure) => emit(LocalArticlesError(failure, articles: currentArticles)),
      (_) => emit(const LocalArticlesDone(
        [],
        messageType: LocalArticleMessageType.cleared,
      )),
    );
  }
}
