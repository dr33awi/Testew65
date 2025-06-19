// lib/app/themes/widgets/cards/app_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// أنواع البطاقات الأساسية
enum CardType {
  normal,
  athkar,
  quote,
  completion,
  info,
  stat,
}

/// أنماط البطاقات المرئية
enum CardStyle {
  normal,
  gradient,
  glassmorphism,
  outlined,
  elevated,
}

/// إجراء في البطاقة
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

/// بطاقة موحدة ومحسنة للتطبيق
class AppCard extends StatelessWidget {
  // المحتوى الأساسي
  final String? title;
  final String? subtitle;
  final String? content;
  final Widget? child;
  
  // التصميم والألوان
  final CardType type;
  final CardStyle style;
  final Color? primaryColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  
  // العناصر البصرية
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final String? badge;
  final Color? badgeColor;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // الخصائص المتقدمة
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final double? elevation;
  final bool isSelected;
  final bool showShadow;
  
  // خصائص خاصة
  final int? currentCount;
  final int? totalCount;
  final bool? isFavorite;
  final String? source;
  final VoidCallback? onFavoriteToggle;
  final String? value;
  final String? unit;
  final double? progress;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.type = CardType.normal,
    this.style = CardStyle.normal,
    this.primaryColor,
    this.backgroundColor,
    this.gradientColors,
    this.icon,
    this.leading,
    this.trailing,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
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
    return _CardContainer(
      style: style,
      primaryColor: primaryColor ?? context.primaryColor,
      backgroundColor: backgroundColor,
      gradientColors: gradientColors,
      borderRadius: borderRadius ?? ThemeConstants.radiusLg,
      elevation: elevation,
      showShadow: showShadow,
      margin: margin ?? _getDefaultMargin(),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          // المحتوى الرئيسي
          Padding(
            padding: padding ?? _getDefaultPadding(),
            child: _buildContent(context),
          ),
          
          // البادج
          if (badge != null) _buildBadge(context),
          
          // مؤشر التحديد
          if (isSelected) _buildSelectionIndicator(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (child != null) return child!;
    
    switch (type) {
      case CardType.athkar:
        return _AthkarCardContent(
          content: content ?? title ?? '',
          source: source,
          currentCount: currentCount,
          totalCount: totalCount,
          isFavorite: isFavorite,
          onFavoriteToggle: onFavoriteToggle,
          actions: actions,
          style: style,
          primaryColor: primaryColor ?? context.primaryColor,
        );
      case CardType.quote:
        return _QuoteCardContent(
          content: content ?? title ?? '',
          source: source,
          subtitle: subtitle,
          style: style,
        );
      case CardType.completion:
        return _CompletionCardContent(
          title: title ?? '',
          content: content,
          subtitle: subtitle,
          icon: icon ?? Icons.check_circle_outline,
          actions: actions,
          primaryColor: primaryColor ?? context.primaryColor,
        );
      case CardType.info:
        return _InfoCardContent(
          title: title ?? '',
          subtitle: subtitle,
          icon: icon,
          trailing: trailing,
          primaryColor: primaryColor ?? context.primaryColor,
        );
      case CardType.stat:
        return _StatCardContent(
          title: title,
          value: value,
          unit: unit,
          icon: icon,
          progress: progress,
          primaryColor: primaryColor ?? context.primaryColor,
        );
      case CardType.normal:
        return _NormalCardContent(
          title: title,
          subtitle: subtitle,
          content: content,
          icon: icon,
          leading: leading,
          trailing: trailing,
          actions: actions,
        );
    }
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
          color: badgeColor ?? context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          badge!,
          style: context.labelSmall?.copyWith(
            color: (badgeColor ?? context.colorScheme.secondary).contrastingTextColor,
            fontWeight: ThemeConstants.semiBold,
          ),
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

  EdgeInsetsGeometry _getDefaultMargin() {
    return const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space2,
    );
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (type) {
      case CardType.completion:
        return const EdgeInsets.all(ThemeConstants.space6);
      default:
        return const EdgeInsets.all(ThemeConstants.space4);
    }
  }

  // ===== Factory Constructors =====
  
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
    String? unit,
  }) {
    return AppCard(
      type: CardType.stat,
      title: title,
      value: value,
      unit: unit,
      icon: icon,
      primaryColor: color,
      onTap: onTap,
      progress: progress,
    );
  }
}

// ===== مكونات البطاقة الداخلية =====

