// lib/app/themes/widgets/unified_widgets.dart - عربي وداكن فقط
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../core/app_theme_constants.dart';

// ==================== البطاقات الموحدة ====================

/// أنواع البطاقات
enum CardType {
  normal,      // بطاقة عادية
  info,        // بطاقة معلومات
  stat,        // بطاقة إحصائية
  athkar,      // بطاقة أذكار
  completion,  // بطاقة إكمال
}

/// أنماط البطاقات
enum CardStyle {
  normal,        // نمط عادي
  gradient,      // نمط متدرج
  glassmorphism, // نمط زجاجي
}

/// بطاقة موحدة قابلة للتخصيص
class AppCard extends StatelessWidget {
  final CardType type;
  final CardStyle style;
  final Widget? child;
  final String? title;
  final String? subtitle;
  final String? content;
  final IconData? icon;
  final Color? primaryColor;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final List<Widget>? actions;

  const AppCard({
    super.key,
    this.type = CardType.normal,
    this.style = CardStyle.normal,
    this.child,
    this.title,
    this.subtitle,
    this.content,
    this.icon,
    this.primaryColor,
    this.gradientColors,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.actions,
  });

  // Factory constructors للأنماط الشائعة
  factory AppCard.info({
    Key? key,
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
    EdgeInsets? margin,
  }) = _InfoCard;

  factory AppCard.stat({
    Key? key,
    required String title,
    required String value,
    IconData? icon,
    Color? color,
    EdgeInsets? margin,
  }) = _StatCard;

  factory AppCard.athkar({
    Key? key,
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required Color primaryColor,
    required VoidCallback onTap,
    List<CardAction>? actions,
  }) = _AthkarCard;

  factory AppCard.completion({
    Key? key,
    required String title,
    required String message,
    String? subMessage,
    required IconData icon,
    required Color primaryColor,
    List<CardAction>? actions,
  }) = _CompletionCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(AppThemeConstants.space4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppThemeConstants.radiusLg,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppThemeConstants.radiusLg,
          ),
          child: Container(
            decoration: _buildDecoration(context),
            padding: padding ?? const EdgeInsets.all(AppThemeConstants.space4),
            child: child ?? _buildDefaultContent(context),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    switch (style) {
      case CardStyle.gradient:
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors ?? [
              primaryColor ?? AppColors.primary,
              (primaryColor ?? AppColors.primary).darken(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppThemeConstants.radiusLg,
          ),
          boxShadow: AppThemeConstants.shadowMd,
        );
        
      case CardStyle.glassmorphism:
        return BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppThemeConstants.radiusLg,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: AppThemeConstants.shadowLg,
        );
        
      case CardStyle.normal:
        return BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppThemeConstants.radiusLg,
          ),
          border: Border.all(
            color: AppColors.divider.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: AppThemeConstants.shadowSm,
        );
    }
  }

  Widget _buildDefaultContent(BuildContext context) {
    final isGradient = style == CardStyle.gradient;
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
                  color: textColor ?? primaryColor,
                  size: AppThemeConstants.iconLg,
                ),
                const SizedBox(width: AppThemeConstants.space3),
              ],
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: textColor,
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null || content != null)
            const SizedBox(height: AppThemeConstants.space2),
        ],
        
        if (subtitle != null) ...[
          Text(
            subtitle!,
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor?.withValues(alpha: 0.8),
            ),
          ),
          if (content != null)
            const SizedBox(height: AppThemeConstants.space2),
        ],
        
        if (content != null) ...[
          Text(
            content!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: textColor?.withValues(alpha: 0.9),
            ),
          ),
        ],
        
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: AppThemeConstants.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!.map((action) => 
              Padding(
                padding: const EdgeInsets.only(left: AppThemeConstants.space2),
                child: action,
              ),
            ).toList(),
          ),
        ],
      ],
    );
  }
}

// ==================== بطاقات مخصصة ====================

class _InfoCard extends AppCard {
  _InfoCard({
    super.key,
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
    EdgeInsets? margin,
  }) : super(
    type: CardType.info,
    title: title,
    subtitle: subtitle,
    icon: icon,
    primaryColor: iconColor,
    onTap: onTap,
    margin: margin,
  );
}

