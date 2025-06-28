// lib/features/prayer_times/widgets/prayer_time_card.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';

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

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
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
    
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildCard(useGradient, isPassed),
          );
        },
      ),
    );
  }

  Widget _buildCard(bool useGradient, bool isPassed) {
    // استخدام AppCard من النظام الموحد
    return AnimatedPress(
      onTap: _handleCardTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.space3),
        decoration: BoxDecoration(
          color: useGradient ? null : AppTheme.card,
          gradient: useGradient ? LinearGradient(
            colors: [
              AppTheme.getPrayerColor(widget.prayer.type.name),
              AppTheme.getPrayerColor(widget.prayer.type.name).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: [
            BoxShadow(
              color: useGradient 
                ? AppTheme.getPrayerColor(widget.prayer.type.name).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space4),
          child: _buildCardContent(useGradient, isPassed),
        ),
      ),
    );
  }

  Widget _buildCardContent(bool useGradient, bool isPassed) {
    return Row(
      children: [
        _buildStatusIcon(useGradient, isPassed),
        
        AppTheme.space4.w,
        
        Expanded(
          child: _buildPrayerInfo(useGradient, isPassed),
        ),
        
        AppTheme.space4.w,
        
        _buildTimeSection(useGradient),
      ],
    );
  }

  Widget _buildStatusIcon(bool useGradient, bool isPassed) {
    final iconData = _getStatusIcon(isPassed);
    final iconColor = _getIconColor(useGradient, isPassed);
    
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withValues(alpha: 0.25)
            : iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.4)
              : iconColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: useGradient ? 0.3 : 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: 24,
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
      return _getPrayerIcon(widget.prayer.nameAr);
    }
  }

  Color _getIconColor(bool useGradient, bool isPassed) {
    if (useGradient) {
      return Colors.white;
    }
    
    if (widget.prayer.isNext) {
      return AppTheme.getPrayerColor(widget.prayer.type.name);
    } else if (isPassed) {
      return AppTheme.primary;
    } else {
      return AppTheme.getPrayerColor(widget.prayer.type.name);
    }
  }

  Widget _buildPrayerInfo(bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.prayer.nameAr,
          style: AppTheme.titleLarge.copyWith(
            color: _getTextColor(useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? FontWeight.bold 
                : FontWeight.w600,
            shadows: useGradient ? [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ] : null,
          ),
        ),
        
        AppTheme.space2.h,
        
        Text(
          widget.prayer.nameEn,
          style: AppTheme.bodySmall.copyWith(
            color: _getTextColor(useGradient, isPassed).withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(bool useGradient) {
    final baseColor = AppTheme.getPrayerColor(widget.prayer.type.name);
    
    return Container(
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: useGradient 
              ? [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.15),
                ]
              : [
                  baseColor.withValues(alpha: 0.15),
                  baseColor.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : baseColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (useGradient ? Colors.white : baseColor).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _formatTime(widget.prayer.time),
            style: AppTheme.headlineMedium.copyWith(
              color: useGradient ? Colors.white : baseColor,
              fontWeight: FontWeight.bold,
              shadows: useGradient ? [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
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
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: AppTheme.bodySmall.copyWith(
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleCardTap() {
    HapticFeedback.lightImpact();
    // يمكن إضافة وظائف إضافية هنا مثل إظهار تفاصيل الصلاة
  }

  Color _getTextColor(bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return AppTheme.textSecondary;
    return AppTheme.textPrimary;
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return Icons.dark_mode;
      case 'الظهر':
      case 'dhuhr':
        return Icons.light_mode;
      case 'العصر':
      case 'asr':
        return Icons.wb_cloudy;
      case 'المغرب':
      case 'maghrib':
        return Icons.wb_twilight;
      case 'العشاء':
      case 'isha':
        return Icons.bedtime;
      default:
        return Icons.mosque;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}