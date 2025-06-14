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

/// بطاقة موحدة بتصميم بسيط وأنيق
class AppCard extends StatelessWidget {
  // النوع
  final CardType type;
  
  // المحتوى الأساسي
  final String? title;
  final String? subtitle;
  final String? content;
  final Widget? child;
  
  // الأيقونات والصور
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  
  // الألوان والتصميم
  final Color? accentColor;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // خصائص إضافية
  final String? badge;
  final bool isSelected;
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
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.icon,
    this.leading,
    this.trailing,
    this.accentColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.showBorder = false,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.badge,
    this.isSelected = false,
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
          horizontalOffset: 30,
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
    final effectiveColor = accentColor ?? context.primaryColor;
    final effectiveBorderRadius = borderRadius ?? ThemeConstants.radiusLg;
    final effectiveElevation = elevation ?? (showBorder ? 0 : ThemeConstants.elevationMd);
    
    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: Material(
        elevation: effectiveElevation,
        shadowColor: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        color: context.cardColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Container(
            decoration: showBorder ? BoxDecoration(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              border: Border.all(
                color: isSelected ? effectiveColor : context.dividerColor,
                width: isSelected ? ThemeConstants.borderMedium : ThemeConstants.borderLight,
              ),
            ) : null,
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
            style: context.bodyMedium,
          ),
        ],
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            style: context.bodyLarge,
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
    final effectiveColor = accentColor ?? context.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الرأس مع العداد والمفضلة
        if (currentCount != null || onFavoriteToggle != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentCount != null && totalCount != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Text(
                    'التكرار: $currentCount/$totalCount',
                    style: context.labelMedium?.copyWith(
                      color: effectiveColor,
                      fontWeight: ThemeConstants.semiBold,
                    ),
                  ),
                ),
              
              if (onFavoriteToggle != null)
                IconButton(
                  icon: Icon(
                    isFavorite == true ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite == true ? ThemeConstants.error : context.textSecondaryColor,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onFavoriteToggle!();
                  },
                  tooltip: isFavorite == true ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                ),
            ],
          ),
        
        if (currentCount != null || onFavoriteToggle != null)
          ThemeConstants.space3.h,
        
        // محتوى الذكر
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space5),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.dividerColor,
              width: ThemeConstants.borderLight,
            ),
          ),
          child: Text(
            content ?? title ?? '',
            textAlign: TextAlign.center,
            style: context.athkarStyle.copyWith(
              color: context.textPrimaryColor,
            ),
          ),
        ),
        
        // المصدر
        if (source != null) ...[
          ThemeConstants.space3.h,
          Center(
            child: Text(
              source!,
              style: context.labelMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ),
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
    final effectiveColor = accentColor ?? context.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Text(
              subtitle!,
              style: context.labelMedium?.copyWith(
                color: effectiveColor,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        
        if (subtitle != null) ThemeConstants.space3.h,
        
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.dividerColor,
              width: ThemeConstants.borderLight,
            ),
          ),
          child: Stack(
            children: [
              // علامة اقتباس في البداية
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.format_quote,
                  size: ThemeConstants.iconSm,
                  color: effectiveColor.withOpacity(0.2),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
                child: Text(
                  content ?? title ?? '',
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.copyWith(
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
                    color: effectiveColor.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (source != null) ...[
          ThemeConstants.space3.h,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              source!,
              style: context.labelMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompletionContent(BuildContext context) {
    final effectiveColor = accentColor ?? context.primaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الأيقونة
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.1),
            shape: BoxShape.circle,
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
            style: context.headlineMedium,
            textAlign: TextAlign.center,
          ),
        
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge,
          ),
        ],
        
        if (subtitle != null) ...[
          ThemeConstants.space2.h,
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium,
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
    final effectiveColor = accentColor ?? context.primaryColor;
    
    return Row(
      children: [
        if (icon != null)
          Container(
            width: ThemeConstants.icon2xl,
            height: ThemeConstants.icon2xl,
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.1),
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
                  style: context.titleMedium?.semiBold,
                ),
              if (subtitle != null) ...[
                ThemeConstants.space1.h,
                Text(
                  subtitle!,
                  style: context.bodyMedium,
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
    final effectiveColor = accentColor ?? context.primaryColor;
    
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
                color: context.textSecondaryColor,
              ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        if (value != null)
          Text(
            value!,
            style: context.headlineMedium?.copyWith(
              color: effectiveColor,
              fontWeight: ThemeConstants.bold,
            ),
          ),
        
        if (title != null) ...[
          ThemeConstants.space1.h,
          Text(
            title!,
            style: context.bodyMedium,
          ),
        ],
        
        if (progress != null) ...[
          ThemeConstants.space3.h,
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: progress!,
              minHeight: 4,
              backgroundColor: context.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final effectiveColor = accentColor ?? context.primaryColor;
    
    return Row(
      children: [
        if (leading != null)
          leading!
        else if (icon != null)
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.1),
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
              style: context.titleMedium?.semiBold,
            ),
          ),
        
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    if (type == CardType.completion) {
      return Column(
        children: actions!.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
          child: _buildActionButton(context, action, fullWidth: true),
        )).toList(),
      );
    }
    
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, CardAction action, {bool fullWidth = false}) {
    final effectiveColor = action.color ?? accentColor ?? context.primaryColor;
    
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
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: effectiveColor.withOpacity(0.2),
              width: ThemeConstants.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: effectiveColor,
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space2.w,
              Text(
                action.label,
                style: context.labelMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    final badgeBgColor = accentColor ?? context.primaryColor;
    
    return Positioned(
      top: ThemeConstants.space2,
      left: ThemeConstants.space2,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.space2,
          vertical: ThemeConstants.space1,
        ),
        decoration: BoxDecoration(
          color: badgeBgColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          badge!,
          style: context.labelSmall?.copyWith(
            color: badgeBgColor.contrastingTextColor,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    final effectiveColor = accentColor ?? context.primaryColor;
    
    return Positioned(
      top: ThemeConstants.space2,
      right: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space1 / 2),
        decoration: BoxDecoration(
          color: effectiveColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: effectiveColor.contrastingTextColor,
          size: ThemeConstants.iconSm,
        ),
      ),
    );
  }

  // Factory constructors للتوافق مع الكود القديم
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? accentColor,
  }) {
    return AppCard(
      type: CardType.normal,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      accentColor: accentColor,
    );
  }

  factory AppCard.athkar({
    required String content,
    String? source,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? accentColor,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    return AppCard(
      type: CardType.athkar,
      content: content,
      source: source,
      currentCount: currentCount,
      totalCount: totalCount,
      isFavorite: isFavorite,
      accentColor: accentColor,
      onTap: onTap,
      onFavoriteToggle: onFavoriteToggle,
      actions: actions,
    );
  }

  factory AppCard.quote({
    required String quote,
    String? author,
    String? category,
    Color? accentColor,
  }) {
    return AppCard(
      type: CardType.quote,
      content: quote,
      source: author,
      subtitle: category,
      accentColor: accentColor,
    );
  }

  factory AppCard.completion({
    required String title,
    required String message,
    String? subMessage,
    IconData icon = Icons.check_circle_outline,
    Color? accentColor,
    List<CardAction> actions = const [],
  }) {
    return AppCard(
      type: CardType.completion,
      title: title,
      content: message,
      subtitle: subMessage,
      icon: icon,
      accentColor: accentColor,
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
      accentColor: iconColor,
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
      accentColor: color,
      onTap: onTap,
      progress: progress,
    );
  }
}