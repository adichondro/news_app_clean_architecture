// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily News';

  @override
  String get newsSourceDefault => 'NEWS';

  @override
  String get noTitle => 'No Title';

  @override
  String get unknownAuthor => 'Unknown Author';

  @override
  String get shareComingSoon => 'Share coming soon!';

  @override
  String get refresh => 'Refresh';

  @override
  String get exploreNews => 'Explore News';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get clearAll => 'Clear All';

  @override
  String get lightThemeTooltip => 'Switch to Light Mode';

  @override
  String get darkThemeTooltip => 'Switch to Dark Mode';

  @override
  String get articleSaved => 'Article saved!';

  @override
  String get articleRemoved => 'Article removed!';

  @override
  String get allArticlesCleared => 'All articles cleared!';

  @override
  String get savedArticlesTitle => 'Saved Articles';

  @override
  String get articlesBookmarkedSuffix => 'articles bookmarked for later';

  @override
  String get noSavedArticlesTitle => 'No Saved Articles';

  @override
  String get noSavedArticlesMessage =>
      'Articles you save will appear here to read later. Find interesting news and save it using the bookmark icon.';

  @override
  String get popularTopicsTitle => 'Popular Topics for You';

  @override
  String get topicPolitics => 'Politics';

  @override
  String get topicTechnology => 'Technology';

  @override
  String get topicScience => 'Science';

  @override
  String get topicHealth => 'Health';

  @override
  String get topicBusiness => 'Business';

  @override
  String get oopsErrorTitle => 'Oops! Something went wrong';

  @override
  String get failedToLoadSavedArticles =>
      'Failed to load your saved articles. Please try again.';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get connectionErrorTitle => 'Connection Error';

  @override
  String get connectionErrorMessage =>
      'Failed to load articles. Please check your connection.';

  @override
  String get noArticlesFoundTitle => 'No Articles Found';

  @override
  String get noArticlesFoundMessage =>
      'No articles are currently available. Please check back later for updates.';

  @override
  String get connectionTimeout =>
      'Connection timed out. Please check your internet connection and try again.';

  @override
  String get noInternetConnection => 'No internet connection available.';

  @override
  String get serverErrorDefault =>
      'A server error occurred. Please try again later.';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';
}
