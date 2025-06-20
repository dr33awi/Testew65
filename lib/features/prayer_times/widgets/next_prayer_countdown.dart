// lib/features/prayer_times/widgets/next_prayer_countdown.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/index.dart';
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
    final prayerColor = ThemeConstants.getPrayerColor(widget.nextPrayer.nameAr);
    
    return IslamicCard.gradient(
      gradient: ThemeConstants.getPrayerGradient(widget.nextPrayer.nameAr),
      margin: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: _buildContent(context, prayerColor),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color prayerColor) {
    return Column(
      children: [
        _buildHeader(context),
        Spaces.medium,
        _buildPrayerInfo(context, prayerColor),
        Spaces.medium,
        _buildCountdown(context),
        Spaces.medium,
        _buildProgressBar(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.spaceSm),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.access_time_filled,
            color: Colors.white,
            size: ThemeConstants.iconMd,
          ),
        ),
        Spaces.mediumH,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصلاة القادمة',
              style: context.titleStyle.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
            Text(
              'استعد لأداء الصلاة',
              style: context.captionStyle.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerInfo(BuildContext context, Color prayerColor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nextPrayer.nameAr,
                style: context.headingStyle.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              Spaces.xs,
              if (widget.currentPrayer != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.spaceMd,
                    vertical: ThemeConstants.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        color: Colors.white.withOpacity(0.8),
                        size: ThemeConstants.iconXs,
                      ),
                      Spaces.smallH,
                      Text(
                        'الحالية: ${widget.currentPrayer!.nameAr}',
                        style: context.captionStyle.copyWith(
                          color: Colors.white.withOpacity(0.8),
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
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            ThemeConstants.getPrayerIcon(widget.nextPrayer.nameAr),
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown(BuildContext context) {
    return IslamicCard.simple(
      color: Colors.white.withOpacity(0.15),
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
              _buildTimeSeparator(context),
              _buildTimeUnit(context, minutes.toString().padLeft(2, '0'), 'دقيقة'),
              _buildTimeSeparator(context),
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
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: context.titleStyle.copyWith(
                color: Colors.white,
                fontSize: 24,
                fontWeight: ThemeConstants.fontBold,
              ),
            ),
          ),
        ),
        Spaces.xs,
        Text(
          unit,
          style: context.captionStyle.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator(BuildContext context) {
    return Text(
      ':',
      style: context.headingStyle.copyWith(
        color: Colors.white,
        fontWeight: ThemeConstants.fontBold,
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
              style: context.captionStyle.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Text(
              '${(_calculateProgress() * 100).toInt()}%',
              style: context.captionStyle.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
          ],
        ),
        Spaces.small,
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
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