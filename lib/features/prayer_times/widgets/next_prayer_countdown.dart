// lib/features/prayer_times/widgets/next_prayer_countdown.dart - النسخة الموحدة

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

class NextPrayerCountdown extends StatefulWidget {
  final PrayerTime nextPrayer;
  final PrayerTime? currentPrayer;

  const NextPrayerCountdown({
    super.key,
    required this.nextPrayer,
    this.currentPrayer,
  });

  @override
  State<NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<NextPrayerCountdown> {

  @override
  Widget build(BuildContext context) {
    // ✅ استخدام AppCard مع تدرج لوني موحد
    return AppCard.custom(
      style: CardStyle.glassmorphism,
      gradientColors: [
        widget.nextPrayer.type.name.themeColor,
        widget.nextPrayer.type.name.themeColor.darken(0.2),
      ],
      child: Column(
        children: [
          _buildHeader(context),
          ThemeConstants.space4.h,
          _buildPrayerInfo(context),
          ThemeConstants.space4.h,
          _buildCountdown(context),
          ThemeConstants.space4.h,
          _buildProgressBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ استخدام النظام الموحد للحاويات
        Container(
          padding: ThemeConstants.space2.all,
          decoration: BoxDecoration(
            color: Colors.white.withOpacitySafe(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            AppIconsSystem.time,
            color: Colors.white,
            size: ThemeConstants.iconMd,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصلاة القادمة',
              style: AppTextStyles.h5.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
            Text(
              'استعد لأداء الصلاة',
              style: AppTextStyles.body2.copyWith(
                color: Colors.white.withOpacitySafe(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerInfo(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nextPrayer.nameAr,
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              
              ThemeConstants.space1.h,
              
              // ✅ استخدام النظام الموحد للمعلومات الإضافية
              if (widget.currentPrayer != null)
                _buildCurrentPrayerInfo(),
            ],
          ),
        ),
        
        // ✅ استخدام النظام الموحد للأيقونات والحاويات
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacitySafe(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacitySafe(0.3),
              width: ThemeConstants.borderMedium,
            ),
          ),
          child: Icon(
            widget.nextPrayer.type.name.themePrayerIcon,
            color: Colors.white,
            size: ThemeConstants.iconXl,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPrayerInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space3,
        vertical: ThemeConstants.space1,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacitySafe(0.2),
        borderRadius: ThemeConstants.radiusFull.circular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            AppIconsSystem.current,
            color: Colors.white,
            size: ThemeConstants.iconXs,
          ),
          ThemeConstants.space1.w,
          Text(
            'الحالية: ${widget.currentPrayer!.nameAr}',
            style: AppTextStyles.label2.copyWith(
              color: Colors.white.withOpacitySafe(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(BuildContext context) {
    // ✅ استخدام AppContainerBuilder للحاوية الموحدة
    return AppContainerBuilder.glassGradient(
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          final duration = widget.nextPrayer.remainingTime;
          final hours = duration.inHours;
          final minutes = duration.inMinutes % 60;
          final seconds = duration.inSeconds % 60;
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(context, hours.toString().padLeft(2, '0'), 'ساعة'),
              _buildTimeSeparator(),
              _buildTimeUnit(context, minutes.toString().padLeft(2, '0'), 'دقيقة'),
              _buildTimeSeparator(),
              _buildTimeUnit(context, seconds.toString().padLeft(2, '0'), 'ثانية'),
            ],
          );
        },
      ),
      padding: ThemeConstants.space4.all,
      borderRadius: ThemeConstants.radiusXl,
    );
  }

  Widget _buildTimeUnit(BuildContext context, String value, String unit) {
    return Column(
      children: [
        // ✅ استخدام النظام الموحد للحاويات
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacitySafe(0.2),
            borderRadius: ThemeConstants.radiusMd.circular,
            border: Border.all(
              color: Colors.white.withOpacitySafe(0.3),
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: AppTextStyles.h3.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ),
        ),
        
        ThemeConstants.space1.h,
        
        Text(
          unit,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacitySafe(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Text(
      ':',
      style: AppTextStyles.h2.copyWith(
        color: Colors.white,
        fontWeight: ThemeConstants.bold,
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم نحو الصلاة',
              style: AppTextStyles.label2.copyWith(
                color: Colors.white.withOpacitySafe(0.8),
              ),
            ),
            Text(
              '${(_calculateProgress() * 100).toInt()}%',
              style: AppTextStyles.label2.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        // ✅ استخدام النظام الموحد لشريط التقدم
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacitySafe(0.2),
            borderRadius: 4.circular,
          ),
          child: ClipRRect(
            borderRadius: 4.circular,
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return LinearProgressIndicator(
                  value: _calculateProgress(),
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double _calculateProgress() {
    if (widget.currentPrayer == null) return 0.0;
    
    final now = DateTime.now();
    final totalDuration = widget.nextPrayer.time.difference(widget.currentPrayer!.time);
    final elapsed = now.difference(widget.currentPrayer!.time);
    
    if (totalDuration.inSeconds == 0) return 0.0;
    
    return (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }
}