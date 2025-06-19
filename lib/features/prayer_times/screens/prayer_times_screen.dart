// lib/features/prayer_times/screens/prayer_times_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';
import '../widgets/prayer_time_card.dart';
import '../widgets/next_prayer_countdown.dart';
import '../widgets/location_header.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with TickerProviderStateMixin {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  // Controllers
  final _scrollController = ScrollController();
  late AnimationController _headerAnimationController;
  late AnimationController _cardsAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardsAnimation;
  
  // State
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  bool _isLoading = true;
  bool _isRetryingLocation = false;
  String? _errorMessage;
  
  // Subscriptions
  StreamSubscription<DailyPrayerTimes>? _timesSubscription;
  StreamSubscription<PrayerTime?>? _nextPrayerSubscription;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeServices();
    _loadPrayerTimes();
  }

  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _cardsAnimationController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );
    
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: ThemeConstants.curveSmooth,
    );
    
    _cardsAnimation = CurvedAnimation(
      parent: _cardsAnimationController,
      curve: ThemeConstants.curveSmooth,
    );
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _prayerService = getIt<PrayerTimesService>();
    
    _timesSubscription = _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
          _errorMessage = null;
        });
        
        _headerAnimationController.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _cardsAnimationController.forward();
          }
        });
      }
    });
    
    _nextPrayerSubscription = _prayerService.nextPrayerStream.listen((prayer) {
      if (mounted) {
        setState(() {
          _nextPrayer = prayer;
        });
      }
    });
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _isLoading = false;
        });
        _headerAnimationController.forward();
        _cardsAnimationController.forward();
      }
      
      if (_prayerService.currentLocation == null) {
        await _requestLocation();
      } else {
        await _prayerService.updatePrayerTimes();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء تحميل مواقيت الصلاة. يرجى المحاولة مرة أخرى.';
        _isLoading = false;
      });
      
      _logger.error(
        message: 'خطأ في تحميل مواقيت الصلاة',
        error: e,
      );
    }
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isRetryingLocation = true;
    });
    
    try {
      final location = await _prayerService.getCurrentLocation();
      
      _logger.info(
        message: 'تم تحديد الموقع بنجاح',
        data: {
          'city': location.cityName,
          'country': location.countryName,
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
      );
      
      await _prayerService.updatePrayerTimes();
      
      if (mounted) {
        setState(() {
          _isRetryingLocation = false;
        });
      }
    } catch (e) {
      _logger.error(
        message: 'فشل الحصول على الموقع',
        error: e,
      );
      
      if (mounted) {
        setState(() {
          _errorMessage = 'لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.';
          _isLoading = false;
          _isRetryingLocation = false;
        });
        
        context.showErrorSnackBar(
          'لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.',
          action: SnackBarAction(
            label: 'حاول مجدداً',
            onPressed: _requestLocation,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerAnimationController.dispose();
    _cardsAnimationController.dispose();
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: RefreshIndicator(
        onRefresh: _loadPrayerTimes,
        color: ThemeConstants.primary,
        backgroundColor: context.cardColor,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar الموحد
            _buildUnifiedAppBar(),
            
            // المحتوى
            if (_isLoading && _dailyTimes == null)
              _buildLoadingState()
            else if (_errorMessage != null && _dailyTimes == null)
              _buildErrorState()
            else if (_dailyTimes != null)
              ..._buildContent()
            else
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedAppBar() {
    return SliverToBoxAdapter(
      child: CustomAppBar.gradient(
        title: 'مواقيت الصلاة',
        gradientColors: ThemeConstants.primaryGradient.colors,
        actions: [
          AppBarAction(
            icon: _isRetryingLocation ? Icons.refresh : Icons.my_location,
            onPressed: _isRetryingLocation ? null : _requestLocation,
            tooltip: 'تحديث الموقع',
            showBackground: true,
          ),
          AppBarAction(
            icon: Icons.notifications_outlined,
            onPressed: () => Navigator.pushNamed(context, '/prayer-notifications-settings'),
            tooltip: 'إعدادات الإشعارات',
            showBackground: true,
          ),
          AppBarAction(
            icon: Icons.settings_outlined,
            onPressed: () => Navigator.pushNamed(context, '/prayer-settings'),
            tooltip: 'الإعدادات',
            showBackground: true,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      // Header مع الموقع - استخدام AppCard
      SliverToBoxAdapter(
        child: AnimatedBuilder(
          animation: _headerAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _headerAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(_headerAnimation),
                child: AppCard.info(
                  title: _dailyTimes!.location.cityName ?? 'غير محدد',
                  subtitle: _dailyTimes!.location.countryName ?? '',
                  icon: Icons.location_on,
                  iconColor: ThemeConstants.primary,
                  onTap: _requestLocation,
                  trailing: Icon(
                    Icons.refresh,
                    color: ThemeConstants.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      
      // العد التنازلي للصلاة التالية
      if (_nextPrayer != null)
        SliverToBoxAdapter(
          child: AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _headerAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_headerAnimation),
                  child: NextPrayerCountdown(
                    nextPrayer: _nextPrayer!,
                    currentPrayer: _dailyTimes!.currentPrayer,
                  ),
                ),
              );
            },
          ),
        ),
      
      // عنوان قائمة الصلوات - استخدام AppCard
      SliverToBoxAdapter(
        child: AnimatedBuilder(
          animation: _cardsAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _cardsAnimation,
              child: AppCard.info(
                title: 'جدول الصلوات اليوم',
                subtitle: '${_dailyTimes!.prayers.where((p) => p.type != PrayerType.sunrise).length} صلوات',
                icon: Icons.schedule_rounded,
                iconColor: ThemeConstants.primary,
              ),
            );
          },
        ),
      ),
      
      // قائمة الصلوات
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final prayers = _dailyTimes!.prayers.where((prayer) => 
                prayer.type != PrayerType.sunrise
              ).toList();
              
              if (index >= prayers.length) return null;
              
              final prayer = prayers[index];
              
              return AnimatedBuilder(
                animation: _cardsAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _cardsAnimation,
                      curve: Interval(
                        (index * 0.1).clamp(0.0, 1.0),
                        ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                        curve: ThemeConstants.curveSmooth,
                      ),
                    )),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _cardsAnimation,
                        curve: Interval(
                          (index * 0.1).clamp(0.0, 1.0),
                          ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                          curve: ThemeConstants.curveSmooth,
                        ),
                      )),
                      child: PrayerTimeCard(
                        prayer: prayer,
                        forceColored: true,
                        onNotificationToggle: (enabled) {
                          _togglePrayerNotification(prayer, enabled);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            childCount: _dailyTimes!.prayers.where((prayer) => 
              prayer.type != PrayerType.sunrise
            ).length,
          ),
        ),
      ),
      
      // مساحة في الأسفل
      const SliverToBoxAdapter(
        child: SizedBox(height: ThemeConstants.space8),
      ),
    ];
  }

  Widget _buildLoadingState() {
    return SliverFillRemaining(
      child: Center(
        child: AppLoading.prayer(
          message: 'جاري تحميل مواقيت الصلاة...',
          color: ThemeConstants.primary,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverFillRemaining(
      child: Center(
        child: AppEmptyState.error(
          message: _errorMessage,
          onRetry: _loadPrayerTimes,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: AppEmptyState.custom(
          title: 'لم يتم تحديد الموقع',
          message: 'نحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
          icon: Icons.location_on,
          onAction: _loadPrayerTimes,
          actionText: 'تحديد الموقع',
          iconColor: ThemeConstants.primary,
        ),
      ),
    );
  }

  void _togglePrayerNotification(PrayerTime prayer, bool enabled) {
    HapticFeedback.lightImpact();
    
    final settings = _prayerService.notificationSettings;
    final updatedPrayers = Map<PrayerType, bool>.from(settings.enabledPrayers);
    updatedPrayers[prayer.type] = enabled;
    
    _prayerService.updateNotificationSettings(
      settings.copyWith(enabledPrayers: updatedPrayers),
    );
    
    context.showSuccessSnackBar(
      enabled 
          ? 'تم تفعيل تنبيه ${prayer.nameAr}'
          : 'تم إيقاف تنبيه ${prayer.nameAr}',
    );
  }
}