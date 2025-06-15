// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/di/service_locator.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard> with TickerProviderStateMixin {
  late final PrayerTimesService _prayerService;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  DailyPrayerTimes? _dailyTimes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupAnimations();
  }

  void _initializeService() {
    _prayerService = getIt<PrayerTimesService>();
    
    _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
        });
        _updateProgressAnimation();
      }
    });
    
    if (_prayerService.currentLocation != null) {
      _prayerService.updatePrayerTimes();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    ));
  }

  void _updateProgressAnimation() {
    if (_dailyTimes != null) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        color: context.cardColor,
      ),
      child: Center(
        child: AppLoading.circular(),
      ),
    );
  }

  Widget _buildNoLocationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 160,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeConstants.primary.withOpacity(0.9),
              ThemeConstants.primaryDark.withOpacity(0.9),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      color: Colors.white.withOpacity(0.9),
                      size: 40,
                    ),
                    ThemeConstants.space3.h,
                    Text(
                      'لم يتم تحديد الموقع',
                      style: context.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    ThemeConstants.space1.h,
                    Text(
                      'اضغط لتحديد موقعك',
                      style: context.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesCard(BuildContext context) {
    final prayers = _getPrayersForDisplay();
    final nextPrayer = _dailyTimes!.nextPrayer;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: nextPrayer != null
                ? [
                    ThemeConstants.getPrayerColor(nextPrayer.type.toString()).withOpacity(0.9),
                    ThemeConstants.getPrayerColor(nextPrayer.type.toString()).darken(0.15).withOpacity(0.9),
                  ]
                : [
                    ThemeConstants.primary.withOpacity(0.9),
                    ThemeConstants.primaryDark.withOpacity(0.9),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: context.primaryColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: Column(
                  children: [
                    // بطاقة الصلاة القادمة المبسطة
                    if (nextPrayer != null)
                      _buildSimpleNextPrayer(context, nextPrayer),
                    
                    ThemeConstants.space3.h,
                    
                    // Timeline مبسط للصلوات
                    _buildSimpleTimeline(context, prayers),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleNextPrayer(BuildContext context, PrayerTime nextPrayer) {
    return Row(
      children: [
        // الأيقونة
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            ThemeConstants.getPrayerIcon(nextPrayer.type.toString()),
            color: Colors.white,
            size: 28,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        // المعلومات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الصلاة القادمة',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                nextPrayer.nameAr,
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // الوقت
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(nextPrayer.time),
              style: context.headlineSmall?.copyWith(
                fontWeight: ThemeConstants.bold,
                color: Colors.white,
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Text(
                  'بعد ${_getTimeRemaining(nextPrayer)}',
                  style: context.labelSmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimpleTimeline(BuildContext context, List<PrayerTime> prayers) {
    return Container(
      height: 60,
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // خط الزمن
              Positioned(
                top: 30,
                left: 10,
                right: 10,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              
              // مؤشر التقدم
              Positioned(
                top: 30,
                left: 10,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 108) * _getDayProgress() * _progressAnimation.value,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              
              // الصلوات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: prayers.map((prayer) => _buildTimelineItem(context, prayer)).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, PrayerTime prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // النقطة
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isActive ? 24 : 20,
          height: isActive ? 24 : 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isPassed && !isActive
                ? Icons.check
                : ThemeConstants.getPrayerIcon(prayer.type.toString()),
            color: isPassed || isActive
                ? ThemeConstants.getPrayerColor(prayer.type.toString())
                : Colors.white,
            size: isActive ? 14 : 12,
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // الوقت
        Text(
          _formatTime(prayer.time),
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.medium,
          ),
        ),
      ],
    );
  }

  List<PrayerTime> _getPrayersForDisplay() {
    if (_dailyTimes == null) return [];
    
    return _dailyTimes!.prayers.where((prayer) =>
      prayer.type != PrayerType.sunrise &&
      prayer.type != PrayerType.midnight &&
      prayer.type != PrayerType.lastThird
    ).toList();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute';
  }

  String _getTimeRemaining(PrayerTime? nextPrayer) {
    if (nextPrayer == null) return '';
    
    final now = DateTime.now();
    final duration = nextPrayer.time.difference(now);
    
    if (duration.isNegative) return 'حان الآن';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours س $minutes د';
    } else {
      return '$minutes دقيقة';
    }
  }

  double _getDayProgress() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    return currentMinutes / 1440;
  }
}