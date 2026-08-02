import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

/// BLoC managing state for remote news article fetching operations.
class RemoteArticlesBloc extends Bloc<RemoteArticlesEvent, RemoteArticleState> {
  final GetArticleUseCase _getArticleUseCase;

  /// Creates a [RemoteArticlesBloc] with required [_getArticleUseCase] dependency.
  RemoteArticlesBloc(this._getArticleUseCase)
    : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
  }

  /// Handles fetching top news articles from remote REST API service.
  Future<void> onGetArticles(
    GetArticles event,
    Emitter<RemoteArticleState> emit,
  ) async {
    final dataState = await _getArticleUseCase();

    // Fold DataState to emit success or error states
    dataState.fold(
      (error) {
        emit(RemoteArticlesError(error));
      },
      (data) {
        emit(RemoteArticlesDone(data));
      },
    );
  }
}

