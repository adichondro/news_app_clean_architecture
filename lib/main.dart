import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/theme/app_theme.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

/// Entry point for the Daily News application.
///
/// Initializes Flutter bindings, environment configuration, and service locator dependencies.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration from .env file
  await dotenv.load(fileName: ".env");

  // Register service locator singletons and factories
  await initializeDependencies();

  runApp(const MyApp());
}

/// Root widget of the application configuring global BLoC providers and MaterialApp.
class MyApp extends StatelessWidget {
  /// Creates the root [MyApp] widget instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>(
          create: (context) => sl()..add(const GetArticles()),
        ),
        BlocProvider<LocalArticleBloc>(
          create: (context) => sl()..add(const GetSavedArticles()),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: theme(),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}

