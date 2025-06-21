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
    
    // الاستماع للتحديثات
    _timesSubscription = _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
          _errorMessage = null;
        });
        
        // بدء الحركة
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
      // تحقق من وجود مواقيت مخزنة مسبقاً لعرضها أثناء تحديث الموقع
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
            // App Bar المحسن
            _buildEnhancedAppBar(),
            
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

  Widget _buildEnhancedAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.backgroundColor,
              context.backgroundColor.withValues(alpha: 0.95),
              context.backgroundColor.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.dividerColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          ThemeConstants.space3.w,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مواقيت الصلاة',
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              if (_dailyTimes?.location != null)
                Text(
                  _dailyTimes!.location.cityName ?? 'موقع غير محدد',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        _buildActionButton(
          icon: _isRetryingLocation ? null : Icons.my_location,
          onPressed: _isRetryingLocation ? null : _requestLocation,
          tooltip: 'تحديث الموقع',
          isLoading: _isRetryingLocation,
        ),
        _buildActionButton(
          icon: Icons.notifications_outlined,
          onPressed: () => Navigator.pushNamed(context, '/prayer-notifications-settings'),
          tooltip: 'إعدادات الإشعارات',
        ),
        _buildActionButton(
          icon: Icons.settings_outlined,
          onPressed: () => Navigator.pushNamed(context, '/prayer-settings'),
          tooltip: 'الإعدادات',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData? icon,
    required VoidCallback? onPressed,
    required String tooltip,
    bool isLoading = false,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(right: isLast ? ThemeConstants.space4 : ThemeConstants.space2),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: IconButton(
        icon: isLoading 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeConstants.primary),
                ),
              )
            : Icon(
                icon,
                color: ThemeConstants.primary,
              ),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      // Header مع الموقع
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
                child: LocationHeader(
                  location: _dailyTimes!.location,
                  onTap: _requestLocation,
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
      
      // عنوان قائمة الصلوات
      SliverToBoxAdapter(
        child: AnimatedBuilder(
          animation: _cardsAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _cardsAnimation,
              child: _buildPrayerListHeader(),
            );
          },
        ),
      ),
      
      // قائمة الصلوات المحسنة
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

  Widget _buildPrayerListHeader() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.05),
            ThemeConstants.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: ThemeConstants.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: ThemeConstants.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: ThemeConstants.primary,
              size: ThemeConstants.iconMd,
            ),
          ),
          ThemeConstants.space3.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جدول الصلوات اليوم',
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.backgroundColor,
              ThemeConstants.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space6),
                decoration: BoxDecoration(
                  gradient: ThemeConstants.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeConstants.primary.withValues(alpha: 0.3),
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
              ThemeConstants.space5.h,
              Text(
                'جاري تحميل مواقيت الصلاة...',
                style: context.titleMedium?.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              ThemeConstants.space2.h,
              Text(
                'الرجاء الانتظار بينما نحصل على موقعك',
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(ThemeConstants.space4),
          padding: const EdgeInsets.all(ThemeConstants.space6),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            border: Border.all(
              color: ThemeConstants.error.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: BoxDecoration(
                  color: ThemeConstants.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ThemeConstants.error,
                ),
              ),
              ThemeConstants.space4.h,
              Text(
                'خطأ في تحميل المواقيت',
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              ThemeConstants.space2.h,
              Text(
                _errorMessage ?? 'حدث خطأ غير متوقع',
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              ThemeConstants.space4.h,
              ElevatedButton.icon(
                onPressed: _loadPrayerTimes,
                icon: const Icon(Icons.refresh),
                label: const Text('المحاولة مرة أخرى'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConstants.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space5,
                    vertical: ThemeConstants.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(ThemeConstants.space4),
          padding: const EdgeInsets.all(ThemeConstants.space6),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: const BoxDecoration(
                  gradient: ThemeConstants.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              ThemeConstants.space4.h,
              Text(
                'لم يتم تحديد الموقع',
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              ThemeConstants.space2.h,
              Text(
                'نحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              ThemeConstants.space4.h,
              ElevatedButton.icon(
                onPressed: _loadPrayerTimes,
                icon: const Icon(Icons.my_location),
                label: const Text('تحديد الموقع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConstants.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space5,
                    vertical: ThemeConstants.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  ),
                ),
              ),
            ],
          ),
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