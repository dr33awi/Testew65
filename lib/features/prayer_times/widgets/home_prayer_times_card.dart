// lib/features/prayer_times/widgets/home_prayer_times_card.dart - مُصحح نهائياً
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
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late PrayerTimesService _prayerService;

  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  PrayerLocation? _location;
  bool _isLoading = true;
  bool _isLoadingLocation = false;
  String? _errorMessage;
  
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
    _fadeController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
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
        
        if (mounted) {
          AppSnackBar.showError(
            context: context,
            message: 'فشل في تحديث الموقع. تحقق من إعدادات الموقع.',
          );
        }
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
              minHeight: isTablet ? 180 : 160,
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

    return _buildPrayerCard(context, nextPrayer, isTablet);
  }

  Widget _buildPrayerCard(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    final prayerColor = AppColorSystem.getPrayerColor(nextPrayer.nameAr);
    
    return AppContainerBuilder.gradient(
      colors: [
        prayerColor,
        prayerColor.darken(0.3),
      ],
      borderRadius: ThemeConstants.radiusLg,
      shadows: AppShadowSystem.colored(color: prayerColor, opacity: 0.2),
      child: GestureDetector(
        onTap: _navigateToPrayerTimes,
        child: Column(
          children: [
            _buildMainHeader(context, nextPrayer, isTablet),
            
            SizedBox(height: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
            
            _buildPrayerTimeline(context, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHeader(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    return Row(
      children: [
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
            boxShadow: AppShadowSystem.light,
          ),
          child: Icon(
            AppIconsSystem.prayer,
            color: Colors.white,
            size: isTablet ? 24 : 20,
          ),
        ),
        
        SizedBox(width: isTablet ? ThemeConstants.space3 : ThemeConstants.space2),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  'مواقيت الصلاة',
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    height: 1.1,
                    shadows: AppShadowSystem.textShadow(),
                  ),
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space1),
              
              Row(
                children: [
                  Icon(
                    AppIconsSystem.location,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 12,
                  ),
                  
                  const SizedBox(width: ThemeConstants.space1),
                  
                  Expanded(
                    child: Text(
                      _location?.displayName ?? 'جاري تحديد الموقع...',
                      style: AppTextStyles.caption.copyWith(
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

  Widget _buildPrayerTimeline(BuildContext context, bool isTablet) {
    if (_dailyTimes == null) return const SizedBox.shrink();
    
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();

    return Expanded(
      child: Container(
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
      ),
    );
  }

  Widget _buildTimelinePoint(BuildContext context, PrayerTime prayer, bool isTablet) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isTablet ? 60 : 50,
          height: isTablet ? 60 : 50,
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
            boxShadow: isActive ? AppShadowSystem.floating() : null,
          ),
          child: Center(
            child: Icon(
              AppIconsSystem.getPrayerIcon(prayer.nameAr),
              color: isActive
                  ? AppColorSystem.getPrayerColor(prayer.nameAr)
                  : isPassed 
                      ? AppColorSystem.getPrayerColor(prayer.nameAr).withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.7),
              size: isTablet ? 24 : 20,
            ),
          ),
        ),
        
        SizedBox(height: isTablet ? 12 : 8),
        
        Text(
          prayer.nameAr,
          style: AppTextStyles.label1.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.8),
            fontWeight: isActive ? ThemeConstants.bold : ThemeConstants.semiBold,
            fontSize: isTablet ? 14 : 12,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 4),
        
        Text(
          _formatTimeShort(prayer.time),
          style: AppTextStyles.label2.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.95 : 0.7),
            fontSize: isTablet ? 12 : 10,
            fontWeight: ThemeConstants.medium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return AppCard.simple(
      title: 'جاري تحميل المواقيت...',
      icon: AppIconsSystem.loading,
    );
  }

  Widget _buildErrorState() {
    return AppCard.info(
      title: _errorMessage ?? 'خطأ في تحميل المواقيت',
      subtitle: 'اضغط للمحاولة مرة أخرى',
      icon: AppIconsSystem.error,
      iconColor: AppColorSystem.error,
      onTap: _updatePrayerTimes,
    );
  }

  Widget _buildEmptyState() {
    return AppCard.info(
      title: _isLoadingLocation 
          ? 'جاري تحديد الموقع...'
          : 'لم يتم تحديد الموقع',
      subtitle: _isLoadingLocation
          ? 'الرجاء الانتظار'
          : 'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
      icon: _isLoadingLocation ? AppIconsSystem.loading : AppIconsSystem.location,
      iconColor: AppColorSystem.primary,
      onTap: _updatePrayerTimes,
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (mounted) {
        AppSnackBar.showInfo(
          context: context,
          message: 'هذه الميزة قيد التطوير',
        );
      }
      return null;
    });
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