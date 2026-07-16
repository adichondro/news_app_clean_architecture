import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_radius.dart';

class SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback? onSave;
  const SaveButton({super.key, required this.isSaved, this.onSave});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.smallRadius,
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? AppColors.secondary : AppColors.outline,
          size: 20,
        ),
        splashColor: AppColors.secondaryContainer.withValues(alpha: 0.5),
        highlightColor: AppColors.secondaryContainer.withValues(alpha: 0.2),
        onPressed: onSave,
      ),
    );
  }
}
