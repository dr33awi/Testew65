// lib/features/prayer_times/widgets/prayer_time_card.dart (محدث بالنظام الموحد)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة المحسنة باستخدام النظام الموحد
class PrayerTimeCard extends StatefulWidget {
  final PrayerTime prayer;
  final Function(bool) onNotificationToggle;
  final bool forceColored;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.onNotificationToggle,
    this.forceColored = false,
  });

  @override
  State<PrayerTimeCard> createState() => _PrayerTimeCardState();
}

class _PrayerTimeCardState extends State<PrayerTimeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNext = widget.prayer.isNext;
    final isPassed = widget.prayer.isPassed;
    final useGradient = widget.forceColored || isNext;
    final prayerColor = AppTheme.getPrayerColor(widget.prayer.nameAr);
    
    return RepaintBoundary(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildCard(context, useGradient, isPassed, prayerColor),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool useGradient, bool isPassed, Color prayerColor) {
    return AnimatedPress(
      onTap: _handleCardTap,
      child: AppCard(
        useGradient: useGradient,
        color: useGradient ? prayerColor : null,
        margin: const EdgeInsets.only(bottom: AppTheme.space3),
        child: _buildCardContent(context, useGradient, isPassed, prayerColor),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool useGradient, bool isPassed, Color prayerColor) {
    return Row(
      children: [
        _buildStatusIcon(context, useGradient, isPassed, prayerColor),
        
        AppTheme.space4.w,
        
        Expanded(
          child: _buildPrayerInfo(context, useGradient, isPassed),
        ),
        
        AppTheme.space4.w,
        
        _buildTimeSection(context, useGradient, prayerColor),
        
        AppTheme.space3.w,
        
        _buildNotificationToggle(context, useGradient, prayerColor),
      ],
    );
  }

  Widget _buildStatusIcon(BuildContext context, bool useGradient, bool isPassed, Color prayerColor) {
    final iconData = _getStatusIcon(isPassed);
    final iconColor = _getIconColor(context, useGradient, isPassed, prayerColor);
    
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: useGradient ? LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.1),
          ],
        ) : null,
        color: !useGradient ? iconColor.withValues(alpha: 0.1) : null,
        borderRadius: AppTheme.radiusXl.radius,
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.4)
              : iconColor.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: useGradient ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: AppTheme.iconLg,
        ),
      ),
    );
  }

  IconData _getStatusIcon(bool isPassed) {
    if (widget.prayer.isNext) {
      return Icons.schedule_rounded;
    } else if (isPassed) {
      return Icons.check_circle_rounded;
    } else {
      return Icons.mosque;
    }
  }

  Color _getIconColor(BuildContext context, bool useGradient, bool isPassed, Color prayerColor) {
    if (useGradient) {
      return Colors.white;
    }
    
    if (widget.prayer.isNext) {
      return prayerColor;
    } else if (isPassed) {
      return AppTheme.success;
    } else {
      return prayerColor;
    }
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.prayer.nameAr,
          style: AppTheme.titleLarge.copyWith(
            color: _getTextColor(context, useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? AppTheme.bold 
                : AppTheme.semiBold,
            shadows: useGradient ? [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ] : null,
          ),
        ),
        
        AppTheme.space1.h,
        
        Text(
          widget.prayer.nameEn,
          style: AppTheme.bodySmall.copyWith(
            color: _getTextColor(context, useGradient, isPassed).withValues(alpha: 0.8),
            fontWeight: AppTheme.medium,
          ),
        ),
        
        // معلومات إضافية
        if (widget.prayer.isNext) ...[
          AppTheme.space1.h,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space2,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: useGradient 
                  ? Colors.black.withValues(alpha: 0.2)
                  : AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: AppTheme.iconSm,
                  color: Colors.white,
                ),
                SizedBox(width: AppTheme.space1),
                Text(
                  'قادمة',
                  style: AppTheme.caption,
                ),
              ],
            ),
          ),
        ] else if (isPassed) ...[
          AppTheme.space1.h,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space2,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  size: AppTheme.iconSm,
                  color: AppTheme.success,
                ),
                SizedBox(width: AppTheme.space1),
                Text(
                  'انتهى',
                  style: AppTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context, bool useGradient, Color prayerColor) {
    return Container(
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        gradient: useGradient ? LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.25),
            Colors.white.withValues(alpha: 0.15),
          ],
        ) : null,
        color: !useGradient ? prayerColor.withValues(alpha: 0.1) : null,
        borderRadius: AppTheme.radiusLg.radius,
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : prayerColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _formatTime(widget.prayer.time),
            style: AppTheme.titleLarge.copyWith(
              color: useGradient ? Colors.white : prayerColor,
              fontWeight: AppTheme.bold,
              shadows: useGradient ? [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ] : null,
            ),
          ),
          
          if (widget.prayer.iqamaTime != null) ...[
            AppTheme.space1.h,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space2,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.black.withValues(alpha: 0.2)
                    : AppTheme.surface,
                borderRadius: AppTheme.radiusSm.radius,
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: AppTheme.bodySmall.copyWith(
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppTheme.textSecondary,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(BuildContext context, bool useGradient, Color prayerColor) {
    // هذا مجرد مؤشر للتنبيه - يمكن إضافة وظائف أكثر لاحقاً
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        // يمكن إضافة toggle للتنبيه هنا
        widget.onNotificationToggle(true);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.2)
              : prayerColor.withValues(alpha: 0.1),
          borderRadius: AppTheme.radiusMd.radius,
          border: Border.all(
            color: useGradient 
                ? Colors.white.withValues(alpha: 0.3)
                : prayerColor.withValues(alpha: 0.2),
          ),
        ),
        child: const Icon(
          Icons.notifications_active,
          color: Colors.white,
          size: AppTheme.iconSm,
        ),
      ),
    );
  }

  void _handleCardTap() {
    HapticFeedback.lightImpact();
    // يمكن إضافة وظائف إضافية هنا مثل إظهار تفاصيل الصلاة
  }

  Color _getTextColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return AppTheme.textSecondary;
    return AppTheme.textPrimary;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}