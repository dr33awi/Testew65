// lib/features/prayer_times/screens/prayer_times_screen.dart - النسخة الموحدة

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

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  final _scrollController = ScrollController();
  
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  bool _isLoading = true;
  bool _isRetryingLocation = false;
  String? _errorMessage;
  
  StreamSubscription<DailyPrayerTimes>? _timesSubscription;
  StreamSubscription<PrayerTime?>? _nextPrayerSubscription;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadPrayerTimes();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _prayerService = getIt<PrayerTimesService>();
    
    // ✅ استخدام النظام الموحد للاستماع للتحديثات
    _timesSubscription = _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
          _errorMessage = null;
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
      // تحقق من وجود مواقيت مخزنة مسبقاً
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _isLoading = false;
        });
      }
      
      // تحديث الموقع والمواقيت
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
        
        // ✅ استخدام النظام الموحد للإشعارات
        context.showErrorSnackBar(
          'لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.',
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      // ✅ استخدام CustomAppBar الموحد
      appBar: CustomAppBar.simple(
        title: 'مواقيت الصلاة',
        actions: [
          // ✅ استخدام AppBarAction الموحد
          AppBarAction(
            icon: 'location'.themeCategoryIcon,
            onPressed: _isRetryingLocation 
                ? () {} // ✅ دالة فارغة بدلاً من null
                : () => _requestLocation(),
            tooltip: 'تحديث الموقع',
            color: _isRetryingLocation ? context.textSecondaryColor : context.primaryColor,
          ),
          
          AppBarAction(
            icon: 'notifications'.themeCategoryIcon,
            onPressed: () {
              Navigator.pushNamed(context, '/prayer-notifications-settings');
            },
            tooltip: 'إعدادات الإشعارات',
            color: context.primaryColor,
          ),
          
          AppBarAction(
            icon: AppIconsSystem.settings,
            onPressed: () {
              Navigator.pushNamed(context, '/prayer-settings');
            },
            tooltip: 'الإعدادات',
            color: context.primaryColor,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPrayerTimes,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ✅ معلومات الموقع باستخدام المكونات الموحدة
            if (_dailyTimes?.location != null)
              SliverToBoxAdapter(
                child: LocationHeader(
                  location: _dailyTimes!.location,
                  onTap: _requestLocation,
                ),
              ),
            
            // ✅ المحتوى الرئيسي
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

  List<Widget> _buildContent() {
    return [
      // ✅ العد التنازلي للصلاة التالية
      if (_nextPrayer != null)
        SliverToBoxAdapter(
          child: Container(
            margin: ThemeConstants.space4.all,
            child: NextPrayerCountdown(
              nextPrayer: _nextPrayer!,
              currentPrayer: _dailyTimes!.currentPrayer,
            ),
          ),
        ),
      
      // ✅ قائمة الصلوات باستخدام AnimationConfiguration
      SliverPadding(
        padding: ThemeConstants.space4.all,
        sliver: SliverAnimatedList(
          initialItemCount: _getMainPrayers().length,
          itemBuilder: (context, index, animation) {
            final prayers = _getMainPrayers();
            if (index >= prayers.length) return const SizedBox.shrink();
            
            final prayer = prayers[index];
            
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: ThemeConstants.durationNormal,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: PrayerTimeCard(
                    prayer: prayer,
                    forceColored: true,
                    onNotificationToggle: (enabled) {
                      _togglePrayerNotification(prayer, enabled);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      
      // ✅ مساحة في الأسفل
      SliverToBoxAdapter(
        child: ThemeConstants.space8.h,
      ),
    ];
  }

  Widget _buildLoadingState() {
    return SliverFillRemaining(
      child: AppLoading.page(
        message: 'جاري تحميل مواقيت الصلاة...',
        size: LoadingSize.large,
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverFillRemaining(
      child: AppEmptyState.error(
        message: _errorMessage ?? 'حدث خطأ في تحميل المواقيت',
        onRetry: _loadPrayerTimes,
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: AppEmptyState.custom(
        title: 'لم يتم تحديد الموقع',
        message: 'نحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
        icon: AppIconsSystem.location,
        actionText: 'تحديد الموقع',
        onAction: _loadPrayerTimes,
        iconColor: context.primaryColor,
      ),
    );
  }

  List<PrayerTime> _getMainPrayers() {
    if (_dailyTimes == null) return [];
    
    return _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();
  }

  void _togglePrayerNotification(PrayerTime prayer, bool enabled) {
    HapticFeedback.lightImpact();
    
    final settings = _prayerService.notificationSettings;
    final updatedPrayers = Map<PrayerType, bool>.from(settings.enabledPrayers);
    updatedPrayers[prayer.type] = enabled;
    
    _prayerService.updateNotificationSettings(
      settings.copyWith(enabledPrayers: updatedPrayers),
    );
    
    // ✅ استخدام النظام الموحد للإشعارات
    context.showSuccessSnackBar(
      enabled 
          ? 'تم تفعيل تنبيه ${prayer.nameAr}'
          : 'تم إيقاف تنبيه ${prayer.nameAr}',
    );
  }
}