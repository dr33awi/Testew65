// lib/features/prayer_times/widgets/next_prayer_countdown.dart - مُصحح نهائياً
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
    return AppContainerBuilder.gradient(
      colors: [
        AppColorSystem.getPrayerColor(widget.nextPrayer.type.name),
        AppColorSystem.getPrayerColor(widget.nextPrayer.type.name).darken(0.2),
      ],
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: ThemeConstants.space4),
          _buildPrayerInfo(context),
          const SizedBox(height: ThemeConstants.space4),
          _buildCountdown(context),
          const SizedBox(height: ThemeConstants.space4),
          _buildProgressBar(context),
        ],
      ),
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
        
        const SizedBox(width: ThemeConstants.space3),
        
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
              
              const SizedBox(height: ThemeConstants.space1),
              
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
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.white,
                        size: ThemeConstants.iconXs,
                      ),
                      const SizedBox(width: ThemeConstants.space1),
                      Text(
                        'الحالية: ${widget.currentPrayer!.nameAr}',
                        style: AppTextStyles.label2.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
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
            AppIconsSystem.getPrayerIcon(widget.nextPrayer.type.name),
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
              style: AppTextStyles.h3.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space1),
        
        Text(
          unit,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
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
                color: Colors.white.withValues(alpha: 0.8),
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
        
        const SizedBox(height: ThemeConstants.space2),
        
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