/// حاوية البطاقة المحسنة
class _CardContainer extends StatelessWidget {
  final Widget child;
  final CardStyle style;
  final Color primaryColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double? elevation;
  final bool showShadow;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _CardContainer({
    required this.child,
    required this.style,
    required this.primaryColor,
    this.backgroundColor,
    this.gradientColors,
    required this.borderRadius,
    this.elevation,
    required this.showShadow,
    this.margin,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        elevation: showShadow ? (elevation ?? _getDefaultElevation()) : 0,
        shadowColor: showShadow ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: _getDecoration(context),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(borderRadius),
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(BuildContext context) {
    final bgColor = backgroundColor ?? context.cardColor;
    
    switch (style) {
      case CardStyle.gradient:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors ?? [primaryColor, primaryColor.darken(0.2)],
          ),
        );
        
      case CardStyle.glassmorphism:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor.withValues(alpha: 0.7),
          border: Border.all(
            color: context.isDarkMode 
                ? Colors.white.withValues(alpha: 0.2) 
                : primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        );
        
      case CardStyle.outlined:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor,
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        );
        
      case CardStyle.elevated:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor,
          boxShadow: ThemeConstants.shadowForElevation(elevation ?? 8),
        );
        
      case CardStyle.normal:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor,
        );
    }
  }

  double _getDefaultElevation() {
    switch (style) {
      case CardStyle.elevated:
        return 8;
      case CardStyle.gradient:
        return 4;
      default:
        return 2;
    }
  }
}

/// محتوى البطاقة العادية
class _NormalCardContent extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? content;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final List<CardAction>? actions;

  const _NormalCardContent({
    this.title,
    this.subtitle,
    this.content,
    this.icon,
    this.leading,
    this.trailing,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // الرأس
        if (title != null || leading != null || trailing != null)
          _buildHeader(context),
        
        // الترجمة
        if (subtitle != null) ...[
          if (title != null) ThemeConstants.space1.h,
          Text(
            subtitle!,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
        
        // المحتوى
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            style: context.bodyLarge,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // الأيقونة أو العنصر الرائد
        if (leading != null)
          leading!
        else if (icon != null)
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
          ),
        
        // المسافة
        if ((leading != null || icon != null) && title != null)
          ThemeConstants.space3.w,
        
        // العنوان
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: context.titleMedium?.copyWith(
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        
        // العنصر الخلفي
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _ActionButton(action: action)).toList(),
    );
  }
}

/// محتوى بطاقة الأذكار المحسن
class _AthkarCardContent extends StatelessWidget {
  final String content;
  final String? source;
  final int? currentCount;
  final int? totalCount;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;
  final List<CardAction>? actions;
  final CardStyle style;
  final Color primaryColor;

