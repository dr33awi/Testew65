// lib/app/themes/widgets/layout/app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';

/// شريط التطبيق الموحد
/// يستخدم بدلاً من AppBar الافتراضي
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final TextStyle? titleTextStyle;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool isTransparent;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final ShapeBorder? shape;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.toolbarHeight,
    this.titleTextStyle,
    this.iconTheme,
    this.actionsIconTheme,
    this.systemOverlayStyle,
    this.isTransparent = false,
    this.flexibleSpace,
    this.leadingWidth,
    this.shape,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? ThemeConstants.appBarHeight) + 
    (bottom?.preferredSize.height ?? 0)
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // الألوان الافتراضية
    final defaultBackgroundColor = isTransparent 
      ? Colors.transparent 
      : (backgroundColor ?? theme.scaffoldBackgroundColor);
    
    final defaultForegroundColor = foregroundColor ?? 
      (isDark ? ThemeConstants.darkTextPrimary : ThemeConstants.lightTextPrimary);

    // نمط النص الافتراضي للعنوان
    final defaultTitleStyle = titleTextStyle ?? AppTextStyles.h4.copyWith(
      color: defaultForegroundColor,
    );

    // أيقونات افتراضية
    final defaultIconTheme = iconTheme ?? IconThemeData(
      color: defaultForegroundColor,
      size: ThemeConstants.iconMd,
    );

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: elevation ?? (isTransparent ? 0 : ThemeConstants.elevationNone),
      backgroundColor: defaultBackgroundColor,
      foregroundColor: defaultForegroundColor,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      titleTextStyle: defaultTitleStyle,
      iconTheme: defaultIconTheme,
      actionsIconTheme: actionsIconTheme ?? defaultIconTheme,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: defaultBackgroundColor,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      flexibleSpace: flexibleSpace,
      leadingWidth: leadingWidth,
      shape: shape,
    );
  }

  /// شريط تطبيق بسيط
  factory CustomAppBar.simple({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBack,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: onBack != null ? BackButton(onPressed: onBack) : null,
    );
  }

  /// شريط تطبيق شفاف
  factory CustomAppBar.transparent({
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    Color? foregroundColor,
  }) {
    return CustomAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      isTransparent: true,
      foregroundColor: foregroundColor,
    );
  }

  /// شريط تطبيق مع بحث
  factory CustomAppBar.withSearch({
    required String title,
    required VoidCallback onSearchTap,
    List<Widget>? additionalActions,
  }) {
    final actions = <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: onSearchTap,
        tooltip: 'بحث',
      ),
      if (additionalActions != null) ...additionalActions,
    ];

    return CustomAppBar(
      title: title,
      actions: actions,
    );
  }

  /// شريط تطبيق مع تبويبات
  factory CustomAppBar.withTabs({
    required String title,
    required TabBar tabBar,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      bottom: tabBar,
    );
  }

  /// شريط تطبيق بتدرج لوني
  factory CustomAppBar.gradient({
    required String title,
    required List<Color> gradientColors,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradientColors,
          ),
        ),
      ),
      foregroundColor: Colors.white,
    );
  }
}

/// زر رجوع مخصص
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: color,
        size: size ?? ThemeConstants.iconMd,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).maybePop();
        }
      },
      tooltip: tooltip ?? 'رجوع',
    );
  }
}

/// زر قائمة مخصص
class AppMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;

  const AppMenuButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.menu_rounded,
        color: color,
        size: size ?? ThemeConstants.iconMd,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onPressed != null) {
          onPressed!();
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
      tooltip: tooltip ?? 'القائمة',
    );
  }
}

/// زر إجراء في شريط التطبيق
class AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;
  final String? badge;
  final Color? badgeColor;

  const AppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          tooltip: tooltip,
        ),
        if (badge != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor ?? ThemeConstants.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}