// lib/features/home/screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/index.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';
import '../../prayer_times/services/prayer_times_service.dart';
import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../widgets/home_prayer_times_card.dart';

/// الشاشة الرئيسية للتطبيق
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerTimesService;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // بيانات الشاشة
  String? _nextPrayerName;
  String? _nextPrayerTime;
  Duration? _timeUntilNextPrayer;

  @override
  void initState() {
    super.initState();
    _logger = getService<LoggerService>();
    _prayerTimesService = getService<PrayerTimesService>();
    _initializeAnimations();
    _loadData();
    _startPeriodicUpdates();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadData() async {
    try {
      _logger.info(message: '[HomeScreen] بدء تحميل بيانات الشاشة الرئيسية');
      
      // تحميل أوقات الصلاة
      await _updatePrayerTimes();
      
      // بدء الأنيميشن
      _animationController.forward();
      
      _logger.info(message: '[HomeScreen] تم تحميل البيانات بنجاح');
    } catch (e) {
      _logger.error(
        message: '[HomeScreen] خطأ في تحميل البيانات',
        error: e,
      );
    }
  }

  Future<void> _updatePrayerTimes() async {
    try {
      final todayTimes = await _prayerTimesService.getTodayPrayerTimes();
      if (todayTimes != null) {
        final nextPrayer = await _prayerTimesService.getNextPrayerInfo();
        if (nextPrayer != null) {
          setState(() {
            _nextPrayerName = nextPrayer['name'];
            _nextPrayerTime = nextPrayer['time'];
            _timeUntilNextPrayer = nextPrayer['duration'];
          });
        }
      }
    } catch (e) {
      _logger.error(
        message: '[HomeScreen] خطأ في تحديث أوقات الصلاة',
        error: e,
      );
    }
  }

  void _startPeriodicUpdates() {
    // تحديث الوقت كل دقيقة
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        _updatePrayerTimes();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      // إزالة الـ drawer
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.primaryColor,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false, // إزالة الثلاث خطوط
      actions: [
        IconButton(
          icon: Icon(
            context.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            // تبديل الوضع الليلي/النهاري
            AppTheme.toggleTheme();
          },
          tooltip: context.isDarkMode ? 'الوضع النهاري' : 'الوضع الليلي',
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => AppRouter.push(AppRouter.appSettings),
          tooltip: 'الإعدادات',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(ThemeConstants.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رسالة الترحيب
              const WelcomeMessage(
                userName: 'المؤمن', // يمكن جعله ديناميكي من الإعدادات
                isCompact: false,
              ),
              
              Spaces.large,
              
              // بطاقة الاقتباس اليومي
              DailyQuotesCard(
                isCompact: false,
                showControls: true,
                showMetadata: true,
                onTap: () {
                  // يمكن إضافة التنقل لشاشة الاقتباسات المفصلة
                  context.showMessage('شاشة الاقتباسات المفصلة - قريباً');
                },
              ),
              
              Spaces.large,
              
              // أوقات الصلاة
              HomePrayerTimesCard(
                nextPrayerName: _nextPrayerName,
                nextPrayerTime: _nextPrayerTime,
                timeUntilNextPrayer: _timeUntilNextPrayer,
              ),
              
              Spaces.large,
              
              // الميزات السريعة
              CategoryGrid(),
              
              // مساحة إضافية في الأسفل
              Spaces.extraLarge,
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '$hours ساعة و $minutes دقيقة';
    } else {
      return '${duration.inMinutes} دقيقة';
    }
  }

  Future<void> _handleRefresh() async {
    await _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}