  const _AthkarCardContent({
    required this.content,
    this.source,
    this.currentCount,
    this.totalCount,
    this.isFavorite,
    this.onFavoriteToggle,
    this.actions,
    required this.style,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الرأس مع العداد والمفضلة
        if (currentCount != null || onFavoriteToggle != null)
          _buildHeader(context),
        
        if (currentCount != null || onFavoriteToggle != null)
          ThemeConstants.space3.h,
        
        // النص الرئيسي
        _buildContentText(context),
        
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // العداد
        if (currentCount != null && totalCount != null)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            child: Text(
              'عدد التكرار $currentCount/$totalCount',
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        
        // المفضلة
        if (onFavoriteToggle != null)
          IconButton(
            icon: Icon(
              isFavorite == true ? Icons.favorite : Icons.favorite_border,
              color: style == CardStyle.gradient ? Colors.white : primaryColor,
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

  Widget _buildContentText(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: style == CardStyle.gradient 
            ? Colors.white.withValues(alpha: 0.1)
            : primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: style == CardStyle.gradient
              ? Colors.white.withValues(alpha: 0.2)
              : primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: context.bodyLarge?.copyWith(
          fontSize: 20,
          fontFamily: ThemeConstants.fontFamilyArabic,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
          color: style == CardStyle.gradient ? Colors.white : context.textPrimaryColor,
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
              ? Colors.black.withValues(alpha: 0.2)
              : primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          source!,
          style: context.labelLarge?.copyWith(
            color: style == CardStyle.gradient ? Colors.white : primaryColor,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _ActionButton(
        action: action,
        isGradientStyle: style == CardStyle.gradient,
      )).toList(),
    );
  }
}

/// محتوى بطاقة الاقتباس
class _QuoteCardContent extends StatelessWidget {
  final String content;
  final String? source;
  final String? subtitle;
  final CardStyle style;

  const _QuoteCardContent({
    required this.content,
    this.source,
    this.subtitle,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // التصنيف
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
        
        if (subtitle != null) ThemeConstants.space3.h,
        
        // النص مع علامات الاقتباس
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // علامة اقتباس افتتاحية
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.format_quote,
                  size: 20,
                  color: Colors.white60,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.8,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ),
              
              // علامة اقتباس ختامية
              Positioned(
                bottom: 0,
                left: 0,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: const Icon(
                    Icons.format_quote,
                    size: 20,
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // المصدر
        if (source != null) ...[
          ThemeConstants.space3.h,
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space2,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              ),
              child: Text(
                source!,
                style: context.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// محتوى بطاقة الإكمال
class _CompletionCardContent extends StatelessWidget {
  final String title;
  final String? content;
  final String? subtitle;
  final IconData icon;
  final List<CardAction>? actions;
  final Color primaryColor;

  const _CompletionCardContent({
    required this.title,
    this.content,
    this.subtitle,
    required this.icon,
    this.actions,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الأيقونة
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: ThemeConstants.icon2xl,
          ),
        ),
        
        ThemeConstants.space5.h,
        
        // العنوان
        Text(
          title,
          style: context.headlineMedium?.copyWith(
            fontWeight: ThemeConstants.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        // المحتوى
        if (content != null) ...[
          ThemeConstants.space3.h,
          Text(
            content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge,
          ),
        ],
        
        // الترجمة
        if (subtitle != null) ...[
          ThemeConstants.space2.h,
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
        
        // الإجراءات
        if (actions != null && actions!.isNotEmpty) ...[
          ThemeConstants.space6.h,
          Column(
            children: actions!.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
              child: _ActionButton(action: action, fullWidth: true),
            )).toList(),
          ),
        ],
      ],
    );
  }
}

/// محتوى بطاقة المعلومات
class _InfoCardContent extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final Color primaryColor;

  const _InfoCardContent({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // الأيقونة
        if (icon != null)
          Container(
            width: ThemeConstants.icon2xl,
            height: ThemeConstants.icon2xl,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: ThemeConstants.iconLg,
            ),
          ),
        
        if (icon != null) ThemeConstants.space4.w,
        
        // المحتوى
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleMedium?.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              if (subtitle != null) ...[
                ThemeConstants.space1.h,
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
        
        // العنصر الخلفي
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// محتوى بطاقة الإحصائيات
class _StatCardContent extends StatelessWidget {
  final String? title;
  final String? value;
  final String? unit;
  final IconData? icon;
  final double? progress;
  final Color primaryColor;

  const _StatCardContent({
    this.title,
    this.value,
    this.unit,
    this.icon,
    this.progress,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // الرأس
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: primaryColor,
                size: ThemeConstants.iconLg,
              ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: ThemeConstants.iconSm,
              color: context.textSecondaryColor,
            ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        // القيمة
        if (value != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value!,
                style: context.headlineMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              if (unit != null) ...[
                ThemeConstants.space1.w,
                Text(
                  unit!,
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ],
          ),
        
        // العنوان
        if (title != null) ...[
          ThemeConstants.space1.h,
          Text(
            title!,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
        
        // شريط التقدم
        if (progress != null) ...[
          ThemeConstants.space3.h,
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: progress!,
              minHeight: 4,
              backgroundColor: context.dividerColor.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ],
    );
  }
}

/// زر الإجراء في البطاقة
class _ActionButton extends StatelessWidget {
  final CardAction action;
  final bool fullWidth;
  final bool isGradientStyle;

  const _ActionButton({
    required this.action,
    this.fullWidth = false,
    this.isGradientStyle = false,
  });

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: action.color ?? context.primaryColor,
            foregroundColor: (action.color ?? context.primaryColor).contrastingTextColor,
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
            color: isGradientStyle
                ? Colors.white.withValues(alpha: 0.2)
                : (action.color ?? context.primaryColor).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: isGradientStyle
                  ? Colors.white.withValues(alpha: 0.3)
                  : (action.color ?? context.primaryColor).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: isGradientStyle 
                    ? Colors.white 
                    : (action.color ?? context.primaryColor),
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space2.w,
              Text(
                action.label,
                style: context.labelMedium?.copyWith(
                  color: isGradientStyle 
                      ? Colors.white 
                      : (action.color ?? context.primaryColor),
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}