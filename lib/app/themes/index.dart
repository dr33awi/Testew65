// lib/app/themes/index.dart
// النقطة الواحدة لاستيراد جميع مكونات الثيم

// ==================== الثيم الأساسي ====================
import 'package:athkar_app/app/themes/components/app_loading.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:athkar_app/app/themes/widgets.dart';
import 'package:flutter/material.dart';

export 'app_theme.dart';
export 'colors.dart';
export 'typography.dart';
export 'widgets.dart';
export 'theme_constants.dart';
// ==================== المكونات المعقدة ====================
export 'components/app_button.dart';
export 'components/app_card.dart';
export 'components/app_text.dart';
export 'components/app_input.dart';
export 'components/app_app_bar.dart';
export 'components/app_dialog.dart';
export 'components/app_loading.dart';
export 'components/app_spacing.dart';
// lib/components/index.dart


// ==================== Extensions للسهولة ====================

/// Extension methods للثيم والألوان
extension BuildContextThemeExtensions on BuildContext {
  // الثيم العام
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  // الألوان السريعة
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get cardColor => theme.cardTheme.color ?? colorScheme.surface;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  Color get textPrimaryColor => colorScheme.onSurface;
  Color get textSecondaryColor => isDarkMode 
      ? ThemeConstants.darkTextSecondary 
      : ThemeConstants.lightTextSecondary;
  Color get dividerColor => isDarkMode 
      ? ThemeConstants.darkBorder 
      : ThemeConstants.lightBorder;
  
  // النصوص السريعة
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
  
  // الأحجام السريعة
  double get smallPadding => ThemeConstants.spaceSm;
  double get mediumPadding => ThemeConstants.spaceMd;
  double get largePadding => ThemeConstants.spaceLg;
  
  double get borderRadius => ThemeConstants.radiusMd;
  double get cardRadius => ThemeConstants.radiusLg;
  
  // رسائل الـ SnackBar
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.success,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.error,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.warning,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.info,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void showWarning(String message) => showWarningSnackBar(message);
}

/// Extension للنصوص
extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.fontBold);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.fontSemiBold);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.fontMedium);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.fontRegular);
  TextStyle get light => copyWith(fontWeight: ThemeConstants.fontLight);
}

/// Widget للتحميل
class AppLoading {
  static Widget circular({
    String? message,
    Color? color,
    double? size,
  }) {
    return AppLoadingWidget(
      message: message,
      color: color,
      size: size,
    );
  }
}

/// Custom AppBar موحد
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return IslamicAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

/// زر موحد للتطبيق
class AppButton {
  static Widget primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    Color? backgroundColor,
  }) {
    return IslamicButton.primary(
      text: text,
      onPressed: onPressed,
      icon: icon,
      width: isFullWidth ? double.infinity : null,
      isLoading: isLoading,
    );
  }
  
  static Widget secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return IslamicButton.secondary(
      text: text,
      onPressed: onPressed,
      icon: icon,
      width: isFullWidth ? double.infinity : null,
      isLoading: isLoading,
    );
  }
  
  static Widget outline({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    Color? color,
  }) {
    return IslamicButton.outlined(
      text: text,
      onPressed: onPressed,
      icon: icon,
      width: isFullWidth ? double.infinity : null,
      color: color,
    );
  }
}

/// مربع حوار معلومات
class AppInfoDialog {
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'موافق',
    String cancelText = 'إلغاء',
    Color? confirmButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        title: Text(
          title,
          style: context.titleLarge?.semiBold,
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: context.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: TextStyle(color: context.textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmButtonColor ?? ThemeConstants.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

/// Widget للضغط مع الحركة
class AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleFactor;

  const AnimatedPress({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleFactor = 0.95,
  });

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
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