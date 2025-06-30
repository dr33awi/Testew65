// lib/app/themes/widgets/cards/app_card.dart - مُصحح مع ألوان واضحة

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
  glassWelcome,  // زجاجي مع تأثير التلميع (للترحيب)
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

/// بطاقة موحدة لجميع الاستخدامات - مُصححة مع ألوان واضحة
class AppCard extends StatefulWidget {
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
  State<AppCard> createState() => _AppCardState();

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

  /// ✅ Factory constructor محسن لكارد الترحيب مع Glass Morphism و Shimmer
  factory AppCard.glassWelcome({
    required String title,
    String? subtitle,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      style: CardStyle.glassWelcome,
      title: title,
      subtitle: subtitle,
      primaryColor: primaryColor,
      gradientColors: [
        primaryColor,
        primaryColor.darken(0.2),
      ],
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
    );
  }

  /// ✅ Factory constructor محسن للفئات مع ألوان واضحة
  factory AppCard.glassCategory({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      style: CardStyle.glassmorphism,
      title: title,
      icon: icon,
      primaryColor: primaryColor,
      gradientColors: [
        primaryColor.withValues(alpha: 0.95),        // شفافية قليلة
        primaryColor.darken(0.15).withValues(alpha: 0.90),
        primaryColor.darken(0.25).withValues(alpha: 0.85),
      ],
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
    );
  }
}

