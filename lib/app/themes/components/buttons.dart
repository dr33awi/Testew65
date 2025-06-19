// lib/app/themes/components/buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/spacing.dart';
import '../core/typography.dart';
import '../extensions/theme_extensions.dart';

/// نظام الأزرار الموحد للتطبيق الإسلامي
/// يوفر أنواع مختلفة من الأزرار مع تأثيرات بصرية متقدمة
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? suffixIcon;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final LinearGradient? customGradient;
  final bool hapticFeedback;
  final Duration animationDuration;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.suffixIcon,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
    this.customGradient,
    this.hapticFeedback = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  /// زر أساسي
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    IconData? suffixIcon,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      suffixIcon: suffixIcon,
      type: AppButtonType.primary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// زر ثانوي
  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    IconData? suffixIcon,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      suffixIcon: suffixIcon,
      type: AppButtonType.secondary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// زر محدود (Outlined)
  factory AppButton.outlined({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    IconData? suffixIcon,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    Color? color,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      suffixIcon: suffixIcon,
      type: AppButtonType.outlined,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      customColor: color,
    );
  }

  /// زر نصي
  factory AppButton.text({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    IconData? suffixIcon,
    AppButtonSize size = AppButtonSize.medium,
    Color? color,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      suffixIcon: suffixIcon,
      type: AppButtonType.text,
      size: size,
      customColor: color,
    );
  }

  /// زر بتدرج لوني
  factory AppButton.gradient({
    required String text,
    required LinearGradient gradient,
    VoidCallback? onPressed,
    IconData? icon,
    IconData? suffixIcon,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      suffixIcon: suffixIcon,
      type: AppButtonType.gradient,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      customGradient: gradient,
    );
  }

  /// زر خطر
  factory AppButton.danger({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      type: AppButtonType.danger,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// زر نجاح
  factory AppButton.success({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      type: AppButtonType.success,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// زر عائم (FAB)
  factory AppButton.floating({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      text: '',
      onPressed: onPressed,
      icon: icon,
      type: AppButtonType.floating,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedButton(
      onPressed: isLoading ? null : _handlePress,
      animationDuration: animationDuration,
      child: _buildButtonContent(context),
    );
  }

  void _handlePress() {
    if (hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    onPressed?.call();
  }

  Widget _buildButtonContent(BuildContext context) {
    return switch (type) {
      AppButtonType.primary => _buildElevatedButton(context),
      AppButtonType.secondary => _buildElevatedButton(context, isSecondary: true),
      AppButtonType.outlined => _buildOutlinedButton(context),
      AppButtonType.text => _buildTextButton(context),
      AppButtonType.gradient => _buildGradientButton(context),
      AppButtonType.danger => _buildElevatedButton(context, isDanger: true),
      AppButtonType.success => _buildElevatedButton(context, isSuccess: true),
      AppButtonType.floating => _buildFloatingButton(context),
    };
  }

  Widget _buildElevatedButton(
    BuildContext context, {
    bool isSecondary = false,
    bool isDanger = false,
    bool isSuccess = false,
  }) {
    final colors = _getButtonColors(context, isSecondary, isDanger, isSuccess);
    final dimensions = _getButtonDimensions();
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.backgroundColor,
        foregroundColor: colors.foregroundColor,
        elevation: _getElevation(),
        padding: dimensions.padding,
        minimumSize: Size(
          isFullWidth ? double.infinity : 0,
          dimensions.height,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
        ),
        textStyle: _getTextStyle(context),
        shadowColor: colors.backgroundColor?.withValues(alpha: 0.3),
      ),
      child: _buildButtonChild(context, colors.foregroundColor),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    final colors = _getButtonColors(context);
    final dimensions = _getButtonDimensions();
    
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.backgroundColor,
        side: BorderSide(
          color: colors.backgroundColor ?? context.primaryColor,
          width: AppSpacing.borderMedium,
        ),
        padding: dimensions.padding,
        minimumSize: Size(
          isFullWidth ? double.infinity : 0,
          dimensions.height,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonChild(context, colors.backgroundColor),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    final colors = _getButtonColors(context);
    final dimensions = _getButtonDimensions();
    
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.backgroundColor,
        padding: dimensions.padding,
        minimumSize: Size(
          isFullWidth ? double.infinity : 0,
          dimensions.height,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
        ),
        textStyle: _getTextStyle(context),
      ),
      child: _buildButtonChild(context, colors.backgroundColor),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    final dimensions = _getButtonDimensions();
    final gradient = customGradient ?? context.primaryGradient;
    
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: dimensions.height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          child: Container(
            padding: dimensions.padding,
            child: _buildButtonChild(context, Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    final dimensions = _getButtonDimensions();
    
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: customColor ?? context.primaryColor,
      foregroundColor: Colors.white,
      elevation: _getElevation(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Icon(
        icon,
        size: dimensions.iconSize,
      ),
    );
  }

  Widget _buildButtonChild(BuildContext context, Color? textColor) {
    if (isLoading) {
      return _buildLoadingIndicator(textColor);
    }

    final children = <Widget>[];
    
    if (icon != null) {
      children.add(Icon(
        icon,
        size: _getButtonDimensions().iconSize,
        color: textColor,
      ));
    }
    
    if (text.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(AppSpacing.widthSm);
      }
      
      children.add(
        Flexible(
          child: Text(
            text,
            style: _getTextStyle(context)?.copyWith(color: textColor),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    
    if (suffixIcon != null) {
      if (children.isNotEmpty) {
        children.add(AppSpacing.widthSm);
      }
      
      children.add(Icon(
        suffixIcon,
        size: _getButtonDimensions().iconSize,
        color: textColor,
      ));
    }

    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildLoadingIndicator(Color? color) {
    final dimensions = _getButtonDimensions();
    
    return SizedBox(
      width: dimensions.iconSize,
      height: dimensions.iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }

  _ButtonColors _getButtonColors(
    BuildContext context, [
    bool isSecondary = false,
    bool isDanger = false,
    bool isSuccess = false,
  ]) {
    if (customColor != null) {
      return _ButtonColors(
        backgroundColor: customColor,
        foregroundColor: context.getContrastingTextColor(customColor!),
      );
    }

    if (isDanger) {
      return _ButtonColors(
        backgroundColor: context.errorColor,
        foregroundColor: Colors.white,
      );
    }

    if (isSuccess) {
      return _ButtonColors(
        backgroundColor: context.successColor,
        foregroundColor: Colors.white,
      );
    }

    if (isSecondary) {
      return _ButtonColors(
        backgroundColor: context.secondaryColor,
        foregroundColor: Colors.white,
      );
    }

    return _ButtonColors(
      backgroundColor: context.primaryColor,
      foregroundColor: Colors.white,
    );
  }

  _ButtonDimensions _getButtonDimensions() {
    return switch (size) {
      AppButtonSize.small => const _ButtonDimensions(
        height: AppSpacing.buttonHeightSm,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        borderRadius: AppSpacing.radiusMd,
        iconSize: AppSpacing.iconSm,
      ),
      AppButtonSize.medium => const _ButtonDimensions(
        height: AppSpacing.buttonHeightMd,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        borderRadius: AppSpacing.radiusLg,
        iconSize: AppSpacing.iconMd,
      ),
      AppButtonSize.large => const _ButtonDimensions(
        height: AppSpacing.buttonHeightLg,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        borderRadius: AppSpacing.radiusXl,
        iconSize: AppSpacing.iconLg,
      ),
      AppButtonSize.extraLarge => const _ButtonDimensions(
        height: AppSpacing.buttonHeightXl,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xl,
        ),
        borderRadius: AppSpacing.radiusXl,
        iconSize: AppSpacing.iconLg,
      ),
    };
  }

  TextStyle? _getTextStyle(BuildContext context) {
    return switch (size) {
      AppButtonSize.small => AppTypography.buttonText.copyWith(
        fontSize: AppTypography.size12,
      ),
      AppButtonSize.medium => AppTypography.buttonText,
      AppButtonSize.large => AppTypography.buttonText.copyWith(
        fontSize: AppTypography.size16,
      ),
      AppButtonSize.extraLarge => AppTypography.buttonText.copyWith(
        fontSize: AppTypography.size18,
      ),
    };
  }

  double _getElevation() {
    return switch (type) {
      AppButtonType.text => 0,
      AppButtonType.outlined => 0,
      AppButtonType.floating => AppSpacing.elevation3,
      _ => AppSpacing.elevation2,
    };
  }
}

/// أنواع الأزرار
enum AppButtonType {
  primary,      // أساسي
  secondary,    // ثانوي
  outlined,     // محدود
  text,         // نصي
  gradient,     // تدرج لوني
  danger,       // خطر
  success,      // نجاح
  floating,     // عائم
}

/// أحجام الأزرار
enum AppButtonSize {
  small,        // صغير
  medium,       // متوسط
  large,        // كبير
  extraLarge,   // كبير جداً
}

/// بيانات ألوان الزر
class _ButtonColors {
  final Color? backgroundColor;
  final Color? foregroundColor;

  const _ButtonColors({
    this.backgroundColor,
    this.foregroundColor,
  });
}

/// أبعاد الزر
class _ButtonDimensions {
  final double height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double iconSize;

  const _ButtonDimensions({
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.iconSize,
  });
}

/// زر متحرك بتأثيرات
class _AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration animationDuration;

  const _AnimatedButton({
    required this.child,
    this.onPressed,
    required this.animationDuration,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// مجموعة أزرار
class AppButtonGroup extends StatelessWidget {
  final List<AppButton> buttons;
  final Axis direction;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const AppButtonGroup({
    super.key,
    required this.buttons,
    this.direction = Axis.horizontal,
    this.spacing = AppSpacing.md,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  factory AppButtonGroup.horizontal({
    required List<AppButton> buttons,
    double spacing = AppSpacing.md,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  }) {
    return AppButtonGroup(
      buttons: buttons,
      direction: Axis.horizontal,
      spacing: spacing,
      mainAxisAlignment: mainAxisAlignment,
    );
  }

  factory AppButtonGroup.vertical({
    required List<AppButton> buttons,
    double spacing = AppSpacing.md,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return AppButtonGroup(
      buttons: buttons,
      direction: Axis.vertical,
      spacing: spacing,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    
    for (int i = 0; i < buttons.length; i++) {
      children.add(buttons[i]);
      
      if (i < buttons.length - 1) {
        children.add(
          direction == Axis.horizontal
              ? AppSpacing.width(spacing)
              : AppSpacing.height(spacing),
        );
      }
    }

    return direction == Axis.horizontal
        ? Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          )
        : Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          );
  }
}

/// زر أيقونة بسيط
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.tooltip,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? AppSpacing.iconMd;
    final effectivePadding = padding ?? AppSpacing.allSm;
    final effectiveBorderRadius = borderRadius ?? AppSpacing.radiusMd;
    
    Widget button = Container(
      padding: effectivePadding,
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            )
          : null,
      child: Icon(
        icon,
        size: effectiveSize,
        color: color ?? context.textSecondaryColor,
      ),
    );

    if (onPressed != null) {
      button = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: button,
        ),
      );
    }

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}