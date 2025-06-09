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
    
    return AppCard(
      style: isNext ? CardStyle.gradient : CardStyle.normal,
      gradientColors: isNext ? gradient : null,
      backgroundColor: isPassed ? context.cardColor.darken(0.03) : null,
      elevation: isNext ? ThemeConstants.elevation4 : ThemeConstants.elevation1,
      showShadow: isNext,
      onTap: () => _showPrayerDetails(context),
      child: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space3),
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
                            color: isNext ? Colors.white : context.successColor,
                          ),
                          ThemeConstants.space1.w,
                          Text(
                            'انتهى الوقت',
                            style: context.bodySmall?.copyWith(
                              color: isNext ? Colors.white.withOpacity(0.8) : context.textSecondaryColor,
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
    // لا نعرض زر التنبيه للصلوات التي انتهت
    if (prayer.isPassed) {
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
    final baseColor = _getPrayerTypeColor(type);
    return [baseColor, baseColor.darken(0.2)];
  }
  
  Color _getPrayerTypeColor(PrayerType type) {
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

  IconData _getPrayerIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.dark_mode;
      case PrayerType.sunrise:
        return Icons.wb_sunny;
      case PrayerType.dhuhr:
        return Icons.light_mode;
      case PrayerType.asr:
        return Icons.wb_cloudy;
      case PrayerType.maghrib:
        return Icons.wb_twilight;
      case PrayerType.isha:
        return Icons.bedtime;
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
    
    AppInfoDialog.show(
      context: context,
      title: prayer.nameAr,
      content: 'وقت ${prayer.nameAr}: ${_formatTime(prayer.time)}',
      subtitle: prayer.isPassed ? 'انتهى وقت الصلاة' : prayer.remainingTimeText,
      icon: _getPrayerIcon(prayer.type),
      accentColor: _getGradient(prayer.type)[0],
      actions: [
        DialogAction(
          label: 'إعدادات الصلاة',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/prayer-settings');
          },
          isPrimary: true,
        ),
      ],
    );
  }
}