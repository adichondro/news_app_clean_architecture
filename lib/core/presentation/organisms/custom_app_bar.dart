import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: leading,
      title: Text(
        title,
        style: AppTypography.headlinesMedium.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          height: 1.33,
        ),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(height: 1.0, color: colorScheme.outlineVariant),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
