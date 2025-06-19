// lib/app/themes/widgets/layout/app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../text_styles.dart';
import '../../core/theme_extensions.dart';

/// أنواع شريط التطبيق
enum AppBarType {
  normal,
  transparent,
  gradient,
  blur,
  floating,
}

/// شريط التطبيق الموحد والمحسن
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
  final AppBarType type;
  final Widget? flexibleSpace;
  final double? leadingWidth;
  final ShapeBorder? shape;
  final List<Color>? gradientColors;
  final bool enableBlur;
  final bool showBorder;

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
    this.type = AppBarType.normal,
    this.flexibleSpace,
    this.leadingWidth,
    this.shape,
    this.gradientColors,
    this.enableBlur = false,
    this.showBorder = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? ThemeConstants.appBarHeight) + 
    (bottom?.preferredSize.height ?? 0)
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget appBar = AppBar(
      title: _buildTitle(context),
      actions: _buildActions(context),
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: _getElevation(),
      backgroundColor: _getBackgroundColor(context),
      foregroundColor: _getForegroundColor(context, isDark),
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      titleTextStyle: _getTitleTextStyle(context, isDark),
      iconTheme: _getIconTheme(context, isDark),
      actionsIconTheme: _getActionsIconTheme(context, isDark),
      systemOverlayStyle: _getSystemOverlayStyle(context, isDark),
      flexibleSpace: _buildFlexibleSpace(context),
      leadingWidth: leadingWidth,
      shape: shape,
    );

    // تطبيق تأثيرات إضافية حسب النوع
    if (type == AppBarType.blur || enableBlur) {
      appBar = _wrapWithBlur(appBar);
    }

    if (showBorder) {
      appBar = _wrapWithBorder(context, appBar);
    }

    return appBar;
  }

  Widget? _buildTitle(BuildContext context) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == AppBarType.gradient || gradientColors != null) ...[
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              Icons.mosque,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          ThemeConstants.space3.w,
        ],
        Flexible(
          child: Text(
            title!,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is AppBarAction) {
        return action;
      }
      
      // تحسين الأزرار العادية
      if (action is IconButton) {
        return Container(
          margin: const EdgeInsets.only(right: ThemeConstants.space2),
          decoration: BoxDecoration(
            color: type == AppBarType.transparent || type == AppBarType.blur
                ? context.cardColor.withValues(alpha: 0.8)
                : null,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: type == AppBarType.transparent || type == AppBarType.blur
                ? Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  )
                : null,
          ),
          child: action,
        );
      }
      
      return action;
    }).toList();
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    if (!automaticallyImplyLeading) return null;
    
    if (Navigator.of(context).canPop()) {
      return AppBackButton(
        color: _getForegroundColor(context, context.isDarkMode),
      );
    }
    
    return null;
  }

  Widget? _buildFlexibleSpace(BuildContext context) {
    if (flexibleSpace != null) return flexibleSpace;
    
    if (type == AppBarType.gradient || gradientColors != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: gradientColors != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors!,
                )
              : ThemeConstants.primaryGradient,
        ),
      );
    }
    
    if (type == AppBarType.blur) {
      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: context.backgroundColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      );
    }
    
    return null;
  }

  Widget _wrapWithBlur(Widget child) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: child,
      ),
    );
  }

  Widget _wrapWithBorder(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: child,
    );
  }

  // Getters for properties
  double _getElevation() {
    if (elevation != null) return elevation!;
    
    switch (type) {
      case AppBarType.transparent:
      case AppBarType.blur:
        return 0;
      case AppBarType.floating:
        return ThemeConstants.elevation4;
      default:
        return ThemeConstants.elevationNone;
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor;
    
    switch (type) {
      case AppBarType.transparent:
        return Colors.transparent;
      case AppBarType.blur:
        return context.backgroundColor.withValues(alpha: 0.8);
      case AppBarType.gradient:
        return Colors.transparent;
      default:
        return context.backgroundColor;
    }
  }

  Color _getForegroundColor(BuildContext context, bool isDark) {
    if (foregroundColor != null) return foregroundColor!;
    
    if (type == AppBarType.gradient || gradientColors != null) {
      return Colors.white;
    }
    
    return isDark ? ThemeConstants.darkTextPrimary : ThemeConstants.lightTextPrimary;
  }

  TextStyle _getTitleTextStyle(BuildContext context, bool isDark) {
    if (titleTextStyle != null) return titleTextStyle!;
    
    final baseStyle = AppTextStyles.h4.copyWith(
      color: _getForegroundColor(context, isDark),
      fontWeight: ThemeConstants.semiBold,
    );
    
    if (type == AppBarType.gradient || gradientColors != null) {
      return baseStyle.copyWith(
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      );
    }
    
    return baseStyle;
  }

  IconThemeData _getIconTheme(BuildContext context, bool isDark) {
    return iconTheme ?? IconThemeData(
      color: _getForegroundColor(context, isDark),
      size: ThemeConstants.iconMd,
    );
  }

  IconThemeData _getActionsIconTheme(BuildContext context, bool isDark) {
    return actionsIconTheme ?? _getIconTheme(context, isDark);
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context, bool isDark) {
    if (systemOverlayStyle != null) return systemOverlayStyle!;
    
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: _getBackgroundColor(context),
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
  }

  // Factory constructors محسنة
  factory CustomAppBar.simple({
    required String title,
    List<Widget>? actions,
    VoidCallback? onBack,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: onBack != null ? AppBackButton(onPressed: onBack) : null,
      backgroundColor: backgroundColor,
    );
  }

  factory CustomAppBar.transparent({
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    Color? foregroundColor,
    bool enableBlur = true,
  }) {
    return CustomAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      type: AppBarType.transparent,
      foregroundColor: foregroundColor,
      enableBlur: enableBlur,
    );
  }

  factory CustomAppBar.gradient({
    required String title,
    required List<Color> gradientColors,
    List<Widget>? actions,
    Widget? leading,
    bool enableBlur = false,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      type: AppBarType.gradient,
      gradientColors: gradientColors,
      enableBlur: enableBlur,
      foregroundColor: Colors.white,
    );
  }

  factory CustomAppBar.withSearch({
    required String title,
    required VoidCallback onSearchTap,
    List<Widget>? additionalActions,
    Color? backgroundColor,
  }) {
    final actions = <Widget>[
      AppBarAction(
        icon: Icons.search,
        onPressed: onSearchTap,
        tooltip: 'بحث',
      ),
      if (additionalActions != null) ...additionalActions,
    ];

    return CustomAppBar(
      title: title,
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  factory CustomAppBar.withTabs({
    required String title,
    required TabBar tabBar,
    List<Widget>? actions,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      bottom: tabBar,
      backgroundColor: backgroundColor,
    );
  }

  factory CustomAppBar.prayer({
    required String title,
    List<Widget>? actions,
    bool showBlur = true,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      type: AppBarType.gradient,
      gradientColors: ThemeConstants.primaryGradient.colors,
      enableBlur: showBlur,
    );
  }

  factory CustomAppBar.floating({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      type: AppBarType.floating,
      backgroundColor: backgroundColor,
      showBorder: true,
    );
  }
}

/// زر رجوع محسن
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;
  final bool showBackground;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.tooltip,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
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

    if (showBackground) {
      button = Container(
        margin: const EdgeInsets.only(left: ThemeConstants.space2),
        decoration: BoxDecoration(
          color: context.cardColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          border: Border.all(
            color: context.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: button,
      );
    }

    return button;
  }
}

/// زر إجراء محسن في شريط التطبيق
class AppBarAction extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;
  final String? badge;
  final Color? badgeColor;
  final bool showBackground;
  final double? size;

  const AppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.badge,
    this.badgeColor,
    this.showBackground = false,
    this.size,
  });

  @override
  State<AppBarAction> createState() => _AppBarActionState();
}

