import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/save_button.dart';
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
///
/// Verifies state rendering (loading, error, empty, done) and user journey interactions
/// including navigation, bookmark toggling, and retry triggers.
void main() {
  late MockRemoteArticlesBloc mockRemoteArticlesBloc;
  late MockLocalArticleBloc mockLocalArticleBloc;

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

  setUpAll(() {
    registerFallbackValue(const GetSavedArticles());
    registerFallbackValue(const SaveArticle(tArticle));
    registerFallbackValue(const RemoveArticle(tArticle));
  });

  setUp(() {
    mockRemoteArticlesBloc = MockRemoteArticlesBloc();
    mockLocalArticleBloc = MockLocalArticleBloc();

    when(() => mockRemoteArticlesBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLocalArticleBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  /// Helper function to instantiate [DailyNewsPage] wrapped in necessary [BlocProvider] and [MaterialApp].
  Widget createWidgetUnderTest({Map<String, WidgetBuilder>? routes}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesBloc>.value(value: mockRemoteArticlesBloc),
        BlocProvider<LocalArticleBloc>.value(value: mockLocalArticleBloc),
      ],
      child: MaterialApp(
        home: const DailyNewsPage(),
        routes: {
          AppRoutes.savedArticles: (_) => const Scaffold(body: Text('Saved Articles Page')),
          AppRoutes.articleDetails: (_) => const Scaffold(body: Text('Article Detail Page')),
          ...?routes,
        },
      ),
    );
  }

  group('DailyNewsPage State Rendering Tests', () {
    testWidgets(
      'should render loading skeleton cards when state is [RemoteArticlesLoading]',
      (WidgetTester tester) async {
        // Arrange: Stub RemoteArticlesBloc loading state and empty local state
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesLoading());
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render DailyNewsPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify placeholder skeleton cards are active on screen
        expect(find.text(AppStrings.placeholderTitle), findsWidgets);
        expect(find.byWidgetPredicate((w) => w.runtimeType.toString().contains('Skeletonizer')), findsWidgets);
      },
    );

    testWidgets(
      'should render article cards when state is [RemoteArticlesDone] with articles',
      (WidgetTester tester) async {
        // Arrange: Stub RemoteArticlesBloc done state with sample articles
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesDone([tArticle]));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render DailyNewsPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify article card and title text are visible
        expect(find.byType(ArticleCard), findsOneWidget);
        expect(find.text('Article Title'), findsOneWidget);
      },
    );

    testWidgets(
      'should render empty state view when state is [RemoteArticlesDone] with empty list',
      (WidgetTester tester) async {
        // Arrange: Stub RemoteArticleBloc done state with empty article list
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesDone([]));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render DailyNewsPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify empty state view is displayed and cards are absent
        expect(find.byType(ArticleCard), findsNothing);
        expect(find.text('No Articles Found'), findsOneWidget);
      },
    );

    testWidgets(
      'should render error view with Try Again button when state is [RemoteArticlesError]',
      (WidgetTester tester) async {
        // Arrange: Stub RemoteArticlesBloc with connection error failure
        when(() => mockRemoteArticlesBloc.state).thenReturn(
          const RemoteArticlesError(ServerFailure('Connection Error')),
        );
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render DailyNewsPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify error view and action button are displayed
        expect(find.byType(ArticleCard), findsNothing);
        expect(find.text('Try Again'), findsOneWidget);
      },
    );
  });

  group('DailyNewsPage User Interactions & Flow Tests', () {
    testWidgets(
      'should dispatch [GetArticles] when Try Again button is pressed on error state',
      (WidgetTester tester) async {
        // Arrange: Stub error state
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesError(ServerFailure('Server Error')));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render page and tap Try Again button
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
        await tester.tap(find.text('Try Again'));
        await tester.pump();

        // Assert: Verify GetArticles event is dispatched to RemoteArticlesBloc
        verify(() => mockRemoteArticlesBloc.add(const GetArticles())).called(1);
      },
    );

    testWidgets(
      'should navigate to saved articles page when bookmark icon in AppBar is tapped',
      (WidgetTester tester) async {
        // Arrange: Stub done state and mock named navigation route
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesDone([tArticle]));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        bool navigatedToSavedArticles = false;

        await tester.pumpWidget(
          createWidgetUnderTest(
            routes: {
              AppRoutes.savedArticles: (context) {
                navigatedToSavedArticles = true;
                return const Scaffold(body: Text('Saved Articles Page'));
              },
            },
          ),
        );
        await tester.pump();

        // Act: Tap AppBar bookmark icon
        await tester.tap(find.byIcon(Icons.bookmark));
        await tester.pumpAndSettle();

        // Assert: Verify navigation to saved articles page
        expect(navigatedToSavedArticles, isTrue);
        expect(find.text('Saved Articles Page'), findsOneWidget);
      },
    );

    testWidgets(
      'should navigate to article details page when article card is tapped',
      (WidgetTester tester) async {
        // Arrange: Stub done state and mock article details route
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesDone([tArticle]));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        bool navigatedToDetail = false;

        await tester.pumpWidget(
          createWidgetUnderTest(
            routes: {
              AppRoutes.articleDetails: (context) {
                navigatedToDetail = true;
                return const Scaffold(body: Text('Article Detail Page'));
              },
            },
          ),
        );
        await tester.pump();

        // Act: Tap article card headline
        await tester.tap(find.text('Article Title'));
        await tester.pumpAndSettle();

        // Assert: Verify navigation to article details page
        expect(navigatedToDetail, isTrue);
        expect(find.text('Article Detail Page'), findsOneWidget);
      },
    );

    testWidgets(
      'should dispatch [SaveArticle] when bookmark button is tapped on unsaved article',
      (WidgetTester tester) async {
        // Arrange: Stub article present remotely but not saved locally
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesDone([tArticle]));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Act: Ensure SaveButton is scrolled into view and tapped
        final bookmarkButton = find.byType(SaveButton);
        expect(bookmarkButton, findsOneWidget);
        await tester.ensureVisible(bookmarkButton);
        await tester.pumpAndSettle();
        await tester.tap(bookmarkButton);
        await tester.pump();

        // Assert: Verify SaveArticle event is dispatched to LocalArticleBloc
        verify(
          () => mockLocalArticleBloc.add(
            any(
              that: isA<SaveArticle>().having(
                (e) => e.article,
                'article',
                equals(tArticle),
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should dispatch [RemoveArticle] when bookmark button is tapped on saved article',
      (WidgetTester tester) async {
        // Arrange: Stub article present remotely and already saved locally
        when(
          () => mockRemoteArticlesBloc.state,
        ).thenReturn(const RemoteArticlesDone([tArticle]));
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([tArticle]));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Act: Ensure SaveButton is scrolled into view and tapped
        final bookmarkButton = find.byType(SaveButton);
        expect(bookmarkButton, findsOneWidget);
        await tester.ensureVisible(bookmarkButton);
        await tester.pumpAndSettle();
        await tester.tap(bookmarkButton);
        await tester.pump();

        // Assert: Verify RemoveArticle event is dispatched to LocalArticleBloc
        verify(
          () => mockLocalArticleBloc.add(
            any(
              that: isA<RemoveArticle>().having(
                (e) => e.article,
                'article',
                equals(tArticle),
              ),
            ),
          ),
        ).called(1);
      },
    );
  });
}
