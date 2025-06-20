// lib/features/prayer_times/screens/prayer_times_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';

import '../../../app/themes/index.dart';
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    );
    
    _cardsAnimation = CurvedAnimation(
      parent: _cardsAnimationController,
      curve: Curves.easeInOut,
    );
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
        context.showErrorMessage('لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.');
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
        color: context.primaryColor,
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
              context.backgroundColor.withAlpha(242),
              context.backgroundColor.withAlpha(230),
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
                    color: context.borderColor.withAlpha(25),
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
            padding: const EdgeInsets.all(ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withAlpha(77),
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
          const HSpace(ThemeConstants.spaceMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مواقيت الصلاة',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              if (_dailyTimes?.location != null)
                Text(
                  _dailyTimes!.location.cityName ?? 'موقع غير محدد',
                  style: context.captionStyle,
                ),
            ],
          ),
        ],
      ),
      actions: [
        // زر تحديث الموقع
        Container(
          margin: const EdgeInsets.only(right: ThemeConstants.spaceMd),
          decoration: BoxDecoration(
            color: context.cardColor.withAlpha(204),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.borderColor.withAlpha(51),
            ),
          ),
          child: IconButton(
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
            onPressed: _isRetryingLocation ? null : _requestLocation,
            tooltip: 'تحديث الموقع',
          ),
        ),
        
        // زر إعدادات الإشعارات
        Container(
          margin: const EdgeInsets.only(right: ThemeConstants.spaceMd),
          decoration: BoxDecoration(
            color: context.cardColor.withAlpha(204),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.borderColor.withAlpha(51),
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: context.primaryColor,
            ),
            onPressed: () => Navigator.pushNamed(context, '/prayer-notifications-settings'),
            tooltip: 'إعدادات الإشعارات',
          ),
        ),
        
        // زر الإعدادات
        Container(
          margin: const EdgeInsets.only(right: ThemeConstants.spaceLg),
          decoration: BoxDecoration(
            color: context.cardColor.withAlpha(204),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.borderColor.withAlpha(51),
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: context.primaryColor,
            ),
            onPressed: () => Navigator.pushNamed(context, '/prayer-settings'),
            tooltip: 'الإعدادات',
          ),
        ),
      ],
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
              child: Container(
                margin: const EdgeInsets.all(ThemeConstants.spaceLg),
                padding: const EdgeInsets.all(ThemeConstants.spaceLg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor.withAlpha(13),
                      context.primaryColor.withAlpha(26),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  border: Border.all(
                    color: context.primaryColor.withAlpha(26),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.schedule_rounded,
                        color: context.primaryColor,
                        size: ThemeConstants.iconMd,
                      ),
                    ),
                    const HSpace(ThemeConstants.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'جدول الصلوات اليوم',
                            style: context.titleStyle.copyWith(
                              fontWeight: ThemeConstants.fontSemiBold,
                            ),
                          ),
                          Text(
                            '${_dailyTimes!.prayers.where((p) => p.type != PrayerType.sunrise).length} صلوات',
                            style: context.captionStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      
      // قائمة الصلوات المحسنة
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceLg),
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
                        curve: Curves.easeInOut,
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
                          curve: Curves.easeInOut,
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
        child: VSpace(ThemeConstants.spaceXl),
      ),
    ];
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
              context.primaryColor.withAlpha(13),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceXl),
                decoration: BoxDecoration(
                  gradient: ThemeConstants.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withAlpha(77),
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
              const VSpace(ThemeConstants.spaceXl),
              Text(
                'جاري تحميل مواقيت الصلاة...',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontSemiBold,
                ),
              ),
              const VSpace(ThemeConstants.spaceMd),
              Text(
                'الرجاء الانتظار بينما نحصل على موقعك',
                style: context.bodyStyle.copyWith(
                  color: context.secondaryTextColor,
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
          margin: const EdgeInsets.all(ThemeConstants.spaceLg),
          padding: const EdgeInsets.all(ThemeConstants.spaceXl),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            border: Border.all(
              color: ThemeConstants.error.withAlpha(51),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceLg),
                decoration: BoxDecoration(
                  color: ThemeConstants.error.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: ThemeConstants.error,
                ),
              ),
              const VSpace(ThemeConstants.spaceLg),
              Text(
                'خطأ في تحميل المواقيت',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              const VSpace(ThemeConstants.spaceMd),
              Text(
                _errorMessage ?? 'حدث خطأ غير متوقع',
                style: context.bodyStyle.copyWith(
                  color: context.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const VSpace(ThemeConstants.spaceLg),
              IslamicButton.primary(
                text: 'المحاولة مرة أخرى',
                icon: Icons.refresh,
                onPressed: _loadPrayerTimes,
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
          margin: const EdgeInsets.all(ThemeConstants.spaceLg),
          padding: const EdgeInsets.all(ThemeConstants.spaceXl),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceLg),
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
              const VSpace(ThemeConstants.spaceLg),
              Text(
                'لم يتم تحديد الموقع',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              const VSpace(ThemeConstants.spaceMd),
              Text(
                'نحتاج لتحديد موقعك لعرض مواقيت الصلاة الصحيحة',
                style: context.bodyStyle.copyWith(
                  color: context.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const VSpace(ThemeConstants.spaceLg),
              IslamicButton.primary(
                text: 'تحديد الموقع',
                icon: Icons.my_location,
                onPressed: _loadPrayerTimes,
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
    
    context.showSuccessMessage(
      enabled 
          ? 'تم تفعيل تنبيه ${prayer.nameAr}'
          : 'تم إيقاف تنبيه ${prayer.nameAr}',
    );
  }
}