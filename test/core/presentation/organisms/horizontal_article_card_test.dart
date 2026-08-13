import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/components/organisms/horizontal_article_card.dart';

/// Organism widget test suite for [HorizontalArticleCard].
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

  /// Helper function to build HorizontalArticleCard wrapped in MaterialApp
  Widget createWidgetUnderTest({
    required ArticleEntity article,
    VoidCallback? onPressed,
    VoidCallback? onDeletePressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: HorizontalArticleCard(
          article: article,
          onPressed: onPressed,
          onDeletePressed: onDeletePressed,
        ),
      ),
    );
  }

  group('HorizontalArticleCard organism widget Tests', () {
    testWidgets(
      'should render article title, uppercase sourcename, and trigger callbacks on tap',
      (WidgetTester tester) async {
        var isCardTapped = false;
        var isDeleteTapped = false;

        // Arrange & Act: Render HorizontalArticleCard with callbacks
        await tester.pumpWidget(
          createWidgetUnderTest(
            article: tArticle,
            onPressed: () => isCardTapped = true,
            onDeletePressed: () => isDeleteTapped = true,
          ),
        );
        await tester.pump();

         // Assert: Verify title, uppercase source name, and delete button icon exist
        expect(find.text('Article Title'), findsOneWidget);
        expect(find.text('BBC NEWS'), findsOneWidget);
        expect(find.byIcon(Icons.bookmark_remove_outlined), findsOneWidget);

        // Act: Simulate tap on delete icon button and card container
        await tester.tap(find.byIcon(Icons.bookmark_remove_outlined));
        await tester.tap(find.text('Article Title'));

        // Assert: Verify callback flags were set to true
        expect(isDeleteTapped, isTrue);
        expect(isCardTapped, isTrue);
      },
    );
  });
}
