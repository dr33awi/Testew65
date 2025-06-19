// lib/app/themes/widgets/common_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../app_theme.dart';

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
    final effectivePadding = padding ?? const EdgeInsets.all(AppTheme.space4);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppTheme.radius2xl);
    
    Widget cardChild = Container(
      width: width,
      height: height,
      padding: effectivePadding,
      margin: margin,
      decoration: BoxDecoration(
        color: gradientColors == null ? (backgroundColor ?? context.cardColor) : null,
        gradient: gradientColors != null ? LinearGradient(
          colors: gradientColors!.map((c) => c.withOpacity(0.9)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        borderRadius: effectiveBorderRadius,
        border: border ?? Border.all(
          color: context.dividerColor.withOpacity(0.2),
          width: AppTheme.borderLight,
        ),
        boxShadow: elevation != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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

/// زر مضغوط بتأثيرات
class AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final Duration duration;

  const AnimatedPress({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleFactor = 0.95,
    this.duration = AppTheme.durationFast,
  });

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppTheme.curveDefault,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
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

/// شريط تطبيق مخصص
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AppBarAction>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation = 0,
  });

  factory CustomAppBar.simple({
    required String title,
    List<AppBarAction>? actions,
    Widget? leading,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.backgroundColor,
            context.backgroundColor.withOpacity(0.95),
            context.backgroundColor.withOpacity(0.9),
          ],
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            title: Text(
              title,
              style: context.titleLarge?.copyWith(
                fontWeight: AppTheme.bold,
              ),
            ),
            centerTitle: centerTitle,
            backgroundColor: backgroundColor ?? Colors.transparent,
            elevation: elevation,
            surfaceTintColor: Colors.transparent,
            leading: leading,
            actions: actions?.map((action) => action._build(context)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// إجراء في شريط التطبيق
class AppBarAction {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  const AppBarAction({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
  });

  Widget _build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.space2),
      decoration: BoxDecoration(
        color: context.cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: context.dividerColor.withOpacity(0.2),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color ?? context.primaryColor,
        ),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
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
          AppTheme.space4H,
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
      iconColor: AppTheme.error,
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
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: iconColor ?? context.textSecondaryColor.withOpacity(0.5),
              ),
              AppTheme.space4H,
            ],
            
            if (title != null) ...[
              Text(
                title!,
                style: context.titleLarge?.copyWith(
                  fontWeight: AppTheme.bold,
                ),
                textAlign: TextAlign.center,
              ),
              AppTheme.space2H,
            ],
            
            Text(
              message,
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              AppTheme.space4H,
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
        side: BorderSide(color: color ?? AppTheme.primary),
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
        AppTheme.textSizeSm,
        16.0,
      ),
      ButtonSize.medium => (
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        AppTheme.textSizeMd,
        18.0,
      ),
      ButtonSize.large => (
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        AppTheme.textSizeLg,
        20.0,
      ),
    };

    final buttonStyle = style ?? ElevatedButton.styleFrom(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: AppTheme.semiBold,
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
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: effectiveAccentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: effectiveAccentColor,
                size: 24,
              ),
            ),
            AppTheme.space3W,
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
        ? AppTheme.error 
        : (confirmButtonColor ?? context.primaryColor);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: buttonColor,
                size: 24,
              ),
            ),
            AppTheme.space3W,
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
        backgroundColor: AppTheme.success,
        icon: Icons.check_circle,
        action: action,
      ),
    );
  }

  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: AppTheme.error,
        icon: Icons.error,
        action: action,
      ),
    );
  }

  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: AppTheme.warning,
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
          AppTheme.space2W,
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      action: action,
    );
  }
}