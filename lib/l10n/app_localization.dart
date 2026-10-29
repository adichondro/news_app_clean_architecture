import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localization_en.dart';
import 'app_localization_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Main title of the news application displayed in the AppBar
  ///
  /// In en, this message translates to:
  /// **'Daily News'**
  String get appTitle;

  /// No description provided for @newsSourceDefault.
  ///
  /// In en, this message translates to:
  /// **'NEWS'**
  String get newsSourceDefault;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get noTitle;

  /// No description provided for @unknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Author'**
  String get unknownAuthor;

  /// No description provided for @shareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share coming soon!'**
  String get shareComingSoon;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @exploreNews.
  ///
  /// In en, this message translates to:
  /// **'Explore News'**
  String get exploreNews;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @lightThemeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get lightThemeTooltip;

  /// No description provided for @darkThemeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get darkThemeTooltip;

  /// No description provided for @articleSaved.
  ///
  /// In en, this message translates to:
  /// **'Article saved!'**
  String get articleSaved;

  /// No description provided for @articleRemoved.
  ///
  /// In en, this message translates to:
  /// **'Article removed!'**
  String get articleRemoved;

  /// No description provided for @allArticlesCleared.
  ///
  /// In en, this message translates to:
  /// **'All articles cleared!'**
  String get allArticlesCleared;

  /// No description provided for @savedArticlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Articles'**
  String get savedArticlesTitle;

  /// No description provided for @articlesBookmarkedSuffix.
  ///
  /// In en, this message translates to:
  /// **'articles bookmarked for later'**
  String get articlesBookmarkedSuffix;

  /// No description provided for @noSavedArticlesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Saved Articles'**
  String get noSavedArticlesTitle;

  /// No description provided for @noSavedArticlesMessage.
  ///
  /// In en, this message translates to:
  /// **'Articles you save will appear here to read later. Find interesting news and save it using the bookmark icon.'**
  String get noSavedArticlesMessage;

  /// No description provided for @popularTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Topics for You'**
  String get popularTopicsTitle;

  /// No description provided for @topicPolitics.
  ///
  /// In en, this message translates to:
  /// **'Politics'**
  String get topicPolitics;

  /// No description provided for @topicTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get topicTechnology;

  /// No description provided for @topicScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get topicScience;

  /// No description provided for @topicHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get topicHealth;

  /// No description provided for @topicBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get topicBusiness;

  /// No description provided for @oopsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsErrorTitle;

  /// No description provided for @failedToLoadSavedArticles.
  ///
  /// In en, this message translates to:
  /// **'Failed to load your saved articles. Please try again.'**
  String get failedToLoadSavedArticles;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @connectionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionErrorTitle;

  /// No description provided for @connectionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load articles. Please check your connection.'**
  String get connectionErrorMessage;

  /// No description provided for @noArticlesFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No Articles Found'**
  String get noArticlesFoundTitle;

  /// No description provided for @noArticlesFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No articles are currently available. Please check back later for updates.'**
  String get noArticlesFoundMessage;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out. Please check your internet connection and try again.'**
  String get connectionTimeout;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection available.'**
  String get noInternetConnection;

  /// No description provided for @serverErrorDefault.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get serverErrorDefault;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
