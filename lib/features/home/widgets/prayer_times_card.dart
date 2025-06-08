// lib/features/home/presentation/widgets/prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/themes/app_theme.dart';
import '../../../../app/routes/app_router.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard> {
  // Mock prayer times data
  final List<PrayerTime> _prayerTimes = [
    PrayerTime(name: 'الفجر', time: '04:35', isPassed: true),
    PrayerTime(name: 'الظهر', time: '12:15', isPassed: true),
    PrayerTime(name: 'العصر', time: '15:45', isPassed: false, isNext: true),
    PrayerTime(name: 'المغرب', time: '18:30', isPassed: false),
    PrayerTime(name: 'العشاء', time: '20:00', isPassed: false),
  ];

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRouter.prayerTimes);
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = _prayerTimes.firstWhere(
      (prayer) => prayer.isNext,
      orElse: () => _prayerTimes.first,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard(
        type: CardType.info,
        style: CardStyle.elevated,
        onTap: _navigateToPrayerTimes,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.space2),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: context.primaryColor,
                        size: ThemeConstants.iconMd,
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Text(
                      'مواقيت الصلاة',
                      style: context.titleMedium?.semiBold,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ThemeConstants.iconSm,
                  color: context.textSecondaryColor,
                ),
              ],
            ),
            
            ThemeConstants.space4.h,
            
            // Next prayer highlight
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.primaryColor.withOpacity(0.1),
                    context.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                border: Border.all(
                  color: context.primaryColor.withOpacity(0.2),
                  width: ThemeConstants.borderThin,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الصلاة القادمة',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                      ThemeConstants.space1.h,
                      Text(
                        nextPrayer.name,
                        style: context.headlineSmall?.copyWith(
                          color: context.primaryColor,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        nextPrayer.time,
                        style: context.headlineMedium?.copyWith(
                          color: context.primaryColor,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      ThemeConstants.space1.h,
                      Text(
                        'بعد ساعتين',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            ThemeConstants.space3.h,
            
            // Prayer times list
            ...List.generate(
              _prayerTimes.length,
              (index) => _buildPrayerTimeRow(_prayerTimes[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(PrayerTime prayer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: prayer.isPassed
                      ? context.successColor
                      : prayer.isNext
                          ? context.primaryColor
                          : context.dividerColor,
                  shape: BoxShape.circle,
                ),
              ),
              ThemeConstants.space3.w,
              Text(
                prayer.name,
                style: context.bodyLarge?.copyWith(
                  color: prayer.isPassed
                      ? context.textSecondaryColor
                      : prayer.isNext
                          ? context.primaryColor
                          : context.textPrimaryColor,
                  fontWeight: prayer.isNext ? ThemeConstants.semiBold : null,
                ),
              ),
            ],
          ),
          Text(
            prayer.time,
            style: context.bodyLarge?.copyWith(
              color: prayer.isPassed
                  ? context.textSecondaryColor
                  : prayer.isNext
                      ? context.primaryColor
                      : context.textPrimaryColor,
              fontWeight: prayer.isNext ? ThemeConstants.semiBold : null,
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTime {
  final String name;
  final String time;
  final bool isPassed;
  final bool isNext;

  PrayerTime({
    required this.name,
    required this.time,
    this.isPassed = false,
    this.isNext = false,
  });
}