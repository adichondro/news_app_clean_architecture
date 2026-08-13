import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
void main() {
  late MockLocalArticleBloc mockLocalArticleBloc;

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

  /// Helper function to build SavedArticlesPage wrapped in BlocProvider
  Widget createWidgetUnderTest() {
    return BlocProvider<LocalArticleBloc>.value(
      value: mockLocalArticleBloc,
      child: const MaterialApp(
        home: SavedArticlesPage(),
      ),
    );
  }

  group('SavedArticlesPage Widget Tests', () {
    testWidgets(
      'should render [SavedArticlesEmptyState] when [LocalArticleBloc] state is [LocalArticlesDone] with empty list',
      (WidgetTester tester) async {
        // Arrange: Stub local BLoC state with empty article list
        when(() => mockLocalArticleBloc.state).thenReturn(
          const LocalArticlesDone([]),
        );

        // Act: Render SavedArticlesPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify empty state view is rendered and article cards are absent
        expect(find.byType(SavedArticlesEmptyState), findsOneWidget);
        expect(find.byType(HorizontalArticleCard), findsNothing);
      },
    );

    testWidgets(
      'should render [HorizontalArticleCard] list when [LocalArticleBloc] state is [LocalArticlesDone] with articles',
      (WidgetTester tester) async {
        // Arrange: Stub local BLoC state with saved articles
        when(() => mockLocalArticleBloc.state).thenReturn(
          const LocalArticlesDone([tArticle]),
        );

        // Act: Render SavedArticlesPage
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Assert: Verify article card and headline text exist on screen
        expect(find.byType(HorizontalArticleCard), findsOneWidget);
        expect(find.text('Article Title'), findsOneWidget);
      },
    );
  });
}

