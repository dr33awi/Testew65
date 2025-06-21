// lib/features/prayer_times/widgets/prayer_calendar_strip.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class PrayerCalendarStrip extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const PrayerCalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<PrayerCalendarStrip> createState() => _PrayerCalendarStripState();
}

class _PrayerCalendarStripState extends State<PrayerCalendarStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    );
    _pageController = PageController(viewportFraction: 0.2);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(14, (index) {
      return today.add(Duration(days: index - 7));
    });
    
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.05),
            ThemeConstants.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
            child: Column(
              children: [
                // رأس التقويم
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space4,
                    vertical: ThemeConstants.space3,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ThemeConstants.primary.withValues(alpha: 0.1),
                        ThemeConstants.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(ThemeConstants.radius2xl),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(ThemeConstants.space2),
                        decoration: BoxDecoration(
                          color: ThemeConstants.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: ThemeConstants.primary,
                          size: ThemeConstants.iconMd,
                        ),
                      ),
                      ThemeConstants.space3.w,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التقويم الهجري',
                              style: context.titleMedium?.copyWith(
                                fontWeight: ThemeConstants.semiBold,
                              ),
                            ),
                            Text(
                              'اختر التاريخ لعرض مواقيت الصلاة',
                              style: context.bodySmall?.copyWith(
                                color: context.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // شريط التواريخ
                Expanded(
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _slideAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(_slideAnimation),
                          child: ListView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space3,
                              vertical: ThemeConstants.space2,
                            ),
                            itemCount: dates.length,
                            itemBuilder: (context, index) {
                              final date = dates[index];
                              final isSelected = _isSameDay(date, widget.selectedDate);
                              final isToday = _isSameDay(date, today);
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: ThemeConstants.space1,
                                ),
                                child: _buildDateItem(
                                  context,
                                  date: date,
                                  isSelected: isSelected,
                                  isToday: isToday,
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    widget.onDateChanged(date);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
    
    return AnimatedPress(
      onTap: onTap,
      scaleFactor: 0.95,
      child: AnimatedContainer(
        duration: ThemeConstants.durationNormal,
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
        decoration: BoxDecoration(
          gradient: isSelected
              ? ThemeConstants.primaryGradient
              : isToday
                  ? LinearGradient(
                      colors: [
                        ThemeConstants.primary.withValues(alpha: 0.1),
                        ThemeConstants.primary.withValues(alpha: 0.05),
                      ],
                    )
                  : null,
          color: !isSelected && !isToday ? context.cardColor : null,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          border: Border.all(
            color: isSelected
                ? ThemeConstants.primary.withValues(alpha: 0.3)
                : isToday
                    ? ThemeConstants.primary.withValues(alpha: 0.2)
                    : context.dividerColor.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: ThemeConstants.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ] : isToday ? [
            BoxShadow(
              color: ThemeConstants.primary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اسم اليوم
            Text(
              dayName,
              style: context.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? ThemeConstants.primary
                        : context.textSecondaryColor,
                fontWeight: isSelected || isToday
                    ? ThemeConstants.semiBold
                    : ThemeConstants.regular,
                fontSize: 11,
              ),
            ),
            
            ThemeConstants.space1.h,
            
            // رقم اليوم
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  dayNumber,
                  style: context.titleLarge?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? ThemeConstants.primary
                            : context.textPrimaryColor,
                    fontWeight: ThemeConstants.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            
            // اسم الشهر
            Text(
              monthName,
              style: context.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : isToday
                        ? ThemeConstants.primary.withValues(alpha: 0.8)
                        : context.textSecondaryColor,
                fontSize: 10,
              ),
            ),
          ],
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