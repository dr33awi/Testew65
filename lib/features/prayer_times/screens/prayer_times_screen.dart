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

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  // Controllers
  final _scrollController = ScrollController();
  
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
    _initializeServices();
    _loadPrayerTimes();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    
    // تهيئة خدمة مواقيت الصلاة
    _prayerService = getIt<PrayerTimesService>();
    
    // الاستماع للتحديثات
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
      // تحقق من وجود مواقيت مخزنة مسبقاً لعرضها أثناء تحديث الموقع
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _isLoading = false;
        });
      }
      
      // التحقق من وجود موقع محفوظ
      if (_prayerService.currentLocation == null) {
        // طلب الموقع
        await _requestLocation();
      } else {
        // تحديث المواقيت
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
      
      // تحديث مواقيت الصلاة بعد تحديد الموقع
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
        
        // عرض رسالة خطأ للمستخدم
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
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar
            _buildAppBar(),
            
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

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: context.backgroundColor,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'مواقيت الصلاة',
        style: context.titleLarge?.semiBold,
      ),
      actions: [
        // زر تحديث الموقع
        IconButton(
          icon: _isRetryingLocation 
              ? SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                  ),
                )
              : const Icon(Icons.my_location),
          onPressed: _isRetryingLocation ? null : _requestLocation,
          tooltip: 'تحديث الموقع',
        ),
        
        // زر إعدادات الإشعارات
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => Navigator.pushNamed(context, '/prayer-notifications-settings'),
          tooltip: 'إعدادات الإشعارات',
        ),
        
        // زر الإعدادات
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.pushNamed(context, '/prayer-settings'),
          tooltip: 'الإعدادات',
        ),
      ],
    );
  }

  List<Widget> _buildContent() {
    return [
      // Header مع الموقع
      SliverToBoxAdapter(
        child: LocationHeader(
          location: _dailyTimes!.location,
          onTap: _requestLocation,
        ),
      ),
      
      // العد التنازلي للصلاة التالية
      if (_nextPrayer != null)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: NextPrayerCountdown(
              nextPrayer: _nextPrayer!,
              currentPrayer: _dailyTimes!.currentPrayer,
            ),
          ),
        ),
      
      // قائمة الصلوات
      SliverPadding(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final prayer = _dailyTimes!.prayers[index];
              
              // تخطي الشروق لأنه ليس صلاة
              if (prayer.type == PrayerType.sunrise) {
                return const SizedBox.shrink();
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
                child: PrayerTimeCard(
                  prayer: prayer,
                  forceColored: true,
                  onNotificationToggle: (enabled) {
                    _togglePrayerNotification(prayer, enabled);
                  },
                ),
              );
            },
            childCount: _dailyTimes!.prayers.length,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoading.circular(size: LoadingSize.large),
            const SizedBox(height: ThemeConstants.space4),
            const Text(
              'جاري تحميل مواقيت الصلاة...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
          onAction: _requestLocation,
          actionText: 'تحديد الموقع',
          iconColor: context.primaryColor,
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