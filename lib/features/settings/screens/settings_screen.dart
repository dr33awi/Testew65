// lib/features/settings/screens/settings_screen.dart (احترافي ومحدث)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/layout/app_bar.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import 'package:athkar_app/app/themes/core/theme_notifier.dart';
import '../../../features/prayer_times/services/prayer_times_service.dart';
import '../../../features/prayer_times/models/prayer_time_model.dart';
import '../models/app_settings.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> 
    with SingleTickerProviderStateMixin {
  
  // الخدمات
  late final StorageService _storage;
  late final PermissionService _permissionService;
  late final LoggerService _logger;
  late final ThemeNotifier _themeNotifier;
  late final PrayerTimesService _prayerService;
  
  // Animation
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  // State
  AppSettings _settings = const AppSettings();
  PrayerLocation? _currentLocation;
  bool _loading = true;
  bool _isRefreshing = false;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimations();
    _loadSettings();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _initializeServices() {
    _storage = getIt<StorageService>();
    _permissionService = getIt<PermissionService>();
    _logger = getIt<LoggerService>();
    _themeNotifier = getIt<ThemeNotifier>();
    _prayerService = getIt<PrayerTimesService>();
  }
  
  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveDefault,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveDefault,
    ));
  }
  
  Future<void> _loadSettings() async {
    setState(() => _loading = true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // تأثير تحميل
      
      final settings = AppSettings(
        isDarkMode: _themeNotifier.isDarkMode,
        notificationsEnabled: await _permissionService.checkNotificationPermission(),
        soundEnabled: _storage.getBool('sound_enabled') ?? false,
        vibrationEnabled: _storage.getBool('vibration_enabled') ?? true,
        locationEnabled: _prayerService.currentLocation != null,
        batteryOptimizationDisabled: await _checkBatteryOptimization(),
      );
      
      setState(() {
        _settings = settings;
        _currentLocation = _prayerService.currentLocation;
        _loading = false;
      });
      
      _animationController.forward();
      
      _logger.info(
        message: '[Settings] تم تحميل الإعدادات بنجاح',
        data: settings.toJson(),
      );
    } catch (e) {
      _logger.error(
        message: '[Settings] فشل تحميل الإعدادات',
        error: e,
      );
      
      setState(() => _loading = false);
      _showErrorMessage('فشل تحميل الإعدادات');
    }
  }
  
  Future<bool> _checkBatteryOptimization() async {
    final status = await _permissionService.checkPermissionStatus(
      AppPermissionType.batteryOptimization,
    );
    return status == AppPermissionStatus.granted;
  }
  
  Future<void> _saveSettings() async {
    try {
      await _storage.setBool('sound_enabled', _settings.soundEnabled);
      await _storage.setBool('vibration_enabled', _settings.vibrationEnabled);
      
      _logger.info(
        message: '[Settings] تم حفظ الإعدادات',
        data: _settings.toJson(),
      );
    } catch (e) {
      _logger.error(
        message: '[Settings] فشل حفظ الإعدادات',
        error: e,
      );
      _showErrorMessage('فشل حفظ الإعدادات');
    }
  }
  
  Future<void> _refreshSettings() async {
    if (_isRefreshing) return;
    
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    
    try {
      await _loadSettings();
      _showSuccessMessage('تم تحديث الإعدادات');
    } finally {
      setState(() => _isRefreshing = false);
    }
  }
  
  // ==================== معالجات الإعدادات ====================
  
  Future<void> _toggleTheme(bool value) async {
    HapticFeedback.mediumImpact();
    
    try {
      await _themeNotifier.setTheme(value);
      setState(() => _settings = _settings.copyWith(isDarkMode: value));
      
      _showSuccessMessage(
        value ? 'تم تفعيل الوضع الليلي' : 'تم تفعيل الوضع النهاري'
      );
      
      _logger.logEvent('theme_changed', parameters: {'isDarkMode': value});
    } catch (e) {
      _logger.error(message: '[Settings] فشل تغيير الثيم', error: e);
      _showErrorMessage('فشل تغيير المظهر');
    }
  }
  
  Future<void> _toggleVibration(bool value) async {
    HapticFeedback.lightImpact();
    setState(() => _settings = _settings.copyWith(vibrationEnabled: value));
    await _saveSettings();
    
    if (value) {
      HapticFeedback.mediumImpact(); // تجربة الاهتزاز
    }
  }
  
  Future<void> _handleNotificationPermission() async {
    HapticFeedback.lightImpact();
    
    if (_settings.notificationsEnabled) {
      // فتح إعدادات الإشعارات
      Navigator.pushNamed(context, AppRouter.notificationSettings);
    } else {
      // طلب الإذن
      final granted = await _permissionService.requestNotificationPermission();
      setState(() => _settings = _settings.copyWith(notificationsEnabled: granted));
      
      if (granted) {
        _showSuccessMessage('تم منح إذن الإشعارات');
        _logger.logEvent('notification_permission_granted');
      } else {
        _showWarningMessage(
          'تم رفض إذن الإشعارات. يمكنك تفعيله من إعدادات النظام.',
          action: SnackBarAction(
            label: 'إعدادات',
            onPressed: () => _permissionService.openAppSettings(),
          ),
        );
      }
    }
  }
  
  Future<void> _updateLocation() async {
    HapticFeedback.lightImpact();
    
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    
    try {
      _showInfoMessage('جاري تحديث الموقع...');
      
      final location = await _prayerService.getCurrentLocation();
      await _prayerService.updatePrayerTimes();
      
      setState(() {
        _currentLocation = location;
        _settings = _settings.copyWith(locationEnabled: true);
        _isRefreshing = false;
      });
      
      _showSuccessMessage('تم تحديث الموقع بنجاح');
      
      _logger.info(
        message: '[Settings] تم تحديث الموقع',
        data: {
          'city': location.cityName,
          'country': location.countryName,
        },
      );
    } catch (e) {
      setState(() => _isRefreshing = false);
      _logger.error(message: '[Settings] فشل تحديث الموقع', error: e);
      
      final shouldOpenSettings = await _showConfirmationDialog(
        title: 'فشل تحديد الموقع',
        content: 'لم نتمكن من تحديد موقعك. تحقق من إعدادات الموقع والمحاولة مرة أخرى.',
        confirmText: 'فتح الإعدادات',
        icon: Icons.location_off,
      );
      
      if (shouldOpenSettings) {
        await _permissionService.openAppSettings(AppSettingsType.location);
      }
    }
  }
  
  Future<void> _handleBatteryOptimization() async {
    HapticFeedback.lightImpact();
    
    if (_settings.batteryOptimizationDisabled) {
      _showInfoMessage('إعدادات البطارية محسنة بالفعل');
      return;
    }
    
    final shouldProceed = await _showConfirmationDialog(
      title: 'تحسين البطارية',
      content: 'لضمان عمل التذكيرات في الخلفية، يُنصح بإيقاف تحسين البطارية لهذا التطبيق.',
      confirmText: 'تحسين الآن',
      icon: Icons.battery_saver,
    );
    
    if (shouldProceed) {
      try {
        final granted = await _permissionService.requestPermission(
          AppPermissionType.batteryOptimization,
        );
        
        setState(() {
          _settings = _settings.copyWith(
            batteryOptimizationDisabled: granted == AppPermissionStatus.granted,
          );
        });
        
        if (granted == AppPermissionStatus.granted) {
          _showSuccessMessage('تم تحسين إعدادات البطارية');
        } else {
          await _permissionService.openAppSettings(AppSettingsType.battery);
        }
      } catch (e) {
        _showErrorMessage('فشل تحسين إعدادات البطارية');
      }
    }
  }
  
  Future<void> _clearCache() async {
    HapticFeedback.mediumImpact();
    
    final shouldClear = await _showConfirmationDialog(
      title: 'مسح البيانات المؤقتة',
      content: 'سيتم مسح جميع البيانات المؤقتة والذاكرة المؤقتة. هذا قد يحسن أداء التطبيق.',
      confirmText: 'مسح',
      cancelText: 'إلغاء',
      icon: Icons.cleaning_services,
      destructive: true,
    );
    
    if (shouldClear) {
      try {
        _permissionService.clearPermissionCache();
        // يمكن إضافة مسح أنواع أخرى من الكاش هنا
        
        _showSuccessMessage('تم مسح البيانات المؤقتة بنجاح');
        _logger.logEvent('cache_cleared');
      } catch (e) {
        _showErrorMessage('فشل مسح البيانات المؤقتة');
      }
    }
  }
  
  // ==================== العمليات الخارجية ====================
  
  Future<void> _shareApp() async {
    HapticFeedback.lightImpact();
    
    const shareText = '''
🕌 تطبيق الأذكار - حصن المسلم

تطبيق شامل يحتوي على:
📿 الأذكار اليومية والمسائية
🕐 مواقيت الصلاة الدقيقة
🧭 اتجاه القبلة
📖 القرآن الكريم
🤲 الأدعية المأثورة

حمّل التطبيق مجاناً:
[رابط التطبيق]

#الأذكار #الصلاة #القرآن #الإسلام
''';
    
    try {
      await Share.share(shareText);
      _logger.logEvent('app_shared');
    } catch (e) {
      _showErrorMessage('فشل مشاركة التطبيق');
    }
  }
  
  Future<void> _rateApp() async {
    HapticFeedback.lightImpact();
    
    const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.athkar_app';
    const appStoreUrl = 'https://apps.apple.com/app/id123456789';
    
    try {
      final url = Theme.of(context).platform == TargetPlatform.iOS 
          ? appStoreUrl 
          : playStoreUrl;
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        _logger.logEvent('app_rated');
      } else {
        _showErrorMessage('لا يمكن فتح متجر التطبيقات');
      }
    } catch (e) {
      _showErrorMessage('فشل فتح صفحة التقييم');
    }
  }
  
  Future<void> _contactSupport() async {
    HapticFeedback.lightImpact();
    
    const email = AppConstants.supportEmail;
    const subject = 'استفسار حول تطبيق الأذكار';
    const body = '''
السلام عليكم ورحمة الله وبركاته

أكتب لكم بخصوص:

[اكتب استفسارك هنا]

معلومات التطبيق:
- الإصدار: ${AppConstants.appVersion}
- رقم البناء: ${AppConstants.appBuildNumber}

وجزاكم الله خيراً
''';
    
    final emailUrl = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
        _logger.logEvent('support_contacted');
      } else {
        _showErrorMessage('لا يمكن فتح تطبيق البريد الإلكتروني');
      }
    } catch (e) {
      _showErrorMessage('فشل فتح البريد الإلكتروني');
    }
  }
  
  void _showAboutDialog() {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space6),
                decoration: BoxDecoration(
                  gradient: ThemeConstants.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(ThemeConstants.radiusXl),
                    topRight: Radius.circular(ThemeConstants.radiusXl),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    ThemeConstants.space3.h,
                    Text(
                      AppConstants.appName,
                      style: context.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    Text(
                      'حصن المسلم',
                      style: context.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.space6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.info_outline,
                      label: 'الإصدار',
                      value: AppConstants.appVersion,
                    ),
                    ThemeConstants.space2.h,
                    _InfoRow(
                      icon: Icons.build_outlined,
                      label: 'رقم البناء',
                      value: AppConstants.appBuildNumber,
                    ),
                    ThemeConstants.space4.h,
                    Text(
                      'تطبيق شامل للمسلم يحتوي على الأذكار اليومية ومواقيت الصلاة واتجاه القبلة والمزيد من الميزات الإسلامية المفيدة.',
                      style: context.bodyMedium?.copyWith(height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                    ThemeConstants.space4.h,
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.space4),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: ThemeConstants.error,
                            size: ThemeConstants.iconSm,
                          ),
                          ThemeConstants.space2.w,
                          Expanded(
                            child: Text(
                              'صُنع بحب لخدمة المسلمين في جميع أنحاء العالم',
                              style: context.labelMedium?.copyWith(
                                color: context.primaryColor,
                                fontWeight: ThemeConstants.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ThemeConstants.space4.h,
                    Center(
                      child: Text(
                        '© 2024 جميع الحقوق محفوظة',
                        style: context.labelSmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _contactSupport();
                        },
                        icon: const Icon(Icons.support_agent, size: 18),
                        label: const Text('تواصل معنا'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // ==================== Helper Methods ====================
  
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void _showWarningMessage(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.warning,
        behavior: SnackBarBehavior.floating,
        action: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: context.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  Future<bool> _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmText,
    String cancelText = 'إلغاء',
    IconData? icon,
    bool destructive = false,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        title: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (destructive ? ThemeConstants.error : context.primaryColor)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: destructive ? ThemeConstants.error : context.primaryColor,
                  size: 24,
                ),
              ),
              ThemeConstants.space3.w,
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(
          content,
          style: context.bodyMedium?.copyWith(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: destructive ? ThemeConstants.error : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.simple(title: 'الإعدادات'),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'الإعدادات',
        actions: [
          AppBarAction(
            icon: Icons.refresh,
            onPressed: _refreshSettings,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSettings,
        color: context.primaryColor,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: ThemeConstants.space8),
      child: Column(
        children: [
          ThemeConstants.space4.h,
          
          // حالة سريعة للإعدادات
          _buildQuickStatus(),
          
          // إعدادات مواقيت الصلاة
          SettingsSection(
            title: 'مواقيت الصلاة',
            icon: Icons.mosque_outlined,
            children: [
              SettingsTile(
                icon: Icons.location_on_outlined,
                title: 'الموقع الحالي',
                subtitle: _currentLocation?.displayName ?? 'لم يتم تحديد الموقع',
                onTap: _updateLocation,
                trailing: _isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _currentLocation != null 
                        ? Icon(Icons.check_circle, color: ThemeConstants.success)
                        : Icon(Icons.refresh, color: context.primaryColor),
                enabled: !_isRefreshing,
              ),
              SettingsTile(
                icon: Icons.calculate_outlined,
                title: 'طريقة الحساب',
                subtitle: 'أم القرى (المملكة العربية السعودية)',
                onTap: () => Navigator.pushNamed(context, AppRouter.prayerSettings),
              ),
              SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'إشعارات الصلاة',
                subtitle: 'تخصيص تنبيهات أوقات الصلاة',
                onTap: () => Navigator.pushNamed(context, AppRouter.prayerNotificationsSettings),
              ),
            ],
          ),
          
          // إعدادات الإشعارات والتنبيهات
          SettingsSection(
            title: 'الإشعارات والتنبيهات',
            icon: Icons.notifications_outlined,
            children: [
              SettingsTile(
                icon: Icons.notifications_active_outlined,
                title: 'الإشعارات',
                subtitle: _settings.notificationsEnabled 
                    ? 'الإشعارات مفعلة - اضغط للتخصيص' 
                    : 'الإشعارات معطلة - اضغط للتفعيل',
                onTap: _handleNotificationPermission,
                trailing: _settings.notificationsEnabled
                    ? Icon(Icons.settings, color: context.primaryColor)
                    : Icon(Icons.add_circle, color: ThemeConstants.warning),
                iconColor: _settings.notificationsEnabled 
                    ? ThemeConstants.success 
                    : ThemeConstants.warning,
              ),
              SettingsTile(
                icon: Icons.menu_book_outlined,
                title: 'إشعارات الأذكار',
                subtitle: 'تخصيص تذكيرات الأذكار اليومية',
                onTap: () => Navigator.pushNamed(
                  context, 
                  AppRouter.athkarNotificationsSettings,
                ),
                enabled: _settings.notificationsEnabled,
              ),
              SettingsTile(
                icon: Icons.vibration_outlined,
                title: 'الاهتزاز',
                subtitle: 'تفعيل الاهتزاز مع الإشعارات',
                trailing: Switch.adaptive(
                  value: _settings.vibrationEnabled,
                  onChanged: _toggleVibration,
                  activeColor: context.primaryColor,
                ),
              ),
            ],
          ),
          
          // إعدادات المظهر
          SettingsSection(
            title: 'المظهر والعرض',
            icon: Icons.palette_outlined,
            children: [
              SettingsTile(
                icon: _settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'وضع العرض',
                subtitle: _settings.isDarkMode ? 'الوضع الليلي مفعل' : 'الوضع النهاري مفعل',
                trailing: Switch.adaptive(
                  value: _settings.isDarkMode,
                  onChanged: _toggleTheme,
                  activeColor: context.primaryColor,
                ),
                iconColor: _settings.isDarkMode ? Colors.orange : Colors.blue,
              ),
            ],
          ),
          
          // إعدادات النظام
          SettingsSection(
            title: 'إعدادات النظام',
            icon: Icons.settings_outlined,
            children: [
              SettingsTile(
                icon: Icons.battery_saver_outlined,
                title: 'تحسين البطارية',
                subtitle: _settings.batteryOptimizationDisabled
                    ? 'تم تحسين إعدادات البطارية'
                    : 'يُنصح بتحسين إعدادات البطارية',
                onTap: _handleBatteryOptimization,
                iconColor: _settings.batteryOptimizationDisabled 
                    ? ThemeConstants.success 
                    : ThemeConstants.warning,
                trailing: _settings.batteryOptimizationDisabled
                    ? Icon(Icons.check_circle, color: ThemeConstants.success)
                    : Icon(Icons.warning, color: ThemeConstants.warning),
              ),
              SettingsTile(
                icon: Icons.cleaning_services_outlined,
                title: 'مسح البيانات المؤقتة',
                subtitle: 'تحسين أداء التطبيق ومساحة التخزين',
                onTap: _clearCache,
              ),
            ],
          ),
          
          // حول التطبيق والدعم
          SettingsSection(
            title: 'الدعم والمعلومات',
            icon: Icons.help_outline,
            children: [
              SettingsTile(
                icon: Icons.share_outlined,
                title: 'مشاركة التطبيق',
                subtitle: 'شارك التطبيق مع الأصدقاء والعائلة',
                onTap: _shareApp,
              ),
              SettingsTile(
                icon: Icons.star_outline,
                title: 'تقييم التطبيق',
                subtitle: 'قيم التطبيق على المتجر وادعمنا',
                onTap: _rateApp,
              ),
              SettingsTile(
                icon: Icons.support_agent_outlined,
                title: 'تواصل معنا',
                subtitle: 'أرسل استفساراتك ومقترحاتك',
                onTap: _contactSupport,
              ),
              SettingsTile(
                icon: Icons.info_outline,
                title: 'عن التطبيق',
                subtitle: 'معلومات الإصدار والمطور',
                onTap: _showAboutDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickStatus() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: ThemeConstants.primaryGradient,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حالة الإعدادات',
            style: context.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          ThemeConstants.space3.h,
          Row(
            children: [
              Expanded(
                child: _StatusIndicator(
                  icon: Icons.notifications,
                  label: 'الإشعارات',
                  isActive: _settings.notificationsEnabled,
                ),
              ),
              Expanded(
                child: _StatusIndicator(
                  icon: Icons.location_on,
                  label: 'الموقع',
                  isActive: _settings.locationEnabled,
                ),
              ),
              Expanded(
                child: _StatusIndicator(
                  icon: Icons.battery_saver,
                  label: 'البطارية',
                  isActive: _settings.batteryOptimizationDisabled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget لمؤشر الحالة
class _StatusIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _StatusIndicator({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.6),
            size: 20,
          ),
        ),
        ThemeConstants.space1.h,
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Widget لعرض معلومة في الـ Dialog
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconSm,
          color: context.textSecondaryColor,
        ),
        ThemeConstants.space2.w,
        Text(
          '$label: ',
          style: context.labelMedium?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        Text(
          value,
          style: context.labelMedium?.copyWith(
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ],
    );
  }
}

// Extension للموقع
extension PrayerLocationExtension on PrayerLocation {
  String get displayName {
    if (cityName != null && countryName != null) {
      return '$cityName، $countryName';
    } else if (cityName != null) {
      return cityName!;
    } else if (countryName != null) {
      return countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }
}