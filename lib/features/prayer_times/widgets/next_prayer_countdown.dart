// lib/features/prayer_times/widgets/next_prayer_countdown.dart (محدث بالنظام الموحد)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // استخدام AppCard من النظام الموحد مع تدرج الصلاة
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      primaryColor: context.getPrayerColor(widget.nextPrayer.type.name),
      gradientColors: [
        context.getPrayerColor(widget.nextPrayer.type.name),
        context.getPrayerColor(widget.nextPrayer.type.name).darken(0.2),
      ],
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // رأس العد التنازلي
        _buildHeader(context),
        
        ThemeConstants.space4.h,
        
        // معلومات الصلاة والوقت
        _buildPrayerInfo(context),
        
        ThemeConstants.space4.h,
        
        // العد التنازلي
        _buildCountdown(context),
        
        ThemeConstants.space4.h,
        
        // شريط التقدم
        _buildProgressBar(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.access_time_filled,
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
              style: context.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
            Text(
              'استعد لأداء الصلاة',
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
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
        // معلومات الصلاة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم الصلاة
              Text(
                widget.nextPrayer.nameAr,
                style: context.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              
              ThemeConstants.space1.h,
              
              // الصلاة الحالية
              if (widget.currentPrayer != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: ThemeConstants.iconXs,
                      ),
                      ThemeConstants.space1.w,
                      Text(
                        'الحالية: ${widget.currentPrayer!.nameAr}',
                        style: context.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        // أيقونة الصلاة
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            context.getPrayerIcon(widget.nextPrayer.type.name),
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
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
    );
  }

  Widget _buildTimeUnit(BuildContext context, String value, String unit) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: context.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ),
        ),
        
        ThemeConstants.space1.h,
        
        Text(
          unit,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Text(
      ':',
      style: context.headlineLarge?.copyWith(
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
              style: context.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            Text(
              '${(_calculateProgress() * 100).toInt()}%',
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
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