// lib/features/prayer_times/widgets/home_prayer_times_card.dart - بطاقة مواقيت مبسطة ومحسنة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  
  // Animation Controllers - إزالة pulse controller أيضاً
  late AnimationController _fadeController;
  
  // Animations - إزالة pulse animation
  late Animation<double> _fadeAnimation;
  
  // Service
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
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeService();
    _startClockTimer();
  }

  void _setupAnimations() {
    // إزالة جميع animations عدا fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
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
        
        AppSnackBar.showError(
          context: context,
          message: 'فشل في تحديث الموقع. تحقق من إعدادات الموقع.',
          action: SnackBarAction(
            label: 'إعادة المحاولة',
            textColor: Colors.white,
            onPressed: _updatePrayerTimes,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: BoxConstraints(
              minHeight: isTablet ? 180 : 160, // زيادة ارتفاع الكارد لاستيعاب الأيقونات الكبيرة
              maxHeight: isTablet ? 220 : 200,
            ),
            child: _buildContent(context, isTablet),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isTablet) {
    if (_isLoading) {
      return _buildLoadingState(isTablet);
    }

    if (_errorMessage != null && _dailyTimes == null) {
      return _buildErrorState(isTablet);
    }

    if (_dailyTimes == null) {
      return _buildEmptyState(isTablet);
    }

    final nextPrayer = _nextPrayer ?? _dailyTimes!.nextPrayer;
    if (nextPrayer == null) {
      return _buildEmptyState(isTablet);
    }

    return _buildPrayerCard(context, nextPrayer, isTablet);
  }

  Widget _buildPrayerCard(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    final prayerColor = context.getPrayerColor(nextPrayer.nameAr);
    final gradientColors = [
      prayerColor,
      prayerColor.darken(0.3),
    ];
    
    return GestureDetector(
      onTap: _navigateToPrayerTimes,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg), // تصغير نصف القطر
          boxShadow: [
            BoxShadow(
              color: prayerColor.withValues(alpha: 0.2), // تقليل الظل
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: -3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          child: Stack(
            children: [
              // الخلفية المتدرجة البسيطة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors.map((c) => 
                      c.withValues(alpha: 0.95)
                    ).toList(),
                  ),
                ),
              ),
              
              // المحتوى الرئيسي
              Padding(
                padding: EdgeInsets.all(
                  isTablet ? ThemeConstants.space4 : ThemeConstants.space3, // تقليل المسافات
                ),
                child: Column(
                  children: [
                    _buildMainHeader(context, nextPrayer, isTablet),
                    
                    SizedBox(height: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
                    
                    _buildPrayerTimeline(context, isTablet),
                  ],
                ),
              ),
              
              // عناصر زخرفية مصغرة
              _buildDecorativeElements(),
              
              // تأثير التفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _navigateToPrayerTimes,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  splashColor: Colors.white.withValues(alpha: 0.1),
                  highlightColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    return Row(
      children: [
        // أيقونة المسجد ثابتة
        Container(
          width: isTablet ? 50 : 40,
          height: isTablet ? 50 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.mosque_rounded,
            color: Colors.white,
            size: isTablet ? 24 : 20,
          ),
        ),
        
        SizedBox(width: isTablet ? ThemeConstants.space3 : ThemeConstants.space2),
        
        // معلومات الموقع والصلاة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  'مواقيت الصلاة',
                  style: (isTablet ? context.titleMedium : context.titleSmall)?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 2),
              
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 12,
                  ),
                  
                  const SizedBox(width: 3),
                  
                  Expanded(
                    child: Text(
                      _location?.displayName ?? 'جاري تحديد الموقع...',
                      style: context.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isTablet ? 11 : 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        

      ],
    );
  }

  Widget _buildNextPrayerInfo(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    // تم حذف هذه الدالة لأنها لم تعد مستخدمة
    return const SizedBox.shrink();
  }

  Widget _buildTimeRemaining(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    // تم حذف هذه الدالة لأنها لم تعد مستخدمة
    return const SizedBox.shrink();
  }

  Widget _buildPrayerTimeline(BuildContext context, bool isTablet) {
    if (_dailyTimes == null) return const SizedBox.shrink();
    
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight, // استخدام كامل المساحة المتاحة
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: mainPrayers.map((prayer) => 
                Expanded(
                  child: _buildTimelinePoint(context, prayer, isTablet),
                )
              ).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelinePoint(BuildContext context, PrayerTime prayer, bool isTablet) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // حساب حجم الأيقونة بناءً على المساحة المتاحة
        final availableWidth = constraints.maxWidth;
        final iconSize = (availableWidth * 0.6).clamp(40.0, isTablet ? 80.0 : 60.0);
        final circleSize = iconSize + (isActive ? 12 : 8);
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: ThemeConstants.durationNormal,
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Colors.white
                    : isPassed 
                        ? Colors.white.withValues(alpha: 0.85)
                        : Colors.white.withValues(alpha: 0.4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                  width: isActive ? 3 : 2,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.7),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ] : isPassed ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Center(
                child: Icon(
                  context.getPrayerIcon(prayer.nameAr),
                  color: isActive
                      ? context.getPrayerColor(prayer.nameAr)
                      : isPassed 
                          ? context.getPrayerColor(prayer.nameAr).withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.7),
                  size: iconSize * 0.6, // الأيقونة تأخذ 60% من حجم الدائرة
                ),
              ),
            ),
            
            SizedBox(height: isTablet ? 12 : 8),
            
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                prayer.nameAr,
                style: context.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.8),
                  fontWeight: isActive ? ThemeConstants.bold : ThemeConstants.semiBold,
                  fontSize: isTablet ? 16 : 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: isTablet ? 6 : 4),
            
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _formatTimeShort(prayer.time),
                style: context.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: isActive ? 0.95 : 0.7),
                  fontSize: isTablet ? 14 : 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: ThemeConstants.medium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDecorativeElements() {
    // تم إزالة العناصر الزخرفية
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState(bool isTablet) {
    return Container(
      height: isTablet ? 140 : 120,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoading.circular(
            size: LoadingSize.medium,
            color: context.primaryColor,
          ),
          SizedBox(height: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
          Text(
            'جاري تحميل المواقيت...',
            style: context.bodySmall?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isTablet) {
    return AppCard.info(
      title: _errorMessage ?? 'خطأ في تحميل المواقيت',
      subtitle: 'اضغط للمحاولة مرة أخرى',
      icon: Icons.error_outline,
      iconColor: context.errorColor,
      onTap: _updatePrayerTimes,
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return AppCard.info(
      title: _isLoadingLocation 
          ? 'جاري تحديد الموقع...'
          : 'لم يتم تحديد الموقع',
      subtitle: _isLoadingLocation
          ? 'الرجاء الانتظار'
          : 'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
      icon: _isLoadingLocation ? Icons.hourglass_empty : Icons.location_on,
      iconColor: context.primaryColor,
      onTap: _updatePrayerTimes,
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (context.mounted) {
        AppSnackBar.showInfo(
          context: context,
          message: 'هذه الميزة قيد التطوير',
        );
      }
      return null;
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  String _formatTimeShort(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute';
  }
}

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