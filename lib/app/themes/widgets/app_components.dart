// lib/app/themes/widgets/app_components.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../app_theme.dart';
import '../theme_constants.dart';
import 'animations/animated_press.dart';
import 'custom_app_bar.dart';

/// بطاقة موحدة للتطبيق
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final bool useGlassEffect;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradientColors,
    this.elevation,
    this.borderRadius,
    this.border,
    this.useGlassEffect = false,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? const EdgeInsets.all(ThemeConstants.defaultCardPadding);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ThemeConstants.defaultBorderRadius);
    
    Widget cardChild = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      margin: margin,
      decoration: BoxDecoration(
        color: gradientColors == null ? (backgroundColor ?? context.cardColor) : null,
        gradient: gradientColors != null ? LinearGradient(
          colors: gradientColors!.map((c) => c.withValues(alpha: 0.9)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        borderRadius: effectiveBorderRadius,
        border: border ?? Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
          width: ThemeConstants.borderLight,
        ),
        boxShadow: elevation != null ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation!,
            offset: Offset(0, elevation! / 2),
          ),
        ] : context.shadowMd,
      ),
      child: child,
    );

    if (useGlassEffect) {
      cardChild = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: cardChild,
        ),
      );
    }

    if (onTap != null) {
      cardChild = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: cardChild,
        ),
      );
    }

    return cardChild;
  }
}

/// حالات التحميل
class AppLoading extends StatelessWidget {
  final String? message;
  final LoadingSize size;

  const AppLoading({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
  });

  factory AppLoading.page({String? message}) {
    return AppLoading(
      message: message,
      size: LoadingSize.large,
    );
  }

  factory AppLoading.circular({LoadingSize size = LoadingSize.medium}) {
    return AppLoading(size: size);
  }

  @override
  Widget build(BuildContext context) {
    final indicatorSize = switch (size) {
      LoadingSize.small => 20.0,
      LoadingSize.medium => 32.0,
      LoadingSize.large => 48.0,
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            strokeWidth: size == LoadingSize.small ? 2 : 3,
          ),
        ),
        if (message != null) ...[
          ThemeConstants.space4.h,
          Text(
            message!,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

enum LoadingSize { small, medium, large }

/// حالات فارغة
class AppEmptyState extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;
  final Color? iconColor;
  final String? title;

  const AppEmptyState({
    super.key,
    required this.message,
    this.actionText,
    this.onAction,
    this.icon,
    this.iconColor,
    this.title,
  });

  factory AppEmptyState.noData({
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      message: message,
      actionText: actionText,
      onAction: onAction,
      icon: Icons.inbox_outlined,
    );
  }

  factory AppEmptyState.error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return AppEmptyState(
      message: message,
      actionText: 'إعادة المحاولة',
      onAction: onRetry,
      icon: Icons.error_outline,
      iconColor: ThemeConstants.error,
      title: 'حدث خطأ',
    );
  }

  factory AppEmptyState.custom({
    required String title,
    required String message,
    required IconData icon,
    Color? iconColor,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
      actionText: actionText,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: iconColor ?? context.textSecondaryColor.withValues(alpha: 0.5),
              ),
              ThemeConstants.space4.h,
            ],
            
            if (title != null) ...[
              Text(
                title!,
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                ),
                textAlign: TextAlign.center,
              ),
              ThemeConstants.space2.h,
            ],
            
            Text(
              message,
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              ThemeConstants.space4.h,
              AppButton.primary(
                text: actionText!,
                onPressed: onAction,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// أزرار موحدة
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonSize size;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.size = ButtonSize.medium,
  });

  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    Color? backgroundColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      backgroundColor: backgroundColor,
    );
  }

  factory AppButton.outline({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    Color? color,
    ButtonSize size = ButtonSize.medium,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      foregroundColor: color,
      size: size,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color ?? ThemeConstants.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? context.primaryColor;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;
    
    final (padding, fontSize, iconSize) = switch (size) {
      ButtonSize.small => (
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ThemeConstants.textSizeSm,
        16.0,
      ),
      ButtonSize.medium => (
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ThemeConstants.textSizeMd,
        18.0,
      ),
      ButtonSize.large => (
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ThemeConstants.textSizeLg,
        20.0,
      ),
    };

    final buttonStyle = style ?? ElevatedButton.styleFrom(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: ThemeConstants.semiBold,
      ),
    );

    Widget buttonChild = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    if (isFullWidth) {
      buttonChild = SizedBox(
        width: double.infinity,
        child: buttonChild,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: buttonChild,
    );
  }
}

enum ButtonSize { small, medium, large }

/// مربعات حوار معلومات
class AppInfoDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    IconData? icon,
    Color? accentColor,
    List<DialogAction>? actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => _InfoDialog(
        title: title,
        content: content,
        icon: icon,
        accentColor: accentColor,
        actions: actions,
      ),
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    IconData? icon,
    Color? confirmButtonColor,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        confirmButtonColor: confirmButtonColor,
        destructive: destructive,
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? accentColor;
  final List<DialogAction>? actions;

  const _InfoDialog({
    required this.title,
    required this.content,
    this.icon,
    this.accentColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? context.primaryColor;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: effectiveAccentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                icon,
                color: effectiveAccentColor,
                size: 24,
              ),
            ),
            ThemeConstants.space3.w,
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(
        content,
        style: context.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: actions?.map((action) => action._build(context)).toList() ?? [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('موافق'),
        ),
      ],
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final Color? confirmButtonColor;
  final bool destructive;

  const _ConfirmationDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    this.icon,
    this.confirmButtonColor,
    required this.destructive,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = destructive 
        ? ThemeConstants.error 
        : (confirmButtonColor ?? context.primaryColor);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                icon,
                color: buttonColor,
                size: 24,
              ),
            ),
            ThemeConstants.space3.w,
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(
        content,
        style: context.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class DialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const DialogAction({
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });

  Widget _build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }
  }
}

/// مساعدات SnackBar
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: ThemeConstants.success,
        icon: Icons.check_circle,
        action: action,
      ),
    );
  }

  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: ThemeConstants.error,
        icon: Icons.error,
        action: action,
      ),
    );
  }

  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: ThemeConstants.warning,
        icon: Icons.warning,
        action: action,
      ),
    );
  }

  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: primaryColor,
        icon: Icons.info,
        action: action,
      ),
    );
  }

  SnackBar _createSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    SnackBarAction? action,
  }) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          ThemeConstants.space2.w,
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      action: action,
      );
  }
}