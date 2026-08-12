import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/article_hero_section.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/article_detail/article_detail_page.dart';

/// Mock LocalArticleBloc using bloc_test
class MockLocalArticleBloc
    extends MockBloc<LocalArticleEvent, LocalArticleState>
    implements LocalArticleBloc {}

/// Fake LocalArticleEvent for mocktail parameter mmatching
class FakeLocalArticleEvent extends Fake implements LocalArticleEvent {}

/// Page widget test suite for [ArticleDetailPage].
void main() {
  late MockLocalArticleBloc mockLocalArticleBloc;

  setUpAll(() {
    registerFallbackValue(FakeLocalArticleEvent());
  });

  setUp(() {
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

  /// Helper Function to build ArticleDetailPage wrapperd idn BlocProvider
  Widget createWidgetUnderTest({ArticleEntity? article}) {
    return BlocProvider<LocalArticleBloc>.value(
      value: mockLocalArticleBloc,
      child: MaterialApp(home: ArticleDetailPage(article: article)),
    );
  }

  group('ArticleDetailPage Widget Tests', () {
    testWidgets(
      'should render [ArticleHeroSection] and article description content when article is provided',
      (WidgetTester tester) async {
        // Arrange: stub local BloC state with empty saved articles
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render ArticleDetailPage
        await tester.pumpWidget(createWidgetUnderTest(article: tArticle));
        await tester.pump();

        // Assert: Verify hero sectioon and body content exist in widget tree
        expect(find.byType(ArticleHeroSection), findsOneWidget);
        expect(find.textContaining('Article Title'), findsOneWidget);
      },
    );

    testWidgets(
      'should dispatch [SaveArticle] event when bookmark icon is tapped and article is not saved',
      (WidgetTester tester) async {
        // Arrange: Stub local BloC state with unsaved article
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([]));

        // Act: Render ArticleDetailPage
        await tester.pumpWidget(createWidgetUnderTest(article: tArticle));
        await tester.pump();

        final bookmarkButton = find.byIcon(Icons.bookmark_border);
        expect(bookmarkButton, findsOneWidget);
        await tester.tap(bookmarkButton);
        await tester.pump();

        // Assert: Verify SaveArticle event was added to LocalArticleBloc
        verify(
          () => mockLocalArticleBloc.add(any(that: isA<SaveArticle>())),
        ).called(1);
      },
    );

    testWidgets(
      'should not dispatch [SaveArticle] event when bookmark icon is tapped and article is saved',
      (WidgetTester tester) async {
        // Arrange: Stub local BloC state with saved article
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([tArticle]));

        // Act: Render ArticleDetailPage
        await tester.pumpWidget(createWidgetUnderTest(article: tArticle));
        await tester.pump();

        final bookmarkButton = find.byIcon(Icons.bookmark);
        expect(bookmarkButton, findsOneWidget);
        await tester.tap(bookmarkButton);
        await tester.pump();
        
        // Assert: Verify SaveArticle event was not added to LocalArticleBloc
        verifyNever(
          () => mockLocalArticleBloc.add(any(that: isA<SaveArticle>())),
        );
      },
    );

    testWidgets(
      'should dispatch [RemoveArticle] event when bookmark icon is tapped and article is saved',
      (WidgetTester tester) async {
        // Arrange: Stub local BloC state with saved article
        when(
          () => mockLocalArticleBloc.state,
        ).thenReturn(const LocalArticlesDone([tArticle]));

        // Act: Render ArticleDetailPage
        await tester.pumpWidget(createWidgetUnderTest(article: tArticle));
        await tester.pump();

        final bookmarkButton = find.byIcon(Icons.bookmark);
        expect(bookmarkButton, findsOneWidget);
        await tester.tap(bookmarkButton);
        await tester.pump();

        // Assert: Verify RemoveArticle event was added to LocalArticleBloc
        verify(
          () => mockLocalArticleBloc.add(any(that: isA<RemoveArticle>())),
        ).called(1);
      },
    );
  });
}
