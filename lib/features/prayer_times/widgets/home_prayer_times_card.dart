// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
  late AnimationController _glowController; // جديد للتوهج
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation; // جديد للتوهج
  late PrayerTimesService _prayerService;

  // State
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  PrayerLocation? _location;
  bool _isLoading = true;
  bool _isLoadingLocation = false;
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

    // مُحكم التوهج الجديد
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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

    // حركة التوهج الجديدة
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
  }

  void _initializeService() {
    try {
      _prayerService = getIt<PrayerTimesService>();
      
      _timesSubscription = _prayerService.prayerTimesStream.listen(
        (times) {
          if (mounted) {
            setState(() {
              _dailyTimes = times;
              _location = times.location;
              _isLoading = false;
              _isLoadingLocation = false;
              _errorMessage = null;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'فشل في تحميل مواقيت الصلاة';
              _isLoading = false;
              _isLoadingLocation = false;
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
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null && mounted) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _location = cachedTimes.location;
          _isLoading = false;
        });
      }
      
      await _updatePrayerTimes();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل مواقيت الصلاة';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updatePrayerTimes() async {
    if (_isLoadingLocation) return;
    
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      if (_prayerService.currentLocation == null) {
        await _prayerService.getCurrentLocation();
      }
      
      await _prayerService.updatePrayerTimes();
      
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحديث الموقع أو مواقيت الصلاة';
          _isLoadingLocation = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('فشل في تحديث الموقع. تحقق من إعدادات الموقع.'),
            backgroundColor: ThemeConstants.error,
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              textColor: Colors.white,
              onPressed: _updatePrayerTimes,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _glowController.dispose(); // تنظيف مُحكم التوهج
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
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Column(
                  children: [
                    _buildMainContent(context, nextPrayer),
                    
                    ThemeConstants.space3.h,
                    
                    // الخط الزمني المحدث مع الأيقونات المضيئة
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
      height: 180,
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
            ThemeConstants.space2.h,
            Text(
              'جاري تحميل مواقيت الصلاة...',
              style: context.bodySmall?.copyWith(
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
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        color: context.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _updatePrayerTimes,
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 36,
                  color: context.errorColor,
                ),
                ThemeConstants.space2.h,
                Text(
                  _errorMessage ?? 'خطأ في تحميل المواقيت',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                ThemeConstants.space1.h,
                Text(
                  'اضغط للمحاولة مرة أخرى',
                  style: context.labelSmall?.copyWith(
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
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        color: context.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _updatePrayerTimes,
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoadingLocation
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                      )
                    : Icon(
                        Icons.location_on,
                        size: 36,
                        color: context.textSecondaryColor,
                      ),
                ThemeConstants.space2.h,
                Text(
                  _isLoadingLocation 
                      ? 'جاري تحديد الموقع...'
                      : 'لم يتم تحديد الموقع',
                  style: context.titleSmall?.semiBold,
                ),
                ThemeConstants.space1.h,
                Text(
                  _isLoadingLocation
                      ? 'الرجاء الانتظار'
                      : 'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
                  style: context.labelSmall?.copyWith(
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

  Widget _buildMainContent(BuildContext context, PrayerTime nextPrayer) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
          child: Icon(
            Icons.mosque,
            color: Colors.white,
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
                style: context.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              
              Text(
                _location?.displayName ?? 'جاري تحديد الموقع...',
                style: context.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
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
              Text(
                nextPrayer.nameAr,
                style: context.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.02),
                    child: Text(
                      _formatTime(nextPrayer.time),
                      style: context.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  );
                },
              ),
              
              _buildTimeRemaining(context, nextPrayer),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRemaining(BuildContext context, PrayerTime nextPrayer) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final remainingTime = nextPrayer.remainingTimeText;
        
        return Container(
          margin: const EdgeInsets.only(top: ThemeConstants.space1),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space2,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
          child: Text(
            remainingTime,
            style: context.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 10,
            ),
          ),
        );
      },
    );
  }

  // الخط الزمني المحدث مع الأيقونات المضيئة
  Widget _buildPrayerTimeline(BuildContext context) {
    if (_dailyTimes == null) return const SizedBox.shrink();
    
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 60,
          child: Stack(
            children: [
              // الخط الأساسي الشفاف
              Positioned(
                top: 20,
                left: 15,
                right: 15,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              
              // الأيقونات المضيئة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: mainPrayers.map((prayer) => 
                  _buildGlowingPrayerIcon(context, prayer)
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // أيقونة الصلاة المضيئة الجديدة
  Widget _buildGlowingPrayerIcon(BuildContext context, PrayerTime prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      children: [
        // الأيقونة المضيئة بإضاءة بيضاء موحدة
        AnimatedBuilder(
          animation: isActive ? _glowAnimation : _progressAnimation,
          builder: (context, child) {
            final glowIntensity = isActive ? _glowAnimation.value : (isPassed ? 1.0 : 0.3);
            
            return Container(
              width: isActive ? 24 : 20,
              height: isActive ? 24 : 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPassed || isActive 
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.3),
                boxShadow: [
                  // توهج داخلي أبيض
                  BoxShadow(
                    color: Colors.white.withValues(alpha: glowIntensity * 0.8),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  // توهج خارجي أبيض
                  if (isPassed || isActive) ...[
                    BoxShadow(
                      color: Colors.white.withValues(alpha: glowIntensity * 0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: glowIntensity * 0.2),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ]
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: glowIntensity),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  isPassed && !isActive 
                      ? Icons.check_rounded 
                      : _getPrayerIcon(prayer.nameAr),
                  color: isPassed || isActive 
                      ? Colors.black.withValues(alpha: 0.8)
                      : Colors.white.withValues(alpha: 0.6),
                  size: isActive ? 12 : 10,
                ),
              ),
            );
          },
        ),
        
        ThemeConstants.space1.h,
        
        // اسم الصلاة
        Text(
          prayer.nameAr,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            fontSize: 9,
          ),
        ),
        
        // الوقت
        Text(
          _formatTime(prayer.time),
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.9 : 0.6),
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('هذه الميزة قيد التطوير'),
            backgroundColor: ThemeConstants.info,
          ),
        );
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