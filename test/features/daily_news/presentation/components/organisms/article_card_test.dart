import 'package:flutter/material.dart' show MaterialApp, Scaffold, ValueChanged;
import 'package:flutter/widgets.dart' show SingleChildScrollView, Widget;
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/article_card.dart';

/// Widget test suite for [ArticleCard] organism component.
void main() {
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

  /// Helper function to wrap [ArticleCard] inside a [MaterialApp] context.
  Widget createWidgetUnderTest({
    required ArticleEntity article,
    bool isSaved = false,
    ValueChanged<ArticleEntity>? onArticlePressed,
    ValueChanged<ArticleEntity>? onSavePressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ArticleCard(
            article: article,
            isSaved: isSaved,
            onArticlePressed: onArticlePressed,
            onSavePressed: onSavePressed,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'should render article title, author, and source chip correctly',
    (WidgetTester tester) async {
      // Arrange & Act: Bouild ArticleCard widget
      await tester.pumpWidget(createWidgetUnderTest(article: tArticle));

      // Assert: Verify text elements exist in widget tree
      expect(find.text('Article Title'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('BBC NEWS'), findsOneWidget);
    },
  );

  testWidgets(
    'should trigger [onArticlePressed] callback when card is tapped',
    (WidgetTester tester) async {
      // Arrange: Callback tracking flag
      bool isTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          article: tArticle,
          onArticlePressed: (article) {
            isTapped = true;
          },
        ),
      );

      // Act: Tap on the article card
      await tester.tap(find.byType(ArticleCard));
      await tester.pump();

      // Assert: Verify callback was invoked
      expect(isTapped, isTrue);
    },
  );
}
