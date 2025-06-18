// lib/app/themes/widgets/core/app_button.dart
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';
import '../../core/theme_extensions.dart';

/// أنواع الأزرار
enum ButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
  success,
}

/// أحجام الأزرار
enum ButtonSize {
  small,
  medium,
  large,
}

/// زر موحد للتطبيق
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final bool isRounded;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? customColor;
  final Color? textColor;
  final double? borderRadius;
  final BorderSide? borderSide;
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isRounded = false,
    this.width,
    this.height,
    this.padding,
    this.customColor,
    this.textColor,
    this.borderRadius,
    this.borderSide,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // الحصول على الألوان حسب النوع
    final backgroundColor = _getBackgroundColor(context);
    final foregroundColor = _getForegroundColor(context);
    
    // الحصول على الحجم
    final buttonHeight = _getHeight();
    final buttonPadding = _getPadding();
    final textStyle = _getTextStyle();
    
    // البنية الداخلية للزر
    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : child ?? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: size == ButtonSize.small ? 16 : 20),
                const SizedBox(width: ThemeConstants.space2),
              ],
              Text(text, style: textStyle),
              if (suffixIcon != null) ...[
                const SizedBox(width: ThemeConstants.space2),
                Icon(suffixIcon, size: size == ButtonSize.small ? 16 : 20),
              ],
            ],
          );

    // شكل الزر
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        isRounded ? ThemeConstants.radiusFull : (borderRadius ?? ThemeConstants.radiusMd)
      ),
    );

    // بناء الزر حسب النوع
    Widget button;
    
    switch (type) {
      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: padding ?? buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: shape,
            side: borderSide ?? BorderSide(
              color: customColor ?? theme.primaryColor,
              width: ThemeConstants.borderMedium,
            ),
          ),
          child: buttonChild,
        );
        break;
        
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: padding ?? buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: shape,
          ),
          child: buttonChild,
        );
        break;
        
      default:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding ?? buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: shape,
            elevation: 0,
          ),
          child: buttonChild,
        );
    }

    // تطبيق العرض
    if (isFullWidth || width != null) {
      button = SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: button,
      );
    }

    return button;
  }

  Color _getBackgroundColor(BuildContext context) {
    if (onPressed == null) {
      return context.dividerColor.withValues(alpha: ThemeConstants.opacity30);
    }

    switch (type) {
      case ButtonType.primary:
        return customColor ?? context.primaryColor;
      case ButtonType.secondary:
        return customColor ?? context.colorScheme.secondary;
      case ButtonType.danger:
        return customColor ?? ThemeConstants.error;
      case ButtonType.success:
        return customColor ?? ThemeConstants.success;
      case ButtonType.outline:
      case ButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    if (textColor != null) return textColor!;

    if (onPressed == null) {
      return context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity50);
    }

    switch (type) {
      case ButtonType.primary:
        return (customColor ?? context.primaryColor).contrastingTextColor;
      case ButtonType.secondary:
        return context.colorScheme.secondary.contrastingTextColor;
      case ButtonType.danger:
        return Colors.white;
      case ButtonType.success:
        return Colors.white;
      case ButtonType.outline:
        return customColor ?? context.primaryColor;
      case ButtonType.text:
        return customColor ?? context.primaryColor;
    }
  }

  double _getHeight() {
    if (height != null) return height!;
    
    switch (size) {
      case ButtonSize.small:
        return ThemeConstants.heightSm;
      case ButtonSize.medium:
        return ThemeConstants.heightMd;
      case ButtonSize.large:
        return ThemeConstants.heightLg;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space2,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space3,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space5,
          vertical: ThemeConstants.space4,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall;
      case ButtonSize.medium:
        return AppTextStyles.button;
      case ButtonSize.large:
        return AppTextStyles.button.copyWith(fontSize: 18);
    }
  }

  // Factory constructors مع إصلاح textColor parameter
  factory AppButton.primary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    Color? backgroundColor,
    Color? textColor, // إضافة معلمة textColor المطلوبة
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      customColor: backgroundColor,
      textColor: textColor, // استخدام المعلمة الجديدة
    );
  }

  factory AppButton.custom({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      customColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory AppButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
    );
  }

  factory AppButton.outline({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    Color? color,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      customColor: color,
    );
  }

  factory AppButton.text({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    Color? color,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      icon: icon,
      isLoading: isLoading,
      size: size,
      customColor: color,
    );
  }

  factory AppButton.danger({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.danger,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
    );
  }

  factory AppButton.success({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.success,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
    );
  }
}