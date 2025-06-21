// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:async';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late PrayerTimesService _prayerService;

  // State
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  PrayerLocation? _location;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Subscriptions
  StreamSubscription<DailyPrayerTimes>? _timesSubscription;
  StreamSubscription<PrayerTime?>? _nextPrayerSubscription;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeService();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: ThemeConstants.curveSmooth,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
  }

  void _initializeService() {
    try {
      _prayerService = getIt<PrayerTimesService>();
      
      // الاستماع للتحديثات
      _timesSubscription = _prayerService.prayerTimesStream.listen(
        (times) {
          if (mounted) {
            setState(() {
              _dailyTimes = times;
              _location = times.location;
              _isLoading = false;
              _errorMessage = null;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'فشل في تحميل مواقيت الصلاة';
              _isLoading = false;
            });
          }
        },
      );
      
      _nextPrayerSubscription = _prayerService.nextPrayerStream.listen(
        (prayer) {
          if (mounted) {
            setState(() {
              _nextPrayer = prayer;
            });
          }
        },
      );
      
      // تحميل البيانات الأولية
      _loadInitialData();
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في تهيئة خدمة مواقيت الصلاة';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadInitialData() async {
    try {
      // محاولة تحميل البيانات المحفوظة أولاً
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null && mounted) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _location = cachedTimes.location;
          _isLoading = false;
        });
      }
      
      // تحديث البيانات في الخلفية
      if (_prayerService.currentLocation == null) {
        await _prayerService.getCurrentLocation();
      }
      await _prayerService.updatePrayerTimes();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل مواقيت الصلاة';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null && _dailyTimes == null) {
      return _buildErrorState();
    }

    if (_dailyTimes == null) {
      return _buildEmptyState();
    }

    final nextPrayer = _nextPrayer ?? _dailyTimes!.nextPrayer;
    if (nextPrayer == null) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: _getPrayerGradient(nextPrayer.nameAr),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Column(
                  children: [
                    // رأس البطاقة
                    _buildHeader(context, nextPrayer),
                    
                    ThemeConstants.space3.h,
                    
                    // الصلاة القادمة
                    _buildNextPrayerSection(context, nextPrayer),
                    
                    ThemeConstants.space4.h,
                    
                    // خط زمني للصلوات
                    _buildPrayerTimeline(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        color: context.cardColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
            ThemeConstants.space3.h,
            Text(
              'جاري تحميل مواقيت الصلاة...',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        color: context.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _loadInitialData,
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.errorColor,
                ),
                ThemeConstants.space3.h,
                Text(
                  _errorMessage ?? 'خطأ في تحميل المواقيت',
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                ThemeConstants.space3.h,
                Text(
                  'اضغط للمحاولة مرة أخرى',
                  style: context.bodySmall?.copyWith(
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        color: context.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _loadInitialData,
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 48,
                  color: context.textSecondaryColor,
                ),
                ThemeConstants.space3.h,
                Text(
                  'لم يتم تحديد الموقع',
                  style: context.titleMedium?.semiBold,
                ),
                ThemeConstants.space2.h,
                Text(
                  'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
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

  Widget _buildHeader(BuildContext context, PrayerTime nextPrayer) {
    return Row(
      children: [
        // أيقونة المسجد
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            Icons.mosque,
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
                'مواقيت الصلاة',
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                _location?.displayName ?? 'جاري تحديد الموقع...',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerSection(BuildContext context, PrayerTime nextPrayer) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // عنوان الصلاة القادمة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space2.w,
              Text(
                'الصلاة القادمة',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          
          ThemeConstants.space2.h,
          
          // اسم الصلاة والوقت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextPrayer.nameAr,
                    style: context.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  Text(
                    _getNextPrayerMessage(nextPrayer.nameAr),
                    style: context.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              
              // الوقت مع تأثير النبض
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.05),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        _formatTime(nextPrayer.time),
                        style: context.titleMedium?.copyWith(
                          color: _getPrayerColor(nextPrayer.nameAr),
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          
          ThemeConstants.space2.h,
          
          // الوقت المتبقي
          _buildTimeRemaining(context, nextPrayer),
        ],
      ),
    );
  }

  Widget _buildTimeRemaining(BuildContext context, PrayerTime nextPrayer) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final remainingTime = nextPrayer.remainingTimeText;
        
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Colors.white.withValues(alpha: 0.8),
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space1.w,
              Text(
                remainingTime,
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerTimeline(BuildContext context) {
    if (_dailyTimes == null) return const SizedBox.shrink();
    
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            // عنوان التايم لاين
            Row(
              children: [
                Icon(
                  Icons.timeline_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: ThemeConstants.iconSm,
                ),
                ThemeConstants.space2.w,
                Text(
                  'جدول اليوم',
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            
            ThemeConstants.space3.h,
            
            // التايم لاين
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  // الخط الأساسي خلف الأيقونات (غير مكتمل)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  
                  // خط التقدم التدريجي
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: _calculateProgressWidth(context, mainPrayers),
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // نقاط الصلوات فوق الخط
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: mainPrayers.map((prayer) => 
                      _buildTimelinePoint(context, prayer)
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimelinePoint(BuildContext context, PrayerTime prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      children: [
        // النقطة (الأيقونة)
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isActive ? 32 : 28,
          height: isActive ? 32 : 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isPassed && !isActive ? Icons.check : _getPrayerIcon(prayer.nameAr),
              color: isPassed || isActive ? _getPrayerColor(prayer.nameAr) : Colors.white,
              size: isActive ? 18 : 16,
            ),
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // اسم الصلاة
        Text(
          prayer.nameAr,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            fontSize: 11,
          ),
        ),
        
        // الوقت
        Text(
          _formatTime(prayer.time),
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.9 : 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (context.mounted) {
        context.showInfoSnackBar('هذه الميزة قيد التطوير');
      }
      return null;
    });
  }

  // دوال مساعدة
  LinearGradient _getPrayerGradient(String prayerName) {
    return ThemeConstants.prayerGradient(prayerName);
  }

  Color _getPrayerColor(String prayerName) {
    return ThemeConstants.getPrayerColor(prayerName);
  }

  IconData _getPrayerIcon(String prayerName) {
    return ThemeConstants.getPrayerIcon(prayerName);
  }

  String _getNextPrayerMessage(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return 'صلاة الفجر مباركة';
      case 'الظهر':
        return 'وقت صلاة الظهر';
      case 'العصر':
        return 'لا تفوت صلاة العصر';
      case 'المغرب':
        return 'حان وقت المغرب';
      case 'العشاء':
        return 'صلاة العشاء قد حانت';
      default:
        return 'استعد للصلاة';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  double _calculateProgressWidth(BuildContext context, List<PrayerTime> prayers) {
    if (prayers.isEmpty) return 0.0;
    
    final screenWidth = MediaQuery.of(context).size.width - 120; // عرض الشاشة مطروحاً منه الهوامش
    final now = DateTime.now();
    
    // العثور على الصلاة الحالية
    int currentPrayerIndex = 0;
    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].isPassed) {
        currentPrayerIndex = i;
      } else {
        break;
      }
    }
    
    // إذا لم تمر أي صلاة بعد، فلا يوجد خط
    if (currentPrayerIndex == 0 && !prayers[0].isPassed) {
      return 0;
    }
    
    // إذا مرت جميع الصلوات، فالخط يصل للنهاية
    if (prayers.every((prayer) => prayer.isPassed)) {
      return screenWidth * _progressAnimation.value;
    }
    
    // حساب التقدم
    double progress;
    if (currentPrayerIndex < prayers.length - 1) {
      final currentPrayer = prayers[currentPrayerIndex];
      final nextPrayer = prayers[currentPrayerIndex + 1];
      final totalDuration = nextPrayer.time.difference(currentPrayer.time);
      final elapsed = now.difference(currentPrayer.time);
      
      if (totalDuration.inSeconds > 0) {
        final sectionProgress = (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
        progress = currentPrayerIndex + sectionProgress;
      } else {
        progress = currentPrayerIndex.toDouble();
      }
    } else {
      progress = currentPrayerIndex.toDouble();
    }
    
    return (screenWidth / (prayers.length - 1)) * progress * _progressAnimation.value;
  }
}

// Extension للموقع
extension PrayerLocationDisplayExtension on PrayerLocation {
  String get displayName {
    if (cityName != null && countryName != null) {
      return '$cityName، $countryName';
    } else if (cityName != null) {
      return cityName!;
    } else if (countryName != null) {
      return countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }
}