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
      drawer: _buildDrawer(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return IslamicAppBar(
      title: 'تطبيق الأذكار',
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
          icon: const Icon(Icons.notifications),
          onPressed: () => AppRouter.push(AppRouter.notificationSettings),
          tooltip: 'الإشعارات',
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
              WelcomeMessage(
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
              _buildPrayerTimesSection(),
              
              Spaces.large,
              
              // الميزات السريعة
              _buildQuickFeaturesSection(),
              
              Spaces.large,
              
              // الإحصائيات اليومية
              _buildDailyStatsSection(),
              
              // مساحة إضافية في الأسفل
              Spaces.extraLarge,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                decoration: BoxDecoration(
                  color: ThemeConstants.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.mosque,
                  color: ThemeConstants.primary,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Text(
                  'أوقات الصلاة',
                  style: context.titleStyle.copyWith(
                    fontWeight: ThemeConstants.fontBold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AppRouter.push(AppRouter.prayerTimes),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          
          Spaces.medium,
          
          if (_nextPrayerName != null && _nextPrayerTime != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.spaceMd),
              decoration: BoxDecoration(
                gradient: ThemeConstants.primaryGradient,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Column(
                children: [
                  Text(
                    'الصلاة القادمة',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Spaces.small,
                  Text(
                    _nextPrayerName!,
                    style: AppTypography.title.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.fontBold,
                    ),
                  ),
                  Spaces.xs,
                  Text(
                    _nextPrayerTime!,
                    style: AppTypography.subtitle.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  if (_timeUntilNextPrayer != null) ...[
                    Spaces.small,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: Colors.white,
                          size: ThemeConstants.iconSm,
                        ),
                        Spaces.smallH,
                        Text(
                          _formatDuration(_timeUntilNextPrayer!),
                          style: AppTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.spaceLg),
              child: Column(
                children: [
                  Icon(
                    Icons.location_off,
                    size: ThemeConstants.iconLg,
                    color: context.secondaryTextColor,
                  ),
                  Spaces.medium,
                  Text(
                    'يرجى تفعيل الموقع لعرض أوقات الصلاة',
                    style: context.bodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  Spaces.medium,
                  IslamicButton.primary(
                    text: 'تفعيل الموقع',
                    icon: Icons.location_on,
                    onPressed: () => AppRouter.push(AppRouter.prayerSettings),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickFeaturesSection() {
    final features = [
      {
        'title': 'الأذكار',
        'subtitle': 'أذكار الصباح والمساء',
        'icon': Icons.menu_book,
        'color': const Color(0xFF4CAF50),
        'route': AppRouter.athkar,
      },
      {
        'title': 'القبلة',
        'subtitle': 'اتجاه القبلة الشريفة',
        'icon': Icons.explore,
        'color': const Color(0xFF2196F3),
        'route': AppRouter.qibla,
      },
      {
        'title': 'التسبيح',
        'subtitle': 'عداد التسبيح الرقمي',
        'icon': Icons.touch_app,
        'color': const Color(0xFF9C27B0),
        'route': AppRouter.tasbih,
      },
      {
        'title': 'الإعدادات',
        'subtitle': 'إعدادات التطبيق',
        'icon': Icons.settings,
        'color': const Color(0xFF607D8B),
        'route': AppRouter.appSettings,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الميزات السريعة',
          style: context.titleStyle.copyWith(
            fontWeight: ThemeConstants.fontBold,
          ),
        ),
        
        Spaces.medium,
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: ThemeConstants.spaceMd,
            mainAxisSpacing: ThemeConstants.spaceMd,
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(
              title: feature['title'] as String,
              subtitle: feature['subtitle'] as String,
              icon: feature['icon'] as IconData,
              color: feature['color'] as Color,
              onTap: () => AppRouter.push(feature['route'] as String),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IslamicCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              icon,
              color: color,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          Spaces.medium,
          
          Text(
            title,
            style: context.titleStyle.copyWith(
              fontSize: ThemeConstants.fontSizeLg,
              fontWeight: ThemeConstants.fontSemiBold,
            ),
            textAlign: TextAlign.center,
          ),
          
          Spaces.xs,
          
          Text(
            subtitle,
            style: context.captionStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyStatsSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics),
              Spaces.mediumH,
              Text(
                'إحصائيات اليوم',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'أذكار مكتملة',
                  value: '12',
                  color: ThemeConstants.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.touch_app,
                  label: 'تسبيحات',
                  value: '300',
                  color: ThemeConstants.info,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'التقدم',
                  value: '75%',
                  color: ThemeConstants.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: ThemeConstants.iconLg,
        ),
        Spaces.small,
        Text(
          value,
          style: context.titleStyle.copyWith(
            color: color,
            fontWeight: ThemeConstants.fontBold,
          ),
        ),
        Spaces.xs,
        Text(
          label,
          style: context.captionStyle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // رأس الدرج
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              ThemeConstants.spaceLg,
              ThemeConstants.space2xl,
              ThemeConstants.spaceLg,
              ThemeConstants.spaceLg,
            ),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: ThemeConstants.iconLg,
                  ),
                ),
                Spaces.medium,
                Text(
                  'أهلاً وسهلاً',
                  style: AppTypography.title.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.fontBold,
                  ),
                ),
                Text(
                  'المؤمن',
                  style: AppTypography.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          
          // قائمة العناصر
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'الرئيسية',
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.mosque,
                  title: 'مواقيت الصلاة',
                  onTap: () {
                    Navigator.pop(context);
                    AppRouter.push(AppRouter.prayerTimes);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.menu_book,
                  title: 'الأذكار',
                  onTap: () {
                    Navigator.pop(context);
                    AppRouter.push(AppRouter.athkar);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.explore,
                  title: 'اتجاه القبلة',
                  onTap: () {
                    Navigator.pop(context);
                    AppRouter.push(AppRouter.qibla);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.touch_app,
                  title: 'التسبيح',
                  onTap: () {
                    Navigator.pop(context);
                    AppRouter.push(AppRouter.tasbih);
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'الإعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    AppRouter.push(AppRouter.appSettings);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول التطبيق'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تطبيق الأذكار'),
            SizedBox(height: 8),
            Text('الإصدار: 1.0.0'),
            SizedBox(height: 16),
            Text(
              'تطبيق شامل للأذكار ومواقيت الصلاة واتجاه القبلة، مصمم لمساعدتك على الذكر والتقرب إلى الله.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}