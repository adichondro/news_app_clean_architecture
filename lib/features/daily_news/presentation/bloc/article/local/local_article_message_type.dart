import 'package:news_app_clean_architecture/core/constant/app_strings.dart';

enum LocalArticleMessageType {
  saved,
  removed,
  cleared;

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
