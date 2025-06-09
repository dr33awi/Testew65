// lib/features/prayer_times/widgets/prayer_calendar_strip.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class PrayerCalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const PrayerCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(7, (index) {
      return today.add(Duration(days: index - 3));
    });
    
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space2,
        ),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);
          final isToday = _isSameDay(date, today);
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
            child: _buildDateItem(
              context,
              date: date,
              isSelected: isSelected,
              isToday: isToday,
              onTap: () => onDateChanged(date),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateItem(
    BuildContext context, {
    required DateTime date,
    required bool isSelected,
    required bool isToday,
    required VoidCallback onTap,
  }) {
    final dayName = _getDayName(date);
    final dayNumber = date.day.toString();
    final monthName = _getMonthName(date.month);
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 65,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space2,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? context.primaryColor
                : isToday
                    ? context.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor
                  : isToday
                      ? context.primaryColor.withValues(alpha: 0.3)
                      : context.dividerColor.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayName,
                style: context.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? context.primaryColor
                          : context.textSecondaryColor,
                  fontWeight: isSelected || isToday
                      ? ThemeConstants.semiBold
                      : ThemeConstants.regular,
                ),
              ),
              ThemeConstants.space1.h,
              Text(
                dayNumber,
                style: context.titleLarge?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? context.primaryColor
                          : context.textPrimaryColor,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                monthName,
                style: context.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.8)
                      : context.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDayName(DateTime date) {
    const days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return days[date.weekday % 7];
  }

  String _getMonthName(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return months[month - 1];
  }
}