class _StatCard extends AppCard {
  _StatCard({
    super.key,
    required String title,
    required String value,
    IconData? icon,
    Color? color,
    EdgeInsets? margin,
  }) : super(
    type: CardType.stat,
    style: CardStyle.gradient,
    primaryColor: color,
    margin: margin,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: Colors.white,
            size: AppThemeConstants.iconLg,
          ),
          const SizedBox(height: AppThemeConstants.space2),
        ],
        Text(
          value,
          style: AppTextStyles.displaySmall.copyWith(
            color: Colors.white,
            fontWeight: AppTextStyles.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppThemeConstants.space1),
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _AthkarCard extends AppCard {
  _AthkarCard({
    super.key,
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required Color primaryColor,
    required VoidCallback onTap,
    List<CardAction>? actions,
  }) : super(
    type: CardType.athkar,
    primaryColor: primaryColor,
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // النص الرئيسي
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppThemeConstants.space4),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: AppTextStyles.islamic.copyWith(
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: AppThemeConstants.space3),
        
        // المعلومات الإضافية
        if (source != null || fadl != null) ...[
          if (source != null) ...[
            Row(
              children: [
                Icon(
                  Icons.library_books,
                  size: AppThemeConstants.iconSm,
                  color: primaryColor,
                ),
                const SizedBox(width: AppThemeConstants.space2),
                Expanded(
                  child: Text(
                    'المصدر: $source',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppThemeConstants.space1),
          ],
          
          if (fadl != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.star,
                  size: AppThemeConstants.iconSm,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppThemeConstants.space2),
                Expanded(
                  child: Text(
                    'الفضل: $fadl',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppThemeConstants.space2),
          ],
        ],
        
        // العداد
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeConstants.space3,
                vertical: AppThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
              ),
              child: Text(
                '$currentCount / $totalCount',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: AppTextStyles.bold,
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

class _CompletionCard extends AppCard {
  _CompletionCard({
    super.key,
    required String title,
    required String message,
    String? subMessage,
    required IconData icon,
    required Color primaryColor,
    List<CardAction>? actions,
  }) : super(
    type: CardType.completion,
    style: CardStyle.gradient,
    primaryColor: primaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: AppThemeConstants.icon2xl,
          ),
        ),
        
        const SizedBox(height: AppThemeConstants.space4),
        
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTextStyles.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppThemeConstants.space2),
        
        Text(
          message,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
        
        if (subMessage != null) ...[
          const SizedBox(height: AppThemeConstants.space1),
          Text(
            subMessage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        
        if (actions != null && actions.isNotEmpty) ...[
          const SizedBox(height: AppThemeConstants.space6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions.map((action) => 
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppThemeConstants.space1,
                ),
                child: action,
              ),
            ).toList(),
          ),
        ],
      ],
    ),
  );
}

// ==================== الأزرار الموحدة ====================

/// زر موحد قابل للتخصيص
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isFullWidth;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderRadius,
    this.padding,
  });

  // Factory constructors للأنماط الشائعة
  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? backgroundColor,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return _PrimaryButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: backgroundColor,
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
    return _SecondaryButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
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
      borderColor: borderColor,
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
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppThemeConstants.buttonHeightMedium,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? 
                BorderRadius.circular(AppThemeConstants.radiusMd),
          ),
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppThemeConstants.space4,
          ),
          elevation: AppThemeConstants.elevationSm,
        ),
        child: isLoading
            ? SizedBox(
                width: AppThemeConstants.iconMd,
                height: AppThemeConstants.iconMd,
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
                    Icon(icon!, size: AppThemeConstants.iconMd),
                    const SizedBox(width: AppThemeConstants.space2),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}

class _PrimaryButton extends AppButton {
  const _PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    Color? backgroundColor,
    super.isLoading,
    super.isFullWidth,
  }) : super(
    backgroundColor: backgroundColor ?? AppColors.primary,
    foregroundColor: Colors.black,
  );
}

class _SecondaryButton extends AppButton {
  const _SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    super.isFullWidth,
  }) : super(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.black,
  );
}

