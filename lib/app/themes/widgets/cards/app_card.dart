// lib/app/themes/widgets/cards/app_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// أنواع البطاقات
enum CardType {
  normal,      // بطاقة عادية
  athkar,      // بطاقة أذكار
  quote,       // بطاقة اقتباس
  completion,  // بطاقة إكمال
  info,        // بطاقة معلومات
  stat,        // بطاقة إحصائيات
}

/// أنماط البطاقات
enum CardStyle {
  normal,        // عادي
  gradient,      // متدرج
  glassmorphism, // زجاجي
  outlined,      // محدد
  elevated,      // مرتفع
}

/// إجراءات البطاقة
class CardAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const CardAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
  });
}

/// بطاقة موحدة لجميع الاستخدامات
class AppCard extends StatelessWidget {
  // النوع والأسلوب
  final CardType type;
  final CardStyle style;
  
  // المحتوى الأساسي
  final String? title;
  final String? subtitle;
  final String? content;
  final Widget? child;
  
  // الأيقونات والصور
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final String? imageUrl;
  
  // الألوان والتصميم
  final Color? primaryColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // خصائص إضافية
  final String? badge;
  final Color? badgeColor;
  final bool isSelected;
  final bool showShadow;
  final bool animate;
  
  // خصائص خاصة بالأذكار
  final int? currentCount;
  final int? totalCount;
  final bool? isFavorite;
  final String? source;
  final VoidCallback? onFavoriteToggle;
  
  // خصائص خاصة بالإحصائيات
  final String? value;
  final String? unit;
  final double? progress;

