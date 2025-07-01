// lib/app/themes/widgets/feedback/app_snackbar.dart - مُصلح بالكامل
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../text_styles.dart';
import '../../core/theme_extensions.dart';
import '../../core/systems/app_color_system.dart';

/// SnackBar موحد للتطبيق - مبسط مع Glass Morphism
class AppSnackBar {
  AppSnackBar._();

  /// عرض SnackBar عام مع Glass Effect
  static void show({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? backgroundColor,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();

    final theme = Theme.of(context);
    final effectiveColor = backgroundColor ?? theme.primaryColor;
    
    // إخفاء أي SnackBar موجود
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _GlassSnackBarContent(
          message: message,
          icon: icon,
          backgroundColor: effectiveColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(ThemeConstants.space4),
        padding: EdgeInsets.zero,
        duration: duration,
        action: action != null ? _buildGlassAction(action) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static SnackBarAction _buildGlassAction(SnackBarAction action) {
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
    SnackBarAction? action,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: AppColorSystem.success,
      action: action,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// عرض رسالة خطأ
  static void showError({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: AppColorSystem.error,
      action: action,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// عرض رسالة معلومات
  static void showInfo({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration? duration,
  }) {
    show(
      context: context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: AppColorSystem.info,
      action: action,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// إخفاء جميع SnackBars
  static void hideAll(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// محتوى SnackBar مع Glass Effect - مبسط
class _GlassSnackBarContent extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color backgroundColor;

  const _GlassSnackBarContent({
    required this.message,
    this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
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
                backgroundColor.withValues(alpha: 0.9),
                backgroundColor.darken(0.1).withValues(alpha: 0.7),
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
              // الأيقونة
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space1),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space3),
              ],
              
              // النص
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
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
        ),
      ),
    );
  }
}

/// Extension لتسهيل الاستخدام - مبسط
extension SnackBarExtension on BuildContext {
  /// عرض SnackBar نجاح
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showSuccess(
      context: this, 
      message: message, 
      action: action,
    );
  }

  /// عرض SnackBar خطأ
  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showError(
      context: this, 
      message: message, 
      action: action,
    );
  }

  /// عرض SnackBar معلومات
  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showInfo(
      context: this, 
      message: message, 
      action: action,
    );
  }

  /// عرض SnackBar مخصص
  void showSnackBar(String message, {
    IconData? icon,
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    AppSnackBar.show(
      context: this,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      action: action,
    );
  }

  /// إخفاء جميع SnackBars
  void hideSnackBars() {
    AppSnackBar.hideAll(this);
  }
}