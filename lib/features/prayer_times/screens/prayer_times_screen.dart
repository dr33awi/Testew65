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
                        child: SizedBox(height: 16),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.mosque,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مواقيت الصلاة',
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: _isRetryingLocation ? null : _requestLocation,
                  icon: _isRetryingLocation 
                      ? SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(context.textSecondaryColor),
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: context.textSecondaryColor,
                        ),
                  tooltip: 'تحديث الموقع',
                ),
              ),
              
              const SizedBox(width: 8),
              
              // زر إعدادات الإشعارات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/prayer-notifications-settings'),
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: context.textSecondaryColor,
                  ),
                  tooltip: 'إعدادات الإشعارات',
                ),
              ),
              
              const SizedBox(width: 8),
              
              // زر الإعدادات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/prayer-settings'),
                  icon: Icon(
                    Icons.settings_outlined,
                    color: context.textSecondaryColor,
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
    final prayerColor = nextPrayer != null 
        ? _getPrayerColor(nextPrayer.type.name)
        : const Color(0xFF6366F1);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            prayerColor.withValues(alpha: 0.9),
            prayerColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    nextPrayer != null 
                        ? _getPrayerIcon(nextPrayer.type.name)
                        : Icons.schedule_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(width: 16),
                
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      if (nextPrayer != null) ...[
                        Text(
                          'الوقت: ${_formatTime(nextPrayer.time)}',
                          style: context.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Text(
                              nextPrayer.remainingTimeText,
                              style: context.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        Text(
                          'حافظ على الصلاة في أوقاتها',
                          style: context.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'وَأَقِمِ الصَّلَاةَ لِذِكْرِي',
                          style: context.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontFamily: 'Amiri',
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
        padding: const EdgeInsets.all(16),
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
        child: SizedBox(height: 32),
      ),
    ];
  }

  Widget _buildPrayerListHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1).withValues(alpha: 0.05),
            const Color(0xFF6366F1).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: Color(0xFF6366F1),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جدول الصلوات اليوم',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
        backgroundColor: Colors.green,
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

  Color _getPrayerColor(String prayerType) {
    switch (prayerType.toLowerCase()) {
      case 'fajr':
        return const Color(0xFF3B82F6); // أزرق
      case 'dhuhr':
        return const Color(0xFFF59E0B); // أصفر
      case 'asr':
        return const Color(0xFFEF4444); // أحمر
      case 'maghrib':
        return const Color(0xFF8B5CF6); // بنفسجي
      case 'isha':
        return const Color(0xFF1F2937); // رمادي داكن
      default:
        return const Color(0xFF6366F1); // أزرق افتراضي
    }
  }

  IconData _getPrayerIcon(String prayerType) {
    switch (prayerType.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.wb_cloudy;
      case 'maghrib':
        return Icons.wb_twilight;
      case 'isha':
        return Icons.nightlight_round;
      default:
        return Icons.schedule_rounded;
    }
  }
}

// إضافة Widgets مفقودة
class AppLoading {
  static Widget page({String? message}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
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
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'خطأ في التحميل',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('المحاولة مرة أخرى'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
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
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.location_on,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
        if (onAction != null && actionText != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.my_location),
            label: Text(actionText),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}