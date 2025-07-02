// lib/app/themes/widgets/feedback/app_snackbar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';

/// SnackBar عام وموحد للتطبيق
class AppSnackBar {
  AppSnackBar._();

  /// عرض SnackBar مخصص
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
    EdgeInsetsGeometry? margin,
    SnackBarAction? action,
    bool hapticFeedback = true,
  }) {
    if (hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? Colors.white,
                size: ThemeConstants.iconMd,
              ),
              const SizedBox(width: ThemeConstants.space3),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ?? theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        margin: margin ?? const EdgeInsets.all(ThemeConstants.space4),
        duration: duration,
        action: action,
      ),
    );
  }

  /// عرض رسالة نجاح
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: ThemeConstants.success,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      action: action,
    );
  }

  /// عرض رسالة خطأ
  static void showError({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: ThemeConstants.error,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
    );
  }

  /// عرض رسالة تحذير
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: ThemeConstants.warning,
      textColor: ThemeConstants.lightTextPrimary,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
    );
  }

  /// عرض رسالة معلومات
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: ThemeConstants.info,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      action: action,
    );
  }

  /// عرض رسالة مع إجراء تراجع
  static void showWithUndo({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    IconData? icon,
    Color? backgroundColor,
    String undoLabel = 'تراجع',
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);
    show(
      context: context,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      duration: duration,
      action: SnackBarAction(
        label: undoLabel,
        textColor: backgroundColor != null
            ? (ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ? Colors.white : Colors.black)
            : (ThemeData.estimateBrightnessForColor(theme.primaryColor) == Brightness.dark ? Colors.white : Colors.black),
        onPressed: onUndo,
      ),
    );
  }

  /// عرض رسالة تحميل (لا تختفي تلقائياً)
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading({
    required BuildContext context,
    required String message,
  }) {
    final theme = Theme.of(context);

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: ThemeConstants.iconMd,
              height: ThemeConstants.iconMd,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: ThemeConstants.space3),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        margin: const EdgeInsets.all(ThemeConstants.space4),
        duration: const Duration(days: 1), // لا تختفي تلقائياً
      ),
    );
  }

  /// إخفاء جميع SnackBars
  static void hideAll(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// Extension لتسهيل استخدام SnackBar
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    AppSnackBar.showSuccess(context: this, message: message, duration: duration, action: action);
  }

  void showErrorSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    AppSnackBar.showError(context: this, message: message, duration: duration, action: action);
  }

  void showInfoSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    AppSnackBar.showInfo(context: this, message: message, duration: duration, action: action);
  }

  void showWarningSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    AppSnackBar.showWarning(context: this, message: message, duration: duration, action: action);
  }

  void hideSnackBars() {
    AppSnackBar.hideAll(this);
  }
}