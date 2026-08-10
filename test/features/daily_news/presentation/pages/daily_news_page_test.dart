import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/article_card.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/daily_news/daily_news_page.dart';

/// Mock BloCs using bloc_test
class MockRemoteArticlesBloc
    extends MockBloc<RemoteArticlesEvent, RemoteArticleState>
    implements RemoteArticlesBloc {}

class MockLocalArticleBloc
    extends MockBloc<LocalArticleEvent, LocalArticleState>
    implements LocalArticleBloc {}

/// Page widget test suite for [DailyNewsPage].
void main() {
  late MockRemoteArticlesBloc mockRemoteArticlesBloc;
  late MockLocalArticleBloc mockLocalArticleBloc;

  setUp(() {
    mockRemoteArticlesBloc = MockRemoteArticlesBloc();
    mockLocalArticleBloc = MockLocalArticleBloc();
  });

  const tArticle = ArticleEntity(
    id: 1,
    author: 'John Doe',
    title: 'Article Title',
    description: 'Article Description',
    url: 'https://example.com',
    urlToImage: null,
    publishedAt: '2022-01-01T00:00:00Z',
    content: 'Article Content',
    sourceName: 'BBC News',
  );

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>.value(value: mockRemoteArticlesBloc),
        BlocProvider<LocalArticleBloc>.value(value: mockLocalArticleBloc),
      ],
      child: const MaterialApp(home: DailyNewsPage()),
    );
  }

  testWidgets(
    'should render article cards when [remoteArticleBloc] state is [RemoteArticleDone]',
    (WidgetTester tester) async {
      // Arrange: Stub BloC state
      when(
        () => mockRemoteArticlesBloc.state,
      ).thenReturn(const RemoteArticlesDone([tArticle]));
      when(
        () => mockLocalArticleBloc.state,
      ).thenReturn(const LocalArticlesDone([]));

      // Act: Render DailyNewsPage
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert: Verify article card and headline text exist on screen
      expect(find.byType(ArticleCard), findsOneWidget);
      expect(find.text('Article Title'), findsOneWidget);
    },
  );

  testWidgets(
    'should render error view when [RemoteArticlesBloc] state is [RemoteArticlesError]',
    (WidgetTester tester) async {
      // Arrange: Stub BloC error state
      when(
        () => mockRemoteArticlesBloc.state,
      ).thenReturn(const RemoteArticlesError(ServerFailure('Server Error')));

      when(
        () => mockLocalArticleBloc.state,
      ).thenReturn(const LocalArticlesDone([]));

      // Act: Render DailyNewsPage
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert: Verify error view element exist
      expect(find.byType(ArticleCard), findsNothing);
      expect(find.text('Try Again'), findsOneWidget);
    },
  );
}
