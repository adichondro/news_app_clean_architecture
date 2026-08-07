import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article_usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

/// Mock implementation of [GetArticleUseCase] using [Mocktail].
class MockGetArticleUseCase extends Mock implements GetArticleUseCase {}

/// Unit test suite for [RemoteArticlesBloc].
void main() {
  late RemoteArticlesBloc bloc;
  late MockGetArticleUseCase mockGetArticleUseCase;

  /// Sets up mock dependencies and instantiates bloc before each test.
  setUp(() {
    mockGetArticleUseCase = MockGetArticleUseCase();
    bloc = RemoteArticlesBloc(mockGetArticleUseCase);
  });

  /// Sample article entity list used for BLoC payload assertions.
  const tArticles = [
    ArticleEntity(
      id: 1,
      author: 'John Doe',
      title: 'Article Title',
      description: 'Article Description',
      url: 'https://example.com',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: '2022-01-01T00:00:00Z',
      content: 'Article Content',
      sourceName: 'BBC News',
    ),
  ];

  test('initial state should be [RemoteArticlesLoading]', () {
    // Assert: Verify that the BLoC starts with initial loading state
    expect(bloc.state, isA<RemoteArticlesLoading>());
  });

  blocTest<RemoteArticlesBloc, RemoteArticleState>(
    'should emit [RemoteArticlesDone] when [GetArticles] event succeeds',
    build: () {
      // Arrange: Stub use case call to return DataSuccess payload
      when(
        () => mockGetArticleUseCase(),
      ).thenAnswer((_) async => const DataSuccess(tArticles));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetArticles()),
    expect: () => [
      // Assert: Expect state transition to RemoteArticlesDone with data
      const RemoteArticlesDone(tArticles),
    ],
    verify: (_) {
      verify(() => mockGetArticleUseCase()).called(1);
    },
  );

  blocTest<RemoteArticlesBloc, RemoteArticleState>(
    'should emit [RemoteArticlesError] when [GetArticles] event fails',
    build: () {
      // Arrange: Stub the use case to return a DataFailed containing a ServerFailure
      final tFailure = ServerFailure('Connection timeout');
      when(
        () => mockGetArticleUseCase(),
      ).thenAnswer((_) async => DataFailed(tFailure));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetArticles()),
    expect: () => [
      // Assert: Expect state transition to RemoteArticlesError with failure
      const RemoteArticlesError(ServerFailure('Connection timeout')),
    ],
    verify: (_) {
      verify(() => mockGetArticleUseCase()).called(1);
    },
  );
}
