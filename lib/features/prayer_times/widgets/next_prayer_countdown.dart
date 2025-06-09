// lib/features/prayer_times/widgets/next_prayer_countdown.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

class NextPrayerCountdown extends StatelessWidget {
  final PrayerTime nextPrayer;
  final PrayerTime? currentPrayer;

  const NextPrayerCountdown({
    super.key,
    required this.nextPrayer,
    this.currentPrayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getPrayerColor(nextPrayer.type),
            _getPrayerColor(nextPrayer.type).darken(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getPrayerColor(nextPrayer.type).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_filled,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              ThemeConstants.space2.w,
              Text(
                'الصلاة القادمة',
                style: context.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ],
          ),
          
          ThemeConstants.space3.h,
          
          // اسم الصلاة والوقت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // اسم الصلاة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextPrayer.nameAr,
                      style: context.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    if (currentPrayer != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        'الصلاة الحالية: ${currentPrayer!.nameAr}',
                        style: context.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // العد التنازلي
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space4,
                  vertical: ThemeConstants.space3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    final duration = nextPrayer.remainingTime;
                    final hours = duration.inHours;
                    final minutes = duration.inMinutes % 60;
                    final seconds = duration.inSeconds % 60;
                    
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTimeUnit(hours.toString().padLeft(2, '0'), 'س'),
                        Text(
                          ':',
                          style: context.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'د'),
                        Text(
                          ':',
                          style: context.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'ث'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          
          ThemeConstants.space3.h,
          
          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return LinearProgressIndicator(
                  value: _calculateProgress(),
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _calculateProgress() {
    if (currentPrayer == null) return 0.0;
    
    final now = DateTime.now();
    final totalDuration = nextPrayer.time.difference(currentPrayer!.time);
    final elapsed = now.difference(currentPrayer!.time);
    
    if (totalDuration.inSeconds == 0) return 0.0;
    
    return (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }
  
  Color _getPrayerColor(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return const Color(0xFF1A237E); // Deep blue
      case PrayerType.sunrise:
        return const Color(0xFFFFB300); // Amber
      case PrayerType.dhuhr:
        return const Color(0xFFFF6F00); // Orange
      case PrayerType.asr:
        return const Color(0xFF00897B); // Teal
      case PrayerType.maghrib:
        return const Color(0xFFE65100); // Deep orange
      case PrayerType.isha:
        return const Color(0xFF4A148C); // Purple
      default:
        return const Color(0xFF607D8B); // Blue grey
    }
  }
}