class _AppBarActionState extends State<AppBarAction> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: ThemeConstants.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  widget.icon,
                  color: widget.color,
                  size: widget.size ?? ThemeConstants.iconMd,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onPressed();
                },
                tooltip: widget.tooltip,
              ),
              if (widget.badge != null) _buildBadge(context),
            ],
          ),
        );
      },
    );

    if (widget.showBackground) {
      button = Container(
        margin: const EdgeInsets.only(right: ThemeConstants.space2),
        decoration: BoxDecoration(
          color: context.cardColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          border: Border.all(
            color: context.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: button,
      );
    }

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: button,
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.badgeColor ?? ThemeConstants.error,
          shape: BoxShape.circle,
          border: Border.all(
            color: context.backgroundColor,
            width: 1,
          ),
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        child: Text(
          widget.badge!,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: ThemeConstants.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// شريط تطبيق بحث محسن
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final TextEditingController? controller;
  final bool autofocus;

  const SearchAppBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.onBack,
    this.actions,
    this.controller,
    this.autofocus = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(ThemeConstants.appBarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.backgroundColor,
      elevation: 0,
      leading: AppBackButton(
        onPressed: widget.onBack,
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          border: Border.all(
            color: context.dividerColor.withValues(alpha: 0.3),
          ),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          style: AppTextStyles.body1,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'بحث...',
            hintStyle: AppTextStyles.body1.copyWith(
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: context.textSecondaryColor,
              size: ThemeConstants.iconMd,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: context.textSecondaryColor,
                      size: ThemeConstants.iconSm,
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                      widget.onClear?.call();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space2,
            ),
          ),
        ),
      ),
      actions: widget.actions,
    );
  }
}