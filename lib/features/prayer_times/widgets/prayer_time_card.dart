// lib/features/prayer_times/widgets/prayer_time_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة
class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayer;
  final Function(bool) onNotificationToggle;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isNext = prayer.isNext;
    final isPassed = prayer.isPassed;
    final gradient = _getGradient(prayer.type);
    
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isNext 
              ? gradient 
              : isPassed 
                  ? [
                      context.cardColor,
                      context.cardColor.darken(0.05),
                    ]
                  : [
                      context.cardColor,
                      context.cardColor.lighten(0.02),
                    ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNext 
              ? gradient[0].withValues(alpha: 0.3)
              : context.dividerColor.withValues(alpha: 0.2),
          width: isNext ? 2 : 1,
        ),
        boxShadow: isNext 
            ? [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _showPrayerDetails(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Row(
              children: [
                // الأيقونة والحالة
                _buildStatusIcon(context),
                
                ThemeConstants.space4.w,
                
                // معلومات الصلاة
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.nameAr,
                        style: context.titleMedium?.copyWith(
                          color: _getTextColor(context),
                          fontWeight: isNext ? ThemeConstants.bold : ThemeConstants.semiBold,
                        ),
                      ),
                      
                      ThemeConstants.space1.h,
                      
                      if (isNext)
                        Text(
                          prayer.remainingTimeText,
                          style: context.bodySmall?.copyWith(
                            color: _getTextColor(context).withValues(alpha: 0.8),
                          ),
                        )
                      else if (isPassed)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: context.successColor,
                            ),
                            ThemeConstants.space1.w,
                            Text(
                              'انتهى الوقت',
                              style: context.bodySmall?.copyWith(
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                // الوقت
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(prayer.time),
                      style: context.headlineSmall?.copyWith(
                        color: _getTextColor(context),
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    
                    if (prayer.iqamaTime != null)
                      Text(
                        'الإقامة ${_formatTime(prayer.iqamaTime!)}',
                        style: context.bodySmall?.copyWith(
                          color: _getTextColor(context).withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                
                ThemeConstants.space3.w,
                
                // زر التنبيه
                _buildNotificationToggle(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    IconData icon;
    Color color;
    
    if (prayer.isNext) {
      icon = Icons.access_time_filled;
      color = Colors.white;
    } else if (prayer.isPassed) {
      icon = Icons.check_circle_outline;
      color = context.successColor;
    } else {
      icon = _getPrayerIcon(prayer.type);
      color = context.textSecondaryColor;
    }
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: prayer.isNext 
            ? Colors.white.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: prayer.isNext 
              ? Colors.white.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Icon(
        icon,
        color: prayer.isNext ? Colors.white : color,
        size: 24,
      ),
    );
  }

  Widget _buildNotificationToggle(BuildContext context) {
    // لا نعرض زر التنبيه للصلوات التي انتهت أو الشروق
    if (prayer.isPassed || prayer.type == PrayerType.sunrise) {
      return const SizedBox(width: 40);
    }
    
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onNotificationToggle(!prayer.isPassed);
      },
      icon: Icon(
        Icons.notifications_outlined,
        color: _getTextColor(context).withValues(alpha: 0.7),
      ),
      tooltip: 'تنبيه الصلاة',
    );
  }

  Color _getTextColor(BuildContext context) {
    if (prayer.isNext) return Colors.white;
    if (prayer.isPassed) return context.textSecondaryColor;
    return context.textPrimaryColor;
  }

  List<Color> _getGradient(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return [const Color(0xFF4A90E2), const Color(0xFF3A7BD5)];
      case PrayerType.sunrise:
        return [const Color(0xFFFFB347), const Color(0xFFFF8E53)];
      case PrayerType.dhuhr:
        return [const Color(0xFFFFD700), const Color(0xFFFFA000)];
      case PrayerType.asr:
        return [const Color(0xFFFF7043), const Color(0xFFFF5722)];
      case PrayerType.maghrib:
        return [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)];
      case PrayerType.isha:
        return [const Color(0xFF3F51B5), const Color(0xFF303F9F)];
      default:
        return [const Color(0xFF607D8B), const Color(0xFF455A64)];
    }
  }

  IconData _getPrayerIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.brightness_5;
      case PrayerType.sunrise:
        return Icons.wb_sunny;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.wb_twilight;
      case PrayerType.maghrib:
        return Icons.nights_stay;
      case PrayerType.isha:
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  void _showPrayerDetails(BuildContext context) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PrayerDetailsSheet(prayer: prayer),
    );
  }
}

// ===== Prayer Details Sheet =====

class _PrayerDetailsSheet extends StatelessWidget {
  final PrayerTime prayer;

  const _PrayerDetailsSheet({required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: ThemeConstants.space2),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getGradient(prayer.type),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getPrayerIcon(prayer.type),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    
                    ThemeConstants.space4.w,
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prayer.nameAr,
                            style: context.headlineSmall?.semiBold,
                          ),
                          Text(
                            prayer.nameEn,
                            style: context.bodyMedium?.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                ThemeConstants.space5.h,
                
                // Times
                _buildTimeRow(
                  context,
                  title: 'وقت الأذان',
                  time: _formatTime(prayer.time),
                  icon: Icons.campaign,
                ),
                
                if (prayer.iqamaTime != null) ...[
                  ThemeConstants.space3.h,
                  _buildTimeRow(
                    context,
                    title: 'وقت الإقامة',
                    time: _formatTime(prayer.iqamaTime!),
                    icon: Icons.mosque,
                  ),
                ],
                
                ThemeConstants.space5.h,
                
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(
                        text: 'إغلاق',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Expanded(
                      child: AppButton.primary(
                        text: 'الإعدادات',
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/prayer-settings');
                        },
                        icon: Icons.settings,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(
    BuildContext context, {
    required String title,
    required String time,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.primaryColor,
            size: 20,
          ),
          ThemeConstants.space3.w,
          Text(
            title,
            style: context.bodyMedium,
          ),
          const Spacer(),
          Text(
            time,
            style: context.titleMedium?.semiBold,
          ),
        ],
      ),
    );
  }

  List<Color> _getGradient(PrayerType type) {
    // نفس الدالة من PrayerTimeCard
    switch (type) {
      case PrayerType.fajr:
        return [const Color(0xFF4A90E2), const Color(0xFF3A7BD5)];
      case PrayerType.sunrise:
        return [const Color(0xFFFFB347), const Color(0xFFFF8E53)];
      case PrayerType.dhuhr:
        return [const Color(0xFFFFD700), const Color(0xFFFFA000)];
      case PrayerType.asr:
        return [const Color(0xFFFF7043), const Color(0xFFFF5722)];
      case PrayerType.maghrib:
        return [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)];
      case PrayerType.isha:
        return [const Color(0xFF3F51B5), const Color(0xFF303F9F)];
      default:
        return [const Color(0xFF607D8B), const Color(0xFF455A64)];
    }
  }

  IconData _getPrayerIcon(PrayerType type) {
    // نفس الدالة من PrayerTimeCard
    switch (type) {
      case PrayerType.fajr:
        return Icons.brightness_5;
      case PrayerType.sunrise:
        return Icons.wb_sunny;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.wb_twilight;
      case PrayerType.maghrib:
        return Icons.nights_stay;
      case PrayerType.isha:
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
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