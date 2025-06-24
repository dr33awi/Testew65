// lib/app/themes/widgets/cards/app_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
    return _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    final effectiveBorderRadius = borderRadius ?? ThemeConstants.radius3xl;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: _buildCardContainer(context, effectiveColor, effectiveBorderRadius),
    );
  }

  Widget _buildCardContainer(BuildContext context, Color effectiveColor, double effectiveBorderRadius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        gradient: _getCardGradient(context, effectiveColor),
        boxShadow: showShadow ? [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
              ),
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
        ),
      ),
    );
  }

  LinearGradient _getCardGradient(BuildContext context, Color color) {
    List<Color> colors;
    
    switch (style) {
      case CardStyle.gradient:
        // إذا تم تمرير ألوان مخصصة، استخدمها
        if (gradientColors != null && gradientColors!.isNotEmpty) {
          colors = gradientColors!;
        } else {
          colors = [
            color,
            color.darken(0.2),
          ];
        }
        break;
      case CardStyle.glassmorphism:
        colors = [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.1),
        ];
        break;
      case CardStyle.outlined:
      case CardStyle.elevated:
      case CardStyle.normal:
        // للكارد العادي، استخدم تدرج خفيف من اللون الأساسي
        colors = [
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.6),
        ];
        break;
    }
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors, // استخدام الألوان مباشرة بدون تقليل الشفافية
    );
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              subtitle!,
              style: context.labelMedium?.textColor(Colors.white).semiBold,
            ),
          ),
        
        if (subtitle != null) ThemeConstants.space3.h,
        
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
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
                  color: Colors.white54,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
                child: Text(
                  content ?? title ?? '',
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.textColor(Colors.white).copyWith(
                    fontSize: 18,
                    height: 1.8,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              
              // علامة اقتباس في النهاية
              Positioned(
                bottom: 0,
                left: 0,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: const Icon(
                    Icons.format_quote,
                    size: ThemeConstants.iconSm,
                    color: Colors.white54,
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
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            icon ?? Icons.check_circle_outline,
            color: Colors.white,
            size: ThemeConstants.icon2xl,
          ),
        ),
        
        ThemeConstants.space5.h,
        
        // العنوان
        if (title != null)
          Text(
            title!,
            style: context.headlineMedium?.textColor(Colors.white).copyWith(
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge?.textColor(Colors.white.withValues(alpha: 0.9)),
          ),
        ],
        
        if (subtitle != null) ...[
          ThemeConstants.space2.h,
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.textColor(Colors.white.withValues(alpha: 0.7)),
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
    return Row(
      children: [
        if (icon != null)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: ThemeConstants.iconLg,
                ),
              ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ThemeConstants.iconSm,
                color: Colors.white.withValues(alpha: 0.7),
              ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        if (value != null)
          Text(
            value!,
            style: context.headlineMedium?.textColor(Colors.white).bold.copyWith(
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        
        if (title != null) ...[
          ThemeConstants.space1.h,
          Text(
            title!,
            style: context.bodyMedium?.textColor(Colors.white.withValues(alpha: 0.8)),
          ),
        ],
        
        if (progress != null) ...[
          ThemeConstants.space3.h,
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: progress!,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (leading != null)
          leading!
        else if (icon != null)
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: _getTextColor(context),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
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
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onFavoriteToggle!();
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  isFavorite == true ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: ThemeConstants.iconMd,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAthkarBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        content ?? title ?? '',
        textAlign: TextAlign.center,
        style: context.bodyLarge?.textColor(Colors.white).copyWith(
          fontSize: 20,
          fontFamily: ThemeConstants.fontFamilyArabic,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
          shadows: const [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
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
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          source!,
          style: context.labelLarge?.textColor(Colors.white).semiBold,
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
    if (action.isPrimary) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                action.onPressed();
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space4,
                  vertical: ThemeConstants.space3,
                ),
                child: Row(
                  mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      action.icon,
                      size: ThemeConstants.iconSm,
                      color: primaryColor ?? context.primaryColor,
                    ),
                    ThemeConstants.space2.w,
                    Text(
                      action.label,
                      style: context.labelMedium?.copyWith(
                        color: primaryColor ?? context.primaryColor,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
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
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: Colors.white,
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space2.w,
              Text(
                action.label,
                style: context.labelMedium?.textColor(Colors.white).semiBold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Positioned(
      top: ThemeConstants.space2,
      left: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space2,
          vertical: ThemeConstants.space1,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          badge!,
          style: context.labelSmall?.copyWith(
            color: primaryColor ?? context.primaryColor,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    return Positioned(
      top: ThemeConstants.space2,
      right: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space1),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.check,
          color: primaryColor ?? context.primaryColor,
          size: ThemeConstants.iconSm,
        ),
      ),
    );
  }

  Color _getTextColor(BuildContext context, {bool isSecondary = false}) {
    // معظم الكارد الآن يستخدم النص الأبيض بسبب التأثيرات الزجاجية والتدرجات
    if (style == CardStyle.gradient || style == CardStyle.glassmorphism) {
      return Colors.white.withValues(alpha: isSecondary ? 0.7 : 1.0);
    }
    
    if (backgroundColor != null) {
      return backgroundColor!.contrastingTextColor.withValues(
        alpha: isSecondary ? 0.7 : 1.0
      );
    }
    
    // للكارد العادي، استخدم النص الأبيض أيضاً للتناسق
    return Colors.white.withValues(alpha: isSecondary ? 0.7 : 1.0);
  }

  // Factory constructors للتوافق مع الكود القديم
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: primaryColor,
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
      style: CardStyle.gradient,
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
      style: CardStyle.glassmorphism,
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
      style: CardStyle.gradient,
    );
  }
}