/// Abstract base event for remote news article BLoC operations.
abstract class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

/// Event triggering fetch of top news headlines from remote API.
class GetArticles extends RemoteArticlesEvent {
  const GetArticles();
}