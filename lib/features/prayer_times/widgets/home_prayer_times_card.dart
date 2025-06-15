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

class _PrayerTimesCardState extends State<PrayerTimesCard> with SingleTickerProviderStateMixin {
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
    
    // الاستماع لتحديثات المواقيت
    _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
        });
        _updateProgressAnimation();
      }
    });
    
    // تحديث المواقيت إذا كان هناك موقع محفوظ
    if (_prayerService.currentLocation != null) {
      _prayerService.updatePrayerTimes();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationSlow,
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

  // حساب الوقت المتبقي للصلاة القادمة
  String _getTimeRemaining(PrayerTime? nextPrayer) {
    if (nextPrayer == null) return '';
    
    final now = DateTime.now();
    final duration = nextPrayer.time.difference(now);
    
    if (duration.isNegative) return 'حان الآن';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours ساعة و $minutes دقيقة';
    } else {
      return '$minutes دقيقة';
    }
  }

  // حساب نسبة التقدم في اليوم
  double _getDayProgress() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    return currentMinutes / 1440; // 1440 دقيقة في اليوم
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
      margin: ThemeConstants.space4.horizontal,
      height: 280,
      child: Card(
        elevation: ThemeConstants.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        child: Center(
          child: AppLoading.circular(size: LoadingSize.medium),
        ),
      ),
    );
  }

  Widget _buildNoLocationCard(BuildContext context) {
    return Container(
      margin: ThemeConstants.space4.horizontal,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.primaryColor.withValues(alpha: ThemeConstants.opacity70),
              context.primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: InkWell(
            onTap: _navigateToPrayerTimes,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_off,
                    color: Colors.white,
                    size: ThemeConstants.iconXl,
                  ),
                ),
                ThemeConstants.space4.h,
                Text(
                  'لم يتم تحديد الموقع',
                  style: context.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
                ThemeConstants.space2.h,
                Text(
                  'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesCard(BuildContext context) {
    final isDark = context.isDarkMode;
    final prayers = _getPrayersForDisplay();
    final nextPrayer = _dailyTimes!.nextPrayer;
    
    return Container(
      margin: ThemeConstants.space4.horizontal,
      constraints: const BoxConstraints(
        minHeight: 280,
        maxHeight: 280,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // الخلفية المتدرجة
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: nextPrayer != null
                      ? [
                          ThemeConstants.getPrayerColor(nextPrayer.type.name).withValues(
                              alpha: isDark ? ThemeConstants.opacity30 : ThemeConstants.opacity20
                          ),
                          ThemeConstants.getPrayerColor(nextPrayer.type.name).darken(0.1).withValues(
                              alpha: isDark ? ThemeConstants.opacity20 : ThemeConstants.opacity10
                          ),
                        ]
                      : [
                          context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                          context.primaryColor.withValues(alpha: ThemeConstants.opacity5),
                        ],
                ),
              ),
            ),
            
            // النمط الدائري في الخلفية
            Positioned(
              right: -80,
              top: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: ThemeConstants.opacity10),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            
            // المحتوى الرئيسي
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _navigateToPrayerTimes,
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                child: Padding(
                  padding: ThemeConstants.space5.all,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // الهيدر
                      SizedBox(
                        height: 50,
                        child: _buildHeader(context, nextPrayer),
                      ),
                      
                      ThemeConstants.space4.h,
                      
                      // بطاقة الصلاة القادمة
                      if (nextPrayer != null) ...[
                        SizedBox(
                          height: 90,
                          child: _buildNextPrayerCard(context, nextPrayer),
                        ),
                        ThemeConstants.space4.h,
                      ],
                      
                      // Timeline للصلوات
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                // خط الزمن
                                Positioned(
                                  top: 16,
                                  left: 20,
                                  right: 20,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: context.dividerColor.withValues(alpha: ThemeConstants.opacity20),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                                
                                // مؤشر التقدم
                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    final progress = _getDayProgress() * _progressAnimation.value;
                                    final maxWidth = constraints.maxWidth - 40;
                                    
                                    return Positioned(
                                      top: 16,
                                      left: 20,
                                      child: Container(
                                        width: maxWidth * progress,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: nextPrayer != null
                                                ? [
                                                    ThemeConstants.getPrayerColor(nextPrayer.type.name),
                                                    ThemeConstants.getPrayerColor(nextPrayer.type.name).darken(0.2),
                                                  ]
                                                : [
                                                    context.primaryColor,
                                                    context.primaryColor.darken(0.2),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(1),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                // الصلوات
                                Padding(
                                  padding: ThemeConstants.space2.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: prayers
                                        .map((prayer) => _buildTimelineItem(
                                              context,
                                              prayer,
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PrayerTime? nextPrayer) {
    final isDark = context.isDarkMode;
    final primaryColor = nextPrayer != null
        ? ThemeConstants.getPrayerColor(nextPrayer.type.name)
        : context.primaryColor;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ThemeConstants.iconPrayer,
                  color: isDark ? Colors.white : primaryColor,
                  size: ThemeConstants.iconMd,
                ),
                ThemeConstants.space2.w,
                Text(
                  'مواقيت الصلاة',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: isDark ? Colors.white : primaryColor,
                  ),
                ),
              ],
            ),
            ThemeConstants.space1.h,
            Row(
              children: [
                if (_dailyTimes!.location.cityName != null) ...[
                  Icon(
                    Icons.location_on,
                    size: ThemeConstants.iconSm,
                    color: (isDark ? Colors.white : primaryColor).withValues(alpha: ThemeConstants.opacity70),
                  ),
                  ThemeConstants.space1.w,
                  Text(
                    _dailyTimes!.location.cityName!,
                    style: context.labelMedium?.copyWith(
                      color: (isDark ? Colors.white : primaryColor).withValues(alpha: ThemeConstants.opacity70),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        // ساعة رقمية
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: ThemeConstants.opacity10),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              final now = DateTime.now();
              return Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: ThemeConstants.iconSm,
                    color: isDark ? Colors.white : primaryColor,
                  ),
                  ThemeConstants.space1.w,
                  Text(
                    '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                    style: context.titleSmall?.copyWith(
                      fontWeight: ThemeConstants.bold,
                      color: isDark ? Colors.white : primaryColor,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCard(BuildContext context, PrayerTime nextPrayer) {
    final gradient = [
      ThemeConstants.getPrayerColor(nextPrayer.type.name),
      ThemeConstants.getPrayerColor(nextPrayer.type.name).darken(0.2),
    ];
    
    return Container(
      padding: ThemeConstants.space4.all,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: ThemeConstants.opacity30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              ThemeConstants.getPrayerIcon(nextPrayer.type.name),
              color: Colors.white,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          ThemeConstants.space4.w,
          
          // المعلومات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصلاة القادمة',
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity70),
                  ),
                ),
                Text(
                  nextPrayer.nameAr,
                  style: context.headlineSmall?.copyWith(
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
                style: context.headlineMedium?.copyWith(
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
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity70),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, PrayerTime prayer) {
    final isDark = context.isDarkMode;
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Flexible(
      flex: 1,
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // النقطة على الخط
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isPassed || isActive
                    ? LinearGradient(
                        colors: [
                          ThemeConstants.getPrayerColor(prayer.type.name),
                          ThemeConstants.getPrayerColor(prayer.type.name).darken(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !isPassed && !isActive
                    ? context.dividerColor.withValues(alpha: ThemeConstants.opacity30)
                    : null,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: ThemeConstants.getPrayerColor(prayer.type.name).withValues(alpha: ThemeConstants.opacity50),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isPassed && !isActive
                    ? Icons.check
                    : ThemeConstants.getPrayerIcon(prayer.type.name),
                color: isPassed || isActive
                    ? Colors.white
                    : context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity50),
                size: ThemeConstants.iconSm,
              ),
            ),
            
            ThemeConstants.space1.h,
            
            // اسم الصلاة
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                prayer.nameAr,
                style: TextStyle(
                  fontSize: ThemeConstants.textSizeXs - 1,
                  color: isActive
                      ? (isDark ? Colors.white : ThemeConstants.getPrayerColor(prayer.type.name))
                      : isPassed
                          ? context.textSecondaryColor
                          : context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity50),
                  fontWeight: isActive ? ThemeConstants.semiBold : null,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ),
            
            ThemeConstants.space1.h,
            
            // الوقت
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatTime(prayer.time),
                style: TextStyle(
                  fontSize: ThemeConstants.textSizeXs - 2,
                  color: isActive
                      ? ThemeConstants.getPrayerColor(prayer.type.name)
                      : isPassed
                          ? context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity70)
                          : context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity50),
                  fontWeight: ThemeConstants.bold,
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
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
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute';
  }
}