// lib/theme/widgets.dart - المكونات الموحدة المبسطة والمُصححة
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== البطاقة الموحدة ====================

/// بطاقة موحدة مع الحفاظ على التصميم الحالي
class AppCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool useGradient;
  final List<Widget>? actions;

  const AppCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.padding,
    this.margin,
    this.useGradient = false,
    this.actions,
  });

  // Factory للبطاقات الشائعة
  factory AppCard.info({
    Key? key,
    required String title,
    String? subtitle,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }

  factory AppCard.stat({
    Key? key,
    required String title,
    required String value,
    IconData? icon,
    Color? color,
  }) {
    return AppCard(
      key: key,
      useGradient: true,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: AppTheme.iconLg),
            AppTheme.space2.h,
          ],
          Text(
            value,
            style: AppTheme.displayLarge.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          AppTheme.space1.h,
          Text(
            title,
            style: AppTheme.labelMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  factory AppCard.athkar({
    Key? key,
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required Color primaryColor,
    required VoidCallback onTap,
    List<Widget>? actions,
  }) {
    return AppCard(
      key: key,
      color: primaryColor,
      onTap: onTap,
      actions: actions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // النص الرئيسي مع نفس التصميم
          Container(
            width: double.infinity,
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              content,
              style: AppTheme.quranStyle.copyWith(height: 1.8),
              textAlign: TextAlign.center,
            ),
          ),
          
          AppTheme.space3.h,
          
          // المعلومات الإضافية
          if (source != null) ...[
            Row(
              children: [
                Icon(
                  Icons.library_books,
                  size: AppTheme.iconSm,
                  color: primaryColor,
                ),
                AppTheme.space2.w,
                Expanded(
                  child: Text(
                    'المصدر: $source',
                    style: AppTheme.bodySmall,
                  ),
                ),
              ],
            ),
            AppTheme.space1.h,
          ],
          
          if (fadl != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.star,
                  size: AppTheme.iconSm,
                  color: AppTheme.warning,
                ),
                AppTheme.space2.w,
                Expanded(
                  child: Text(
                    'الفضل: $fadl',
                    style: AppTheme.bodySmall,
                  ),
                ),
              ],
            ),
            AppTheme.space2.h,
          ],
          
          // العداد
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: AppTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: AppTheme.radiusFull.radius,
                ),
                child: Text(
                  '$currentCount / $totalCount',
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ),
              
              if (actions != null && actions.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: _buildDecoration(),
            padding: padding ?? AppTheme.space4.padding,
            child: child ?? _buildDefaultContent(),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    if (useGradient) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? AppTheme.primary,
            (color ?? AppTheme.primary).darken(0.2),
          ],
        ),
        borderRadius: AppTheme.radiusLg.radius,
        boxShadow: AppTheme.shadowMd,
      );
    }
    
    return BoxDecoration(
      color: AppTheme.card,
      borderRadius: AppTheme.radiusLg.radius,
      border: Border.all(
        color: AppTheme.divider.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: AppTheme.shadowSm,
    );
  }

  Widget _buildDefaultContent() {
    final isGradient = useGradient;
    final textColor = isGradient ? Colors.white : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null || title != null) ...[
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon!,
                  color: textColor ?? color ?? AppTheme.primary,
                  size: AppTheme.iconLg,
                ),
                AppTheme.space3.w,
              ],
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    style: AppTheme.titleMedium.copyWith(
                      color: textColor,
                      fontWeight: AppTheme.semiBold,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) AppTheme.space2.h,
        ],
        
        if (subtitle != null) ...[
          Text(
            subtitle!,
            style: AppTheme.bodySmall.copyWith(
              color: textColor?.withValues(alpha: 0.8),
            ),
          ),
        ],
        
        if (actions != null && actions!.isNotEmpty) ...[
          AppTheme.space4.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!.map((action) => 
              Padding(
                padding: const EdgeInsets.only(left: AppTheme.space2),
                child: action,
              ),
            ).toList(),
          ),
        ],
      ],
    );
  }
}

// ==================== الأزرار الموحدة ====================

