// lib/app/themes/widgets/widgets.dart - النظام المنظف والمحسّن
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== Export الكروت المتخصصة الجديدة ====================
export 'specialized/athkar_cards.dart';
export 'specialized/prayer_cards.dart';
export 'specialized/qibla_cards.dart';
export 'specialized/tasbih_cards.dart';
export 'specialized/settings_cards.dart';

// ==================== المكونات الأساسية فقط ====================

/// زر موحد أساسي
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
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: AppTheme.secondary,
      foregroundColor: Colors.black,
      isLoading: isLoading,
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
    Color? color,
  }) {
    return _TextButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      color: color ?? AppTheme.primary,
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
  final Color color;

  const _TextButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: AppTheme.space3.paddingH,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon!, size: AppTheme.iconSm),
            AppTheme.space1.w,
          ],
          Text(text),
        ],
      ),
    );
  }
}

/// بطاقة أساسية عامة
class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final bool useGradient;
  final List<Color>? gradientColors;
  final bool useAnimation;
  final double? borderRadius;
  final double? elevation;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.useGradient = false,
    this.gradientColors,
    this.useAnimation = true,
    this.borderRadius,
    this.elevation,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.useAnimation && widget.onTap != null) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      );
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 0.97,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
    } else {
      _animationController = AnimationController(
        duration: Duration.zero,
        vsync: this,
      );
      _scaleAnimation = const AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.lightImpact();
      if (widget.useAnimation) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      }
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? AppTheme.space3.padding,
            child: Material(
              color: Colors.transparent,
              borderRadius: (widget.borderRadius ?? AppTheme.radiusLg).radius,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: (widget.borderRadius ?? AppTheme.radiusLg).radius,
                child: Container(
                  decoration: _buildDecoration(),
                  padding: widget.padding ?? AppTheme.space4.padding,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration() {
    if (widget.useGradient) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.gradientColors ?? [
            widget.color ?? AppTheme.primary,
            AppTheme.darken(widget.color ?? AppTheme.primary, 0.2),
          ],
        ),
        borderRadius: (widget.borderRadius ?? AppTheme.radiusLg).radius,
        boxShadow: AppTheme.shadowMd,
      );
    }
    
    return BoxDecoration(
      color: widget.color ?? AppTheme.card,
      borderRadius: (widget.borderRadius ?? AppTheme.radiusLg).radius,
      border: Border.all(
        color: AppTheme.divider.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: widget.elevation != null ? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: widget.elevation! * 2,
          offset: Offset(0, widget.elevation!),
        ),
      ] : AppTheme.shadowSm,
    );
  }
}

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

  factory AppLoading.small() {
    return const AppLoading(size: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? AppTheme.iconMd,
            height: size ?? AppTheme.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: size != null && size! < 30 ? 2 : 3,
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
  final Color? color;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.actionText,
    this.onAction,
    this.color,
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

  factory AppEmptyState.search({
    required String query,
  }) {
    return AppEmptyState(
      message: 'لا توجد نتائج للبحث عن "$query"',
      icon: Icons.search_off,
    );
  }

  factory AppEmptyState.error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return AppEmptyState(
      message: message,
      icon: Icons.error_outline,
      actionText: 'إعادة المحاولة',
      onAction: onRetry,
      color: AppTheme.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = color ?? AppTheme.textTertiary;
    
    return Center(
      child: Padding(
        padding: AppTheme.space6.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon!,
                  size: 40,
                  color: stateColor,
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
                borderColor: stateColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// حالة الخطأ
class AppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const AppErrorState({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppTheme.space6.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الخطأ
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 50,
                color: AppTheme.error,
              ),
            ),
            
            AppTheme.space4.h,
            
            // العنوان
            Text(
              title,
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.error,
                fontWeight: AppTheme.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            AppTheme.space2.h,
            
            // الرسالة
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            AppTheme.space6.h,
            
            // الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onBack != null) ...[
                  AppButton.outline(
                    text: 'رجوع',
                    onPressed: onBack!,
                    icon: Icons.arrow_back,
                  ),
                  if (onRetry != null) AppTheme.space3.w,
                ],
                
                if (onRetry != null)
                  AppButton.primary(
                    text: 'إعادة المحاولة',
                    onPressed: onRetry!,
                    icon: Icons.refresh,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// نص مع أيقونة
class AppIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final double? iconSize;
  final TextStyle? textStyle;
  final MainAxisAlignment alignment;

  const AppIconText({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.iconSize,
    this.textStyle,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.textSecondary;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          size: iconSize ?? AppTheme.iconSm,
          color: effectiveColor,
        ),
        AppTheme.space2.w,
        Text(
          text,
          style: textStyle?.copyWith(color: effectiveColor) ?? 
                 AppTheme.bodyMedium.copyWith(color: effectiveColor),
        ),
      ],
    );
  }
}

/// فاصل مع نص
class AppDivider extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? thickness;

  const AppDivider({
    super.key,
    this.text,
    this.color,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppTheme.divider;
    
    if (text == null) {
      return Divider(
        color: dividerColor,
        thickness: thickness ?? 1,
      );
    }
    
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness ?? 1,
          ),
        ),
        Padding(
          padding: AppTheme.space3.paddingH,
          child: Text(
            text!,
            style: AppTheme.caption.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness ?? 1,
          ),
        ),
      ],
    );
  }
}

/// شارة (Badge)
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.size,
  });

  factory AppBadge.primary(String text) {
    return AppBadge(
      text: text,
      backgroundColor: AppTheme.primary,
      textColor: Colors.black,
    );
  }

  factory AppBadge.error(String text) {
    return AppBadge(
      text: text,
      backgroundColor: AppTheme.error,
      textColor: Colors.white,
    );
  }

  factory AppBadge.success(String text) {
    return AppBadge(
      text: text,
      backgroundColor: AppTheme.success,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size ?? AppTheme.space2,
        vertical: (size ?? AppTheme.space2) / 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primary,
        borderRadius: AppTheme.radiusFull.radius,
      ),
      child: Text(
        text,
        style: AppTheme.caption.copyWith(
          color: textColor ?? Colors.white,
          fontWeight: AppTheme.bold,
          fontSize: (size ?? AppTheme.space2) * 0.7,
        ),
      ),
    );
  }
}