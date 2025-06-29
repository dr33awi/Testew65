// lib/app/themes/widgets/widgets.dart - النظام الموحد المحسّن للكروت
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== البطاقة الموحدة الشاملة ====================

/// بطاقة موحدة شاملة - النسخة الوحيدة المعتمدة
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
  final List<CardAction>? actions;
  final double? borderRadius;
  final double? elevation;

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
    this.actions,
    this.borderRadius,
    this.elevation,
  });

  // ========== Factory Constructors الموحدة ==========

  /// بطاقة معلومات أساسية
  factory AppCard.basic({
    Key? key,
    required String title,
    String? subtitle,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      onTap: onTap,
      actions: actions,
    );
  }

  /// بطاقة إحصائية
  factory AppCard.stat({
    Key? key,
    required String title,
    required String value,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    String? subtitle,
  }) {
    return AppCard(
      key: key,
      useGradient: true,
      color: color ?? AppTheme.primary,
      onTap: onTap,
      child: _StatCardContent(
        title: title,
        value: value,
        icon: icon,
        subtitle: subtitle,
      ),
    );
  }

  /// بطاقة ذكر/دعاء موحدة
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

  /// بطاقة صلاة موحدة
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
      color: isCurrent ? AppTheme.getPrayerColor(prayerName) : null,
      onTap: onTap,
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

  /// بطاقة فئة موحدة
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
      color: AppTheme.getCategoryColor(categoryId),
      onTap: onTap,
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

  /// بطاقة القبلة موحدة
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
      color: isSimple ? AppTheme.tertiary : null,
      onTap: onTap,
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
      padding: AppTheme.space5.padding,
      onTap: onTap,
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
                  decoration: CardHelper.getCardDecoration(
                    color: widget.color,
                    useGradient: widget.useGradient,
                    borderRadius: widget.borderRadius ?? AppTheme.radiusLg,
                  ),
                  padding: widget.padding ?? AppTheme.space4.padding,
                  child: widget.child ?? _buildDefaultContent(),
                ),
              ),
            ),
          ),
        );
      },
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
                Icon(
                  widget.icon!,
                  color: textColor ?? widget.color ?? AppTheme.primary,
                  size: AppTheme.iconLg,
                ),
                AppTheme.space3.w,
              ],
              if (widget.title != null)
                Expanded(
                  child: Text(
                    widget.title!,
                    style: AppTheme.titleMedium.copyWith(
                      color: textColor,
                      fontWeight: AppTheme.semiBold,
                    ),
                  ),
                ),
            ],
          ),
          if (widget.subtitle != null) AppTheme.space2.h,
        ],
        
        if (widget.subtitle != null) ...[
          Text(
            widget.subtitle!,
            style: AppTheme.bodySmall.copyWith(
              color: textColor?.withValues(alpha: 0.8),
            ),
          ),
        ],
        
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          AppTheme.space4.h,
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

// ==================== محتويات البطاقات المتخصصة ====================

