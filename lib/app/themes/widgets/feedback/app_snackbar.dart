// lib/app/themes/widgets/feedback/app_snackbar.dart - محسن مع Glass Morphism
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../text_styles.dart';
import '../../core/theme_extensions.dart';

/// SnackBar عام وموحد للتطبيق مع Glass Morphism
class AppSnackBar {
  AppSnackBar._();

  /// عرض SnackBar مخصص مع Glass Effect
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    EdgeInsetsGeometry? margin,
    SnackBarAction? action,
    bool hapticFeedback = true,
    bool enableGlass = true,
    double? elevation,
  }) {
    if (hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    final theme = Theme.of(context);
    final effectiveColor = backgroundColor ?? theme.primaryColor;
    final effectiveTextColor = textColor ?? Colors.white;
    
    // إخفاء أي SnackBar موجود
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _GlassSnackBarContent(
          message: message,
          icon: icon,
          textColor: effectiveTextColor,
          enableGlass: enableGlass,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: margin ?? const EdgeInsets.all(ThemeConstants.space4),
        padding: EdgeInsets.zero,
        duration: duration,
        action: action != null ? _buildGlassAction(action, effectiveColor) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static SnackBarAction _buildGlassAction(SnackBarAction action, Color backgroundColor) {
    return SnackBarAction(
      label: action.label,
      textColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      onPressed: action.onPressed,
    );
  }

  /// عرض رسالة نجاح
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: ThemeConstants.success,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
      enableGlass: enableGlass,
    );
  }

  /// عرض رسالة خطأ
  static void showError({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: ThemeConstants.error,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 4),
      action: action,
      enableGlass: enableGlass,
    );
  }

  /// عرض رسالة تحذير
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: ThemeConstants.warning,
      textColor: ThemeConstants.lightTextPrimary,
      duration: duration ?? const Duration(seconds: 4),
      action: action,
      enableGlass: enableGlass,
    );
  }

  /// عرض رسالة معلومات
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration? duration,
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: ThemeConstants.info,
      textColor: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
      action: action,
      enableGlass: enableGlass,
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
    Duration duration = const Duration(seconds: 5),
    bool enableGlass = true,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = backgroundColor ?? theme.primaryColor;
    
    show(
      context: context,
      message: message,
      icon: icon,
      backgroundColor: effectiveColor,
      duration: duration,
      enableGlass: enableGlass,
      action: SnackBarAction(
        label: undoLabel,
        textColor: Colors.white,
        onPressed: onUndo,
      ),
    );
  }

  /// عرض رسالة تحميل (لا تختفي تلقائياً)
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading({
    required BuildContext context,
    required String message,
    bool enableGlass = true,
  }) {
    final theme = Theme.of(context);

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _GlassSnackBarContent(
          message: message,
          icon: null, // سيتم عرض مؤشر التحميل بدلاً منها
          textColor: Colors.white,
          enableGlass: enableGlass,
          isLoading: true,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(ThemeConstants.space4),
        padding: EdgeInsets.zero,
        duration: const Duration(days: 1), // لا تختفي تلقائياً
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
      ),
    );
  }

  /// عرض إشعار مع صورة
  static void showWithImage({
    required BuildContext context,
    required String message,
    required String imagePath,
    String? title,
    Duration? duration,
    VoidCallback? onTap,
    bool enableGlass = true,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: context.primaryColor,
      duration: duration ?? const Duration(seconds: 5),
      enableGlass: enableGlass,
    );
  }

  /// إخفاء جميع SnackBars
  static void hideAll(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// محتوى SnackBar مع Glass Effect
class _GlassSnackBarContent extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color textColor;
  final bool enableGlass;
  final bool isLoading;

  const _GlassSnackBarContent({
    required this.message,
    this.icon,
    required this.textColor,
    this.enableGlass = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.primaryColor;
    
    Widget container = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor.withValues(alpha: enableGlass ? 0.9 : 1.0),
            backgroundColor.darken(0.1).withValues(alpha: enableGlass ? 0.7 : 0.9),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأيقونة أو مؤشر التحميل
          if (isLoading)
            SizedBox(
              width: ThemeConstants.iconMd,
              height: ThemeConstants.iconMd,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            )
          else if (icon != null)
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space1),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Icon(
                icon,
                color: textColor,
                size: ThemeConstants.iconSm,
              ),
            ),
          
          if (icon != null || isLoading) ThemeConstants.space3.w,
          
          // النص
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body2.copyWith(
                color: textColor,
                fontWeight: ThemeConstants.medium,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (enableGlass) {
      container = ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: container,
        ),
      );
    }

    return container;
  }
}

/// Extension لتسهيل استخدام SnackBar المحسن
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    AppSnackBar.showSuccess(
      context: this, 
      message: message, 
      duration: duration, 
      action: action,
      enableGlass: enableGlass,
    );
  }

  void showErrorSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    AppSnackBar.showError(
      context: this, 
      message: message, 
      duration: duration, 
      action: action,
      enableGlass: enableGlass,
    );
  }

  void showInfoSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    AppSnackBar.showInfo(
      context: this, 
      message: message, 
      duration: duration, 
      action: action,
      enableGlass: enableGlass,
    );
  }

  void showWarningSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    AppSnackBar.showWarning(
      context: this, 
      message: message, 
      duration: duration, 
      action: action,
      enableGlass: enableGlass,
    );
  }

  void showLoadingSnackBar(String message, {bool enableGlass = true}) {
    AppSnackBar.showLoading(
      context: this, 
      message: message,
      enableGlass: enableGlass,
    );
  }

  void hideSnackBars() {
    AppSnackBar.hideAll(this);
  }
}