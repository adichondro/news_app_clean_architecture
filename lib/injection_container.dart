import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/core/network/dio/news_dio_client.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repositories/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/settings/data/data_sources/local/theme_local_data_source.dart';
import 'package:news_app_clean_architecture/features/settings/data/repositories/theme_repository_impl.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repositories/theme_repository.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:news_app_clean_architecture/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator instance managed by [GetIt].
final sl = GetIt.instance;

/// Registers all application dependencies including network clients, database DAOs,
/// repositories, use cases, and BLoC factories into the service locator.
Future<void> initializeDependencies() async {
  // 1. Core & External Infrastructure
  sl.registerSingleton<Dio>(NewsDioClient.create());
  sl.registerSingleton<AppDatabase>(AppDatabase());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // 2. Data Sources (Remote API & Local DAO)
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleDao>(ArticleDao(sl()));
  sl.registerSingleton<ThemeLocalDataSource>(ThemeLocalDataSourceImpl(sl()));

  // 3. Repositories
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl(), sl()));
  sl.registerSingleton<ThemeRepository>(ThemeRepositoryImpl(sl()));

  // 4. Use Cases
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<GetSavedArticlesUseCase>(GetSavedArticlesUseCase(sl()));
  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));
  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));
  sl.registerSingleton<ClearArticleUseCase>(ClearArticleUseCase(sl()));
  sl.registerSingleton<GetThemeModeUseCase>(GetThemeModeUseCase(sl()));
  sl.registerSingleton<SetThemeModeUseCase>(SetThemeModeUseCase(sl()));

  // 5. BLoCs (Registered as factories to provide fresh instances per request)
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc(sl()));
  sl.registerFactory<LocalArticleBloc>(
    () => LocalArticleBloc(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<ThemeBloc>(() => ThemeBloc(sl(), sl()));
}
