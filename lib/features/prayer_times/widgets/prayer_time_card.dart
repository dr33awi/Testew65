// lib/features/prayer_times/widgets/prayer_time_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة
class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayer;
  final Function(bool) onNotificationToggle;
  // إضافة خاصية جديدة للتحكم في إظهار الألوان دائمًا
  final bool forceColored;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.onNotificationToggle,
    this.forceColored = false, // افتراضيًا لا نجبر الألوان
  });

  @override
  Widget build(BuildContext context) {
    final isNext = prayer.isNext;
    final isPassed = prayer.isPassed;
    final gradient = _getGradient(prayer.type);
    
    // تحديد ما إذا كان سيتم عرض الخلفية الملونة
    final useGradient = forceColored || isNext;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: useGradient ? gradient[0].withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showPrayerDetails(context),
          splashColor: useGradient ? Colors.white.withOpacity(0.1) : gradient[0].withOpacity(0.1),
          highlightColor: useGradient ? Colors.white.withOpacity(0.05) : gradient[0].withOpacity(0.05),
          child: Ink(
            decoration: BoxDecoration(
              gradient: useGradient 
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  )
                : null,
              color: !useGradient ? (isPassed ? context.cardColor.darken(0.03) : context.cardColor) : null,
            ),
            child: SizedBox(
              height: 90,
              child: Stack(
                children: [
                  // إضافة نمط للخلفية
                  if (useGradient) Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  
                  if (useGradient) Positioned(
                    left: -20,
                    bottom: -30,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.03),
                      ),
                    ),
                  ),
                  
                  // إضافة مؤشر داخلي للصلاة القادمة
                  if (isNext)
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  
                  // المحتوى الأساسي
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        // الأيقونة والحالة
                        _buildStatusIcon(context, useGradient),
                        
                        const SizedBox(width: 14),
                        
                        // معلومات الصلاة
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prayer.nameAr,
                                style: context.titleMedium?.copyWith(
                                  color: _getTextColor(context, useGradient),
                                  fontWeight: isNext ? ThemeConstants.bold : ThemeConstants.semiBold,
                                ),
                              ),
                              
                              const SizedBox(height: 4),
                              
                              if (isNext)
                                StreamBuilder(
                                  stream: Stream.periodic(const Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    return Text(
                                      prayer.remainingTimeText,
                                      style: context.bodySmall?.copyWith(
                                        color: _getTextColor(context, useGradient).withValues(alpha: 0.8),
                                      ),
                                    );
                                  },
                                )
                              else if (isPassed)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: useGradient ? Colors.white : context.successColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'انتهى الوقت',
                                      style: context.bodySmall?.copyWith(
                                        color: useGradient ? Colors.white.withValues(alpha: 0.8) : context.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  "متبقي " + _formatTime(prayer.time),
                                  style: context.bodySmall?.copyWith(
                                    color: _getTextColor(context, useGradient).withValues(alpha: 0.8),
                                  ),
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
                                color: _getTextColor(context, useGradient),
                                fontWeight: ThemeConstants.bold,
                              ),
                            ),
                            
                            if (prayer.iqamaTime != null)
                              Text(
                                'الإقامة ${_formatTime(prayer.iqamaTime!)}',
                                style: context.bodySmall?.copyWith(
                                  color: _getTextColor(context, useGradient).withValues(alpha: 0.7),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // زر التنبيه
                        _buildNotificationToggle(context, useGradient),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, bool useGradient) {
    IconData icon;
    Color color;
    
    if (prayer.isNext) {
      icon = Icons.access_time_filled;
      color = Colors.white;
    } else if (prayer.isPassed) {
      icon = Icons.check_circle_outline;
      color = useGradient ? Colors.white : context.successColor;
    } else {
      icon = _getPrayerIcon(prayer.type);
      color = useGradient ? Colors.white : _getPrayerTypeColor(prayer.type);
    }
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildNotificationToggle(BuildContext context, bool useGradient) {
    // تم تعديل الدالة لإظهار زر التنبيه دائمًا بغض النظر عن انتهاء وقت الصلاة
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onNotificationToggle(true);
      },
      icon: Icon(
        Icons.notifications_outlined,
        color: _getTextColor(context, useGradient).withValues(alpha: 0.7),
      ),
      tooltip: 'تنبيه الصلاة',
    );
  }

  Color _getTextColor(BuildContext context, bool useGradient) {
    if (useGradient) return Colors.white;
    if (prayer.isPassed) return context.textSecondaryColor;
    return context.textPrimaryColor;
  }

  List<Color> _getGradient(PrayerType type) {
    final baseColor = _getPrayerTypeColor(type);
    return [baseColor, baseColor.darken(0.2)];
  }
  
  Color _getPrayerTypeColor(PrayerType type) {
    return ThemeConstants.getPrayerColor(type.name);
  }

  IconData _getPrayerIcon(PrayerType type) {
    return ThemeConstants.getPrayerIcon(type.name);
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