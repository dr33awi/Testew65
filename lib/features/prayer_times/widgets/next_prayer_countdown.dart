// lib/features/prayer_times/widgets/next_prayer_countdown.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';

// ✅ استيراد النظام الموحد
import 'package:athkar_app/app/themes/app_theme.dart';

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
    return Container(
      margin: EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.getPrayerColor(widget.nextPrayer.type.name),
            AppTheme.getPrayerColor(widget.nextPrayer.type.name).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getPrayerColor(widget.nextPrayer.type.name).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.space4),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // رأس العد التنازلي
        _buildHeader(),
        
        AppTheme.space4.h,
        
        // معلومات الصلاة والوقت
        _buildPrayerInfo(),
        
        AppTheme.space4.h,
        
        // العد التنازلي
        _buildCountdown(),
        
        AppTheme.space4.h,
        
        // شريط التقدم
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: AppTheme.space2.padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.access_time_filled,
            color: Colors.white,
            size: 24,
          ),
        ),
        
        AppTheme.space3.w,
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الصلاة القادمة',
              style: AppTheme.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'استعد لأداء الصلاة',
              style: AppTheme.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerInfo() {
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
                style: AppTheme.headlineLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              AppTheme.space1.h,
              
              // وقت الصلاة
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: AppTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: AppTheme.radiusFull.radius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    AppTheme.space1.w,
                    Text(
                      '${widget.nextPrayer.time.hour.toString().padLeft(2, '0')}:${widget.nextPrayer.time.minute.toString().padLeft(2, '0')}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // الصلاة الحالية
              if (widget.currentPrayer != null) ...[
                AppTheme.space1.h,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.space3,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                      AppTheme.space1.w,
                      Text(
                        'الحالية: ${widget.currentPrayer!.nameAr}',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // أيقونة الصلاة
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
            _getPrayerIcon(widget.nextPrayer.type.name),
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown() {
    return Container(
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: AppTheme.radiusXl.radius,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
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
              _buildTimeUnit(hours.toString().padLeft(2, '0'), 'ساعة'),
              _buildTimeSeparator(),
              _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'دقيقة'),
              _buildTimeSeparator(),
              _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'ثانية'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeUnit(String value, String unit) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: AppTheme.radiusMd.radius,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: AppTheme.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        AppTheme.space1.h,
        
        Text(
          unit,
          style: AppTheme.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Text(
      ':',
      style: AppTheme.headlineLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم نحو الصلاة',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                final progress = _calculateProgress();
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        
        AppTheme.space2.h,
        
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
        
        AppTheme.space2.h,
        
        // معلومات إضافية
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoChip(
              icon: Icons.access_time,
              label: 'الوقت المتبقي',
              value: _formatRemainingTime(),
            ),
            _buildInfoChip(
              icon: Icons.timeline,
              label: 'المدة الإجمالية',
              value: _formatTotalDuration(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.space2,
        vertical: AppTheme.space1,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: AppTheme.radiusMd.radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white.withOpacity(0.8),
          ),
          AppTheme.space1.w,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return Icons.dark_mode;
      case 'dhuhr':
      case 'الظهر':
        return Icons.light_mode;
      case 'asr':
      case 'العصر':
        return Icons.wb_cloudy;
      case 'maghrib':
      case 'المغرب':
        return Icons.wb_twilight;
      case 'isha':
      case 'العشاء':
        return Icons.bedtime;
      default:
        return Icons.mosque;
    }
  }

  double _calculateProgress() {
    if (widget.currentPrayer == null) return 0.0;
    
    final now = DateTime.now();
    final totalDuration = widget.nextPrayer.time.difference(widget.currentPrayer!.time);
    final elapsed = now.difference(widget.currentPrayer!.time);
    
    if (totalDuration.inSeconds == 0) return 0.0;
    
    return (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }

  String _formatRemainingTime() {
    final duration = widget.nextPrayer.remainingTime;
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    } else {
      return '${minutes}د';
    }
  }

  String _formatTotalDuration() {
    if (widget.currentPrayer == null) return '-';
    
    final totalDuration = widget.nextPrayer.time.difference(widget.currentPrayer!.time);
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    } else {
      return '${minutes}د';
    }
  }
}