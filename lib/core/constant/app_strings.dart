/// Centralized repository of application-wide user-facing string constants.
class AppStrings {
  const AppStrings._();

  // App Bar & General
  static const String appTitle = 'Daily News';
  static const String newsSourceDefault = 'NEWS';
  static const String noTitle = 'No Title';
  static const String unknownAuthor = 'Unknown Author';

  // Actions & Buttons
  static const String shareComingSoon = 'Share coming soon!';
  static const String refresh = 'Refresh';
  static const String exploreNews = 'Explore News';
  static const String tryAgain = 'Try Again';
  static const String clearAll = 'Clear All';

  // BLoC Notifications
  static const String articleSaved = 'Article saved!';
  static const String articleRemoved = 'Article removed!';
  static const String allArticlesCleared = 'All articles cleared!';

  // Saved Articles Page
  static const String savedArticlesTitle = 'Saved Articles';
  static const String articlesBookmarkedSuffix = 'articles bookmarked for later';
  static const String noSavedArticlesTitle = 'No Saved Articles';
  static const String noSavedArticlesMessage =
      'Articles you save will appear here to read later. Find interesting news and save it using the bookmark icon.';
  static const String popularTopicsTitle = 'Popular Topics for You';

  // Topics
  static const String topicPolitics = 'Politics';
  static const String topicTechnology = 'Technology';
  static const String topicScience = 'Science';
  static const String topicHealth = 'Health';
  static const String topicBusiness = 'Business';

  // Error Messages
  static const String oopsErrorTitle = 'Oops! Something went wrong';
  static const String failedToLoadSavedArticles =
      'Failed to load your saved articles. Please try again.';
  static const String unexpectedError = 'An unexpected error occurred.';
  static const String connectionErrorTitle = 'Connection Error';
  static const String connectionErrorMessage =
      'Failed to load articles. Please check your connection.';
  static const String noArticlesFoundTitle = 'No Articles Found';
  static const String noArticlesFoundMessage =
      'No articles are currently available. Please check back later for updates.';

  // Network & Exception Failure Messages
  static const String connectionTimeout =
      'Connection timed out. Please check your internet connection and try again.';
  static const String invalidSslCertificate =
      'Secure connection failed. Please check your network connection or try again later.';
  static const String requestCancelled = 'The request was cancelled.';
  static const String noInternetConnection = 'No internet connection available.';
  static const String noServerResponse =
      'No response received from the server. Please try again later.';
  static const String serverErrorDefault =
      'A server error occurred. Please try again later.';
  static const String sessionExpired =
      'Access denied or session expired. Please sign in again.';
  static const String resourceNotFound =
      'The requested content could not be found.';
  static const String tooManyRequests =
      'Too many requests. Please try again in a few moments.';
  static const String badGateway =
      'Server is temporarily unavailable. Please try again later.';
  static const String serviceUnavailable =
      'Server is undergoing maintenance. Please try again later.';
  static const String gatewayTimeout =
      'Server took too long to respond. Please try again later.';

  // Skeleton Placeholders
  static const String placeholderTitle =
      'This is the placeholder title of the article loading';
  static const String placeholderDescription =
      'This is a placeholder description for loading articles so that the skeleton layout is formed proportionally.';
}
