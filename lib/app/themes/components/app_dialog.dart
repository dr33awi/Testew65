// lib/app/themes/components/app_dialog.dart
import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

class AppDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: AppTypography.title,
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: AppTypography.body,
          textAlign: TextAlign.center,
        ),
        actions: [
          if (onConfirm != null)
            TextButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context, true);
              },
              child: Text(
                confirmText ?? 'موافق',
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText ?? 'إلغاء',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title, style: AppTypography.title),
        content: Text(content, style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'موافق',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}