/// زر موحد بسيط
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height,
  });

  // Factory constructors
  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.black,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: AppTheme.secondary,
      foregroundColor: Colors.black,
      isFullWidth: isFullWidth,
    );
  }

  factory AppButton.outline({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? borderColor,
    bool isFullWidth = false,
  }) {
    return _OutlineButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      borderColor: borderColor ?? AppTheme.primary,
      isFullWidth: isFullWidth,
    );
  }

  factory AppButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? textColor,
  }) {
    return _TextButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      textColor: textColor ?? AppTheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppTheme.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primary,
          foregroundColor: foregroundColor ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusMd.radius,
          ),
          padding: AppTheme.space4.paddingH,
          elevation: AppTheme.elevationSm,
        ),
        child: isLoading
            ? SizedBox(
                width: AppTheme.iconMd,
                height: AppTheme.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? Colors.black,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon!, size: AppTheme.iconMd),
                    AppTheme.space2.w,
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

class _OutlineButton extends AppButton {
  final Color borderColor;

  const _OutlineButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    required this.borderColor,
    super.isFullWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppTheme.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: borderColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusMd.radius,
          ),
          padding: AppTheme.space4.paddingH,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon!, size: AppTheme.iconMd),
              AppTheme.space2.w,
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _TextButton extends AppButton {
  final Color textColor;

  const _TextButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space3,
          vertical: AppTheme.space2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon!, size: AppTheme.iconSm),
            AppTheme.space2.w,
          ],
          Text(text),
        ],
      ),
    );
  }
}

// ==================== الشريط العلوي ====================

/// شريط علوي بسيط
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTheme.titleLarge.copyWith(
          fontWeight: AppTheme.semiBold,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: leading,
      actions: actions,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

// ==================== إجراءات البطاقات ====================

/// إجراء في البطاقة
class CardAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color? color;

  const CardAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: AppTheme.radiusMd.radius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space2,
          ),
          decoration: isPrimary ? BoxDecoration(
            color: color ?? AppTheme.primary,
            borderRadius: AppTheme.radiusMd.radius,
          ) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppTheme.iconSm,
                color: isPrimary 
                    ? Colors.black
                    : color ?? AppTheme.textSecondary,
              ),
              AppTheme.space1.w,
              Text(
                label,
                style: AppTheme.labelMedium.copyWith(
                  color: isPrimary 
                      ? Colors.black
                      : color ?? AppTheme.textSecondary,
                  fontWeight: isPrimary 
                      ? AppTheme.semiBold 
                      : AppTheme.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== حالات التحميل ====================

/// مؤشر التحميل
class AppLoading extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;

  const AppLoading({
    super.key,
    this.message,
    this.color,
    this.size,
  });

  factory AppLoading.page({String? message}) {
    return AppLoading(
      message: message ?? 'جاري التحميل...',
      size: 48,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? AppTheme.iconMd,
            height: size ?? AppTheme.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppTheme.primary,
              ),
            ),
          ),
          
          if (message != null) ...[
            AppTheme.space4.h,
            Text(
              message!,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// حالة الفراغ
class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.actionText,
    this.onAction,
  });

  factory AppEmptyState.noData({
    required String message,
    VoidCallback? onRetry,
  }) {
    return AppEmptyState(
      message: message,
      icon: Icons.inbox_outlined,
      actionText: onRetry != null ? 'إعادة المحاولة' : null,
      onAction: onRetry,
    );
  }

  factory AppEmptyState.error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return AppEmptyState(
      message: message,
      icon: Icons.error_outline,
      actionText: onRetry != null ? 'إعادة المحاولة' : null,
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppTheme.space6.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon!,
                  size: 40,
                  color: AppTheme.textTertiary,
                ),
              ),
              AppTheme.space4.h,
            ],
            
            Text(
              message,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              AppTheme.space6.h,
              AppButton.outline(
                text: actionText!,
                onPressed: onAction!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== مكون الضغط المتحرك ====================

/// مكون بتأثير الضغط
class AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;

  const AnimatedPress({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.95,
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
      end: widget.scale,
    ).animate(_controller);
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