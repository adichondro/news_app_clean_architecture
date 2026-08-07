import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_message_type.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

/// Mock implementation of [GetSavedArticlesUseCase] using [Mocktail]
class MockGetSavedArticlesUseCase extends Mock
    implements GetSavedArticlesUseCase {}

/// Mock implementation of [SaveArticleUseCase] using [Mocktail]
class MockSaveArticleUseCase extends Mock implements SaveArticleUseCase {}

/// Mock implementation of [RemoveArticleUseCase] using [Mocktail]
class MockRemoveArticleUseCase extends Mock implements RemoveArticleUseCase {}

/// Mock implementation of [ClearArticleUseCase] using [Mocktail]
class MockClearArticleUseCase extends Mock implements ClearArticleUseCase {}

/// unit test for [LocalArticleBloc]
void main() {
  late LocalArticleBloc bloc;
  late MockGetSavedArticlesUseCase mockGetSavedArticlesUseCase;
  late MockSaveArticleUseCase mockSaveArticleUseCase;
  late MockRemoveArticleUseCase mockRemoveArticleUseCase;
  late MockClearArticleUseCase mockClearArticleUseCase;

  setUp(() {
    mockGetSavedArticlesUseCase = MockGetSavedArticlesUseCase();
    mockSaveArticleUseCase = MockSaveArticleUseCase();
    mockRemoveArticleUseCase = MockRemoveArticleUseCase();
    mockClearArticleUseCase = MockClearArticleUseCase();

    bloc = LocalArticleBloc(
      mockGetSavedArticlesUseCase,
      mockSaveArticleUseCase,
      mockRemoveArticleUseCase,
      mockClearArticleUseCase,
    );
  });

  const tArticle = ArticleEntity(
    id: 1,
    author: 'John Doe',
    title: 'Article Title',
    description: 'Article Description',
    url: 'https://example.com',
    urlToImage: 'https://example.com/image.jpg',
    publishedAt: '2022-01-01T00:00:00Z',
    content: 'Article Content',
    sourceName: 'BBC News',
  );

  const tArticles = [tArticle];

  test('initial state should be [LocalArticlesLoading]', () {
    // Assert: Verify that the BLoC starts with initial loading state
    expect(bloc.state, isA<LocalArticlesLoading>());
  });

  group('GetSavedArticles', () {
    blocTest<LocalArticleBloc, LocalArticleState>(
      'should emit [LocalArticlesDone] when [GetSavedArticles] succeeds',
      build: () {
        // Arrange: Stub get saved articles use case to return DataSuccess payload
        when(
          () => mockGetSavedArticlesUseCase(),
        ).thenAnswer((_) async => const DataSuccess(tArticles));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetSavedArticles()),
      expect: () => [
        // Assert: Expect state transition to LocalArticlesDone with articles list
        const LocalArticlesDone(tArticles),
      ],
      verify: (_) {
        // Verify: Ensure get saved articles use case is called exactly once
        verify(() => mockGetSavedArticlesUseCase()).called(1);
      },
    );
  });

  group('SaveArticle', () {
    blocTest<LocalArticleBloc, LocalArticleState>(
      'should emit optimistic update then sync with database on [SaveArticle]',
      build: () {
        // Arrange: Stub save article use case and get saved articles use case
        when(
          () => mockSaveArticleUseCase(params: tArticle),
        ).thenAnswer((_) async => const DataSuccess(null));
        when(
          () => mockGetSavedArticlesUseCase(),
        ).thenAnswer((_) async => const DataSuccess(tArticles));
        return bloc;
      },
      act: (bloc) => bloc.add(const SaveArticle(tArticle)),
      expect: () => [
        // Assert: Expect optimistic update first (saved message), then database sync state
        const LocalArticlesDone(
          tArticles,
          messageType: LocalArticleMessageType.saved,
        ),
        const LocalArticlesDone(tArticles),
      ],
      verify: (_) {
        // Verify: Ensure save article use case and get saved articles use case are invoked
        verify(() => mockSaveArticleUseCase(params: tArticle)).called(1);
        verify(() => mockGetSavedArticlesUseCase()).called(1);
      },
    );
  });

  group('RemoveArticle', () {
    blocTest<LocalArticleBloc, LocalArticleState>(
      'should emit optimistic update then sync with database on [RemoveArticle]',
      build: () {
        // Arrange: Stub initial state containing tArticle so isArticleSaved returns true
        when(
          () => mockGetSavedArticlesUseCase(),
        ).thenAnswer((_) async => const DataSuccess(tArticles));
        when(
          () => mockRemoveArticleUseCase(params: tArticle),
        ).thenAnswer((_) async => const DataSuccess(null));
        return bloc;
      },
      act: (bloc) async {
        // Seed initial saved state first
        bloc.add(const GetSavedArticles());
        await Future.delayed(Duration.zero);
        bloc.add(const RemoveArticle(tArticle));
      },
      expect: () => [
        // 1. Initial GetSavedArticles state
        const LocalArticlesDone(tArticles),
        // 2. Optimistic update (removed message)
        const LocalArticlesDone(
          [],
          messageType: LocalArticleMessageType.removed,
        ),
        // 3. Database sync state (empty list from DB)
        const LocalArticlesDone(tArticles),
      ],
      verify: (_) {
        verify(() => mockRemoveArticleUseCase(params: tArticle)).called(1);
      },
    );
  });

  group('ClearArticles', () {
    blocTest<LocalArticleBloc, LocalArticleState>(
      'should emit optimistic clear state then call [ClearArticleUseCase]',
      build: () {
        // Arrange: Stub clear article use case to return DataSuccess payload
        when(
          () => mockClearArticleUseCase(),
        ).thenAnswer((_) async => const DataSuccess(null));
        return bloc;
      },
      act: (bloc) => bloc.add(const ClearArticles()),
      expect: () => [
        // Assert: Expect optimistic clear state with cleared message type
        const LocalArticlesDone(
          [],
          messageType: LocalArticleMessageType.cleared,
        ),
      ],
      verify: (_) {
        // Verify: Ensure clear article use case is called exactly once
        verify(() => mockClearArticleUseCase()).called(1);
      },
    );
  });
}
