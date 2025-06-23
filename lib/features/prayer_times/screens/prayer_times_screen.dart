// lib/features/prayer_times/screens/prayer_times_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.'),
            action: SnackBarAction(
              label: 'حاول مجدداً',
              onPressed: _requestLocation,
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
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // شريط التنقل العلوي
            _buildAppBar(context),
            
            // المحتوى
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadPrayerTimes,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // رسالة الترحيب
                    if (_dailyTimes != null) ...[
                      SliverToBoxAdapter(
                        child: _buildWelcomeCard(context),
                      ),
                      
                      const SliverToBoxAdapter(
                        child: SizedBox(height: ThemeConstants.space4),
                      ),
                    ],
                    
                    // المحتوى الرئيسي
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // أيقونة التطبيق - استخدام ألوان الثيم
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: ThemeConstants.shadowSm,
            ),
            child: Icon(
              ThemeConstants.iconPrayer,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مواقيت الصلاة',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  _dailyTimes?.location.cityName ?? 'جاري تحديد الموقع...',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // الإجراءات
          Row(
            children: [
              // زر تحديث الموقع
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: _isRetryingLocation ? null : () {
                    HapticFeedback.lightImpact();
                    _requestLocation();
                  },
                  icon: _isRetryingLocation 
                      ? SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: context.primaryColor,
                        ),
                  tooltip: 'تحديث الموقع',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              // زر إعدادات الإشعارات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/prayer-notifications-settings');
                  },
                  icon: Icon(
                    ThemeConstants.iconNotifications,
                    color: context.primaryColor,
                  ),
                  tooltip: 'إعدادات الإشعارات',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              // زر الإعدادات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/prayer-settings');
                  },
                  icon: Icon(
                    ThemeConstants.iconSettings,
                    color: context.primaryColor,
                  ),
                  tooltip: 'الإعدادات',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final nextPrayer = _nextPrayer ?? _dailyTimes?.nextPrayer;
    final prayerGradient = nextPrayer != null 
        ? ThemeConstants.prayerGradient(nextPrayer.type.name)
        : ThemeConstants.primaryGradient;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: prayerGradient,
        boxShadow: [
          BoxShadow(
            color: (nextPrayer != null 
                ? ThemeConstants.getPrayerColor(nextPrayer.type.name)
                : ThemeConstants.primary).withValues(alpha: ThemeConstants.opacity30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                width: ThemeConstants.borderThin,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            ),
            child: Row(
              children: [
                // أيقونة الصلاة مع خلفية دائرية
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                      width: ThemeConstants.borderThin,
                    ),
                  ),
                  child: Icon(
                    nextPrayer != null 
                        ? ThemeConstants.getPrayerIcon(nextPrayer.type.name)
                        : ThemeConstants.iconPrayerTime,
                    color: Colors.white,
                    size: ThemeConstants.icon2xl,
                  ),
                ),
                
                const SizedBox(width: ThemeConstants.space4),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextPrayer != null 
                            ? 'الصلاة القادمة: ${nextPrayer.nameAr}'
                            : 'مواقيت الصلاة',
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      
                      const SizedBox(height: ThemeConstants.space2),
                      
                      if (nextPrayer != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space3,
                            vertical: ThemeConstants.space1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                              width: ThemeConstants.borderThin,
                            ),
                          ),
                          child: Text(
                            'الوقت: ${_formatTime(nextPrayer.time)}',
                            style: context.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.semiBold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space2),
                        
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Text(
                              nextPrayer.remainingTimeText,
                              style: context.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                                fontWeight: ThemeConstants.medium,
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        Text(
                          'وَأَقِمِ الصَّلَاةَ لِذِكْرِي',
                          style: context.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                            fontFamily: ThemeConstants.fontFamilyQuran,
                            height: 1.8,
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space2),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space3,
                            vertical: ThemeConstants.space1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                              width: ThemeConstants.borderThin,
                            ),
                          ),
                          child: Text(
                            'حافظ على الصلاة في أوقاتها',
                            style: context.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                              fontWeight: ThemeConstants.medium,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
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
      
      // عنوان قائمة الصلوات
      SliverToBoxAdapter(
        child: _buildPrayerListHeader(),
      ),
      
      // قائمة الصلوات
      SliverPadding(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final prayers = _dailyTimes!.prayers.where((prayer) => 
                prayer.type != PrayerType.sunrise
              ).toList();
              
              if (index >= prayers.length) return null;
              
              final prayer = prayers[index];
              
              return PrayerTimeCard(
                prayer: prayer,
                forceColored: true,
                onNotificationToggle: (enabled) {
                  _togglePrayerNotification(prayer, enabled);
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

  Widget _buildPrayerListHeader() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity10),
            ThemeConstants.primaryLight.withValues(alpha: ThemeConstants.opacity10),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity20),
          width: ThemeConstants.borderThin,
        ),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity20),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              ThemeConstants.iconPrayerTime,
              color: ThemeConstants.primary,
              size: ThemeConstants.iconMd,
            ),
          ),
          const SizedBox(width: ThemeConstants.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جدول الصلوات اليوم',
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  '${_dailyTimes!.prayers.where((p) => p.type != PrayerType.sunrise).length} صلوات',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverFillRemaining(
      child: Center(
        child: AppLoading.page(
          message: 'جاري تحميل مواقيت الصلاة...',
        ),
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
      child: AppEmptyState.noData(
        message: 'لم يتم تحديد الموقع',
        description: 'نحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
        actionText: 'تحديد الموقع',
        onAction: _loadPrayerTimes,
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
        backgroundColor: ThemeConstants.success,
      ),
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

// Widgets مساعدة محدثة بألوان الثيم
class AppLoading {
  static Widget page({String? message}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space6),
          decoration: BoxDecoration(
            gradient: ThemeConstants.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity30),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: ThemeConstants.space5),
          Text(
            message,
            style: const TextStyle(
              fontWeight: ThemeConstants.semiBold,
              color: ThemeConstants.lightTextPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

class AppEmptyState {
  static Widget error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: ThemeConstants.error.withValues(alpha: ThemeConstants.opacity10),
            shape: BoxShape.circle,
            border: Border.all(
              color: ThemeConstants.error.withValues(alpha: ThemeConstants.opacity30),
              width: ThemeConstants.borderThin,
            ),
          ),
          child: Icon(
            Icons.error_outline,
            size: ThemeConstants.icon3xl,
            color: ThemeConstants.error,
          ),
        ),
        const SizedBox(height: ThemeConstants.space4),
        const Text(
          'خطأ في التحميل',
          style: TextStyle(
            fontSize: ThemeConstants.textSizeXl,
            fontWeight: ThemeConstants.bold,
            color: ThemeConstants.lightTextPrimary,
          ),
        ),
        const SizedBox(height: ThemeConstants.space2),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeConstants.lightTextSecondary,
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: ThemeConstants.space4),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('المحاولة مرة أخرى'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            ),
          ),
        ],
      ],
    );
  }

  static Widget noData({
    required String message,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            gradient: ThemeConstants.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: ThemeConstants.shadowMd,
          ),
          child: Icon(
            Icons.my_location,
            size: ThemeConstants.icon3xl,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: ThemeConstants.space4),
        Text(
          message,
          style: const TextStyle(
            fontSize: ThemeConstants.textSizeXl,
            fontWeight: ThemeConstants.bold,
            color: ThemeConstants.lightTextPrimary,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: ThemeConstants.space2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ThemeConstants.lightTextSecondary,
            ),
          ),
        ],
        if (onAction != null && actionText != null) ...[
          const SizedBox(height: ThemeConstants.space4),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.my_location),
            label: Text(actionText),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            ),
          ),
        ],
      ],
    );
  }
}