/// محتوى بطاقة الإحصائية
class _StatCardContent extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final String? subtitle;

  const _StatCardContent({
    required this.title,
    required this.value,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon!, color: Colors.white, size: AppTheme.iconLg),
          AppTheme.space2.h,
        ],
        Text(
          value,
          style: AppTheme.displayLarge.copyWith(
            color: Colors.white,
            fontSize: 28,
            fontFamily: AppTheme.numbersFont,
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
        if (subtitle != null) ...[
          AppTheme.space1.h,
          Text(
            subtitle!,
            style: AppTheme.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// محتوى بطاقة الذكر الموحدة
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
        // النص الرئيسي
        Container(
          width: double.infinity,
          padding: AppTheme.space4.padding,
          decoration: BoxDecoration(
            color: isCompleted 
                ? primaryColor.withValues(alpha: 0.2)
                : primaryColor.withValues(alpha: 0.1),
            borderRadius: AppTheme.radiusMd.radius,
            border: Border.all(
              color: isCompleted
                  ? primaryColor.withValues(alpha: 0.4)
                  : primaryColor.withValues(alpha: 0.2),
              width: isCompleted ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                content,
                style: AppTheme.quranStyle.copyWith(
                  height: 1.8,
                  color: isCompleted ? primaryColor : AppTheme.textReligious,
                ),
                textAlign: TextAlign.center,
              ),
              
              if (isCompleted) ...[
                AppTheme.space2.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: primaryColor,
                      size: AppTheme.iconSm,
                    ),
                    AppTheme.space1.w,
                    Text(
                      'مكتمل',
                      style: AppTheme.caption.copyWith(
                        color: primaryColor,
                        fontWeight: AppTheme.medium,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        
        AppTheme.space3.h,
        
        // المعلومات الإضافية
        if (source != null) ...[
          _buildInfoRow(Icons.library_books, 'المصدر: $source', primaryColor),
          AppTheme.space1.h,
        ],
        
        if (fadl != null) ...[
          _buildInfoRow(Icons.star, 'الفضل: $fadl', AppTheme.warning),
          AppTheme.space2.h,
        ],
        
        // شريط التقدم والعداد
        Row(
          children: [
            // العداد
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.success : primaryColor,
                borderRadius: AppTheme.radiusFull.radius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted)
                    const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  else ...[
                    Text(
                      '$currentCount',
                      style: AppTheme.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                    Text(
                      ' / $totalCount',
                      style: AppTheme.labelMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // شريط التقدم
            if (showProgress && !isCompleted) ...[
              AppTheme.space3.w,
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: AppTheme.radiusFull.radius,
                      ),
                    ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppTheme.iconSm,
          color: iconColor,
        ),
        AppTheme.space2.w,
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// محتوى بطاقة الصلاة الموحدة
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
        Icon(
          AppTheme.getPrayerIcon(prayerName),
          size: AppTheme.iconLg,
          color: isCurrent ? Colors.white : prayerColor,
        ),
        AppTheme.space2.h,
        Text(
          prayerName,
          style: AppTheme.titleMedium.copyWith(
            color: isCurrent ? Colors.white : null,
            fontWeight: AppTheme.semiBold,
          ),
        ),
        AppTheme.space1.h,
        Text(
          time,
          style: AppTheme.bodyLarge.copyWith(
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.bold,
            color: isCurrent ? Colors.white : prayerColor,
          ),
        ),
        if (isNext || isCompleted) ...[
          AppTheme.space1.h,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: (isCurrent ? Colors.white : prayerColor).withValues(alpha: 0.2),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: Text(
              isCompleted ? 'مُؤداة' : 'التالية',
              style: AppTheme.caption.copyWith(
                color: isCurrent ? Colors.white : prayerColor,
                fontWeight: AppTheme.medium,
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
                Icon(
                  AppTheme.getPrayerIcon(prayerName),
                  color: isCurrent ? Colors.white : prayerColor,
                  size: AppTheme.iconMd,
                ),
                AppTheme.space3.w,
                Text(
                  prayerName,
                  style: AppTheme.titleMedium.copyWith(
                    color: isCurrent ? Colors.white : null,
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ],
            ),
            Text(
              time,
              style: AppTheme.titleMedium.copyWith(
                fontFamily: AppTheme.numbersFont,
                fontWeight: AppTheme.bold,
                color: isCurrent ? Colors.white : prayerColor,
              ),
            ),
          ],
        ),
        
        if (remainingTime != null && isNext) ...[
          AppTheme.space2.h,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space3,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: (isCurrent ? Colors.white : prayerColor).withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: Text(
              'بعد ${AppTheme.formatDuration(remainingTime!)}',
              style: AppTheme.bodySmall.copyWith(
                color: isCurrent ? Colors.white : prayerColor,
                fontWeight: AppTheme.medium,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// محتوى بطاقة الفئة الموحدة
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
        Icon(
          categoryIcon,
          color: Colors.white,
          size: AppTheme.iconLg,
        ),
        AppTheme.space2.h,
        Text(
          title,
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.semiBold,
          ),
          textAlign: TextAlign.center,
        ),
        AppTheme.space1.h,
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: AppTheme.radiusFull.radius,
          ),
          child: Text(
            '$count ذكر',
            style: AppTheme.caption.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullContent(Color categoryColor, IconData categoryIcon) {
    return Row(
      children: [
        // الأيقونة
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: AppTheme.radiusMd.radius,
          ),
          child: Icon(
            categoryIcon,
            color: categoryColor,
            size: AppTheme.iconMd,
          ),
        ),
        
        AppTheme.space3.w,
        
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
              if (showDescription) ...[
                AppTheme.space1.h,
                Text(
                  customDescription ?? _getDefaultDescription(),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // العدد
        if (count > 0) ...[
          AppTheme.space2.w,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space2,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: Text(
              count.toString(),
              style: AppTheme.caption.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.bold,
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
        return 'أذكار الصباح والاستيقاظ';
      case 'evening':
      case 'المساء':
        return 'أذكار المساء والمغرب';
      case 'sleep':
      case 'النوم':
        return 'أذكار النوم والاضطجاع';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار الصلاة والوضوء';
      case 'eating':
      case 'الطعام':
        return 'أذكار الطعام والشراب';
      case 'travel':
      case 'السفر':
        return 'أذكار السفر والطريق';
      default:
        return 'أذكار متنوعة';
    }
  }
}

/// محتوى بطاقة القبلة الموحدة
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
        Transform.rotate(
          angle: direction * (3.14159 / 180),
          child: const Icon(
            Icons.navigation,
            size: 32,
            color: Colors.white,
          ),
        ),
        AppTheme.space2.h,
        Text(
          'القبلة',
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.semiBold,
          ),
        ),
        AppTheme.space1.h,
        Text(
          '${direction.toStringAsFixed(0)}°',
          style: AppTheme.bodyLarge.copyWith(
            color: Colors.white,
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.bold,
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
                const Icon(
                  Icons.explore,
                  color: AppTheme.tertiary,
                  size: AppTheme.iconMd,
                ),
                AppTheme.space2.w,
                Text(
                  'اتجاه القبلة',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space2,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isCalibrated ? AppTheme.success : AppTheme.warning,
                borderRadius: AppTheme.radiusFull.radius,
              ),
              child: Text(
                isCalibrated ? 'مُعايَر' : 'غير مُعايَر',
                style: AppTheme.caption.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ),
          ],
        ),
        
        AppTheme.space4.h,
        
        // البوصلة
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppTheme.oliveGoldGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.shadowMd,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // خلفية البوصلة
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              // السهم
              Transform.rotate(
                angle: direction * (3.14159 / 180),
                child: const Icon(
                  Icons.navigation,
                  size: 40,
                  color: AppTheme.tertiary,
                ),
              ),
              // النص
              Positioned(
                bottom: 25,
                child: Text(
                  '${direction.toStringAsFixed(0)}°',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.tertiary,
                    fontWeight: AppTheme.bold,
                    fontFamily: AppTheme.numbersFont,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        AppTheme.space4.h,
        
        // المعلومات الإضافية
        if (locationName != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: AppTheme.iconSm,
                color: AppTheme.textSecondary,
              ),
              AppTheme.space1.w,
              Text(
                locationName!,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          AppTheme.space2.h,
        ],
        
        if (accuracy != null) ...[
          Text(
            'دقة القياس: ${accuracy!.toStringAsFixed(1)}%',
            style: AppTheme.caption.copyWith(
              color: AppTheme.textTertiary,
              fontFamily: AppTheme.numbersFont,
            ),
          ),
          AppTheme.space2.h,
        ],
        
        // زر المعايرة
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
              style: AppTheme.titleLarge.copyWith(
                fontWeight: AppTheme.bold,
              ),
            ),
            if (currentPrayer != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: AppTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.getPrayerColor(currentPrayer!),
                  borderRadius: AppTheme.radiusFull.radius,
                ),
                child: Text(
                  currentPrayer!,
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ),
          ],
        ),
        
        AppTheme.space4.h,
        
        // الوقت المتبقي للصلاة التالية
        if (nextPrayer != null && timeToNext != null) ...[
          Container(
            width: double.infinity,
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              gradient: AppTheme.oliveGoldGradient,
              borderRadius: AppTheme.radiusMd.radius,
            ),
            child: Column(
              children: [
                Text(
                  'الصلاة التالية: $nextPrayer',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.medium,
                  ),
                ),
                AppTheme.space1.h,
                Text(
                  AppTheme.formatDuration(timeToNext!),
                  style: AppTheme.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                    fontFamily: AppTheme.numbersFont,
                  ),
                ),
              ],
            ),
          ),
          AppTheme.space4.h,
        ],
        
        // قائمة أوقات الصلوات
        ...prayerTimes.entries.map((entry) => _buildPrayerRow(
          entry.key,
          entry.value,
          entry.key == currentPrayer,
        )),
      ],
    );
  }

  Widget _buildPrayerRow(String prayer, String time, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isCurrent 
                      ? AppTheme.getPrayerColor(prayer)
                      : AppTheme.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
              AppTheme.space3.w,
              Text(
                prayer,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: isCurrent ? AppTheme.semiBold : AppTheme.regular,
                  color: isCurrent ? AppTheme.getPrayerColor(prayer) : null,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: AppTheme.bodyLarge.copyWith(
              fontFamily: AppTheme.numbersFont,
              fontWeight: isCurrent ? AppTheme.bold : AppTheme.medium,
              color: isCurrent ? AppTheme.getPrayerColor(prayer) : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== باقي المكونات الموحدة ====================

/// زر موحد شامل - بدون تغيير
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
              if (label.isNotEmpty) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== بطاقة الإعدادات الموحدة ====================

/// بطاقة إعداد واحد - موحدة
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
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space1,
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (color ?? AppTheme.primary).withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
            ),
            child: Icon(
              icon,
              color: color ?? AppTheme.primary,
              size: AppTheme.iconMd,
            ),
          ),
          
          AppTheme.space3.w,
          
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: AppTheme.medium,
                  ),
                ),
                if (subtitle != null) ...[
                  AppTheme.space1.h,
                  Text(
                    subtitle!,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // العنصر الجانبي
          if (trailing != null) ...[
            AppTheme.space2.w,
            trailing!,
          ] else if (showArrow) ...[
            AppTheme.space2.w,
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
              size: AppTheme.iconMd,
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== مؤشرات الحالة ====================

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
