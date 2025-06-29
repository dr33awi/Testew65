// lib/app/themes/widgets/widgets.dart - النظام الموحد المحسّن مع Glassmorphism
import 'dart:ui';
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== البطاقة الموحدة المحسّنة مع Glassmorphism ====================

/// بطاقة موحدة شاملة مع تأثيرات Glassmorphism
class AppCard extends StatefulWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool useGradient;
  final bool useAnimation;
  final bool useGlass;
  final List<CardAction>? actions;
  final double? borderRadius;
  final double? elevation;
  final double glassOpacity;
  final bool addBlur;

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
    this.useAnimation = true,
    this.useGlass = true,
    this.actions,
    this.borderRadius,
    this.elevation,
    this.glassOpacity = 0.12,
    this.addBlur = true,
  });

  // ========== Factory Constructors المحسّنة ==========

  /// بطاقة معلومات أساسية مع Glassmorphism
  factory AppCard.basic({
    Key? key,
    required String title,
    String? subtitle,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    List<CardAction>? actions,
    bool useGlass = true,
  }) {
    return AppCard(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      onTap: onTap,
      actions: actions,
      useGlass: useGlass,
    );
  }

  /// بطاقة إحصائية مع تأثيرات متقدمة
  factory AppCard.stat({
    Key? key,
    required String title,
    required String value,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    String? subtitle,
    bool useFloating = true,
  }) {
    return AppCard(
      key: key,
      useGradient: true,
      useGlass: false,
      color: color ?? AppTheme.primary,
      onTap: onTap,
      borderRadius: AppTheme.radius2xl,
      child: _StatCardContent(
        title: title,
        value: value,
        icon: icon,
        subtitle: subtitle,
        useFloating: useFloating,
      ),
    );
  }

  /// بطاقة ذكر/دعاء محسّنة
  factory AppCard.athkar({
    Key? key,
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    Color? primaryColor,
    bool isCompleted = false,
    required VoidCallback onTap,
    List<CardAction>? actions,
    bool showProgress = true,
    bool useAdvancedAnimation = false,
  }) {
    return AppCard(
      key: key,
      color: primaryColor ?? AppTheme.primary,
      onTap: onTap,
      actions: actions,
      useAnimation: useAdvancedAnimation,
      useGlass: true,
      glassOpacity: isCompleted ? 0.2 : 0.12,
      borderRadius: AppTheme.radius2xl,
      child: _AthkarCardContent(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        primaryColor: primaryColor ?? AppTheme.primary,
        isCompleted: isCompleted,
        showProgress: showProgress,
      ),
    );
  }

  /// بطاقة صلاة محسّنة
  factory AppCard.prayer({
    Key? key,
    required String prayerName,
    required String time,
    bool isCurrent = false,
    bool isNext = false,
    bool isCompleted = false,
    VoidCallback? onTap,
    Duration? remainingTime,
    bool isCompact = false,
  }) {
    return AppCard(
      key: key,
      useGradient: isCurrent,
      useGlass: !isCurrent,
      color: AppTheme.getPrayerColor(prayerName),
      onTap: onTap,
      glassOpacity: isNext ? 0.15 : 0.12,
      borderRadius: isCompact ? AppTheme.radiusXl : AppTheme.radius2xl,
      child: _PrayerCardContent(
        prayerName: prayerName,
        time: time,
        isCurrent: isCurrent,
        isNext: isNext,
        isCompleted: isCompleted,
        remainingTime: remainingTime,
        isCompact: isCompact,
      ),
    );
  }

  /// بطاقة فئة محسّنة
  factory AppCard.category({
    Key? key,
    required String categoryId,
    required String title,
    required int count,
    VoidCallback? onTap,
    bool showDescription = true,
    bool isCompact = false,
    String? customDescription,
  }) {
    return AppCard(
      key: key,
      useGradient: isCompact,
      useGlass: !isCompact,
      color: AppTheme.getCategoryColor(categoryId),
      onTap: onTap,
      borderRadius: isCompact ? AppTheme.radiusXl : AppTheme.radius2xl,
      child: _CategoryCardContent(
        categoryId: categoryId,
        title: title,
        count: count,
        showDescription: showDescription,
        isCompact: isCompact,
        customDescription: customDescription,
      ),
    );
  }

  /// بطاقة القبلة محسّنة
  factory AppCard.qibla({
    Key? key,
    required double direction,
    String? locationName,
    double? accuracy,
    bool isCalibrated = false,
    VoidCallback? onTap,
    VoidCallback? onCalibrate,
    bool isSimple = false,
  }) {
    return AppCard(
      key: key,
      useGradient: isSimple,
      useGlass: !isSimple,
      color: AppTheme.tertiary,
      onTap: onTap,
      borderRadius: AppTheme.radius3xl,
      child: _QiblaCardContent(
        direction: direction,
        locationName: locationName,
        accuracy: accuracy,
        isCalibrated: isCalibrated,
        onCalibrate: onCalibrate,
        isSimple: isSimple,
      ),
    );
  }

  /// بطاقة أوقات الصلاة المتقدمة
  factory AppCard.prayerTimes({
    Key? key,
    required Map<String, String> prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    Duration? timeToNext,
    VoidCallback? onTap,
  }) {
    return AppCard(
      key: key,
      padding: const EdgeInsets.all(AppTheme.space6),
      onTap: onTap,
      useGlass: true,
      borderRadius: AppTheme.radius3xl,
      child: _PrayerTimesCardContent(
        prayerTimes: prayerTimes,
        currentPrayer: currentPrayer,
        nextPrayer: nextPrayer,
        timeToNext: timeToNext,
      ),
    );
  }

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    // إعداد animation للضغط
    _animationController = AnimationController(
      duration: AppTheme.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.useAnimation ? 0.96 : 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // إعداد animation للـ hover
    _hoverController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
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

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      margin: widget.margin ?? const EdgeInsets.all(AppTheme.space3),
      padding: widget.padding ?? const EdgeInsets.all(AppTheme.space5),
      decoration: CardHelper.getCardDecoration(
        color: widget.color,
        useGradient: widget.useGradient,
        borderRadius: widget.borderRadius ?? AppTheme.radiusXl,
        useGlass: widget.useGlass,
        glassOpacity: widget.glassOpacity,
      ),
      child: widget.child ?? _buildDefaultContent(),
    );

    // إضافة blur effect إذا كان مطلوباً
    if (widget.useGlass && widget.addBlur) {
      cardContent = ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? AppTheme.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: cardContent,
        ),
      );
    }

    // إضافة الـ animations
    Widget animatedCard = AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _hoverAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _hoverAnimation.value,
          child: child,
        );
      },
      child: cardContent,
    );

    // إضافة الـ interaction
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: AppTheme.durationNormal,
          curve: Curves.easeInOut,
          child: animatedCard,
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    final isGradient = widget.useGradient;
    final textColor = isGradient ? Colors.white : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null || widget.title != null) ...[
          Row(
            children: [
              if (widget.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppTheme.space2),
                  decoration: BoxDecoration(
                    color: isGradient 
                        ? Colors.white.withValues(alpha: 0.2)
                        : (widget.color ?? AppTheme.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(
                    widget.icon!,
                    color: isGradient 
                        ? Colors.white
                        : widget.color ?? AppTheme.primary,
                    size: AppTheme.iconMd,
                  ),
                ),
                AppTheme.space4.w,
              ],
              if (widget.title != null)
                Expanded(
                  child: Text(
                    widget.title!,
                    style: AppTheme.titleLarge.copyWith(
                      color: textColor,
                      fontWeight: AppTheme.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (widget.subtitle != null) AppTheme.space3.h,
        ],
        
        if (widget.subtitle != null) ...[
          Text(
            widget.subtitle!,
            style: AppTheme.bodyMedium.copyWith(
              color: textColor?.withValues(alpha: 0.8) ?? AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
        
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          AppTheme.space5.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.actions!.map((action) => 
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

// ==================== محتويات البطاقات المحسّنة ====================

/// محتوى بطاقة الإحصائية المحسّن
class _StatCardContent extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final String? subtitle;
  final bool useFloating;

  const _StatCardContent({
    required this.title,
    required this.value,
    this.icon,
    this.subtitle,
    this.useFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(AppTheme.space3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            ),
            child: Icon(
              icon!, 
              color: Colors.white, 
              size: AppTheme.iconLg,
            ),
          ),
          AppTheme.space3.h,
        ],
        
        Text(
          value,
          style: AppTheme.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 32,
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.extraBold,
          ),
          textAlign: TextAlign.center,
        ),
        
        AppTheme.space2.h,
        
        Text(
          title,
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: AppTheme.semiBold,
          ),
          textAlign: TextAlign.center,
        ),
        
        if (subtitle != null) ...[
          AppTheme.space1.h,
          Text(
            subtitle!,
            style: AppTheme.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (useFloating) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 2),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -3 + (6 * value)),
            child: child,
          );
        },
        child: content,
      );
    }

    return content;
  }
}

/// محتوى بطاقة الذكر المحسّن
class _AthkarCardContent extends StatelessWidget {
  final String content;
  final String? source;
  final String? fadl;
  final int currentCount;
  final int totalCount;
  final Color primaryColor;
  final bool isCompleted;
  final bool showProgress;

  const _AthkarCardContent({
    required this.content,
    this.source,
    this.fadl,
    required this.currentCount,
    required this.totalCount,
    required this.primaryColor,
    required this.isCompleted,
    required this.showProgress,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? currentCount / totalCount : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // النص الرئيسي مع تأثيرات متقدمة
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.space6),
          decoration: BoxDecoration(
            gradient: isCompleted 
                ? LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.3),
                      primaryColor.withValues(alpha: 0.1),
                    ],
                  )
                : AppTheme.glassGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            border: Border.all(
              color: isCompleted
                  ? primaryColor.withValues(alpha: 0.5)
                  : AppTheme.glassStroke,
              width: isCompleted ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                content,
                style: AppTheme.quranStyle.copyWith(
                  height: 2.0,
                  color: isCompleted ? primaryColor : AppTheme.textReligious,
                  fontSize: 18,
                  fontWeight: AppTheme.medium,
                ),
                textAlign: TextAlign.center,
              ),
              
              if (isCompleted) ...[
                AppTheme.space3.h,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space4,
                    vertical: AppTheme.space2,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.success,
                        AppTheme.success.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.success.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: AppTheme.iconSm,
                      ),
                      AppTheme.space2.w,
                      Text(
                        'مكتمل ✨',
                        style: AppTheme.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        AppTheme.space4.h,
        
        // المعلومات الإضافية مع تصميم محسّن
        if (source != null) ...[
          _buildInfoRow(
            Icons.library_books, 
            'المصدر: $source', 
            primaryColor,
          ),
          AppTheme.space2.h,
        ],
        
        if (fadl != null) ...[
          _buildInfoRow(
            Icons.star_border, 
            'الفضل: $fadl', 
            AppTheme.warning,
          ),
          AppTheme.space3.h,
        ],
        
        // شريط التقدم والعداد المحسّن
        Row(
          children: [
            // العداد المحسّن
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space4,
                vertical: AppTheme.space2,
              ),
              decoration: BoxDecoration(
                gradient: isCompleted 
                    ? LinearGradient(colors: [AppTheme.success, AppTheme.success.darken(0.1)])
                    : LinearGradient(colors: [primaryColor, primaryColor.darken(0.1)]),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: (isCompleted ? AppTheme.success : primaryColor).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted) ...[
                    const Icon(
                      Icons.celebration,
                      size: 16,
                      color: Colors.white,
                    ),
                    AppTheme.space1.w,
                    Text(
                      'مُنجز',
                      style: AppTheme.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                      ),
                    ),
                  ] else ...[
                    Text(
                      '$currentCount',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                    Text(
                      ' / $totalCount',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // شريط التقدم المحسّن
            if (showProgress && !isCompleted) ...[
              AppTheme.space4.w,
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Stack(
                    children: [
                      // الخلفية الزجاجية
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.glassGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                      ),
                      // شريط التقدم مع تأثير متحرك
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.lighten(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppTheme.space3.w,
              // نسبة التقدم
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: AppTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${(progress * 100).round()}%',
                  style: AppTheme.caption.copyWith(
                    color: primaryColor,
                    fontWeight: AppTheme.bold,
                    fontFamily: AppTheme.numbersFont,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space3),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.space1),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(
              icon,
              size: AppTheme.iconSm,
              color: iconColor,
            ),
          ),
          AppTheme.space3.w,
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// محتوى بطاقة الصلاة المحسّن
class _PrayerCardContent extends StatelessWidget {
  final String prayerName;
  final String time;
  final bool isCurrent;
  final bool isNext;
  final bool isCompleted;
  final Duration? remainingTime;
  final bool isCompact;

  const _PrayerCardContent({
    required this.prayerName,
    required this.time,
    required this.isCurrent,
    required this.isNext,
    required this.isCompleted,
    this.remainingTime,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final prayerColor = AppTheme.getPrayerColor(prayerName);
    
    if (isCompact) {
      return _buildCompactContent(prayerColor);
    }
    
    return _buildFullContent(prayerColor);
  }

  Widget _buildCompactContent(Color prayerColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // أيقونة الصلاة مع تأثيرات
        Container(
          padding: const EdgeInsets.all(AppTheme.space3),
          decoration: BoxDecoration(
            gradient: isCurrent 
                ? LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      prayerColor.withValues(alpha: 0.2),
                      prayerColor.withValues(alpha: 0.1),
                    ],
                  ),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          ),
          child: Icon(
            AppTheme.getPrayerIcon(prayerName),
            size: AppTheme.iconLg,
            color: isCurrent ? Colors.white : prayerColor,
          ),
        ),
        
        AppTheme.space3.h,
        
        Text(
          prayerName,
          style: AppTheme.titleMedium.copyWith(
            color: isCurrent ? Colors.white : null,
            fontWeight: AppTheme.bold,
          ),
        ),
        
        AppTheme.space2.h,
        
        Text(
          time,
          style: AppTheme.headlineSmall.copyWith(
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.extraBold,
            color: isCurrent ? Colors.white : prayerColor,
          ),
        ),
        
        if (isNext || isCompleted) ...[
          AppTheme.space2.h,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space3,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: (isCurrent ? Colors.white : prayerColor).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(
                color: (isCurrent ? Colors.white : prayerColor).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              isCompleted ? 'مُؤداة ✓' : 'التالية ⏳',
              style: AppTheme.caption.copyWith(
                color: isCurrent ? Colors.white : prayerColor,
                fontWeight: AppTheme.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFullContent(Color prayerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.space2),
                  decoration: BoxDecoration(
                    gradient: isCurrent 
                        ? LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              prayerColor.withValues(alpha: 0.2),
                              prayerColor.withValues(alpha: 0.1),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(
                    AppTheme.getPrayerIcon(prayerName),
                    color: isCurrent ? Colors.white : prayerColor,
                    size: AppTheme.iconMd,
                  ),
                ),
                AppTheme.space4.w,
                Text(
                  prayerName,
                  style: AppTheme.titleLarge.copyWith(
                    color: isCurrent ? Colors.white : null,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ],
            ),
            Text(
              time,
              style: AppTheme.headlineSmall.copyWith(
                fontFamily: AppTheme.numbersFont,
                fontWeight: AppTheme.extraBold,
                color: isCurrent ? Colors.white : prayerColor,
              ),
            ),
          ],
        ),
        
        if (remainingTime != null && isNext) ...[
          AppTheme.space4.h,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.space4),
            decoration: BoxDecoration(
              gradient: AppTheme.glassGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: AppTheme.glassStroke,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  color: isCurrent ? Colors.white : prayerColor,
                  size: AppTheme.iconSm,
                ),
                AppTheme.space2.w,
                Text(
                  'بعد ${AppTheme.formatDuration(remainingTime!)}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: isCurrent ? Colors.white : prayerColor,
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// محتوى بطاقة الفئة المحسّن
class _CategoryCardContent extends StatelessWidget {
  final String categoryId;
  final String title;
  final int count;
  final bool showDescription;
  final bool isCompact;
  final String? customDescription;

  const _CategoryCardContent({
    required this.categoryId,
    required this.title,
    required this.count,
    required this.showDescription,
    required this.isCompact,
    this.customDescription,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppTheme.getCategoryColor(categoryId);
    final categoryIcon = AppTheme.getCategoryIcon(categoryId);
    
    if (isCompact) {
      return _buildCompactContent(categoryColor, categoryIcon);
    }
    
    return _buildFullContent(categoryColor, categoryIcon);
  }

  Widget _buildCompactContent(Color categoryColor, IconData categoryIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // أيقونة الفئة مع تأثيرات
        Container(
          padding: const EdgeInsets.all(AppTheme.space4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            categoryIcon,
            color: Colors.white,
            size: AppTheme.iconLg,
          ),
        ),
        
        AppTheme.space3.h,
        
        Text(
          title,
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        AppTheme.space2.h,
        
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            '$count ذكر',
            style: AppTheme.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullContent(Color categoryColor, IconData categoryIcon) {
    return Row(
      children: [
        // الأيقونة المحسّنة
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                categoryColor.withValues(alpha: 0.2),
                categoryColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            border: Border.all(
              color: categoryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            categoryIcon,
            color: categoryColor,
            size: AppTheme.iconMd,
          ),
        ),
        
        AppTheme.space4.w,
        
        // النص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: AppTheme.bold,
                ),
              ),
              if (showDescription) ...[
                AppTheme.space2.h,
                Text(
                  customDescription ?? _getDefaultDescription(),
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // العدد المحسّن
        if (count > 0) ...[
          AppTheme.space3.w,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space3,
              vertical: AppTheme.space2,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryColor,
                  categoryColor.darken(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              count.toString(),
              style: AppTheme.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.extraBold,
                fontFamily: AppTheme.numbersFont,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getDefaultDescription() {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'أذكار الصباح والاستيقاظ - تُقرأ بعد صلاة الفجر';
      case 'evening':
      case 'المساء':
        return 'أذكار المساء والمغرب - تُقرأ بعد صلاة العصر';
      case 'sleep':
      case 'النوم':
        return 'أذكار النوم والاضطجاع - عند النوم والاستيقاظ';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار الصلاة والوضوء - عند الوضوء وبعد الصلوات';
      case 'eating':
      case 'الطعام':
        return 'أذكار الطعام والشراب - قبل وبعد الأكل';
      case 'travel':
      case 'السفر':
        return 'أذكار السفر والطريق - عند السفر والركوب';
      default:
        return 'أذكار وأدعية متنوعة لجميع الأوقات';
    }
  }
}

/// محتوى بطاقة القبلة المحسّن
class _QiblaCardContent extends StatelessWidget {
  final double direction;
  final String? locationName;
  final double? accuracy;
  final bool isCalibrated;
  final VoidCallback? onCalibrate;
  final bool isSimple;

  const _QiblaCardContent({
    required this.direction,
    this.locationName,
    this.accuracy,
    required this.isCalibrated,
    this.onCalibrate,
    required this.isSimple,
  });

  @override
  Widget build(BuildContext context) {
    if (isSimple) {
      return _buildSimpleContent();
    }
    
    return _buildFullContent();
  }

  Widget _buildSimpleContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // البوصلة المبسطة
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Transform.rotate(
              angle: direction * (3.14159 / 180),
              child: const Icon(
                Icons.navigation,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        AppTheme.space3.h,
        
        Text(
          'القبلة',
          style: AppTheme.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
          ),
        ),
        
        AppTheme.space1.h,
        
        Text(
          '${direction.toStringAsFixed(0)}°',
          style: AppTheme.headlineSmall.copyWith(
            color: Colors.white,
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.extraBold,
          ),
        ),
      ],
    );
  }

  Widget _buildFullContent() {
    return Column(
      children: [
        // العنوان والحالة
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.space2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.tertiary.withValues(alpha: 0.2),
                        AppTheme.tertiary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Icons.explore,
                    color: AppTheme.tertiary,
                    size: AppTheme.iconMd,
                  ),
                ),
                AppTheme.space3.w,
                Text(
                  'اتجاه القبلة',
                  style: AppTheme.titleLarge.copyWith(
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCalibrated 
                      ? [AppTheme.success, AppTheme.success.darken(0.1)]
                      : [AppTheme.warning, AppTheme.warning.darken(0.1)],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: (isCalibrated ? AppTheme.success : AppTheme.warning)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                isCalibrated ? 'مُعايَر ✓' : 'غير مُعايَر ⚠️',
                style: AppTheme.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                ),
              ),
            ),
          ],
        ),
        
        AppTheme.space6.h,
        
        // البوصلة المتقدمة
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            gradient: AppTheme.oliveGoldGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.3),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: AppTheme.secondary.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // خلفية البوصلة
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              // السهم المتحرك
              Transform.rotate(
                angle: direction * (3.14159 / 180),
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.space2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.tertiary,
                        AppTheme.tertiary.darken(0.2),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.navigation,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              // النص
              Positioned(
                bottom: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space2,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.tertiary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Text(
                    '${direction.toStringAsFixed(0)}°',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.bold,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        AppTheme.space5.h,
        
        // المعلومات الإضافية
        if (locationName != null) ...[
          Container(
            padding: const EdgeInsets.all(AppTheme.space3),
            decoration: BoxDecoration(
              gradient: AppTheme.glassGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.glassStroke),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: AppTheme.iconSm,
                  color: AppTheme.info,
                ),
                AppTheme.space2.w,
                Text(
                  locationName!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: AppTheme.medium,
                  ),
                ),
              ],
            ),
          ),
          AppTheme.space3.h,
        ],
        
        if (accuracy != null) ...[
          Text(
            'دقة القياس: ${accuracy!.toStringAsFixed(1)}%',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textTertiary,
              fontFamily: AppTheme.numbersFont,
            ),
          ),
          AppTheme.space3.h,
        ],
        
        // زر المعايرة المحسّن
        if (!isCalibrated && onCalibrate != null)
          AppButton.outline(
            text: 'معايرة البوصلة',
            icon: Icons.tune,
            onPressed: onCalibrate!,
            borderColor: AppTheme.tertiary,
          ),
      ],
    );
  }
}

/// محتوى بطاقة أوقات الصلاة المتقدمة
class _PrayerTimesCardContent extends StatelessWidget {
  final Map<String, String> prayerTimes;
  final String? currentPrayer;
  final String? nextPrayer;
  final Duration? timeToNext;

  const _PrayerTimesCardContent({
    required this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.timeToNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان والحالة الحالية
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'أوقات الصلاة',
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: AppTheme.extraBold,
              ),
            ),
            if (currentPrayer != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                  vertical: AppTheme.space2,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.getPrayerColor(currentPrayer!),
                      AppTheme.getPrayerColor(currentPrayer!).darken(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.getPrayerColor(currentPrayer!)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  currentPrayer!,
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ),
          ],
        ),
        
        AppTheme.space5.h,
        
        // الوقت المتبقي للصلاة التالية
        if (nextPrayer != null && timeToNext != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.space5),
            decoration: BoxDecoration(
              gradient: AppTheme.oliveGoldGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              boxShadow: AppTheme.glassShadowMd,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppTheme.getPrayerIcon(nextPrayer!),
                      color: Colors.white,
                      size: AppTheme.iconMd,
                    ),
                    AppTheme.space2.w,
                    Text(
                      'الصلاة التالية: $nextPrayer',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                  ],
                ),
                AppTheme.space2.h,
                Text(
                  AppTheme.formatDuration(timeToNext!),
                  style: AppTheme.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.extraBold,
                    fontFamily: AppTheme.numbersFont,
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
          AppTheme.space5.h,
        ],
        
        // قائمة أوقات الصلوات المحسّنة
        ...prayerTimes.entries.map((entry) => _buildPrayerRow(
          entry.key,
          entry.value,
          entry.key == currentPrayer,
          entry.key == nextPrayer,
        )),
      ],
    );
  }

  Widget _buildPrayerRow(String prayer, String time, bool isCurrent, bool isNext) {
    final prayerColor = AppTheme.getPrayerColor(prayer);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space3),
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        gradient: isCurrent 
            ? LinearGradient(
                colors: [
                  prayerColor.withValues(alpha: 0.2),
                  prayerColor.withValues(alpha: 0.1),
                ],
              )
            : AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: isCurrent 
              ? prayerColor.withValues(alpha: 0.4)
              : AppTheme.glassStroke,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // مؤشر الحالة
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              gradient: isCurrent 
                  ? LinearGradient(colors: [prayerColor, prayerColor.darken(0.1)])
                  : null,
              color: isCurrent ? null : (isNext ? prayerColor.withValues(alpha: 0.6) : AppTheme.textTertiary),
              shape: BoxShape.circle,
              boxShadow: isCurrent ? [
                BoxShadow(
                  color: prayerColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
          ),
          
          AppTheme.space4.w,
          
          // أيقونة الصلاة
          Container(
            padding: const EdgeInsets.all(AppTheme.space2),
            decoration: BoxDecoration(
              color: prayerColor.withValues(alpha: isCurrent ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              AppTheme.getPrayerIcon(prayer),
              color: prayerColor,
              size: AppTheme.iconSm,
            ),
          ),
          
          AppTheme.space3.w,
          
          // اسم الصلاة
          Expanded(
            child: Text(
              prayer,
              style: AppTheme.titleMedium.copyWith(
                fontWeight: isCurrent ? AppTheme.bold : AppTheme.medium,
                color: isCurrent ? prayerColor : AppTheme.textPrimary,
              ),
            ),
          ),
          
          // الوقت
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space3,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: prayerColor.withValues(alpha: isCurrent ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Text(
              time,
              style: AppTheme.titleMedium.copyWith(
                fontFamily: AppTheme.numbersFont,
                fontWeight: isCurrent ? AppTheme.bold : AppTheme.semiBold,
                color: prayerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== باقي المكونات المحسّنة ====================

/// زر موحد محسّن مع Glassmorphism
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final bool useGlass;

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
    this.useGlass = false,
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

  factory AppButton.glass({
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
      isFullWidth: isFullWidth,
      useGlass: true,
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

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _controller.forward();
  }

  void _handleTapUp() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = widget.isLoading
        ? SizedBox(
            width: AppTheme.iconMd,
            height: AppTheme.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.foregroundColor ?? AppTheme.textPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon!, size: AppTheme.iconMd),
                AppTheme.space2.w,
              ],
              Text(
                widget.text,
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: AppTheme.semiBold,
                ),
              ),
            ],
          );

    Widget button = Container(
      width: widget.isFullWidth ? double.infinity : widget.width,
      height: widget.height ?? AppTheme.buttonHeight,
      decoration: widget.useGlass 
          ? AppTheme.createGlassEffect(
              borderRadius: AppTheme.radiusXl,
              opacity: 0.15,
            )
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.backgroundColor ?? AppTheme.primary,
                  (widget.backgroundColor ?? AppTheme.primary).darken(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? AppTheme.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          onTapDown: (_) => _handleTapDown(),
          onTapUp: (_) => _handleTapUp(),
          onTapCancel: _handleTapUp,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space6,
              vertical: AppTheme.space4,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: widget.useGlass 
                    ? AppTheme.textPrimary
                    : (widget.foregroundColor ?? Colors.black),
              ),
              child: buttonChild,
            ),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: button,
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
    return Container(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppTheme.buttonHeight,
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space6,
              vertical: AppTheme.space4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon!, 
                    size: AppTheme.iconMd,
                    color: borderColor,
                  ),
                  AppTheme.space2.w,
                ],
                Text(
                  text,
                  style: AppTheme.titleMedium.copyWith(
                    color: borderColor,
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// إجراء في البطاقة محسّن
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
    return Container(
      decoration: isPrimary ? BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color ?? AppTheme.primary,
            (color ?? AppTheme.primary).darken(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: (color ?? AppTheme.primary).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ) : AppTheme.createGlassEffect(
        borderRadius: AppTheme.radiusMd,
        opacity: 0.1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space3,
              vertical: AppTheme.space2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: AppTheme.iconSm,
                  color: isPrimary 
                      ? Colors.white
                      : color ?? AppTheme.textSecondary,
                ),
                if (label.isNotEmpty) ...[
                  AppTheme.space1.w,
                  Text(
                    label,
                    style: AppTheme.labelMedium.copyWith(
                      color: isPrimary 
                          ? Colors.white
                          : color ?? AppTheme.textSecondary,
                      fontWeight: isPrimary 
                          ? AppTheme.bold 
                          : AppTheme.medium,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== بطاقة الإعدادات المحسّنة ====================

/// بطاقة إعداد واحد محسّنة
class SettingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;
  final bool showArrow;

  const SettingCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    this.color,
    this.showArrow = true,
  });

  factory SettingCard.toggle({
    Key? key,
    required String title,
    String? subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? color,
  }) {
    return SettingCard(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      showArrow: false,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color ?? AppTheme.primary,
      ),
      onTap: onChanged != null ? () => onChanged(!value) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      decoration: AppTheme.createGlassEffect(
        borderRadius: AppTheme.radiusXl,
        opacity: 0.1,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.space5),
            child: Row(
              children: [
                // الأيقونة المحسّنة
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (color ?? AppTheme.primary).withValues(alpha: 0.2),
                        (color ?? AppTheme.primary).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: (color ?? AppTheme.primary).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? AppTheme.primary,
                    size: AppTheme.iconMd,
                  ),
                ),
                
                AppTheme.space4.w,
                
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: AppTheme.semiBold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        AppTheme.space1.h,
                        Text(
                          subtitle!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // العنصر الجانبي
                if (trailing != null) ...[
                  AppTheme.space3.w,
                  trailing!,
                ] else if (showArrow) ...[
                  AppTheme.space3.w,
                  Container(
                    padding: const EdgeInsets.all(AppTheme.space1),
                    decoration: BoxDecoration(
                      color: AppTheme.textTertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textTertiary,
                      size: AppTheme.iconMd,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== مؤشرات الحالة المحسّنة ====================

/// مؤشر التحميل المحسّن
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
      child: Container(
        padding: const EdgeInsets.all(AppTheme.space6),
        decoration: AppTheme.createGlassEffect(
          borderRadius: AppTheme.radius2xl,
          opacity: 0.1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size ?? AppTheme.iconMd,
              height: size ?? AppTheme.iconMd,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color ?? AppTheme.primary,
                    (color ?? AppTheme.primary).withValues(alpha: 0.7),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            
            if (message != null) ...[
              AppTheme.space4.h,
              Text(
                message!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: AppTheme.medium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// حالة الفراغ المحسّنة
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.space6),
        padding: const EdgeInsets.all(AppTheme.space8),
        decoration: AppTheme.createGlassEffect(
          borderRadius: AppTheme.radius3xl,
          opacity: 0.08,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.textTertiary.withValues(alpha: 0.2),
                      AppTheme.textTertiary.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon!,
                  size: 48,
                  color: AppTheme.textTertiary,
                ),
              ),
              AppTheme.space5.h,
            ],
            
            Text(
              message,
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: AppTheme.medium,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (actionText != null && onAction != null) ...[
              AppTheme.space6.h,
              AppButton.glass(
                text: actionText!,
                onPressed: onAction!,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}