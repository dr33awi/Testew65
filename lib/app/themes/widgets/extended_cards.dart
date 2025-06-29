// lib/app/themes/widgets/extended_cards.dart - البطاقات المتخصصة فقط منظّفة
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== كروت أوقات الصلاة المتخصصة ====================

/// كرت أوقات الصلاة المتقدم
class PrayerTimesCard extends StatelessWidget {
  final Map<String, String> prayerTimes;
  final String? currentPrayer;
  final String? nextPrayer;
  final Duration? timeToNext;
  final VoidCallback? onTap;

  const PrayerTimesCard({
    super.key,
    required this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.timeToNext,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppTheme.space5.padding,
      child: Column(
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
            context,
            entry.key,
            entry.value,
            entry.key == currentPrayer,
          )),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(BuildContext context, String prayer, String time, bool isCurrent) {
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

/// كرت الصلاة التالية المتقدم
class NextPrayerCard extends StatelessWidget {
  final String prayerName;
  final String time;
  final Duration? remainingTime;
  final VoidCallback? onTap;

  const NextPrayerCard({
    super.key,
    required this.prayerName,
    required this.time,
    this.remainingTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: AppTheme.getPrayerColor(prayerName),
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppTheme.getPrayerIcon(prayerName),
                color: Colors.white,
                size: AppTheme.iconMd,
              ),
              AppTheme.space2.w,
              Text(
                'الصلاة التالية',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ],
          ),
          AppTheme.space3.h,
          Text(
            prayerName,
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.bold,
            ),
          ),
          AppTheme.space1.h,
          Text(
            time,
            style: AppTheme.titleLarge.copyWith(
              color: Colors.white,
              fontFamily: AppTheme.numbersFont,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          if (remainingTime != null) ...[
            AppTheme.space2.h,
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
                'بعد ${AppTheme.formatDuration(remainingTime!)}',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// كرت إحصائيات الصلوات
class PrayerStatsCard extends StatelessWidget {
  final int completedToday;
  final int totalDaily;
  final int streak;
  final VoidCallback? onTap;

  const PrayerStatsCard({
    super.key,
    required this.completedToday,
    required this.totalDaily,
    required this.streak,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completionRate = totalDaily > 0 ? completedToday / totalDaily : 0.0;
    
    return AppCard(
      useGradient: true,
      color: AppTheme.primary,
      onTap: onTap,
      child: Column(
        children: [
          Text(
            'إحصائيات الصلوات',
            style: AppTheme.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          AppTheme.space3.h,
          
          // شريط التقدم
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
          AppTheme.space3.h,
          
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('اليوم', '$completedToday/$totalDaily'),
              _buildStat('النسبة', '${(completionRate * 100).toInt()}%'),
              _buildStat('المواظبة', '$streak يوم'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

// ==================== كروت معلومات القبلة ====================

/// كرت معلومات القبلة المتقدم
class QiblaInfoCard extends StatelessWidget {
  final double qiblaDirection;
  final String? locationName;
  final double? accuracy;
  final bool isCalibrated;
  final VoidCallback? onCalibrate;
  final VoidCallback? onTap;

  const QiblaInfoCard({
    super.key,
    required this.qiblaDirection,
    this.locationName,
    this.accuracy,
    this.isCalibrated = false,
    this.onCalibrate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
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
                  angle: qiblaDirection * (3.14159 / 180),
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
                    '${qiblaDirection.toStringAsFixed(0)}°',
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
      ),
    );
  }
}

/// كرت البوصلة المبسط
class SimpleQiblaCard extends StatelessWidget {
  final double direction;
  final VoidCallback? onTap;

  const SimpleQiblaCard({
    super.key,
    required this.direction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: AppTheme.tertiary,
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}

// ==================== كروت الإحصائيات المتقدمة ====================

/// كرت إحصائية التسبيح
class TasbihStatCard extends StatelessWidget {
  final int totalCount;
  final int todayCount;
  final int streakDays;
  final VoidCallback? onTap;

  const TasbihStatCard({
    super.key,
    required this.totalCount,
    required this.todayCount,
    required this.streakDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: AppTheme.secondary,
      onTap: onTap,
      child: Column(
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.fingerprint,
                color: Colors.white,
                size: AppTheme.iconMd,
              ),
              AppTheme.space2.w,
              Text(
                'التسبيح',
                style: AppTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.semiBold,
                ),
              ),
            ],
          ),
          
          AppTheme.space4.h,
          
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('اليوم', todayCount.toString()),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildStat('المجموع', AppTheme.formatLargeNumber(totalCount)),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildStat('الأيام', streakDays.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
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

/// كرت إحصائية الأذكار
class AthkarStatCard extends StatelessWidget {
  final int completedToday;
  final int totalAthkar;
  final double completionRate;
  final VoidCallback? onTap;

  const AthkarStatCard({
    super.key,
    required this.completedToday,
    required this.totalAthkar,
    required this.completionRate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: AppTheme.accent,
      onTap: onTap,
      child: Column(
        children: [
          // العنوان والنسبة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: AppTheme.iconMd,
                  ),
                  AppTheme.space2.w,
                  Text(
                    'الأذكار',
                    style: AppTheme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.semiBold,
                    ),
                  ),
                ],
              ),
              Text(
                '${(completionRate * 100).toInt()}%',
                style: AppTheme.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),
          
          AppTheme.space3.h,
          
          // شريط التقدم
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
          
          AppTheme.space3.h,
          
          // الأرقام
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مكتمل: $completedToday',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
              Text(
                'المجموع: $totalAthkar',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// كرت إحصائية المواظبة
class StreakStatCard extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final int totalDays;
  final VoidCallback? onTap;

  const StreakStatCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: AppTheme.info,
      onTap: onTap,
      child: Column(
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: AppTheme.iconMd,
              ),
              AppTheme.space2.w,
              Text(
                'المواظبة',
                style: AppTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.semiBold,
                ),
              ),
            ],
          ),
          
          AppTheme.space4.h,
          
          // الرقم الرئيسي
          Text(
            currentStreak.toString(),
            style: AppTheme.displayLarge.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.bold,
              fontFamily: AppTheme.numbersFont,
              fontSize: 36,
            ),
          ),
          
          Text(
            'يوم متتالي',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          
          AppTheme.space3.h,
          
          // الإحصائيات الفرعية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSubStat('أفضل سلسلة', bestStreak.toString()),
              _buildSubStat('مجموع الأيام', totalDays.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ==================== كرت ذكر متقدم مع Animation ====================

/// كرت ذكر متقدم مع تأثيرات بصرية
class AdvancedAthkarCard extends StatefulWidget {
  final String content;
  final String? source;
  final String? fadl;
  final int currentCount;
  final int totalCount;
  final Color primaryColor;
  final bool isCompleted;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final VoidCallback? onCopy;
  final VoidCallback? onReset;

  const AdvancedAthkarCard({
    super.key,
    required this.content,
    this.source,
    this.fadl,
    required this.currentCount,
    required this.totalCount,
    required this.primaryColor,
    this.isCompleted = false,
    this.isFavorite = false,
    required this.onTap,
    this.onShare,
    this.onFavorite,
    this.onCopy,
    this.onReset,
  });

  @override
  State<AdvancedAthkarCard> createState() => _AdvancedAthkarCardState();
}

class _AdvancedAthkarCardState extends State<AdvancedAthkarCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AppCard.athkar(
            content: widget.content,
            source: widget.source,
            fadl: widget.fadl,
            currentCount: widget.currentCount,
            totalCount: widget.totalCount,
            primaryColor: widget.primaryColor,
            isCompleted: widget.isCompleted,
            onTap: () {
              HapticFeedback.lightImpact();
              _animationController.forward().then((_) {
                _animationController.reverse();
              });
              widget.onTap();
            },
            actions: [
              if (widget.onFavorite != null)
                CardAction(
                  icon: widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: '',
                  onPressed: widget.onFavorite!,
                  color: widget.isFavorite ? AppTheme.error : AppTheme.textSecondary,
                ),
              
              if (widget.onShare != null)
                CardAction(
                  icon: Icons.share,
                  label: '',
                  onPressed: widget.onShare!,
                  color: AppTheme.textSecondary,
                ),
              
              if (widget.onCopy != null)
                CardAction(
                  icon: Icons.copy,
                  label: '',
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    widget.onCopy!();
                  },
                  color: AppTheme.textSecondary,
                ),
              
              if (widget.isCompleted && widget.onReset != null)
                CardAction(
                  icon: Icons.refresh,
                  label: '',
                  onPressed: widget.onReset!,
                  color: AppTheme.textSecondary,
                ),
            ],
          ),
        );
      },
    );
  }
}