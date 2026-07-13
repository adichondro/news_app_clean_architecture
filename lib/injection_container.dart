import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repositories/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // ==========================================
  // 1. Core & External
  // ==========================================
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Database (Drift)
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // ==========================================
  // 2. Data Sources
  // ==========================================
  // Remote
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  // Local (DAO membutuhkan AppDatabase)
  sl.registerSingleton<ArticleDao>(ArticleDao(sl()));

  // ==========================================
  // 3. Repository
  // ==========================================
  // Sekarang ArticleRepositoryImpl membutuhkan DUA parameter:
  // sl() pertama untuk NewsApiService, sl() kedua untuk ArticleDao
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl(), sl()));

  // ==========================================
  // 4. UseCases
  // ==========================================
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<GetSavedArticlesUseCase>(GetSavedArticlesUseCase(sl()));
  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));
  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));
  sl.registerSingleton<ClearArticleUseCase>(ClearArticleUseCase(sl()));

  // ==========================================
  // 5. Blocs
  // ==========================================
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
  sl.registerFactory<LocalArticleBloc>(
    () => LocalArticleBloc(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
}
