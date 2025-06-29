// lib/app/themes/widgets/specialized/prayer_cards.dart
// كروت الصلوات وأوقاتها - مفصولة ومتخصصة
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== كروت الصلوات المتخصصة ====================

/// بطاقة صلاة واحدة متقدمة
class PrayerCard extends StatefulWidget {
  final String prayerName;
  final String time;
  final bool isCurrent;
  final bool isNext;
  final bool isCompleted;
  final Duration? remainingTime;
  final VoidCallback? onTap;
  final List<PrayerAction>? actions;
  final bool showStatus;
  final bool useAnimation;
  final bool isCompact;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.time,
    this.isCurrent = false,
    this.isNext = false,
    this.isCompleted = false,
    this.remainingTime,
    this.onTap,
    this.actions,
    this.showStatus = true,
    this.useAnimation = true,
    this.isCompact = false,
  });

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // تشغيل التأثير للصلاة الحالية
    if (widget.isCurrent && widget.useAnimation) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PrayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && widget.useAnimation && !oldWidget.isCurrent) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isCurrent && oldWidget.isCurrent) {
      _animationController.stop();
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
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayerColor = AppTheme.getPrayerColor(widget.prayerName);
    final prayerIcon = AppTheme.getPrayerIcon(widget.prayerName);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isCurrent && widget.useAnimation ? _scaleAnimation.value : 1.0,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppTheme.space4,
              vertical: AppTheme.space2,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: AppTheme.radiusLg.radius,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: AppTheme.radiusLg.radius,
                child: Container(
                  decoration: _buildCardDecoration(prayerColor),
                  padding: AppTheme.space4.padding,
                  child: widget.isCompact 
                      ? _buildCompactContent(prayerColor, prayerIcon)
                      : _buildFullContent(prayerColor, prayerIcon),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildCardDecoration(Color prayerColor) {
    if (widget.isCurrent) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            prayerColor,
            AppTheme.darken(prayerColor, 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppTheme.radiusLg.radius,
        boxShadow: [
          BoxShadow(
            color: prayerColor.withValues(alpha: widget.useAnimation ? _glowAnimation.value : 0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }

    return BoxDecoration(
      color: widget.isNext 
          ? prayerColor.withValues(alpha: 0.1)
          : AppTheme.card,
      borderRadius: AppTheme.radiusLg.radius,
      border: Border.all(
        color: widget.isNext 
            ? prayerColor.withValues(alpha: 0.3)
            : AppTheme.divider.withValues(alpha: 0.3),
        width: widget.isNext ? 2 : 1,
      ),
      boxShadow: AppTheme.shadowSm,
    );
  }

  Widget _buildCompactContent(Color prayerColor, IconData prayerIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // الأيقونة
        Icon(
          prayerIcon,
          size: AppTheme.iconLg,
          color: widget.isCurrent ? Colors.white : prayerColor,
        ),
        
        AppTheme.space2.h,
        
        // اسم الصلاة
        Text(
          widget.prayerName,
          style: AppTheme.titleMedium.copyWith(
            color: widget.isCurrent ? Colors.white : null,
            fontWeight: AppTheme.semiBold,
          ),
          textAlign: TextAlign.center,
        ),
        
        AppTheme.space1.h,
        
        // الوقت
        Text(
          widget.time,
          style: AppTheme.bodyLarge.copyWith(
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.bold,
            color: widget.isCurrent ? Colors.white : prayerColor,
          ),
        ),
        
        // الحالة
        if (widget.showStatus && (widget.isNext || widget.isCompleted)) ...[
          AppTheme.space1.h,
          _buildStatusChip(),
        ],
      ],
    );
  }

  Widget _buildFullContent(Color prayerColor, IconData prayerIcon) {
    return Column(
      children: [
        // الصف الرئيسي
        Row(
          children: [
            // الأيقونة واسم الصلاة
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.isCurrent 
                          ? Colors.white.withValues(alpha: 0.2)
                          : prayerColor.withValues(alpha: 0.1),
                      borderRadius: AppTheme.radiusMd.radius,
                    ),
                    child: Icon(
                      prayerIcon,
                      color: widget.isCurrent ? Colors.white : prayerColor,
                      size: AppTheme.iconMd,
                    ),
                  ),
                  
                  AppTheme.space3.w,
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prayerName,
                          style: AppTheme.titleMedium.copyWith(
                            color: widget.isCurrent ? Colors.white : null,
                            fontWeight: AppTheme.semiBold,
                          ),
                        ),
                        if (widget.remainingTime != null && widget.isNext) ...[
                          AppTheme.space1.h,
                          Text(
                            'بعد ${AppTheme.formatDuration(widget.remainingTime!)}',
                            style: AppTheme.bodySmall.copyWith(
                              color: widget.isCurrent 
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // الوقت والحالة
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.time,
                  style: AppTheme.titleLarge.copyWith(
                    fontFamily: AppTheme.numbersFont,
                    fontWeight: AppTheme.bold,
                    color: widget.isCurrent ? Colors.white : prayerColor,
                  ),
                ),
                if (widget.showStatus && (widget.isNext || widget.isCompleted)) ...[
                  AppTheme.space1.h,
                  _buildStatusChip(),
                ],
              ],
            ),
          ],
        ),
        
        // الإجراءات
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          AppTheme.space4.h,
          _buildActions(),
        ],
      ],
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String chipText;
    IconData chipIcon;

    if (widget.isCompleted) {
      chipColor = AppTheme.success;
      chipText = 'مُؤداة';
      chipIcon = Icons.check_circle;
    } else if (widget.isNext) {
      chipColor = widget.isCurrent ? Colors.white : AppTheme.warning;
      chipText = 'التالية';
      chipIcon = Icons.schedule;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: widget.isCurrent 
            ? chipColor.withValues(alpha: 0.2)
            : chipColor.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusFull.radius,
        border: Border.all(
          color: chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            chipIcon,
            size: 12,
            color: widget.isCurrent ? Colors.white : chipColor,
          ),
          AppTheme.space1.w,
          Text(
            chipText,
            style: AppTheme.caption.copyWith(
              color: widget.isCurrent ? Colors.white : chipColor,
              fontWeight: AppTheme.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widget.actions!.map((action) => 
        Padding(
          padding: const EdgeInsets.only(left: AppTheme.space2),
          child: action,
        ),
      ).toList(),
    );
  }
}

/// بطاقة جدول الصلوات الكامل
class PrayerTimesTableCard extends StatelessWidget {
  final Map<String, String> prayerTimes;
  final String? currentPrayer;
  final String? nextPrayer;
  final Duration? timeToNext;
  final Function(String)? onPrayerTap;
  final VoidCallback? onRefresh;
  final String? locationName;
  final DateTime? date;

  const PrayerTimesTableCard({
    super.key,
    required this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.timeToNext,
    this.onPrayerTap,
    this.onRefresh,
    this.locationName,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: AppTheme.radiusLg.radius,
            border: Border.all(
              color: AppTheme.divider.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: AppTheme.shadowMd,
          ),
          padding: AppTheme.space5.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              AppTheme.space4.h,
              if (nextPrayer != null && timeToNext != null)
                _buildNextPrayerSection(),
              AppTheme.space4.h,
              _buildPrayersList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أوقات الصلاة',
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: AppTheme.bold,
                ),
              ),
              if (locationName != null) ...[
                AppTheme.space1.h,
                Row(
                  children: [
                    Icon(
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
              ],
              if (date != null) ...[
                AppTheme.space1.h,
                Text(
                  _formatDate(date!),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (currentPrayer != null) ...[
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
        if (onRefresh != null) ...[
          AppTheme.space2.w,
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            color: AppTheme.textSecondary,
            tooltip: 'تحديث',
          ),
        ],
      ],
    );
  }

  Widget _buildNextPrayerSection() {
    return Container(
      width: double.infinity,
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        gradient: AppTheme.oliveGoldGradient,
        borderRadius: AppTheme.radiusMd.radius,
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
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ],
          ),
          AppTheme.space2.h,
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
    );
  }

  Widget _buildPrayersList() {
    // ترتيب الصلوات
    final sortedPrayers = AppTheme.sortByPriority(
      prayerTimes.keys.toList(),
      (prayer) => AppTheme.getPrayerPriority(prayer),
    );

    return Column(
      children: sortedPrayers.map((prayerName) {
        final time = prayerTimes[prayerName] ?? '--:--';
        final isCurrent = prayerName == currentPrayer;
        final isNext = prayerName == nextPrayer;
        
        return _buildPrayerRow(prayerName, time, isCurrent, isNext);
      }).toList(),
    );
  }

  Widget _buildPrayerRow(String prayerName, String time, bool isCurrent, bool isNext) {
    final prayerColor = AppTheme.getPrayerColor(prayerName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: onPrayerTap != null ? () => onPrayerTap!(prayerName) : null,
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space3.padding,
            decoration: isCurrent ? BoxDecoration(
              color: prayerColor.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: prayerColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ) : null,
            child: Row(
              children: [
                // مؤشر الحالة
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isCurrent 
                        ? prayerColor
                        : isNext
                            ? prayerColor.withValues(alpha: 0.5)
                            : AppTheme.textTertiary.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                
                AppTheme.space3.w,
                
                // الأيقونة
                Icon(
                  AppTheme.getPrayerIcon(prayerName),
                  color: isCurrent 
                      ? prayerColor
                      : AppTheme.textSecondary,
                  size: AppTheme.iconMd,
                ),
                
                AppTheme.space3.w,
                
                // اسم الصلاة
                Expanded(
                  child: Text(
                    prayerName,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: isCurrent ? AppTheme.semiBold : AppTheme.regular,
                      color: isCurrent ? prayerColor : null,
                    ),
                  ),
                ),
                
                // الوقت
                Text(
                  time,
                  style: AppTheme.bodyLarge.copyWith(
                    fontFamily: AppTheme.numbersFont,
                    fontWeight: isCurrent ? AppTheme.bold : AppTheme.medium,
                    color: isCurrent ? prayerColor : AppTheme.textSecondary,
                  ),
                ),
                
                // حالة إضافية
                if (isNext && !isCurrent) ...[
                  AppTheme.space2.w,
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.warning,
                      shape: BoxShape.circle,
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

  String _formatDate(DateTime date) {
    const arabicDays = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    
    const arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final dayName = arabicDays[date.weekday - 1];
    final monthName = arabicMonths[date.month - 1];
    
    return '$dayName ${date.day} $monthName ${date.year}';
  }
}

/// بطاقة مختصرة للصلاة التالية
class NextPrayerCard extends StatelessWidget {
  final String prayerName;
  final String time;
  final Duration remainingTime;
  final VoidCallback? onTap;
  final bool showCountdown;
  final bool useGradient;

  const NextPrayerCard({
    super.key,
    required this.prayerName,
    required this.time,
    required this.remainingTime,
    this.onTap,
    this.showCountdown = true,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final prayerColor = AppTheme.getPrayerColor(prayerName);
    
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              gradient: useGradient ? LinearGradient(
                colors: [prayerColor, AppTheme.darken(prayerColor, 0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
              color: useGradient ? null : prayerColor.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusLg.radius,
              border: useGradient ? null : Border.all(
                color: prayerColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: useGradient ? AppTheme.shadowMd : AppTheme.shadowSm,
            ),
            padding: AppTheme.space5.padding,
            child: Column(
              children: [
                // الأيقونة واسم الصلاة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppTheme.getPrayerIcon(prayerName),
                      color: useGradient ? Colors.white : prayerColor,
                      size: AppTheme.iconLg,
                    ),
                    AppTheme.space3.w,
                    Text(
                      'الصلاة التالية: $prayerName',
                      style: AppTheme.titleMedium.copyWith(
                        color: useGradient ? Colors.white : prayerColor,
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // الوقت
                Text(
                  time,
                  style: AppTheme.headlineMedium.copyWith(
                    color: useGradient ? Colors.white : prayerColor,
                    fontWeight: AppTheme.bold,
                    fontFamily: AppTheme.numbersFont,
                  ),
                ),
                
                if (showCountdown) ...[
                  AppTheme.space2.h,
                  Text(
                    'بعد ${AppTheme.formatDuration(remainingTime)}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: useGradient 
                          ? Colors.white.withValues(alpha: 0.9)
                          : prayerColor.withValues(alpha: 0.8),
                      fontWeight: AppTheme.medium,
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

/// بطاقة إحصائيات الصلوات
class PrayerStatsCard extends StatelessWidget {
  final Map<String, bool> prayerStatus;
  final int completedToday;
  final int totalPrayers;
  final double completionPercentage;
  final VoidCallback? onViewDetails;

  const PrayerStatsCard({
    super.key,
    required this.prayerStatus,
    required this.completedToday,
    required this.totalPrayers,
    required this.completionPercentage,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onViewDetails,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              gradient: _getGradientForPercentage(),
              borderRadius: AppTheme.radiusLg.radius,
              boxShadow: AppTheme.shadowMd,
            ),
            padding: AppTheme.space5.padding,
            child: Column(
              children: [
                // العنوان والنسبة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'صلوات اليوم',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                    Text(
                      '${completionPercentage.toInt()}%',
                      style: AppTheme.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // شريط التقدم
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (completionPercentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppTheme.radiusFull.radius,
                      ),
                    ),
                  ),
                ),
                
                AppTheme.space4.h,
                
                // الإحصائيات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('مُؤداة', completedToday.toString()),
                    _buildStatItem('المجموع', totalPrayers.toString()),
                    _buildStatItem('متبقية', (totalPrayers - completedToday).toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradientForPercentage() {
    if (completionPercentage >= 100) {
      return const LinearGradient(
        colors: [AppTheme.success, Color(0xFF4CAF50)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (completionPercentage >= 80) {
      return LinearGradient(
        colors: [AppTheme.primary, AppTheme.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (completionPercentage >= 60) {
      return LinearGradient(
        colors: [AppTheme.warning, AppTheme.secondaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: [AppTheme.info, AppTheme.tertiary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        AppTheme.space1.h,
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: AppTheme.medium,
          ),
        ),
      ],
    );
  }
}

// ==================== مكونات مساعدة للصلوات ====================

/// إجراء في بطاقة الصلاة
class PrayerAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const PrayerAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
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

/// العد التنازلي للصلاة
class PrayerCountdown extends StatefulWidget {
  final Duration remainingTime;
  final String prayerName;
  final Color? color;
  final bool showIcon;
  final VoidCallback? onComplete;

  const PrayerCountdown({
    super.key,
    required this.remainingTime,
    required this.prayerName,
    this.color,
    this.showIcon = true,
    this.onComplete,
  });

  @override
  State<PrayerCountdown> createState() => _PrayerCountdownState();
}

class _PrayerCountdownState extends State<PrayerCountdown> {
  late Duration _remainingTime;
  
  @override
  void initState() {
    super.initState();
    _remainingTime = widget.remainingTime;
    // يمكن إضافة Timer هنا لتحديث الوقت كل ثانية
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.primary;
    
    return Container(
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusMd.radius,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showIcon) ...[
            Icon(
              Icons.schedule,
              color: color,
              size: AppTheme.iconSm,
            ),
            AppTheme.space2.w,
          ],
          
          Text(
            'بعد ${AppTheme.formatDuration(_remainingTime)}',
            style: AppTheme.bodyMedium.copyWith(
              color: color,
              fontWeight: AppTheme.medium,
              fontFamily: AppTheme.numbersFont,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Factory Methods للصلوات ====================

/// مصنع بطاقات الصلوات
class PrayerCards {
  PrayerCards._();

  /// بطاقة صلاة بسيطة
  static Widget simple({
    required String prayerName,
    required String time,
    bool isCurrent = false,
    bool isNext = false,
    VoidCallback? onTap,
  }) {
    return PrayerCard(
      prayerName: prayerName,
      time: time,
      isCurrent: isCurrent,
      isNext: isNext,
      onTap: onTap,
      isCompact: true,
      useAnimation: false,
    );
  }

  /// بطاقة صلاة متقدمة
  static Widget advanced({
    required String prayerName,
    required String time,
    bool isCurrent = false,
    bool isNext = false,
    bool isCompleted = false,
    Duration? remainingTime,
    VoidCallback? onTap,
    List<PrayerAction>? actions,
  }) {
    return PrayerCard(
      prayerName: prayerName,
      time: time,
      isCurrent: isCurrent,
      isNext: isNext,
      isCompleted: isCompleted,
      remainingTime: remainingTime,
      onTap: onTap,
      actions: actions,
      useAnimation: true,
    );
  }

  /// جدول كامل للصلوات
  static Widget table({
    required Map<String, String> prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    Duration? timeToNext,
    Function(String)? onPrayerTap,
    VoidCallback? onRefresh,
    String? locationName,
  }) {
    return PrayerTimesTableCard(
      prayerTimes: prayerTimes,
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
      timeToNext: timeToNext,
      onPrayerTap: onPrayerTap,
      onRefresh: onRefresh,
      locationName: locationName,
      date: DateTime.now(),
    );
  }

  /// بطاقة الصلاة التالية
  static Widget nextPrayer({
    required String prayerName,
    required String time,
    required Duration remainingTime,
    VoidCallback? onTap,
    bool showCountdown = true,
  }) {
    return NextPrayerCard(
      prayerName: prayerName,
      time: time,
      remainingTime: remainingTime,
      onTap: onTap,
      showCountdown: showCountdown,
    );
  }

  /// بطاقة إحصائيات الصلوات
  static Widget stats({
    required Map<String, bool> prayerStatus,
    VoidCallback? onViewDetails,
  }) {
    final completed = prayerStatus.values.where((status) => status).length;
    final total = prayerStatus.length;
    final percentage = total > 0 ? (completed / total) * 100 : 0.0;
    
    return PrayerStatsCard(
      prayerStatus: prayerStatus,
      completedToday: completed,
      totalPrayers: total,
      completionPercentage: percentage,
      onViewDetails: onViewDetails,
    );
  }
}

// ==================== Extensions للصلوات ====================

extension PrayerCardExtensions on BuildContext {
  /// إظهار تفاصيل الصلاة في dialog
  void showPrayerDetails({
    required String prayerName,
    required String time,
    String? description,
    List<String>? sunnah,
    VoidCallback? onMarkCompleted,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              AppTheme.getPrayerIcon(prayerName),
              color: AppTheme.getPrayerColor(prayerName),
            ),
            AppTheme.space2.w,
            Text(prayerName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الوقت
            Text(
              'الوقت: $time',
              style: AppTheme.bodyLarge.copyWith(
                fontFamily: AppTheme.numbersFont,
                fontWeight: AppTheme.bold,
              ),
            ),
            
            if (description != null) ...[
              AppTheme.space3.h,
              Text(
                description,
                style: AppTheme.bodyMedium,
              ),
            ],
            
            if (sunnah != null && sunnah.isNotEmpty) ...[
              AppTheme.space3.h,
              Text(
                'السُنن:',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: AppTheme.semiBold,
                ),
              ),
              AppTheme.space2.h,
              ...sunnah.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.space1),
                child: Text(
                  '• $item',
                  style: AppTheme.bodySmall,
                ),
              )),
            ],
          ],
        ),
        actions: [
          if (onMarkCompleted != null)
            TextButton(
              onPressed: () {
                onMarkCompleted();
                Navigator.pop(context);
              },
              child: const Text('تم الأداء'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}