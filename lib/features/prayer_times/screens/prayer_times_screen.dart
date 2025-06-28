// lib/features/prayer_times/screens/prayer_times_screen.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// ✅ استيراد النظام الموحد
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';

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
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تحديث الموقع بنجاح'),
            backgroundColor: AppTheme.primary,
          ),
        );
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.'),
            backgroundColor: AppTheme.accent,
            action: SnackBarAction(
              label: 'حاول مجدداً',
              onPressed: _requestLocation,
              textColor: Colors.white,
            ),
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
      backgroundColor: AppTheme.background,
      appBar: SimpleAppBar(
        title: 'مواقيت الصلاة',
        actions: [
          // زر تحديث الموقع
          if (_isRetryingLocation)
            Container(
              padding: AppTheme.space2.padding,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.my_location, color: AppTheme.textSecondary),
              onPressed: _requestLocation,
              tooltip: 'تحديث الموقع',
            ),
          
          // زر إعدادات الإشعارات
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppTheme.textSecondary),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/prayer-notifications-settings');
            },
            tooltip: 'إعدادات الإشعارات',
          ),
          
          // زر الإعدادات
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/prayer-settings');
            },
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPrayerTimes,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _dailyTimes == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: AppLoading.page(message: 'جاري تحميل مواقيت الصلاة...'),
      );
    }
    
    if (_errorMessage != null && _dailyTimes == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: AppEmptyState.error(
          message: _errorMessage ?? 'حدث خطأ في تحميل المواقيت',
          onRetry: _loadPrayerTimes,
        ),
      );
    }
    
    if (_dailyTimes == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: AppEmptyState.noData(
          message: 'لم يتم تحديد الموقع\nنحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
          onRetry: _loadPrayerTimes,
        ),
      );
    }
    
    return Column(
      children: [
        // معلومات الموقع
        if (_dailyTimes?.location != null)
          LocationHeader(
            location: _dailyTimes!.location,
            onTap: _requestLocation,
          ),
        
        // العد التنازلي للصلاة التالية
        if (_nextPrayer != null)
          NextPrayerCountdown(
            nextPrayer: _nextPrayer!,
            currentPrayer: _dailyTimes!.currentPrayer,
          ),
        
        // عنوان قائمة الصلوات
        _buildPrayerListHeader(),
        
        // قائمة الصلوات
        Padding(
          padding: AppTheme.space4.paddingH,
          child: Column(
            children: [
              ..._dailyTimes!.prayers
                  .where((prayer) => prayer.type != PrayerType.sunrise)
                  .map((prayer) => AnimatedPress(
                        onTap: () => _togglePrayerNotification(prayer, true),
                        child: PrayerTimeCard(
                          prayer: prayer,
                          forceColored: true,
                          onNotificationToggle: (enabled) {
                            _togglePrayerNotification(prayer, enabled);
                          },
                        ),
                      )),
            ],
          ),
        ),
        
        AppTheme.space8.h,
      ],
    );
  }

  Widget _buildPrayerListHeader() {
    return Padding(
      padding: AppTheme.space4.padding,
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: AppTheme.space3.padding,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: AppTheme.radiusMd.radius,
              ),
              child: Icon(
                Icons.mosque,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            
            AppTheme.space3.w,
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جدول الصلوات اليوم',
                    style: AppTheme.titleMedium,
                  ),
                  Text(
                    '${_dailyTimes!.prayers.where((p) => p.type != PrayerType.sunrise).length} صلوات',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: AppTheme.radiusFull.radius,
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                DateTime.now().day.toString(),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled 
              ? 'تم تفعيل تنبيه ${prayer.nameAr}'
              : 'تم إيقاف تنبيه ${prayer.nameAr}',
        ),
        backgroundColor: AppTheme.primary,
      ),
    );
  }
}