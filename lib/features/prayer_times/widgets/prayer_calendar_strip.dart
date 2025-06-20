// lib/features/prayer_times/widgets/prayer_calendar_strip.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/index.dart';

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
      margin: const EdgeInsets.symmetric(vertical: ThemeConstants.spaceSm),
      child: IslamicCard.simple(
        color: context.primaryColor.withAlpha(13),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                // رأس التقويم
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.spaceMd,
                    vertical: ThemeConstants.spaceMd,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.primaryColor.withAlpha(26),
                        context.primaryColor.withAlpha(13),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(ThemeConstants.radiusXl),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: context.primaryColor,
                          size: ThemeConstants.iconMd,
                        ),
                      ),
                      const HSpace(ThemeConstants.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التقويم الهجري',
                              style: context.titleStyle.copyWith(
                                fontWeight: ThemeConstants.fontSemiBold,
                              ),
                            ),
                            Text(
                              'اختر التاريخ لعرض مواقيت الصلاة',
                              style: context.captionStyle,
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
                              horizontal: ThemeConstants.spaceMd,
                              vertical: ThemeConstants.spaceSm,
                            ),
                            itemCount: dates.length,
                            itemBuilder: (context, index) {
                              final date = dates[index];
                              final isSelected = _isSameDay(date, widget.selectedDate);
                              final isToday = _isSameDay(date, today);
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: ThemeConstants.spaceXs,
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
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ThemeConstants.durationNormal,
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceXs),
        decoration: BoxDecoration(
          gradient: isSelected
              ? ThemeConstants.primaryGradient
              : isToday
                  ? LinearGradient(
                      colors: [
                        context.primaryColor.withAlpha(26),
                        context.primaryColor.withAlpha(13),
                      ],
                    )
                  : null,
          color: !isSelected && !isToday ? context.cardColor : null,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          border: Border.all(
            color: isSelected
                ? context.primaryColor.withAlpha(77)
                : isToday
                    ? context.primaryColor.withAlpha(51)
                    : context.borderColor.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
              ? ThemeConstants.shadowLg
              : isToday 
                  ? ThemeConstants.shadowSm 
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: context.captionStyle.copyWith(
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? context.primaryColor
                        : context.secondaryTextColor,
                fontWeight: isSelected || isToday
                    ? ThemeConstants.fontSemiBold
                    : ThemeConstants.fontRegular,
                fontSize: 11,
              ),
            ),
            const VSpace(ThemeConstants.spaceXs),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withAlpha(51)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  dayNumber,
                  style: context.titleStyle.copyWith(
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? context.primaryColor
                            : context.textColor,
                    fontWeight: ThemeConstants.fontBold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Text(
              monthName,
              style: context.captionStyle.copyWith(
                color: isSelected
                    ? Colors.white.withAlpha(204)
                    : isToday
                        ? context.primaryColor.withAlpha(204)
                        : context.secondaryTextColor,
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