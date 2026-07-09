import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_colors.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_spacing.dart';
import 'package:news_app_clean_architecture/core/presentation/atoms/app_typography.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onActionPressed;
  final String actionLabel;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.message,
    this.onActionPressed,
    this.actionLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.outline),
            const SizedBox(height: AppSpacing.stackMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            if (onActionPressed != null) ...[
              const SizedBox(height: AppSpacing.stackLg),
              // TODO: Buat Custom Button untuk button dibawah ini
              ElevatedButton(
                // (Untuk sekarang kita biarkan ElevatedButton standar,
                // nantinya bisa diganti dengan CustomButton Atom jika Anda punya)
                onPressed: onActionPressed,
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