class _OutlineButton extends AppButton {
  const _OutlineButton({
    super.key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? borderColor,
    bool isFullWidth = false,
  }) : super(
    text: text,
    onPressed: onPressed,
    icon: icon,
    backgroundColor: Colors.transparent,
    foregroundColor: borderColor ?? AppColors.primary,
    isFullWidth: isFullWidth,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppThemeConstants.buttonHeightMedium,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          side: BorderSide(
            color: foregroundColor ?? AppColors.primary,
            width: AppThemeConstants.borderWidthNormal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? 
                BorderRadius.circular(AppThemeConstants.radiusMd),
          ),
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppThemeConstants.space4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon!, size: AppThemeConstants.iconMd),
              const SizedBox(width: AppThemeConstants.space2),
            ],
            Text(
              text,
              style: AppTextStyles.buttonSecondary.copyWith(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextButton extends AppButton {
  const _TextButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    Color? textColor,
  }) : super(
    foregroundColor: textColor ?? AppColors.primary,
  );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space3,
          vertical: AppThemeConstants.space2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon!, size: AppThemeConstants.iconSm),
            const SizedBox(width: AppThemeConstants.space2),
          ],
          Text(
            text,
            style: AppTextStyles.buttonSecondary.copyWith(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== إجراءات البطاقات ====================

/// إجراء قابل للتنفيذ داخل البطاقة
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
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppThemeConstants.space3,
            vertical: AppThemeConstants.space2,
          ),
          decoration: isPrimary ? BoxDecoration(
            color: color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
          ) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppThemeConstants.iconSm,
                color: isPrimary 
                    ? Colors.black
                    : color ?? AppColors.textSecondary,
              ),
              const SizedBox(width: AppThemeConstants.space1),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isPrimary 
                      ? Colors.black
                      : color ?? AppColors.textSecondary,
                  fontWeight: isPrimary 
                      ? AppTextStyles.semiBold 
                      : AppTextStyles.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== الشريط العلوي الموحد ====================

/// شريط علوي موحد قابل للتخصيص
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AppBarAction>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.elevation,
  });

  factory CustomAppBar.simple({
    Key? key,
    required String title,
    List<AppBarAction>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          color: foregroundColor ?? AppColors.textPrimary,
          fontWeight: AppTextStyles.semiBold,
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      elevation: elevation ?? 0,
      centerTitle: true,
      leading: leading,
      actions: actions?.map((action) => action).toList(),
      bottom: bottom,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    AppThemeConstants.appBarHeightMedium + (bottom?.preferredSize.height ?? 0),
  );
}

/// إجراء في الشريط العلوي
class AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;

  const AppBarAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color ?? AppColors.primary,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      tooltip: tooltip,
    );
  }
}

/// زر العودة المخصص
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: color ?? AppColors.primary,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      tooltip: 'العودة',
    );
  }
}

// ==================== حالات التحميل والفراغ ====================

/// مؤشرات التحميل الموحدة
class AppLoading extends StatelessWidget {
  final String? message;
  final LoadingSize size;
  final Color? color;

  const AppLoading({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
    this.color,
  });

  factory AppLoading.page({
    String? message,
    Color? color,
  }) {
    return AppLoading(
      message: message ?? 'جاري التحميل...',
      size: LoadingSize.large,
      color: color,
    );
  }

  factory AppLoading.circular({
    LoadingSize size = LoadingSize.medium,
    Color? color,
  }) {
    return AppLoading(
      size: size,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final indicatorSize = _getIndicatorSize();
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: _getStrokeWidth(),
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          
          if (message != null) ...[
            const SizedBox(height: AppThemeConstants.space4),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  double _getIndicatorSize() {
    switch (size) {
      case LoadingSize.small:
        return 20.0;
      case LoadingSize.medium:
        return 32.0;
      case LoadingSize.large:
        return 48.0;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2.0;
      case LoadingSize.medium:
        return 3.0;
      case LoadingSize.large:
        return 4.0;
    }
  }
}

/// حالات الفراغ والأخطاء
class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  factory AppEmptyState.noData({
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      message: message,
      icon: Icons.inbox_outlined,
      iconColor: AppColors.textTertiary,
      actionText: actionText ?? 'إعادة المحاولة',
      onAction: onAction,
    );
  }

  factory AppEmptyState.error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return AppEmptyState(
      message: message,
      icon: Icons.error_outline,
      iconColor: AppColors.error,
      actionText: onRetry != null ? 'إعادة المحاولة' : null,
      onAction: onRetry,
    );
  }

  factory AppEmptyState.custom({
    required String message,
    String? title,
    required IconData icon,
    Color? iconColor,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
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
        padding: const EdgeInsets.all(AppThemeConstants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.textTertiary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon!,
                  size: AppThemeConstants.icon2xl,
                  color: iconColor ?? AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppThemeConstants.space4),
            ],
            
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppThemeConstants.space6),
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

// ==================== مكونات أخرى ====================

/// مكون الضغط مع التحريك
class AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;
  final Duration duration;

  const AnimatedPress({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.95,
    this.duration = const Duration(milliseconds: 100),
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
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
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