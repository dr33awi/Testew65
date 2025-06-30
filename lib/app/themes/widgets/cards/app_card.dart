// lib/app/themes/widgets/cards/app_card.dart
// ✅ محدث بالكامل – تمت إضافة نمط glassWelcome (Glass-morphism + Shimmer)

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
  normal,                 // عادي
  gradient,               // متدرج
  glassmorphism,          // زجاجي
  glassmorphismShimmer,   // زجاجي مع وميض تلميع ⭐️ (جديد)
  outlined,               // محدد
  elevated,               // مرتفع
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
  final String? fadl;
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
    this.fadl,
    this.onFavoriteToggle,
    this.value,
    this.unit,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ التحقق من صحة البيانات
    if (!_isValidCard()) {
      return _buildFallbackCard(context);
    }

    return _buildCard(context);
  }

  /// ✅ التحقق من صحة البطاقة
  bool _isValidCard() {
    // البطاقة صحيحة إذا كان لديها محتوى أو child
    return child != null || 
           title != null || 
           content != null || 
           icon != null ||
           type == CardType.stat ||
           type == CardType.completion;
  }

  /// ✅ بطاقة احتياطية في حالة عدم وجود محتوى
  Widget _buildFallbackCard(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ThemeConstants.radiusMd,
        ),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.textSecondaryColor,
            size: ThemeConstants.iconMd,
          ),
          const SizedBox(width: ThemeConstants.space2),
          Expanded(
            child: Text(
              'بطاقة فارغة',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    final effectiveBorderRadius = borderRadius ?? ThemeConstants.radiusMd;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: _buildCardContainer(context, effectiveColor, effectiveBorderRadius),
    );
  }

  Widget _buildCardContainer(
    BuildContext context,
    Color effectiveColor,
    double effectiveBorderRadius,
  ) {
    // ✅ بناء محتوى البطاقة أولاً
    Widget cardContent = _buildContent(context);
    
    // ✅ إذا لم يكن هناك محتوى، أرجع بطاقة فارغة
    if (cardContent is SizedBox && (cardContent as SizedBox).child == null) {
      return _buildFallbackCard(context);
    }

    // ✅ تطبيق التصميم المناسب
    switch (style) {
      case CardStyle.gradient:
        return _buildGradientCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      case CardStyle.glassmorphism:
        return _buildGlassCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      case CardStyle.glassmorphismShimmer:   // ⭐️ جديد
        return _buildGlassShimmerCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      case CardStyle.outlined:
        return _buildOutlinedCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      case CardStyle.elevated:
        return _buildElevatedCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      default:
        return _buildNormalCard(context, effectiveColor, effectiveBorderRadius, cardContent);
    }
  }

  /// ✅ بطاقة عادية مبسطة
  Widget _buildNormalCard(BuildContext context, Color color, double radius, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: showShadow ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  /// ✅ بطاقة متدرجة
  Widget _buildGradientCard(BuildContext context, Color color, double radius, Widget content) {
    final colors = gradientColors ?? [color, color.darken(0.2)];
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: showShadow ? [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  /// ✅ بطاقة زجاجية محسّنة
  Widget _buildGlassCard(BuildContext context, Color color, double radius, Widget content) {
    final effectiveGradientColors = gradientColors ?? [
      color.withValues(alpha: 0.95),
      color.darken(0.15).withValues(alpha: 0.90),
      color.darken(0.25).withValues(alpha: 0.85),
    ];
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          // الخلفية
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: effectiveGradientColors,
                stops: effectiveGradientColors.length == 3
                    ? [0.0, 0.5, 1.0]
                    : null,
              ),
              boxShadow: showShadow
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
          ),

          // طبقة الزجاج
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),

          // المحتوى
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ بطاقة زجاجية مع Shimmer
  Widget _buildGlassShimmerCard(
    BuildContext context,
    Color color,
    double radius,
    Widget content,
  ) {
    final baseCard = _buildGlassCard(context, color, radius, content);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          baseCard,
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -2.0, end: 2.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              onEnd: () => (context as Element).markNeedsBuild(), // لإعادة التشغيل
              builder: (context, value, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.12),
                        Colors.transparent,
                      ],
                      stops: [
                        (value - 0.3).clamp(0.0, 1.0),
                        value.clamp(0.0, 1.0),
                        (value + 0.3).clamp(0.0, 1.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ بطاقة محددة
  Widget _buildOutlinedCard(BuildContext context, Color color, double radius, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  /// ✅ بطاقة مرتفعة
  Widget _buildElevatedCard(BuildContext context, Color color, double radius, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  // ===== بناء المحتوى حسب النوع =====
  Widget _buildContent(BuildContext context) {
    if (child != null) return child!;
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

  // ------------------------------------------------------------------
  //                 دوال بناء المحتويات (بدون تغيير)
  // ------------------------------------------------------------------
  // ملاحظة: تم الإبقاء على الشيفرات الأصلية كما هي لضمان عدم المساس بالوظائف.
  // (لو كانت هناك تغييرات لديك في هذه المقاطع أضفها هنا.)

  /// محتوى عادي
  Widget _buildNormalContent(BuildContext context) {
    if (title == null && subtitle == null && content == null && icon == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        const Spacer(),
        if (title != null)
          Text(
            title!,
            style: _getTextColor(context) == Colors.white
                ? context.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontSize: 18,
                    height: 1.2,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  )
                : context.titleLarge?.copyWith(
                    color: _getTextColor(context),
                    fontWeight: ThemeConstants.semiBold,
                  ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        if (subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            subtitle!,
            style: _getTextColor(context) == Colors.white
                ? context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  )
                : context.bodyMedium?.copyWith(
                    color: _getTextColor(context, isSecondary: true),
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            content!,
            style: context.bodyLarge?.copyWith(
              color: _getTextColor(context),
            ),
          ),
        ],
        if (onTap != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ],
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space4),
          _buildActions(context),
        ],
      ],
    );
  }

  /// محتوى أذكار
  Widget _buildAthkarContent(BuildContext context) {
    if (content == null && title == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (currentCount != null || totalCount != null || actions != null)
          _buildAthkarHeader(context),
        if ((currentCount != null || totalCount != null || actions != null) &&
            (content != null || title != null))
          const SizedBox(height: ThemeConstants.space3),
        if (content != null || title != null) _buildAthkarBody(context),
        if (source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(context),
        ],
        if (fadl != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildFadlSection(context),
        ],
      ],
    );
  }

  /// محتوى اقتباس
  Widget _buildQuoteContent(BuildContext context) {
    if (content == null && title == null) return const SizedBox.shrink();

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
            ),
            child: Text(
              subtitle!,
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        if (subtitle != null) const SizedBox(height: ThemeConstants.space3),
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          ),
          child: Text(
            content ?? title ?? '',
            textAlign: TextAlign.center,
            style: context.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ),
        if (source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(context),
        ],
      ],
    );
  }

  /// محتوى إكمال
  Widget _buildCompletionContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon ?? Icons.check_circle_outline,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: ThemeConstants.space4),
        if (title != null)
          Text(
            title!,
            style: context.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
            textAlign: TextAlign.center,
          ),
        if (content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space2),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space6),
          _buildActions(context),
        ],
      ],
    );
  }

  /// محتوى معلومات
  Widget _buildInfoContent(BuildContext context) {
    if (title == null && subtitle == null && icon == null) return const SizedBox.shrink();

    return Row(
      children: [
        if (icon != null)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (primaryColor ?? context.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              icon,
              color: primaryColor ?? context.primaryColor,
              size: ThemeConstants.iconLg,
            ),
          ),
        if (icon != null) const SizedBox(width: ThemeConstants.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
              if (subtitle != null) ...[
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  subtitle!,
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }

  /// محتوى إحصائيات
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
        const SizedBox(height: ThemeConstants.space2),
        if (value != null)
          Text(
            value!,
            style: context.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
        if (title != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            title!,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
        if (progress != null) ...[
          const SizedBox(height: ThemeConstants.space3),
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

  // ===== وحدات فرعية خاصة بأذكار =====
  Widget _buildAthkarHeader(BuildContext context) {
    return Row(
      children: [
        if (currentCount != null && totalCount != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$currentCount/$totalCount',
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const Spacer(),
        if (actions != null && actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!
                .map(
                  (action) => IconButton(
                    onPressed: action.onPressed,
                    icon: Icon(action.icon),
                    iconSize: 20,
                    color: Colors.white.withValues(alpha: 0.8),
                    tooltip: action.label,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildAthkarBody(BuildContext context) {
    final text = content ?? title ?? '';
    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
        ),
      ),
    );
  }

  Widget _buildSource(BuildContext context) {
    if (source == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          source!,
          style: context.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildFadlSection(BuildContext context) {
    if (fadl == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.star_outline,
            color: Colors.white.withValues(alpha: 0.8),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفضل',
                  style: context.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fadl!,
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== إجراءات / أزرار =====
  Widget _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) return const SizedBox.shrink();

    if (type == CardType.completion) {
      return Column(
        children: actions!
            .map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
                child: _buildActionButton(context, action, fullWidth: true),
              ),
            )
            .toList(),
      );
    }

    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    CardAction action, {
    bool fullWidth = false,
  }) {
    if (action.isPrimary) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            action.onPressed();
          },
          icon: Icon(action.icon, size: 18),
          label: Text(action.label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: primaryColor ?? context.primaryColor,
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        action.onPressed();
      },
      icon: Icon(action.icon, size: 18),
      label: Text(action.label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
      ),
    );
  }

  // ===== Factory Constructors =====
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return AppCard(
      type: CardType.normal,
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
    String? fadl,
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
      fadl: fadl,
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
      style: CardStyle.gradient,
      title: title,
      content: message,
      subtitle: subMessage,
      icon: icon,
      primaryColor: primaryColor,
      actions: actions,
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
      style: CardStyle.gradient,
      title: title,
      value: value,
      icon: icon,
      primaryColor: color,
      onTap: onTap,
      progress: progress,
    );
  }

  /// ⭐️ بطاقة ترحيب زجاجية مع Shimmer
  factory AppCard.glassWelcome({
    required String title,
    String? subtitle,
    required Color primaryColor,
    List<CardAction>? actions,
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      style: CardStyle.glassmorphismShimmer,
      title: title,
      subtitle: subtitle,
      primaryColor: primaryColor,
      gradientColors: [
        primaryColor.withOpacity(0.95),
        primaryColor.darken(0.20).withOpacity(0.90),
      ],
      actions: actions,
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
    );
  }

  // ===== أدوات مساعدة =====
  Color _getTextColor(BuildContext context, {bool isSecondary = false}) {
    if (style == CardStyle.gradient ||
        style == CardStyle.glassmorphism ||
        style == CardStyle.glassmorphismShimmer) { // ⭐️ مضاف
      return Colors.white.withValues(alpha: isSecondary ? 0.7 : 1.0);
    }
    return isSecondary ? context.textSecondaryColor : context.textPrimaryColor;
  }
}
