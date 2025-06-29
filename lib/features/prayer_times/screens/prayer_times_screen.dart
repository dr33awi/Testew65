// lib/features/prayer_times/screens/prayer_times_screen.dart - محدث بالنظام الموحد الكامل

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
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
    with SingleTickerProviderStateMixin {
  
  // Services
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  // Controllers
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
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
    _animationController = AnimationController(
      duration: AppTheme.durationSlow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _prayerService = getIt<PrayerTimesService>();
    
    // الاستماع للتحديثات
    _timesSubscription = _prayerService.prayerTimesStream.listen(
      (times) {
        if (mounted) {
          setState(() {
            _dailyTimes = times;
            _isLoading = false;
            _errorMessage = null;
          });
        }
      },
      onError: (error) {
        _logger.error(
          message: 'خطأ في stream مواقيت الصلاة',
          error: error,
        );
        if (mounted) {
          setState(() {
            _errorMessage = 'حدث خطأ في تحديث مواقيت الصلاة';
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
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // تحقق من وجود مواقيت مخزنة مسبقاً
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null && mounted) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _isLoading = false;
        });
      }
      
      // التحقق من وجود موقع محفوظ
      if (_prayerService.currentLocation == null) {
        await _requestLocation();
      } else {
        await _prayerService.updatePrayerTimes();
      }
    } catch (e) {
      _logger.error(
        message: 'خطأ في تحميل مواقيت الصلاة',
        error: e,
      );
      
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء تحميل مواقيت الصلاة. يرجى المحاولة مرة أخرى.';
          _isLoading = false;
        });
      }
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.'),
            backgroundColor: AppTheme.error,
            action: SnackBarAction(
              label: 'حاول مجدداً',
              textColor: Colors.white,
              onPressed: _requestLocation,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
          IconButton(
            onPressed: _isRetryingLocation ? null : _requestLocation,
            icon: _isRetryingLocation 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                    color: AppTheme.primary,
                  ),
            tooltip: 'تحديث الموقع',
          ),
          
          // زر إعدادات الإشعارات
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/prayer-notifications-settings');
            },
            icon: const Icon(
              Icons.notifications,
              color: AppTheme.primary,
            ),
            tooltip: 'إعدادات الإشعارات',
          ),
          
          // زر الإعدادات
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/prayer-settings');
            },
            icon: const Icon(
              Icons.settings,
              color: AppTheme.primary,
            ),
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _loadPrayerTimes,
          color: AppTheme.primary,
          backgroundColor: AppTheme.surface,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // معلومات الموقع
              if (_dailyTimes?.location != null)
                SliverToBoxAdapter(
                  child: LocationHeader(
                    location: _dailyTimes!.location,
                    onTap: _requestLocation,
                  ),
                ),
              
              // المحتوى الرئيسي
              if (_isLoading && _dailyTimes == null)
                _buildLoadingState()
              else if (_errorMessage != null && _dailyTimes == null)
                _buildErrorState()
              else if (_dailyTimes != null)
                ..._buildContent()
              else
                _buildEmptyState(),
                
              // مساحة في الأسفل
              SliverToBoxAdapter(child: AppTheme.space8.h),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      // العد التنازلي للصلاة التالية
      if (_nextPrayer != null)
        SliverToBoxAdapter(
          child: NextPrayerCountdown(
            nextPrayer: _nextPrayer!,
            currentPrayer: _dailyTimes!.currentPrayer,
          ),
        ),
      
      // إحصائيات سريعة
      SliverToBoxAdapter(
        child: _buildQuickStats(),
      ),
      
      // قائمة الصلوات
      SliverPadding(
        padding: AppTheme.space4.padding,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // الصلوات الرئيسية فقط (بدون الشروق)
              final prayers = _dailyTimes!.prayers.where((prayer) => 
                prayer.type != PrayerType.sunrise &&
                prayer.type != PrayerType.midnight &&
                prayer.type != PrayerType.lastThird
              ).toList();
              
              if (index >= prayers.length) return null;
              
              final prayer = prayers[index];
              
              return AnimatedPress(
                onTap: () => _showPrayerDetails(prayer),
                child: PrayerTimeCard(
                  prayer: prayer,
                  forceColored: prayer.isNext,
                  onNotificationToggle: (enabled) {
                    _togglePrayerNotification(prayer, enabled);
                  },
                ),
              );
            },
            childCount: _dailyTimes!.prayers.where((prayer) => 
              prayer.type != PrayerType.sunrise &&
              prayer.type != PrayerType.midnight &&
              prayer.type != PrayerType.lastThird
            ).length,
          ),
        ),
      ),
    ];
  }

  Widget _buildQuickStats() {
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise &&
      prayer.type != PrayerType.midnight &&
      prayer.type != PrayerType.lastThird
    ).toList();
    
    final passedCount = mainPrayers.where((p) => p.isPassed).length;
    final totalCount = mainPrayers.length;
    final progress = totalCount > 0 ? (passedCount / totalCount) : 0.0;
    
    return Container(
      margin: AppTheme.space4.padding,
      child: Row(
        children: [
          // إحصائية الصلوات المؤداة
          Expanded(
            child: AppCard.stat(
              title: 'الصلوات المؤداة',
              value: '$passedCount من $totalCount',
              icon: Icons.check_circle,
              color: AppTheme.success,
            ),
          ),
          
          AppTheme.space3.w,
          
          // نسبة التقدم في اليوم
          Expanded(
            child: AppCard.stat(
              title: 'تقدم اليوم',
              value: '${(progress * 100).toInt()}%',
              icon: Icons.timeline,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverFillRemaining(
      child: AppLoading.page(message: 'جاري تحميل مواقيت الصلاة...'),
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
      child: AppEmptyState.noData(
        message: 'لم يتم تحديد الموقع\nنحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
        onRetry: _loadPrayerTimes,
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
        backgroundColor: enabled ? AppTheme.success : AppTheme.surface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPrayerDetails(PrayerTime prayer) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      builder: (context) => _buildPrayerDetailsSheet(prayer),
    );
  }

  Widget _buildPrayerDetailsSheet(PrayerTime prayer) {
    return Container(
      padding: AppTheme.space4.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppTheme.space4),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // عنوان الصلاة
          Row(
            children: [
              Container(
                padding: AppTheme.space3.padding,
                decoration: BoxDecoration(
                  color: AppTheme.getPrayerColor(prayer.nameAr).withValues(alpha: 0.1),
                  borderRadius: AppTheme.radiusMd.radius,
                ),
                child: Icon(
                  AppTheme.getCategoryColor(prayer.nameAr) as IconData? ?? Icons.mosque,
                  color: AppTheme.getPrayerColor(prayer.nameAr),
                  size: AppTheme.iconLg,
                ),
              ),
              
              AppTheme.space3.w,
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prayer.nameAr,
                      style: AppTheme.titleLarge.copyWith(
                        fontWeight: AppTheme.bold,
                      ),
                    ),
                    Text(
                      prayer.nameEn,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          AppTheme.space4.h,
          
          // معلومات الوقت
          AppCard(
            child: Column(
              children: [
                _buildDetailRow('الوقت', _formatTime(prayer.time)),
                if (prayer.iqamaTime != null) ...[
                  AppTheme.space2.h,
                  _buildDetailRow('الإقامة', _formatTime(prayer.iqamaTime!)),
                ],
                AppTheme.space2.h,
                _buildDetailRow('الحالة', prayer.isNext ? 'قادمة' : prayer.isPassed ? 'انتهت' : 'قادمة'),
                if (prayer.isNext) ...[
                  AppTheme.space2.h,
                  _buildDetailRow('الوقت المتبقي', prayer.remainingTimeText),
                ],
              ],
            ),
          ),
          
          AppTheme.space4.h,
          
          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'إغلاق',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              AppTheme.space3.w,
              
              Expanded(
                child: AppButton.primary(
                  text: 'الإعدادات',
                  icon: Icons.settings,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/prayer-notifications-settings');
                  },
                ),
              ),
            ],
          ),
          
          AppTheme.space4.h,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: AppTheme.semiBold,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}