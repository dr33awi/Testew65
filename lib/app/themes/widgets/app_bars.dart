// lib/app/themes/widgets/app_bars.dart - أشرطة علوية موحدة
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام الأشرطة العلوية الموحد
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;
  final double? elevation;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final TextStyle? titleStyle;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation,
    this.bottom,
    this.showBackButton = true,
    this.onBackPressed,
    this.titleStyle,
  });

  // ========== Factory Constructors ==========

  /// شريط علوي أساسي
  factory AppAppBar.basic({
    Key? key,
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  /// شريط علوي للصفحة الرئيسية
  factory AppAppBar.home({
    Key? key,
    required String title,
    List<Widget>? actions,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      actions: actions,
      showBackButton: false,
      titleStyle: AppTheme.headlineMedium.copyWith(
        fontWeight: AppTheme.bold,
      ),
    );
  }

  /// شريط علوي مع بحث
  factory AppAppBar.search({
    Key? key,
    required String title,
    required VoidCallback onSearchPressed,
    List<Widget>? extraActions,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      onBackPressed: onBackPressed,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchPressed,
          tooltip: 'البحث',
        ),
        ...?extraActions,
      ],
    );
  }

  /// شريط علوي شفاف للتمرير
  factory AppAppBar.transparent({
    Key? key,
    required String title,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      onBackPressed: onBackPressed,
    );
  }

  /// شريط علوي ملون
  factory AppAppBar.colored({
    Key? key,
    required String title,
    required Color color,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      actions: actions,
      backgroundColor: color,
      elevation: AppTheme.elevationSm,
      onBackPressed: onBackPressed,
      titleStyle: AppTheme.titleLarge.copyWith(
        color: Colors.white,
        fontWeight: AppTheme.bold,
      ),
    );
  }

  /// شريط علوي بتاب
  factory AppAppBar.withTabs({
    Key? key,
    required String title,
    required TabBar tabBar,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      actions: actions,
      bottom: tabBar,
      onBackPressed: onBackPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleStyle ?? AppTheme.titleLarge.copyWith(
          fontWeight: AppTheme.semiBold,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      actions: actions,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _getStatusBarBrightness(),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    if (!showBackButton) return null;
    
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'رجوع',
    );
  }

  Brightness _getStatusBarBrightness() {
    if (backgroundColor == null || backgroundColor == Colors.transparent) {
      return Brightness.light;
    }
    
    // حساب سطوع اللون لتحديد لون شريط الحالة
    final luminance = backgroundColor!.computeLuminance();
    return luminance > 0.5 ? Brightness.dark : Brightness.light;
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }
}

// ==================== مكونات الشريط العلوي ====================

/// زر إعدادات للشريط العلوي
class AppBarSettingsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasBadge;
  final String? badgeText;

  const AppBarSettingsButton({
    super.key,
    required this.onPressed,
    this.hasBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onPressed,
          tooltip: 'الإعدادات',
        ),
        if (hasBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppTheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeText ?? '',
                style: AppTheme.caption.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// زر القائمة للشريط العلوي
class AppBarMenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBarMenuButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: onPressed,
      tooltip: 'القائمة',
    );
  }
}

/// زر المشاركة للشريط العلوي
class AppBarShareButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppBarShareButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: onPressed,
      tooltip: 'مشاركة',
    );
  }
}

/// عدادات للشريط العلوي
class AppBarCounter extends StatelessWidget {
  final int count;
  final Color? color;

  const AppBarCounter({
    super.key,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space2,
        vertical: AppTheme.space1,
      ),
      decoration: BoxDecoration(
        color: (color ?? AppTheme.primary).withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusFull.radius,
        border: Border.all(
          color: color ?? AppTheme.primary,
          width: 1,
        ),
      ),
      child: Text(
        AppTheme.formatLargeNumber(count),
        style: AppTheme.labelMedium.copyWith(
          color: color ?? AppTheme.primary,
          fontWeight: AppTheme.bold,
          fontFamily: AppTheme.numbersFont,
        ),
      ),
    );
  }
}

