// lib/features/settings/screens/settings_screen.dart (محسن ومطور)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../models/app_settings.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late final StorageService _storage;
  late final PermissionService _permissionService;
  late final LoggerService _logger;
  late final AnimationController _animationController;
  
  AppSettings _settings = const AppSettings();
  bool _loading = true;
  
  @override
  void initState() {
    super.initState();
    _storage = getIt<StorageService>();
    _permissionService = getIt<PermissionService>();
    _logger = getIt<LoggerService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    _loadSettings();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSettings() async {
    try {
      final settings = AppSettings(
        isDarkMode: _storage.getBool('theme_mode') ?? false,
        language: _storage.getString('app_language') ?? 'ar',
        notificationsEnabled: await _permissionService.checkNotificationPermission(),
        soundEnabled: _storage.getBool('sound_enabled') ?? false,
        vibrationEnabled: _storage.getBool('vibration_enabled') ?? true,
        fontSize: _storage.getDouble('font_size') ?? 16.0,
      );
      
      setState(() {
        _settings = settings;
        _loading = false;
      });
      
      _animationController.forward();
      
      _logger.info(
        message: '[Settings] تم تحميل الإعدادات',
        data: settings.toJson(),
      );
    } catch (e) {
      _logger.error(
        message: '[Settings] فشل تحميل الإعدادات',
        error: e,
      );
      setState(() => _loading = false);
      context.showErrorSnackBar('فشل تحميل الإعدادات');
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      await _storage.setBool('theme_mode', _settings.isDarkMode);
      await _storage.setString('app_language', _settings.language);
      await _storage.setBool('sound_enabled', _settings.soundEnabled);
      await _storage.setBool('vibration_enabled', _settings.vibrationEnabled);
      await _storage.setDouble('font_size', _settings.fontSize);
      
      _logger.info(
        message: '[Settings] تم حفظ الإعدادات',
        data: _settings.toJson(),
      );
    } catch (e) {
      _logger.error(
        message: '[Settings] فشل حفظ الإعدادات',
        error: e,
      );
      context.showErrorSnackBar('فشل حفظ الإعدادات');
    }
  }
  
  Future<void> _toggleTheme(bool value) async {
    HapticFeedback.lightImpact();
    setState(() {
      _settings = _settings.copyWith(isDarkMode: value);
    });
    await _saveSettings();
    // TODO: تطبيق تغيير الثيم فوراً
    context.showSuccessSnackBar(
      value ? 'تم تفعيل الوضع الليلي' : 'تم تفعيل الوضع النهاري'
    );
  }
  
  Future<void> _changeLanguage(String? value) async {
    if (value == null || value == _settings.language) return;
    
    HapticFeedback.lightImpact();
    setState(() {
      _settings = _settings.copyWith(language: value);
    });
    await _saveSettings();
    
    // عرض رسالة تأكيد
    final shouldRestart = await AppInfoDialog.showConfirmation(
      context: context,
      title: 'تغيير اللغة',
      content: 'يجب إعادة تشغيل التطبيق لتطبيق تغيير اللغة. هل تريد إعادة التشغيل الآن؟',
      confirmText: 'إعادة التشغيل',
      cancelText: 'لاحقاً',
      icon: Icons.language,
    );
    
    if (shouldRestart == true) {
      // TODO: إعادة تشغيل التطبيق
      SystemNavigator.pop(); // خروج مؤقت
    }
  }
  
  Future<void> _toggleVibration(bool value) async {
    HapticFeedback.lightImpact();
    setState(() {
      _settings = _settings.copyWith(vibrationEnabled: value);
    });
    await _saveSettings();
  }
  
  Future<void> _changeFontSize(double value) async {
    setState(() {
      _settings = _settings.copyWith(fontSize: value);
    });
    await _saveSettings();
  }
  
  Future<void> _requestNotificationPermission() async {
    final granted = await _permissionService.requestNotificationPermission();
    setState(() {
      _settings = _settings.copyWith(notificationsEnabled: granted);
    });
    
    if (granted) {
      context.showSuccessSnackBar('تم منح إذن الإشعارات');
    } else {
      context.showErrorSnackBar('تم رفض إذن الإشعارات');
    }
  }
  
  Future<void> _shareApp() async {
    HapticFeedback.lightImpact();
    const text = '''
🕌 تطبيق الأذكار - حصن المسلم

تطبيق شامل يحتوي على:
📿 الأذكار اليومية
🕐 مواقيت الصلاة
🧭 اتجاه القبلة
📖 القرآن الكريم

حمّل التطبيق مجاناً:
[رابط التطبيق]
''';
    
    try {
      await Share.share(text);
      _logger.logEvent('app_shared');
    } catch (e) {
      context.showErrorSnackBar('فشل مشاركة التطبيق');
    }
  }
  
  Future<void> _rateApp() async {
    HapticFeedback.lightImpact();
    const url = 'https://play.google.com/store/apps/details?id=com.example.athkar_app';
    
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        _logger.logEvent('app_rated');
      } else {
        context.showErrorSnackBar('لا يمكن فتح المتجر');
      }
    } catch (e) {
      context.showErrorSnackBar('فشل فتح صفحة التقييم');
    }
  }
  
  Future<void> _openLocationSettings() async {
    HapticFeedback.lightImpact();
    final hasPermission = await _permissionService.checkPermissionStatus(
      AppPermissionType.location,
    );
    
    if (hasPermission == AppPermissionStatus.granted) {
      context.showSuccessSnackBar('إذن الموقع ممنوح بالفعل');
    } else {
      final result = await _permissionService.requestPermission(
        AppPermissionType.location,
      );
      
      if (result == AppPermissionStatus.granted) {
        context.showSuccessSnackBar('تم منح إذن الموقع');
      } else if (result == AppPermissionStatus.permanentlyDenied) {
        final shouldOpenSettings = await AppInfoDialog.showConfirmation(
          context: context,
          title: 'إذن الموقع مطلوب',
          content: 'يرجى منح إذن الموقع من إعدادات التطبيق لحساب أوقات الصلاة بدقة',
          confirmText: 'فتح الإعدادات',
          cancelText: 'إلغاء',
          icon: Icons.location_off,
        );
        
        if (shouldOpenSettings == true) {
          await _permissionService.openAppSettings();
        }
      }
    }
  }
  
  Future<void> _openBatterySettings() async {
    HapticFeedback.lightImpact();
    final hasPermission = await _permissionService.checkPermissionStatus(
      AppPermissionType.batteryOptimization,
    );
    
    if (hasPermission == AppPermissionStatus.granted) {
      context.showSuccessSnackBar('إعدادات البطارية محسنة بالفعل');
    } else {
      final shouldOpenSettings = await AppInfoDialog.showConfirmation(
        context: context,
        title: 'تحسين البطارية',
        content: 'لضمان عمل التذكيرات في الخلفية، يُنصح بإيقاف تحسين البطارية لهذا التطبيق',
        confirmText: 'فتح الإعدادات',
        cancelText: 'إلغاء',
        icon: Icons.battery_saver,
      );
      
      if (shouldOpenSettings == true) {
        await _permissionService.openAppSettings(AppSettingsType.battery);
      }
    }
  }
  
  Future<void> _clearCache() async {
    HapticFeedback.mediumImpact();
    final shouldClear = await AppInfoDialog.showConfirmation(
      context: context,
      title: 'مسح البيانات المؤقتة',
      content: 'سيتم مسح جميع البيانات المؤقتة والكاش. هذا قد يحسن أداء التطبيق.',
      confirmText: 'مسح',
      cancelText: 'إلغاء',
      icon: Icons.cleaning_services,
      destructive: true,
    );
    
    if (shouldClear == true) {
      try {
        // مسح الكاش
        _permissionService.clearPermissionCache();
        
        // TODO: مسح كاش الصور والبيانات الأخرى
        
        context.showSuccessSnackBar('تم مسح البيانات المؤقتة');
        _logger.logEvent('cache_cleared');
      } catch (e) {
        context.showErrorSnackBar('فشل مسح البيانات المؤقتة');
      }
    }
  }
  
  void _showAboutDialog() {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: ThemeConstants.primaryGradient,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: ThemeConstants.iconMd,
              ),
            ),
            ThemeConstants.space3.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: context.titleLarge,
                  ),
                  Text(
                    'حصن المسلم',
                    style: context.labelMedium?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
            ThemeConstants.space3.h,
            Text(
              'تطبيق شامل للمسلم يحتوي على الأذكار اليومية ومواقيت الصلاة واتجاه القبلة والمزيد من الميزات الإسلامية.',
              style: context.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
            ThemeConstants.space3.h,
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space3),
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
                      'صُنع بحب لخدمة المسلمين',
                      style: context.labelMedium?.copyWith(
                        color: context.primaryColor,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ThemeConstants.space3.h,
            Text(
              '© 2024 جميع الحقوق محفوظة',
              style: context.labelSmall?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(color: context.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.simple(title: 'الإعدادات'),
        body: Center(
          child: AppLoading.page(message: 'جاري تحميل الإعدادات...'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // AppBar متقدم
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            snap: true,
            backgroundColor: context.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'الإعدادات',
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: ThemeConstants.primaryGradient,
                ),
              ),
            ),
          ),
          
          // المحتوى
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: ThemeConstants.curveDefault,
                    )),
                    child: _buildContent(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent() {
    return Column(
      children: [
        // إعدادات الإشعارات
        SettingsSection(
          title: 'الإشعارات والتنبيهات',
          icon: Icons.notifications_outlined,
          children: [
            SettingsTile(
              icon: Icons.notifications_active_outlined,
              title: 'الإشعارات',
              subtitle: _settings.notificationsEnabled 
                  ? 'الإشعارات مفعلة' 
                  : 'الإشعارات معطلة',
              trailing: _settings.notificationsEnabled
                  ? Icon(Icons.check_circle, color: ThemeConstants.success)
                  : TextButton(
                      onPressed: _requestNotificationPermission,
                      child: const Text('تفعيل'),
                    ),
            ),
            SettingsTile(
              icon: Icons.mosque_outlined,
              title: 'إشعارات الصلاة',
              subtitle: 'تخصيص تنبيهات أوقات الصلاة',
              onTap: () => Navigator.pushNamed(
                context, 
                AppRouter.prayerNotificationsSettings,
              ),
            ),
            SettingsTile(
              icon: Icons.menu_book_outlined,
              title: 'إشعارات الأذكار',
              subtitle: 'تخصيص تذكيرات الأذكار اليومية',
              onTap: () => Navigator.pushNamed(
                context, 
                AppRouter.athkarNotificationsSettings,
              ),
            ),
            SettingsTile(
              icon: Icons.vibration_outlined,
              title: 'الاهتزاز',
              subtitle: 'تفعيل الاهتزاز مع الإشعارات',
              trailing: Switch(
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
              subtitle: _settings.isDarkMode ? 'الوضع الليلي' : 'الوضع النهاري',
              trailing: Switch(
                value: _settings.isDarkMode,
                onChanged: _toggleTheme,
                activeColor: context.primaryColor,
              ),
            ),
            SettingsTile(
              icon: Icons.language_outlined,
              title: 'اللغة',
              subtitle: _settings.language == 'ar' ? 'العربية' : 'English',
              trailing: DropdownButton<String>(
                value: _settings.language,
                onChanged: _changeLanguage,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                items: const [
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
              ),
            ),
            SettingsTile(
              icon: Icons.text_fields_outlined,
              title: 'حجم الخط',
              subtitle: 'تخصيص حجم النصوص',
              trailing: SizedBox(
                width: 120,
                child: Slider(
                  value: _settings.fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  label: '${_settings.fontSize.round()}',
                  onChanged: _changeFontSize,
                  activeColor: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
        
        // إعدادات عامة
        SettingsSection(
          title: 'الإعدادات العامة',
          icon: Icons.tune_outlined,
          children: [
            SettingsTile(
              icon: Icons.location_on_outlined,
              title: 'الموقع',
              subtitle: 'إعدادات الموقع لحساب أوقات الصلاة',
              onTap: _openLocationSettings,
            ),
            SettingsTile(
              icon: Icons.battery_saver_outlined,
              title: 'تحسين البطارية',
              subtitle: 'إدارة استهلاك البطارية',
              onTap: _openBatterySettings,
            ),
            SettingsTile(
              icon: Icons.cleaning_services_outlined,
              title: 'مسح البيانات المؤقتة',
              subtitle: 'تحسين أداء التطبيق',
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
              subtitle: 'قيم التطبيق على المتجر',
              onTap: _rateApp,
            ),
            SettingsTile(
              icon: Icons.info_outline,
              title: 'عن التطبيق',
              subtitle: 'معلومات الإصدار والمطور',
              onTap: _showAboutDialog,
            ),
          ],
        ),
        
        // مساحة إضافية
        ThemeConstants.space8.h,
      ],
    );
  }
}

// ويدجت لعرض معلومة في الـ Dialog
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