// lib/features/home/widgets/prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/di/service_locator.dart';
import '../../prayer_times/services/prayer_times_service.dart';
import '../../prayer_times/models/prayer_time_model.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard> {
  late final PrayerTimesService _prayerService;
  DailyPrayerTimes? _dailyTimes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() {
    _prayerService = getIt<PrayerTimesService>();
    
    // الاستماع لتحديثات المواقيت
    _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
        });
      }
    });
    
    // تحديث المواقيت إذا كان هناك موقع محفوظ
    if (_prayerService.currentLocation != null) {
      _prayerService.updatePrayerTimes();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRouter.prayerTimes);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard(context);
    }
    
    if (_dailyTimes == null) {
      return _buildNoLocationCard(context);
    }
    
    return _buildPrayerTimesCard(context);
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard(
        type: CardType.normal,
        style: CardStyle.elevated,
        child: Container(
          height: 200,
          child: Center(
            child: AppLoading.circular(size: LoadingSize.medium),
          ),
        ),
      ),
    );
  }

  Widget _buildNoLocationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard(
        type: CardType.info,
        style: CardStyle.elevated,
        onTap: _navigateToPrayerTimes,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    Icons.location_off,
                    color: context.primaryColor,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                ThemeConstants.space3.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مواقيت الصلاة',
                        style: context.titleMedium?.semiBold,
                      ),
                      Text(
                        'اضغط لتحديد موقعك',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ThemeConstants.iconSm,
                  color: context.textSecondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesCard(BuildContext context) {
    final nextPrayer = _dailyTimes!.nextPrayer;
    final prayers = _dailyTimes!.prayers.where((p) => 
      p.type != PrayerType.sunrise && 
      p.type != PrayerType.midnight && 
      p.type != PrayerType.lastThird
    ).toList();

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
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.mosque,
                        color: context.primaryColor,
                        size: ThemeConstants.iconMd,
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مواقيت الصلاة',
                          style: context.titleMedium?.semiBold,
                        ),
                        if (_dailyTimes!.location.cityName != null)
                          Text(
                            _dailyTimes!.location.cityName!,
                            style: context.bodySmall?.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                      ],
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
            if (nextPrayer != null)
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor.withValues(alpha: 0.1),
                      context.primaryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.primaryColor.withValues(alpha: 0.2),
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
                          nextPrayer.nameAr,
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
                          _formatTime(nextPrayer.time),
                          style: context.headlineMedium?.copyWith(
                            color: context.primaryColor,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        ThemeConstants.space1.h,
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Text(
                              nextPrayer.remainingTimeText,
                              style: context.bodySmall?.copyWith(
                                color: context.textSecondaryColor,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            ThemeConstants.space3.h,
            
            // Prayer times list
            ...prayers.map((prayer) => _buildPrayerTimeRow(context, prayer)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(BuildContext context, PrayerTime prayer) {
    final isNext = prayer.isNext;
    final isPassed = prayer.isPassed;
    
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
                  color: isPassed
                      ? context.successColor
                      : isNext
                          ? context.primaryColor
                          : context.dividerColor,
                  shape: BoxShape.circle,
                ),
              ),
              ThemeConstants.space3.w,
              Text(
                prayer.nameAr,
                style: context.bodyLarge?.copyWith(
                  color: isPassed
                      ? context.textSecondaryColor
                      : isNext
                          ? context.primaryColor
                          : context.textPrimaryColor,
                  fontWeight: isNext ? ThemeConstants.semiBold : null,
                ),
              ),
            ],
          ),
          Text(
            _formatTime(prayer.time),
            style: context.bodyLarge?.copyWith(
              color: isPassed
                  ? context.textSecondaryColor
                  : isNext
                      ? context.primaryColor
                      : context.textPrimaryColor,
              fontWeight: isNext ? ThemeConstants.semiBold : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}