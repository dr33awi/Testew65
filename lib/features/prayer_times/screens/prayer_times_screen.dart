// lib/features/prayer_times/screens/prayer_times_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';
import '../widgets/prayer_time_card.dart';
import '../widgets/next_prayer_countdown.dart';
import '../widgets/prayer_calendar_strip.dart';
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
  late final PermissionService _permissionService;
  
  // Controllers
  final _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // State
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  bool _isLoading = true;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();
  
  // Subscriptions
  StreamSubscription<DailyPrayerTimes>? _timesSubscription;
  StreamSubscription<PrayerTime?>? _nextPrayerSubscription;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _loadPrayerTimes();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _permissionService = getIt<PermissionService>();
    
    // تهيئة خدمة مواقيت الصلاة
    _prayerService = PrayerTimesService(
      logger: _logger,
      storage: getIt(),
      permissionService: _permissionService,
    );
    
    // الاستماع للتحديثات
    _timesSubscription = _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
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

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
    );
    
    _fadeController.forward();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // التحقق من وجود موقع محفوظ
      if (_prayerService.currentLocation == null) {
        // طلب الموقع
        await _requestLocation();
      } else {
        // تحديث المواقيت
        await _prayerService.updatePrayerTimes(date: _selectedDate);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocation() async {
    try {
      final location = await _prayerService.getCurrentLocation();
      _logger.logEvent('prayer_location_obtained', parameters: {
        'city': location.cityName ?? 'unknown',
        'country': location.countryName ?? 'unknown',
      });
    } catch (e) {
      _logger.error(
        message: 'فشل الحصول على الموقع',
        error: e,
      );
      
      if (mounted) {
        setState(() {
          _errorMessage = 'لم نتمكن من تحديد موقعك. يرجى التحقق من إعدادات الموقع.';
          _isLoading = false;
        });
      }
    }
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    
    HapticFeedback.lightImpact();
    _prayerService.updatePrayerTimes(date: date);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    _prayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // App Bar
          _buildAppBar(),
          
          // المحتوى
          if (_isLoading)
            _buildLoadingState()
          else if (_errorMessage != null)
            _buildErrorState()
          else if (_dailyTimes != null)
            ..._buildContent()
          else
            _buildEmptyState(),
        ],
      ),
      
      // زر الإعدادات العائم
      floatingActionButton: _buildFAB(),
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
          icon: const Icon(Icons.my_location),
          onPressed: _requestLocation,
          tooltip: 'تحديث الموقع',
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: LocationHeader(
            location: _dailyTimes!.location,
            onTap: _requestLocation,
          ),
        ),
      ),
      
      // شريط التقويم
      SliverPersistentHeader(
        pinned: true,
        delegate: _CalendarStripDelegate(
          selectedDate: _selectedDate,
          onDateChanged: _onDateChanged,
        ),
      ),
      
      // العد التنازلي للصلاة التالية
      if (_nextPrayer != null)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: NextPrayerCountdown(
                nextPrayer: _nextPrayer!,
                currentPrayer: _dailyTimes!.currentPrayer,
              ),
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
              
              return Padding(
                padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
                child: AnimationConfiguration.staggeredList(
                  position: index,
                  duration: ThemeConstants.durationNormal,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: PrayerTimeCard(
                        prayer: prayer,
                        onNotificationToggle: (enabled) {
                          _togglePrayerNotification(prayer, enabled);
                        },
                      ),
                    ),
                  ),
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
            ThemeConstants.space4.h,
            Text(
              'جاري تحميل مواقيت الصلاة...',
              style: context.bodyLarge,
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

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        HapticFeedback.lightImpact();
        _showQiblaDirection();
      },
      icon: const Icon(Icons.explore),
      label: const Text('اتجاه القبلة'),
      backgroundColor: context.primaryColor,
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

  void _showQiblaDirection() {
    Navigator.pushNamed(context, '/qibla');
  }
}

// Delegate للتقويم
class _CalendarStripDelegate extends SliverPersistentHeaderDelegate {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  _CalendarStripDelegate({
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: context.backgroundColor,
      child: PrayerCalendarStrip(
        selectedDate: selectedDate,
        onDateChanged: onDateChanged,
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant _CalendarStripDelegate oldDelegate) {
    return selectedDate != oldDelegate.selectedDate;
  }
}