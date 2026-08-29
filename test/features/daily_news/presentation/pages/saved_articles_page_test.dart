import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/config/routes/app_routes.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/presentation/molecules/clear_all_saved_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/horizontal_article_card.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/saved_articles_empty_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/saved_articles/saved_articles_page.dart';

/// Mock LocalArticleBloc using bloc_test
class MockLocalArticleBloc
    extends MockBloc<LocalArticleEvent, LocalArticleState>
    implements LocalArticleBloc {}

/// Page widget test suite for [SavedArticlesPage].
///
/// Verifies local bookmark list rendering, empty states error fallbacks,
/// and interactive user journeys (delete, clear all, back navigation)
void main() {
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
    registerFallbackValue(const ClearArticles());
    registerFallbackValue(const RemoveArticle(tArticle));
  });

  setUp(() {
    mockLocalArticleBloc = MockLocalArticleBloc();
    when(
      () => mockLocalArticleBloc.stream,
    ).thenAnswer((_) => const Stream.empty());
  });

  /// Helper function to instantiate [SavedArticlesPage] wrapped in BlocProvider and MaterialApp.
  Widget createWidgetUnderTest({Map<String, WidgetBuilder>? routes}) {
    return BlocProvider<LocalArticleBloc>.value(
      value: mockLocalArticleBloc,
      child: MaterialApp(
        home: const SavedArticlesPage(),
        routes: {
          AppRoutes.articleDetails: (_) =>
              const Scaffold(body: Text('Article Detail Page')),
          ...?routes,
        },
      ),
    );
  }

  group('SavedArticlesPage State Rendering Tests', () {
    testWidgets(
      'should render [Skeletonizer] loading placeholder when state is [LocalArticlesLoading]',
      (WidgetTester tester) async {
        // Arrange: Stub local Bloc loading state
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesLoading());

        // Act: Render SavedArticlesPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify skeleton placeholder is rendered
        expect(find.text(AppStrings.placeholderTitle), findsWidgets);
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString().contains('Skeletonizer'),
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'should render [SavedArticlesEmptyState] when state is [LocalArticlesDone] with empty list',
      (WidgetTester tester) async {
        // Arrange: Stub local BLoC state with empty article list
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render SavedArticlesPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify empty state view is rendered and article cards are absent
        expect(find.byType(SavedArticlesEmptyState), findsOneWidget);
        expect(find.byType(HorizontalArticleCard), findsNothing);
        expect(find.byType(ClearAllSavedButton), findsNothing);
      },
    );

    testWidgets(
      'should render [HorizontalArticleCard] list and Clear All button when state is [LocalArticlesDone] with articles',
      (WidgetTester tester) async {
        // Arrange: Stub local BLoC state with saved articles
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([tArticle]));

        // Act: Render SavedArticlesPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify article card and headline text exist on screen
        expect(find.byType(HorizontalArticleCard), findsOneWidget);
        expect(find.text('Article Title'), findsOneWidget);
        expect(find.byType(ClearAllSavedButton), findsOneWidget);
      },
    );

    testWidgets(
      'should render error view with refresh button when state is [LocalArticleError]',
      (WidgetTester tester) async {
        // Arrange: Set mobile viewport size to prevent landscape clipping
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Stub local Bloc error state
        when(() => mockLocalArticleBloc.state).thenReturn(
          const LocalArticlesError(CacheFailure('Database read error')),
        );

        // Act: Render SavedArticlesPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: verify error text and refresh button are displayed
        expect(find.text(AppStrings.failedToLoadSavedArticles), findsOneWidget);
        expect(find.text(AppStrings.refresh), findsWidgets);
      },
    );
  });

  group('SavedArticlesPage User Interactions & Flow Tests', () {
    testWidgets(
      'should dispatch [GetSavedArticles] when refresh button is tapped on error state',
      (WidgetTester tester) async {
        // Arrange: Set mobile viewport size to prevent landscape clipping
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Stub local Bloc error state
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesError(CacheFailure('Database error')));

        // Act: Render page and tap refresh button
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
        await tester.tap(find.text(AppStrings.refresh));
        await tester.pump();

        // Assert: Verify GetSavedArticles event is dispatched
        verify(
          () => mockLocalArticleBloc.add(const GetSavedArticles()),
        ).called(1);
      },
    );

    testWidgets(
      'should dispatch [ClearArticles] when Clear All button is tapped',
      (WidgetTester tester) async {
        // Arrange: Stub Local Bloc state with saved articles
        when(() => mockLocalArticleBloc.state).thenReturn(
          const LocalArticlesDone([tArticle]),
        );

        // Act: render page and tap Clear All button
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();
        await tester.tap(find.byType(ClearAllSavedButton));
        await tester.pump();

        // Assert: Verify ClearArticles event is dispatched
        verify(
          () => mockLocalArticleBloc.add(any(that: isA<ClearArticles>())),
        ).called(1);
      },
    );

    testWidgets(
      'should dispatch [RemoveArticle] when delete icon on article card is tapped',
      (WidgetTester tester) async {
        // Arrange: Stub Local Bloc state with saved articles
        when(() => mockLocalArticleBloc.state).thenReturn(
          const LocalArticlesDone([tArticle]),
        );

        // Act: Render page and tap delete/trash icon on horizontal card
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        final deleteButton = find.byIcon(Icons.bookmark_remove_outlined);
        expect(deleteButton, findsOneWidget);
        await tester.tap(deleteButton);
        await tester.pump();

        // Assert: Verify RemoveArticle event is dispatched
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

    testWidgets(
      'should navigate to article details page when horizontal card is tapped',
      (WidgetTester tester) async {
        // Arrange: Stub local Bloc state with saved articles
        when(() => mockLocalArticleBloc.state).thenReturn(
          const LocalArticlesDone([tArticle]),
        );

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

        // Act: Tap headline on horizontal article card
        await tester.tap(find.text('Article Title'));
        await tester.pumpAndSettle();

        // Assert: Verify navigation to article details
        expect(navigatedToDetail, isTrue);
        expect(find.text('Article Detail Page'), findsOneWidget);
      },
    );

    testWidgets('should pop navigator when back button in AppBar is tapped', (
      WidgetTester tester,
    ) async {
      //Arrange: stub Local Bloc state with empty list
      when(
        () => mockLocalArticleBloc.state,
      ).thenReturn(const LocalArticlesDone([]));

      // Build navigation hierarchy where root pushes SavedArticlePage
      await tester.pumpWidget(
        BlocProvider<LocalArticleBloc>.value(
          value: mockLocalArticleBloc,
          child: MaterialApp(
            home: Builder(
              builder: ((context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SavedArticlesPage()),
                  ),
                  child: const Text('Open Saved Articles'),
                ),
              )),
            ),
          ),
        ),
      );

      // Navigate to SavedArticlesPage
      await tester.tap(find.text('Open Saved Articles'));
      await tester.pumpAndSettle();
      expect(find.byType(SavedArticlesPage), findsOneWidget);

      // Act: tap back button
      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      // Assert: Verify SavedArticlesPage is popped and root button is visible
      expect(find.byType(SavedArticlesPage), findsNothing);
      expect(find.text('Open Saved Articles'), findsOneWidget);
    });
  });
}