  const AppCard({
    super.key,
    this.type = CardType.normal,
    this.style = CardStyle.normal,
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.icon,
    this.leading,
    this.trailing,
    this.imageUrl,
    this.primaryColor,
    this.backgroundColor,
    this.gradientColors,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.badge,
    this.badgeColor,
    this.isSelected = false,
    this.showShadow = true,
    this.animate = true,
    this.currentCount,
    this.totalCount,
    this.isFavorite,
    this.source,
    this.onFavoriteToggle,
    this.value,
    this.unit,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = _buildCard(context);
    
    if (animate) {
      return AnimationConfiguration.synchronized(
        duration: ThemeConstants.durationNormal,
        child: SlideAnimation(
          horizontalOffset: 50,
          curve: ThemeConstants.curveSmooth,
          child: FadeInAnimation(
            curve: ThemeConstants.curveDefault,
            child: card,
          ),
        ),
      );
    }
    
    return card;
  }

  Widget _buildCard(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    final effectiveBorderRadius = borderRadius ?? ThemeConstants.radiusLg;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: Material(
        elevation: showShadow ? (elevation ?? ThemeConstants.elevation4) : 0,
        shadowColor: showShadow ? effectiveColor.withValues(alpha: ThemeConstants.opacity20) : Colors.transparent,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: _getDecoration(context, effectiveColor, effectiveBorderRadius),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            child: Stack(
              children: [
                Padding(
                  padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
                  child: _buildContent(context),
                ),
                if (badge != null) _buildBadge(context),
                if (isSelected) _buildSelectionIndicator(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(BuildContext context, Color color, double radius) {
    final bgColor = backgroundColor ?? context.cardColor;
    
    switch (style) {
      case CardStyle.gradient:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: ThemeConstants.customGradient(
            colors: gradientColors ?? [color, color.darken(0.2)],
          ),
        );
        
      case CardStyle.glassmorphism:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgColor.withValues(alpha: ThemeConstants.opacity70),
          border: Border.all(
            color: context.isDarkMode ? Colors.white.withValues(alpha: ThemeConstants.opacity20) : color.withValues(alpha: ThemeConstants.opacity20),
            width: ThemeConstants.borderThin,
          ),
        );
        
      case CardStyle.outlined:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgColor,
          border: Border.all(
            color: color.withValues(alpha: ThemeConstants.opacity30),
            width: ThemeConstants.borderMedium,
          ),
        );
        
      case CardStyle.elevated:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgColor,
          boxShadow: ThemeConstants.shadowForElevation(elevation ?? 8),
        );
        
      case CardStyle.normal:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgColor,
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    // إذا كان هناك child مخصص، استخدمه
    if (child != null) return child!;
    
    // بناء المحتوى حسب النوع
    switch (type) {
      case CardType.athkar:
        return _buildAthkarContent(context);
      case CardType.quote:
        return _buildQuoteContent(context);
      case CardType.completion:
        return _buildCompletionContent(context);
      case CardType.info:
        return _buildInfoContent(context);
      case CardType.stat:
        return _buildStatContent(context);
      case CardType.normal:
        return _buildNormalContent(context);
    }
  }

  Widget _buildNormalContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || leading != null || trailing != null)
          _buildHeader(context),
        if (subtitle != null) ...[
          if (title != null) ThemeConstants.space1.h,
          Text(
            subtitle!,
            style: context.bodyMedium?.textColor(_getTextColor(context, isSecondary: true)),
          ),
        ],
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            style: context.bodyLarge?.textColor(_getTextColor(context)),
          ),
        ],
        if (actions != null && actions!.isNotEmpty) ...[
          ThemeConstants.space4.h,
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildAthkarContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الرأس مع العداد والمفضلة
        if (currentCount != null || onFavoriteToggle != null)
          _buildAthkarHeader(context),
        
        if (currentCount != null || onFavoriteToggle != null)
          ThemeConstants.space3.h,
        
        // محتوى الذكر
        _buildAthkarBody(context),
        
        // المصدر
        if (source != null) ...[
          ThemeConstants.space3.h,
          _buildSource(context),
        ],
        
        // الإجراءات
        if (actions != null && actions!.isNotEmpty) ...[
          ThemeConstants.space4.h,
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildQuoteContent(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: ThemeConstants.opacity20),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Text(
              subtitle!,
              style: context.labelMedium?.textColor(_getTextColor(context)).semiBold,
            ),
          ),
        
        if (subtitle != null) ThemeConstants.space3.h,
        
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: _getTextColor(context).withValues(alpha: ThemeConstants.opacity10),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: _getTextColor(context).withValues(alpha: ThemeConstants.opacity20),
              width: ThemeConstants.borderThin,
            ),
          ),
          child: Stack(
            children: [
              // علامة اقتباس في البداية
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.format_quote,
                  size: ThemeConstants.iconSm,
                  color: Colors.black26,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
                child: Text(
                  content ?? title ?? '',
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.textColor(_getTextColor(context)).copyWith(
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
              ),
              
              // علامة اقتباس في النهاية
              Positioned(
                bottom: 0,
                left: 0,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: Icon(
                    Icons.format_quote,
                    size: ThemeConstants.iconSm,
                    color: _getTextColor(context).withValues(alpha: ThemeConstants.opacity50),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (source != null) ...[
          ThemeConstants.space3.h,
          _buildSource(context),
        ],
      ],
    );
  }

  Widget _buildCompletionContent(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الأيقونة
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: ThemeConstants.opacity10),
            shape: BoxShape.circle,
            border: Border.all(
              color: effectiveColor.withValues(alpha: ThemeConstants.opacity30),
              width: ThemeConstants.borderMedium,
            ),
          ),
          child: Icon(
            icon ?? Icons.check_circle_outline,
            color: effectiveColor,
            size: ThemeConstants.icon2xl,
          ),
        ),
        
        ThemeConstants.space5.h,
        
        // العنوان
        if (title != null)
          Text(
            title!,
            style: context.headlineMedium?.textColor(_getTextColor(context)),
            textAlign: TextAlign.center,
          ),
        
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge?.textColor(_getTextColor(context)),
          ),
        ],
        
        if (subtitle != null) ...[
          ThemeConstants.space2.h,
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.textColor(_getTextColor(context, isSecondary: true)),
          ),
        ],
        
        if (actions != null && actions!.isNotEmpty) ...[
          ThemeConstants.space6.h,
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildInfoContent(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    
    return Row(
      children: [
        if (icon != null)
          Container(
            width: ThemeConstants.icon2xl,
            height: ThemeConstants.icon2xl,
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: ThemeConstants.opacity10),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: effectiveColor,
              size: ThemeConstants.iconLg,
            ),
          ),
        
        if (icon != null) ThemeConstants.space4.w,
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: context.titleMedium?.semiBold.textColor(_getTextColor(context)),
                ),
              if (subtitle != null) ...[
                ThemeConstants.space1.h,
                Text(
                  subtitle!,
                  style: context.bodyMedium?.textColor(_getTextColor(context, isSecondary: true)),
                ),
              ],
            ],
          ),
        ),
        
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildStatContent(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: effectiveColor,
                size: ThemeConstants.iconLg,
              ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ThemeConstants.iconSm,
                color: _getTextColor(context, isSecondary: true),
              ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        if (value != null)
          Text(
            value!,
            style: context.headlineMedium?.textColor(effectiveColor).bold,
          ),
        
        if (title != null) ...[
          ThemeConstants.space1.h,
          Text(
            title!,
            style: context.bodyMedium?.textColor(_getTextColor(context, isSecondary: true)),
          ),
        ],
        
        if (progress != null) ...[
          ThemeConstants.space3.h,
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: progress!,
              minHeight: 4,
              backgroundColor: context.dividerColor.withValues(alpha: ThemeConstants.opacity50),
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    
    return Row(
      children: [
        if (leading != null)
          leading!
        else if (icon != null)
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: ThemeConstants.opacity10),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: effectiveColor,
              size: ThemeConstants.iconMd,
            ),
          ),
        
        if ((leading != null || icon != null) && title != null)
          ThemeConstants.space3.w,
        
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: context.titleMedium?.textColor(_getTextColor(context)).semiBold,
            ),
          ),
        
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildAthkarHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentCount != null && totalCount != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: ThemeConstants.opacity20),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                  ThemeConstants.space1.w,
                ],
                Text(
                  'عدد التكرار $currentCount/$totalCount',
                  style: context.labelMedium?.textColor(Colors.white).semiBold,
                ),
              ],
            ),
          ),
        
        if (onFavoriteToggle != null)
          IconButton(
            icon: Icon(
              isFavorite == true ? Icons.favorite : Icons.favorite_border,
              color: style == CardStyle.gradient ? Colors.white : primaryColor ?? context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              onFavoriteToggle!();
            },
            tooltip: isFavorite == true ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
          ),
      ],
    );
  }

  Widget _buildAthkarBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: style == CardStyle.gradient 
            ? Colors.white.withValues(alpha: ThemeConstants.opacity10)
            : (primaryColor ?? context.primaryColor).withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: style == CardStyle.gradient
              ? Colors.white.withValues(alpha: ThemeConstants.opacity20)
              : (primaryColor ?? context.primaryColor).withValues(alpha: ThemeConstants.opacity20),
          width: ThemeConstants.borderThin,
        ),
      ),
      child: Text(
        content ?? title ?? '',
        textAlign: TextAlign.center,
        style: context.bodyLarge?.textColor(_getTextColor(context)).copyWith(
          fontSize: 20,
          fontFamily: ThemeConstants.fontFamilyArabic,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
        ),
      ),
    );
  }

  Widget _buildSource(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: style == CardStyle.gradient
              ? Colors.black.withValues(alpha: ThemeConstants.opacity20)
              : (primaryColor ?? context.primaryColor).withValues(alpha: ThemeConstants.opacity10),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          source!,
          style: context.labelLarge?.textColor(_getTextColor(context)).semiBold,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    // للبطاقات من نوع completion، عرض الإجراءات بشكل عمودي
    if (type == CardType.completion) {
      return Column(
        children: actions!.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
          child: _buildActionButton(context, action, fullWidth: true),
        )).toList(),
      );
    }
    
    // للبطاقات الأخرى، عرض الإجراءات بشكل أفقي
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, CardAction action, {bool fullWidth = false}) {
    final effectiveColor = action.color ?? primaryColor ?? context.primaryColor;
    
    if (action.isPrimary) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            action.onPressed();
          },
          icon: Icon(action.icon, size: ThemeConstants.iconSm),
          label: Text(action.label),
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveColor,
            foregroundColor: effectiveColor.contrastingTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          ),
        ),
      );
    }
    
    // زر ثانوي
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          action.onPressed();
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: style == CardStyle.gradient
                ? Colors.white.withValues(alpha: ThemeConstants.opacity20)
                : effectiveColor.withValues(alpha: ThemeConstants.opacity10),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: style == CardStyle.gradient
                  ? Colors.white.withValues(alpha: ThemeConstants.opacity30)
                  : effectiveColor.withValues(alpha: ThemeConstants.opacity30),
              width: ThemeConstants.borderThin,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: style == CardStyle.gradient ? Colors.white : effectiveColor,
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space2.w,
              Text(
                action.label,
                style: context.labelMedium?.textColor(
                  style == CardStyle.gradient ? Colors.white : effectiveColor
                ).semiBold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    final badgeBgColor = badgeColor ?? context.colorScheme.secondary;
    
    return Positioned(
      top: ThemeConstants.space2,
      left: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space2,
          vertical: ThemeConstants.space1,
        ),
        decoration: BoxDecoration(
          color: badgeBgColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          badge!,
          style: context.labelSmall?.textColor(badgeBgColor.contrastingTextColor).semiBold,
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    
    return Positioned(
      top: ThemeConstants.space2,
      right: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space1 / 2),
        decoration: BoxDecoration(
          color: effectiveColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: backgroundColor ?? context.cardColor,
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.check,
          color: effectiveColor.contrastingTextColor,
          size: ThemeConstants.iconSm,
        ),
      ),
    );
  }

  Color _getTextColor(BuildContext context, {bool isSecondary = false}) {
    if (style == CardStyle.gradient) {
      return Colors.white.withValues(alpha: isSecondary ? ThemeConstants.opacity70 : 1.0);
    }
    
    if (backgroundColor != null) {
      return backgroundColor!.contrastingTextColor.withValues(
        alpha: isSecondary ? ThemeConstants.opacity70 : 1.0
      );
    }
    
    return isSecondary ? context.textSecondaryColor : context.textPrimaryColor;
  }

  // Factory constructors للتوافق مع الكود القديم
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: CardType.normal,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
    );
  }

  factory AppCard.athkar({
    required String content,
    String? source,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? primaryColor,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    return AppCard(
      type: CardType.athkar,
      style: CardStyle.gradient,
      content: content,
      source: source,
      currentCount: currentCount,
      totalCount: totalCount,
      isFavorite: isFavorite,
      primaryColor: primaryColor,
      onTap: onTap,
      onFavoriteToggle: onFavoriteToggle,
      actions: actions,
    );
  }

  factory AppCard.quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
  }) {
    return AppCard(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: quote,
      source: author,
      subtitle: category,
      primaryColor: primaryColor,
      gradientColors: gradientColors,
    );
  }

  factory AppCard.completion({
    required String title,
    required String message,
    String? subMessage,
    IconData icon = Icons.check_circle_outline,
    Color? primaryColor,
    List<CardAction> actions = const [],
  }) {
    return AppCard(
      type: CardType.completion,
      title: title,
      content: message,
      subtitle: subMessage,
      icon: icon,
      primaryColor: primaryColor,
      actions: actions,
      padding: const EdgeInsets.all(ThemeConstants.space6),
    );
  }

  factory AppCard.info({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return AppCard(
      type: CardType.info,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: iconColor,
      trailing: trailing,
    );
  }

  factory AppCard.stat({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
    double? progress,
  }) {
    return AppCard(
      type: CardType.stat,
      title: title,
      value: value,
      icon: icon,
      primaryColor: color,
      onTap: onTap,
      progress: progress,
    );
  }
}