class _AppCardState extends State<AppCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _shimmerController;
  Animation<double>? _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    // إعداد انيميشن التلميع فقط للنمط glassWelcome
    if (widget.style == CardStyle.glassWelcome) {
      _setupShimmerAnimation();
    }
  }

  void _setupShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    super.dispose();
  }

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
    return widget.child != null || 
           widget.title != null || 
           widget.content != null || 
           widget.icon != null ||
           widget.type == CardType.stat ||
           widget.type == CardType.completion;
  }

  /// ✅ بطاقة احتياطية في حالة عدم وجود محتوى
  Widget _buildFallbackCard(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? ThemeConstants.radiusMd,
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
    final effectiveColor = widget.primaryColor ?? context.primaryColor;
    final effectiveBorderRadius = widget.borderRadius ?? ThemeConstants.radiusMd;
    
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: _buildCardContainer(context, effectiveColor, effectiveBorderRadius),
    );
  }

  Widget _buildCardContainer(BuildContext context, Color effectiveColor, double effectiveBorderRadius) {
    // ✅ بناء محتوى البطاقة أولاً
    Widget cardContent = _buildContent(context);
    
    // ✅ إذا لم يكن هناك محتوى، أرجع بطاقة فارغة
    if (cardContent is SizedBox && cardContent.child == null) {
      return _buildFallbackCard(context);
    }

    // ✅ تطبيق التصميم المناسب
    switch (widget.style) {
      case CardStyle.gradient:
        return _buildGradientCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      case CardStyle.glassmorphism:
        return _buildGlassCard(context, effectiveColor, effectiveBorderRadius, cardContent);
      case CardStyle.glassWelcome:
        return _buildGlassWelcomeCard(context, effectiveColor, effectiveBorderRadius, cardContent);
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
        color: widget.backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: widget.showShadow ? [
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
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  /// ✅ بطاقة متدرجة
  Widget _buildGradientCard(BuildContext context, Color color, double radius, Widget content) {
    final colors = widget.gradientColors ?? [color, color.darken(0.2)];
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: widget.showShadow ? [
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
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  /// ✅ بطاقة زجاجية محسّنة مع ألوان واضحة
  Widget _buildGlassCard(BuildContext context, Color color, double radius, Widget content) {
    // ✅ ألوان تدرج واضحة وقوية
    final effectiveGradientColors = widget.gradientColors ?? [
      color.withValues(alpha: 0.95),                    // شفافية أقل للوضوح
      color.darken(0.15).withValues(alpha: 0.90),      // تدرج متوسط
      color.darken(0.25).withValues(alpha: 0.85),      // تدرج داكن
    ];
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          // ✅ الخلفية الأساسية بألوان قوية
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
              boxShadow: widget.showShadow ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ] : null,
            ),
          ),
          
          // ✅ طبقة زجاجية خفيفة فقط للتأثير
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // ضبابية أقل بكثير
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05), // شفافية قليلة جداً
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
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ بطاقة زجاجية مع تأثير التلميع للترحيب
  Widget _buildGlassWelcomeCard(BuildContext context, Color color, double radius, Widget content) {
    // ✅ ألوان تدرج واضحة وقوية
    final effectiveGradientColors = widget.gradientColors ?? [
      color.withValues(alpha: 0.9),
      color.darken(0.2),
    ];
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          // ✅ الخلفية المتدرجة
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: effectiveGradientColors.map((c) => 
                  c.withValues(alpha: 0.9)
                ).toList(),
              ),
            ),
          ),
          
          // ✅ الطبقة الزجاجية
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
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
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              borderRadius: BorderRadius.circular(radius),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Container(
                padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space5),
                child: content,
              ),
            ),
          ),
          
          // عناصر زخرفية
          _buildWelcomeDecorativeElements(),
          
          // تأثير التلميع المتحرك
          if (_shimmerAnimation != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerAnimation!,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                        stops: [
                          (_shimmerAnimation!.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnimation!.value.clamp(0.0, 1.0),
                          (_shimmerAnimation!.value + 0.3).clamp(0.0, 1.0),
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

  Widget _buildWelcomeDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية صغيرة
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          // دائرة زخرفية إضافية
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
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
        color: widget.backgroundColor ?? Colors.transparent,
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
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
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
        color: widget.backgroundColor ?? context.cardColor,
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
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // ✅ إذا كان هناك child مخصص، استخدمه مباشرة
    if (widget.child != null) {
      return widget.child!;
    }
    
    // ✅ بناء المحتوى حسب النوع
    switch (widget.type) {
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

  /// ✅ محتوى عادي محسن مع نصوص واضحة
  Widget _buildNormalContent(BuildContext context) {
    // ✅ التحقق من وجود محتوى
    if (widget.title == null && widget.subtitle == null && widget.content == null && widget.icon == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ الأيقونة المحسنة
        if (widget.icon != null)
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
              widget.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        
        const Spacer(),
        
        // ✅ العنوان المحسن مع ظلال قوية
        if (widget.title != null)
          Text(
            widget.title!,
            style: _getTextColor(context) == Colors.white
                ? context.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontSize: 18,
                    height: 1.2,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5), // ظل أقوى للوضوح
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
        
        // ✅ العنوان الفرعي المحسن
        if (widget.subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            widget.subtitle!,
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
        
        // المحتوى النصي
        if (widget.content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            widget.content!,
            style: context.bodyLarge?.copyWith(
              color: _getTextColor(context),
            ),
          ),
        ],
        
        // مؤشر الانتقال
        if (widget.onTap != null) ...[
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
        
        // الإجراءات
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space4),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildAthkarContent(BuildContext context) {
    if (widget.content == null && widget.title == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الرأس مع العداد والأيقونات
        if (widget.currentCount != null || widget.totalCount != null || widget.actions != null)
          _buildAthkarHeader(context),
        
        if ((widget.currentCount != null || widget.totalCount != null || widget.actions != null) && 
            (widget.content != null || widget.title != null))
          const SizedBox(height: ThemeConstants.space3),
        
        // محتوى الذكر
        if (widget.content != null || widget.title != null)
          _buildAthkarBody(context),
        
        // المصدر
        if (widget.source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(context),
        ],
        
        // الفضل إن وُجد
        if (widget.fadl != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildFadlSection(context),
        ],
      ],
    );
  }

  Widget _buildQuoteContent(BuildContext context) {
    if (widget.content == null && widget.title == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.subtitle != null)
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
              widget.subtitle!,
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        
        if (widget.subtitle != null) const SizedBox(height: ThemeConstants.space3),
        
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          ),
          child: Text(
            widget.content ?? widget.title ?? '',
            textAlign: TextAlign.center,
            style: context.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ),
        
        if (widget.source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(context),
        ],
      ],
    );
  }

  Widget _buildCompletionContent(BuildContext context) {
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
          ),
          child: Icon(
            widget.icon ?? Icons.check_circle_outline,
            color: Colors.white,
            size: 40,
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // العنوان
        if (widget.title != null)
          Text(
            widget.title!,
            style: context.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
            textAlign: TextAlign.center,
          ),
        
        if (widget.content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            widget.content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
        
        if (widget.subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space2),
          Text(
            widget.subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
        
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space6),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildInfoContent(BuildContext context) {
    if (widget.title == null && widget.subtitle == null && widget.icon == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (widget.icon != null)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (widget.primaryColor ?? context.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              widget.icon,
              color: widget.primaryColor ?? context.primaryColor,
              size: ThemeConstants.iconLg,
            ),
          ),
        
        if (widget.icon != null) const SizedBox(width: ThemeConstants.space4),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  widget.subtitle!,
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        if (widget.trailing != null) widget.trailing!,
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
            if (widget.icon != null)
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: ThemeConstants.iconLg,
                ),
              ),
            if (widget.onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ThemeConstants.iconSm,
                color: Colors.white.withValues(alpha: 0.7),
              ),
          ],
        ),
        
        const SizedBox(height: ThemeConstants.space2),
        
        if (widget.value != null)
          Text(
            widget.value!,
            style: context.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
        
        if (widget.title != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            widget.title!,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
        
        if (widget.progress != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: widget.progress!,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAthkarHeader(BuildContext context) {
    return Row(
      children: [
        // عداد التكرار
        if (widget.currentCount != null && widget.totalCount != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25), // ✅ خلفية أوضح
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4), // ✅ حدود أوضح
                width: 1,
              ),
            ),
            child: Text(
              '${widget.currentCount}/${widget.totalCount}',
              style: context.labelMedium?.copyWith(
                color: Colors.white, // ✅ أبيض صافي
                fontWeight: FontWeight.bold,
                shadows: [
                  // ✅ ظل للنص
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        
        const Spacer(),
        
        // أيقونات الإجراءات
        if (widget.actions != null && widget.actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.actions!.map((action) => 
              Container(
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: action.onPressed,
                  icon: Icon(action.icon),
                  iconSize: 20,
                  color: Colors.white, // ✅ أبيض صافي للأيقونات
                  tooltip: action.label,
                ),
              ),
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildAthkarBody(BuildContext context) {
    final text = widget.content ?? widget.title ?? '';
    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15), // ✅ شفافية أكثر للخلفية
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3), // ✅ حدود أوضح
          width: 1,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.bodyLarge?.copyWith(
          color: Colors.white, // ✅ أبيض صافي للنص
          fontSize: 20,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
          shadows: [
            // ✅ ظل أقوى للنص
            Shadow(
              color: Colors.black.withValues(alpha: 0.6),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSource(BuildContext context) {
    if (widget.source == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25), // ✅ خلفية أوضح
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4), // ✅ حدود أوضح
            width: 1,
          ),
        ),
        child: Text(
          widget.source!,
          style: context.labelLarge?.copyWith(
            color: Colors.white, // ✅ أبيض صافي
            fontWeight: ThemeConstants.bold, // ✅ خط أثقل للوضوح
            shadows: [
              // ✅ ظل للنص
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFadlSection(BuildContext context) {
    if (widget.fadl == null) return const SizedBox.shrink();

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
                  widget.fadl!,
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

  Widget _buildActions(BuildContext context) {
    if (widget.actions == null || widget.actions!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.type == CardType.completion) {
      return Column(
        children: widget.actions!.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
          child: _buildActionButton(context, action, fullWidth: true),
        )).toList(),
      );
    }
    
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: widget.actions!.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, CardAction action, {bool fullWidth = false}) {
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
            foregroundColor: widget.primaryColor ?? context.primaryColor,
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

  Color _getTextColor(BuildContext context, {bool isSecondary = false}) {
    if (widget.style == CardStyle.gradient || 
        widget.style == CardStyle.glassmorphism ||
        widget.style == CardStyle.glassWelcome) {
      // ✅ استخدام أبيض صافي للنصوص الأساسية وأبيض شفاف للثانوية
      return isSecondary 
          ? Colors.white.withValues(alpha: 0.85) // شفافية أقل للوضوح
          : Colors.white; // أبيض صافي للنصوص الأساسية
    }
    
    return isSecondary 
        ? context.textSecondaryColor 
        : context.textPrimaryColor;
  }
}