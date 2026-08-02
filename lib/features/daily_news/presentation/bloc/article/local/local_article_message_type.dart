import 'package:news_app_clean_architecture/core/constant/app_strings.dart';

/// Enum representing feedback snackbar notification types for local article actions.
enum LocalArticleMessageType {
  /// Feedback when an article is saved.
  saved,

  /// Feedback when an article is removed.
  removed,

  /// Feedback when all articles are cleared.
  cleared;

  /// Converts the message type enum value into a localized user-facing text string.
  String toText() {
    switch (this) {
      case LocalArticleMessageType.saved:
        return AppStrings.articleSaved;
      case LocalArticleMessageType.removed:
        return AppStrings.articleRemoved;
      case LocalArticleMessageType.cleared:
        return AppStrings.allArticlesCleared;
    }
  }
}

