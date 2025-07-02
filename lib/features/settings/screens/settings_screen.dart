// lib/features/settings/screens/settings_screen.dart - محدثة بالكامل للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/settings_services_manager.dart';
import '../widgets/service_status_widgets.dart';

import '../models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> 
    with AutomaticKeepAliveClientMixin {
  
  SettingsServicesManager? _servicesManager;
  LoggerService? _logger;
  
  AppSettings _settings = const AppSettings();
  ServiceStatus _serviceStatus = ServiceStatus.initial();
  bool _loading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  
  Stream<AppSettings>? _settingsStream;
  Stream<ServiceStatus>? _serviceStatusStream;
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }
  
  void _initializeServices() {
    try {
      _logger = getServiceSafe<LoggerService>();
      _servicesManager = getServiceSafe<SettingsServicesManager>();
      
      if (_servicesManager == null) {
        _handleServicesError('فشل في الحصول على مدير الإعدادات');
        return;
      }
      
      if (_logger == null) {
        debugPrint('[Settings] LoggerService غير متوفر');
      }
      
      _initializeStreams();
      _loadSettings();
      
    } catch (e, stackTrace) {
      debugPrint('[Settings] خطأ في تهيئة الخدمات: $e');
      debugPrint('StackTrace: $stackTrace');
      _handleServicesError('فشل في تهيئة الخدمات: ${e.toString()}');
    }
  }
  
  void _initializeStreams() {
    if (_servicesManager == null) return;
    
    try {
      _settingsStream = _servicesManager!.settingsStream;
      _serviceStatusStream = _servicesManager!.serviceStatusStream;
      
      _settingsStream?.listen(
        (settings) {
          if (mounted) {
            setState(() {
              _settings = settings;
              _errorMessage = null;
            });
          }
        },
        onError: (error) {
          _logger?.error(
            message: '[Settings] خطأ في stream الإعدادات',
            error: error,
          );
          if (mounted) {
            setState(() {
              _errorMessage = 'خطأ في تحديث الإعدادات: ${error.toString()}';
            });
          }
        },
        cancelOnError: false,
      );
      
      _serviceStatusStream?.listen(
        (status) {
          if (mounted) {
            setState(() {
              _serviceStatus = status;
              _errorMessage = null;
            });
          }
        },
        onError: (error) {
          _logger?.error(
            message: '[Settings] خطأ في stream حالة الخدمات',
            error: error,
          );
          if (mounted) {
            setState(() {
              _errorMessage = 'خطأ في تحديث حالة الخدمات: ${error.toString()}';
            });
          }
        },
        cancelOnError: false,
      );
      
      _logger?.debug(message: '[Settings] تم تهيئة الـ Streams بنجاح');
      
    } catch (e) {
      _logger?.error(
        message: '[Settings] خطأ في تهيئة الـ Streams',
        error: e,
      );
      _handleServicesError('فشل في تهيئة الـ Streams: ${e.toString()}');
    }
  }
  
  void _handleServicesError(String error) {
    setState(() {
      _errorMessage = error;
      _loading = false;
    });
    _useDefaultValues();
  }
  
  void _useDefaultValues() {
    setState(() {
      _settings = const AppSettings();
      _serviceStatus = ServiceStatus.initial();
    });
  }
  
  Future<void> _loadSettings() async {
    if (_servicesManager == null) {
      _handleServicesError('مدير الخدمات غير متوفر');
      return;
    }
    
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    
    try {
      final result = await _servicesManager!.loadSettings();
      
      if (result.isSuccess && result.settings != null && result.serviceStatus != null) {
        setState(() {
          _settings = result.settings!;
          _serviceStatus = result.serviceStatus!;
          _loading = false;
          _errorMessage = null;
        });
        
        _logger?.info(
          message: '[Settings] تم تحميل الإعدادات بنجاح',
          data: _settings.toJson(),
        );
      } else {
        throw Exception(result.error ?? 'فشل غير معروف');
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'فشل تحميل الإعدادات: ${e.toString()}';
      });
      
      _logger?.error(
        message: '[Settings] خطأ في تحميل الإعدادات',
        error: e,
      );
      
      _useDefaultValues();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showErrorMessage('فشل تحميل الإعدادات. تم استخدام القيم الافتراضية.');
        }
      });
    }
  }
  
  Future<void> _refreshSettings() async {
    if (_isRefreshing) return;
    
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    
    try {
      if (_servicesManager != null) {
        await _servicesManager!.refreshAllServices();
        _showSuccessMessage('تم تحديث الإعدادات');
      } else {
        _initializeServices();
        _showSuccessMessage('تم إعادة تهيئة الخدمات');
      }
    } catch (e) {
      _logger?.error(
        message: '[Settings] فشل في تحديث الإعدادات',
        error: e,
      );
      _showErrorMessage('فشل في تحديث الإعدادات: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }
  
  // ==================== معالجات الإعدادات ====================
  
  Future<void> _toggleTheme(bool value) async {
    HapticFeedback.mediumImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final newSettings = _settings.copyWith(isDarkMode: value);
      final success = await _servicesManager!.saveSettings(newSettings);
      
      if (success) {
        _showSuccessMessage(
          value ? 'تم تفعيل الوضع الليلي' : 'تم تفعيل الوضع النهاري'
        );
        _logger?.logEvent('theme_changed', parameters: {'isDarkMode': value});
      } else {
        _showErrorMessage('فشل تغيير المظهر');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تغيير الثيم', error: e);
      _showErrorMessage('فشل تغيير المظهر: ${e.toString()}');
    }
  }
  
  Future<void> _toggleVibration(bool value) async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final newSettings = _settings.copyWith(vibrationEnabled: value);
      await _servicesManager!.saveSettings(newSettings);
      
      if (value) {
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تحديث الاهتزاز', error: e);
      _showErrorMessage('فشل تحديث إعدادات الاهتزاز: ${e.toString()}');
    }
  }
  
  Future<void> _toggleSound(bool value) async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final newSettings = _settings.copyWith(soundEnabled: value);
      await _servicesManager!.saveSettings(newSettings);
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تحديث الصوت', error: e);
      _showErrorMessage('فشل تحديث إعدادات الصوت: ${e.toString()}');
    }
  }
  
  Future<void> _handleNotificationPermission() async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      if (_settings.notificationsEnabled) {
        Navigator.pushNamed(context, AppRouter.notificationSettings);
      } else {
        final result = await _servicesManager!.requestPermission(
          AppPermissionType.notification,
        );
        
        if (result.isSuccess && result.status == AppPermissionStatus.granted) {
          _showSuccessMessage('تم منح إذن الإشعارات');
          _logger?.logEvent('notification_permission_granted');
        } else {
          _showPermissionDeniedDialog('الإشعارات');
        }
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل في معالجة إذن الإشعارات', error: e);
      _showErrorMessage('فشل في معالجة إذن الإشعارات: ${e.toString()}');
    }
  }
  
  Future<void> _handleLocationUpdate() async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    
    try {
      _showInfoMessage('جاري تحديث الموقع...');
      
      final result = await _servicesManager!.updatePrayerLocation();
      
      if (result.isSuccess) {
        _showSuccessMessage('تم تحديث الموقع بنجاح');
        
        _logger?.info(
          message: '[Settings] تم تحديث الموقع',
          data: {
            'location': result.location?.toString() ?? 'غير محدد',
          },
        );
      } else {
        throw Exception(result.error ?? 'فشل غير معروف');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تحديث الموقع', error: e);
      
      final shouldOpenSettings = await _showConfirmationDialog(
        title: 'فشل تحديد الموقع',
        content: 'لم نتمكن من تحديد موقعك. تحقق من إعدادات الموقع والمحاولة مرة أخرى.\n\nالخطأ: ${e.toString()}',
        confirmText: 'فتح الإعدادات',
        icon: Icons.location_off,
      );
      
      if (shouldOpenSettings && _servicesManager != null) {
        await _servicesManager!.openAppSettings(AppSettingsType.location);
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }
  
  Future<void> _handleBatteryOptimization() async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    if (_settings.batteryOptimizationDisabled) {
      _showInfoMessage('إعدادات البطارية محسنة بالفعل');
      return;
    }
    
    try {
      final shouldProceed = await _showConfirmationDialog(
        title: 'تحسين البطارية',
        content: 'لضمان عمل التذكيرات في الخلفية، يُنصح بإيقاف تحسين البطارية لهذا التطبيق.',
        confirmText: 'تحسين الآن',
        icon: Icons.battery_saver,
      );
      
      if (shouldProceed) {
        final result = await _servicesManager!.optimizeBatterySettings();
        
        if (result.isSuccess && result.isOptimized) {
          _showSuccessMessage('تم تحسين إعدادات البطارية');
        } else {
          _showBatteryOptimizationFailedDialog();
        }
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تحسين البطارية', error: e);
      _showErrorMessage('فشل تحسين إعدادات البطارية: ${e.toString()}');
    }
  }
  
  Future<void> _requestAllPermissions() async {
    HapticFeedback.mediumImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final shouldProceed = await _showConfirmationDialog(
        title: 'طلب جميع الأذونات',
        content: 'سيتم طلب جميع الأذونات المطلوبة لتشغيل التطبيق بأفضل شكل ممكن.',
        confirmText: 'متابعة',
        icon: Icons.security,
      );
      
      if (!shouldProceed) return;
      
      final permissions = [
        AppPermissionType.notification,
        AppPermissionType.location,
        AppPermissionType.batteryOptimization,
      ];
      
      // ✅ استخدام AppLoading الموحد
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppLoading.page(
          message: 'جاري طلب الأذونات...',
        ),
      );
      
      final result = await _servicesManager!.requestMultiplePermissions(
        permissions,
        onProgress: (progress) {},
      );
      
      if (mounted) {
        Navigator.pop(context);
      }
      
      if (result.isSuccess) {
        final grantedCount = result.results.values
            .where((status) => status == AppPermissionStatus.granted)
            .length;
        
        if (grantedCount == permissions.length) {
          _showSuccessMessage('تم منح جميع الأذونات بنجاح!');
        } else {
          _showPartialPermissionDialog(result);
        }
      } else {
        _showErrorMessage('فشل في طلب الأذونات: ${result.error ?? "خطأ غير معروف"}');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
      _logger?.error(message: '[Settings] فشل طلب الأذونات', error: e);
      _showErrorMessage('حدث خطأ أثناء طلب الأذونات: ${e.toString()}');
    }
  }
  
  // ==================== باقي الدوال ====================
  
  Future<void> _shareApp() async {
    try {
      const appUrl = 'https://play.google.com/store/apps/details?id=com.athkar.app';
      const shareText = '''
🕌 ${AppConstants.appName} - ${AppConstants.appVersion}

تطبيق شامل للأذكار والأدعية الإسلامية مع مواقيت الصلاة واتجاه القبلة.

📱 حمل التطبيق الآن:
$appUrl

#الأذكار #القرآن #الصلاة #اسلامي
      ''';
      
      await Share.share(shareText);
      _logger?.logEvent('app_shared');
    } catch (e) {
      _logger?.error(message: '[Settings] فشل مشاركة التطبيق', error: e);
      _showErrorMessage('فشل في مشاركة التطبيق');
    }
  }
  
  Future<void> _rateApp() async {
    try {
      const appUrl = 'https://play.google.com/store/apps/details?id=com.athkar.app';
      if (await canLaunchUrl(Uri.parse(appUrl))) {
        await launchUrl(Uri.parse(appUrl));
        _logger?.logEvent('app_rated');
      } else {
        _showErrorMessage('لا يمكن فتح متجر التطبيقات');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل فتح تقييم التطبيق', error: e);
      _showErrorMessage('فشل في فتح صفحة التقييم');
    }
  }
  
  Future<void> _contactSupport() async {
    try {
      final emailUrl = Uri(
        scheme: 'mailto',
        path: AppConstants.supportEmail,
        query: 'subject=استفسار حول ${AppConstants.appName} - الإصدار ${AppConstants.appVersion}',
      );
      
      if (await canLaunchUrl(emailUrl)) {
        await launchUrl(emailUrl);
        _logger?.logEvent('support_contacted');
      } else {
        await Clipboard.setData(const ClipboardData(text: AppConstants.supportEmail));
        _showSuccessMessage('تم نسخ البريد الإلكتروني للدعم');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل فتح الدعم', error: e);
      _showErrorMessage('فشل في فتح البريد الإلكتروني');
    }
  }
  
  void _showAboutDialog() {
    AppInfoDialog.show(
      context: context,
      title: AppConstants.appName,
      content: '''
حصن المسلم - تطبيق شامل للمسلم

الإصدار: ${AppConstants.appVersion}
رقم البناء: ${AppConstants.appBuildNumber}

تطبيق شامل للمسلم يحتوي على الأذكار اليومية ومواقيت الصلاة واتجاه القبلة والمزيد من الميزات الإسلامية المفيدة.

صُنع بحب لخدمة المسلمين في جميع أنحاء العالم.

© 2024 جميع الحقوق محفوظة''',
      icon: AppIconsSystem.info,
      accentColor: AppColorSystem.primary,
      actions: [
        DialogAction(
          label: 'تواصل معنا',
          onPressed: () {
            Navigator.of(context).pop();
            _contactSupport();
          },
          isPrimary: true,
        ),
      ],
    );
  }
  
  String _getPermissionDisplayName(AppPermissionType permission) {
    switch (permission) {
      case AppPermissionType.notification:
        return 'الإشعارات';
      case AppPermissionType.location:
        return 'الموقع';
      case AppPermissionType.batteryOptimization:
        return 'تحسين البطارية';
      case AppPermissionType.storage:
        return 'التخزين';
      case AppPermissionType.doNotDisturb:
        return 'عدم الإزعاج';
      case AppPermissionType.unknown:
        return 'غير معروف';
    }
  }
  
  // ==================== Helper Methods - النظام الموحد ====================
  
  void _showSuccessMessage(String message) {
    if (!mounted) return;
    AppSnackBar.showSuccess(context: context, message: message);
  }
  
  void _showErrorMessage(String message) {
    if (!mounted) return;
    AppSnackBar.showError(
      context: context,
      message: message,
      action: SnackBarAction(
        label: 'إعادة المحاولة',
        textColor: Colors.white,
        onPressed: _refreshSettings,
      ),
    );
  }
  
  void _showInfoMessage(String message) {
    if (!mounted) return;
    AppSnackBar.showInfo(context: context, message: message);
  }
  
  Future<bool> _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmText,
    String cancelText = 'إلغاء',
    IconData? icon,
    bool destructive = false,
  }) async {
    if (!mounted) return false;
    
    return await AppInfoDialog.showConfirmation(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: destructive,
    ) ?? false;
  }
  
  void _showPermissionDeniedDialog(String permissionName) {
    if (!mounted) return;
    
    AppInfoDialog.show(
      context: context,
      title: 'إذن $permissionName مطلوب',
      content: 'لاستخدام هذه الميزة، يجب منح إذن $permissionName. يمكنك تفعيله من إعدادات التطبيق.',
      icon: AppIconsSystem.getStateIcon('warning'),
      accentColor: AppColorSystem.warning,
      actions: [
        DialogAction(
          label: 'فتح الإعدادات',
          onPressed: () async {
            Navigator.of(context).pop();
            if (_servicesManager != null) {
              await _servicesManager!.openAppSettings();
            }
          },
          isPrimary: true,
        ),
      ],
    );
  }
  
  void _showBatteryOptimizationFailedDialog() {
    if (!mounted) return;
    
    AppInfoDialog.show(
      context: context,
      title: 'تحسين البطارية',
      content: 'لم نتمكن من تحسين إعدادات البطارية تلقائياً. يرجى فتح إعدادات النظام وإيقاف تحسين البطارية لهذا التطبيق يدوياً.',
      icon: Icons.battery_saver,
      accentColor: AppColorSystem.warning,
      actions: [
        DialogAction(
          label: 'فتح الإعدادات',
          onPressed: () async {
            Navigator.of(context).pop();
            if (_servicesManager != null) {
              await _servicesManager!.openAppSettings(AppSettingsType.battery);
            }
          },
          isPrimary: true,
        ),
      ],
    );
  }
  
  void _showPartialPermissionDialog(BatchPermissionResult result) {
    if (!mounted) return;
    
    final deniedPermissions = result.deniedPermissions
        .map((p) => _getPermissionDisplayName(p))
        .join('، ');
    
    AppInfoDialog.show(
      context: context,
      title: 'أذونات مفقودة',
      content: 'تم منح بعض الأذونات بنجاح، لكن الأذونات التالية لم يتم منحها:\n\n$deniedPermissions\n\nيمكنك منحها لاحقاً من إعدادات التطبيق.',
      icon: AppIconsSystem.getStateIcon('warning'),
      accentColor: AppColorSystem.warning,
      actions: [
        DialogAction(
          label: 'فتح الإعدادات',
          onPressed: () async {
            Navigator.of(context).pop();
            if (_servicesManager != null) {
              await _servicesManager!.openAppSettings();
            }
          },
          isPrimary: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (_errorMessage != null && _servicesManager == null) {
      return Scaffold(
        backgroundColor: AppColorSystem.getBackground(context),
        appBar: CustomAppBar.simple(
          title: 'الإعدادات',
          actions: [
            AppBarAction(
              icon: AppIconsSystem.loading,
              onPressed: () {
                setState(() => _errorMessage = null);
                _initializeServices();
              },
              tooltip: 'إعادة المحاولة',
            ),
          ],
        ),
        body: _buildErrorView(),
      );
    }
    
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColorSystem.getBackground(context),
        appBar: CustomAppBar.simple(title: 'الإعدادات'),
        body: _buildLoadingView(),
      );
    }

    return Scaffold(
      backgroundColor: AppColorSystem.getBackground(context),
      appBar: CustomAppBar.simple(
        title: 'الإعدادات',
        actions: [
          AppBarAction(
            icon: AppIconsSystem.loading,
            onPressed: _refreshSettings,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSettings,
        color: AppColorSystem.primary,
        child: _buildContent(),
      ),
    );
  }
  
  Widget _buildErrorView() {
    return AppEmptyState.error(
      message: _errorMessage ?? 'حدث خطأ غير معروف',
      onRetry: () {
        setState(() => _errorMessage = null);
        _initializeServices();
      },
    );
  }
  
  Widget _buildLoadingView() {
    return AppLoading.page(
      message: 'جاري تحميل الإعدادات...',
      color: AppColorSystem.primary,
    );
  }
  
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: ThemeConstants.space8),
      child: Column(
        children: [
          const SizedBox(height: ThemeConstants.space4),
          
          if (_errorMessage != null) _buildErrorBanner(),
          
          if (_servicesManager != null)
            ServiceStatusOverview(
              status: _serviceStatus,
              servicesManager: _servicesManager!,
              onRefresh: _refreshSettings,
            ),
          
          // ✅ القسم الأول: الأذونات
          _buildPermissionsSection(),
          
          // ✅ القسم الثاني: الإشعارات
          _buildNotificationsSection(),
          
          // ✅ القسم الثالث: المظهر
          _buildAppearanceSection(),
          
          // ✅ القسم الرابع: الدعم
          _buildSupportSection(),
        ],
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return AppCard.custom(
      type: CardType.normal,
      style: CardStyle.normal,
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس القسم
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: AppColorSystem.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.radiusMd),
                topRight: Radius.circular(ThemeConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  AppIconsSystem.getStateIcon('success'),
                  color: AppColorSystem.primary,
                  size: ThemeConstants.iconMd,
                ),
                const SizedBox(width: ThemeConstants.space3),
                Text(
                  'الأذونات والصلاحيات',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColorSystem.primary,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى القسم
          _buildPermissionTile(
            icon: Icons.notifications_active_outlined,
            title: 'الإشعارات',
            subtitle: _settings.notificationsEnabled 
                ? 'الإشعارات مفعلة - اضغط للتخصيص' 
                : 'الإشعارات معطلة - اضغط للتفعيل',
            onTap: _handleNotificationPermission,
            trailing: _settings.notificationsEnabled
                ? const Icon(Icons.settings, color: AppColorSystem.primary)
                : const Icon(Icons.add_circle, color: AppColorSystem.warning),
            iconColor: _settings.notificationsEnabled 
                ? AppColorSystem.success 
                : AppColorSystem.warning,
            showWarning: !_settings.notificationsEnabled,
            enabled: _servicesManager != null,
          ),
          
          _buildDivider(),
          
          _buildPermissionTile(
            icon: Icons.location_on_outlined,
            title: 'الموقع للصلاة',
            subtitle: _serviceStatus.locationAvailable
                ? 'الموقع محدد - اضغط للتحديث'
                : 'لم يتم تحديد الموقع',
            onTap: _handleLocationUpdate,
            trailing: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : _serviceStatus.locationAvailable
                    ? const Icon(Icons.refresh, color: AppColorSystem.primary)
                    : const Icon(Icons.add_location, color: AppColorSystem.warning),
            enabled: !_isRefreshing && _servicesManager != null,
            iconColor: _serviceStatus.locationAvailable
                ? AppColorSystem.success
                : AppColorSystem.warning,
            showWarning: !_serviceStatus.locationAvailable,
          ),
          
          _buildDivider(),
          
          _buildPermissionTile(
            icon: Icons.battery_saver_outlined,
            title: 'تحسين البطارية',
            subtitle: _settings.batteryOptimizationDisabled
                ? 'تم تحسين إعدادات البطارية'
                : 'يُنصح بتحسين إعدادات البطارية',
            onTap: _handleBatteryOptimization,
            iconColor: _settings.batteryOptimizationDisabled 
                ? AppColorSystem.success 
                : AppColorSystem.warning,
            trailing: _settings.batteryOptimizationDisabled
                ? const Icon(Icons.check_circle, color: AppColorSystem.success)
                : const Icon(Icons.warning, color: AppColorSystem.warning),
            showWarning: !_settings.batteryOptimizationDisabled,
            enabled: _servicesManager != null,
          ),
          
          _buildDivider(),
          
          _buildPermissionTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'طلب جميع الأذونات',
            subtitle: 'تفعيل جميع الأذونات دفعة واحدة',
            onTap: _requestAllPermissions,
            iconColor: AppColorSystem.primary,
            trailing: const Icon(Icons.security_update_good, color: AppColorSystem.primary),
            enabled: _servicesManager != null,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return AppCard.custom(
      type: CardType.normal,
      style: CardStyle.normal,
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس القسم
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: AppColorSystem.accent.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.radiusMd),
                topRight: Radius.circular(ThemeConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColorSystem.accent,
                  size: ThemeConstants.iconMd,
                ),
                const SizedBox(width: ThemeConstants.space3),
                Text(
                  'الإشعارات والتنبيهات',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColorSystem.accent,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
          
          _buildSettingTile(
            icon: Icons.menu_book_outlined,
            title: 'إشعارات الأذكار',
            subtitle: 'تخصيص تذكيرات الأذكار اليومية',
            onTap: () => Navigator.pushNamed(
              context, 
              AppRouter.athkarNotificationsSettings,
            ),
            enabled: _settings.notificationsEnabled,
          ),
          
          _buildDivider(),
          
          _buildSettingTile(
            icon: Icons.mosque_outlined,
            title: 'إشعارات الصلاة',
            subtitle: 'تخصيص تنبيهات أوقات الصلاة',
            onTap: () => Navigator.pushNamed(context, AppRouter.prayerNotificationsSettings),
            enabled: _settings.notificationsEnabled,
          ),
          
          _buildDivider(),
          
          _buildSwitchTile(
            icon: Icons.volume_up_outlined,
            title: 'الصوت',
            subtitle: 'تفعيل الأصوات مع الإشعارات',
            value: _settings.soundEnabled,
            onChanged: _servicesManager != null ? _toggleSound : null,
            enabled: _settings.notificationsEnabled && _servicesManager != null,
          ),
          
          _buildDivider(),
          
          _buildSwitchTile(
            icon: Icons.vibration_outlined,
            title: 'الاهتزاز',
            subtitle: 'تفعيل الاهتزاز مع الإشعارات',
            value: _settings.vibrationEnabled,
            onChanged: _servicesManager != null ? _toggleVibration : null,
            enabled: _servicesManager != null,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return AppCard.custom(
      type: CardType.normal,
      style: CardStyle.normal,
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس القسم
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: AppColorSystem.tertiary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.radiusMd),
                topRight: Radius.circular(ThemeConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.palette_outlined,
                  color: AppColorSystem.tertiary,
                  size: ThemeConstants.iconMd,
                ),
                const SizedBox(width: ThemeConstants.space3),
                Text(
                  'المظهر والعرض',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColorSystem.tertiary,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
          
          _buildSwitchTile(
            icon: _settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'وضع العرض',
            subtitle: _settings.isDarkMode ? 'الوضع الليلي مفعل' : 'الوضع النهاري مفعل',
            value: _settings.isDarkMode,
            onChanged: _servicesManager != null ? _toggleTheme : null,
            iconColor: _settings.isDarkMode ? Colors.orange : Colors.blue,
            enabled: _servicesManager != null,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return AppCard.custom(
      type: CardType.normal,
      style: CardStyle.normal,
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس القسم
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: AppColorSystem.info.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.radiusMd),
                topRight: Radius.circular(ThemeConstants.radiusMd),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.help_outline,
                  color: AppColorSystem.info,
                  size: ThemeConstants.iconMd,
                ),
                const SizedBox(width: ThemeConstants.space3),
                Text(
                  'الدعم والمعلومات',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColorSystem.info,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
          
          _buildSettingTile(
            icon: Icons.share_outlined,
            title: 'مشاركة التطبيق',
            subtitle: 'شارك التطبيق مع الأصدقاء والعائلة',
            onTap: _shareApp,
          ),
          
          _buildDivider(),
          
          _buildSettingTile(
            icon: Icons.star_outline,
            title: 'تقييم التطبيق',
            subtitle: 'قيم التطبيق على المتجر وادعمنا',
            onTap: _rateApp,
          ),
          
          _buildDivider(),
          
          _buildSettingTile(
            icon: Icons.support_agent_outlined,
            title: 'تواصل معنا',
            subtitle: 'أرسل استفساراتك ومقترحاتك',
            onTap: _contactSupport,
          ),
          
          _buildDivider(),
          
          _buildSettingTile(
            icon: AppIconsSystem.info,
            title: 'عن التطبيق',
            subtitle: 'معلومات الإصدار والمطور',
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      child: AppNoticeCard.error(
        title: 'خطأ في النظام',
        message: _errorMessage!,
        onClose: () => setState(() => _errorMessage = null),
      ),
    );
  }

  // =============== Helper Widgets ===============

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required Color iconColor,
    Widget? trailing,
    bool showWarning = false,
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: enabled 
                          ? iconColor.withValues(alpha: 0.1)
                          : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: Icon(
                      icon,
                      color: enabled 
                          ? iconColor
                          : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
                      size: ThemeConstants.iconMd,
                    ),
                  ),
                  
                  if (showWarning)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColorSystem.warning,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: ThemeConstants.space4),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label1.copyWith(
                        color: enabled 
                            ? AppColorSystem.getTextPrimary(context)
                            : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.7),
                        fontWeight: ThemeConstants.medium,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space1),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: enabled 
                            ? AppColorSystem.getTextSecondary(context)
                            : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (trailing != null) ...[
                const SizedBox(width: ThemeConstants.space3),
                trailing,
              ] else if (onTap != null && enabled) ...[
                const SizedBox(width: ThemeConstants.space3),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ThemeConstants.iconSm,
                  color: AppColorSystem.getTextSecondary(context).withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
    bool enabled = true,
  }) {
    final effectiveIconColor = iconColor ?? AppColorSystem.primary;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: enabled 
                      ? effectiveIconColor.withValues(alpha: 0.1)
                      : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: enabled 
                      ? effectiveIconColor
                      : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
                  size: ThemeConstants.iconMd,
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space4),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label1.copyWith(
                        color: enabled 
                            ? AppColorSystem.getTextPrimary(context)
                            : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.7),
                        fontWeight: ThemeConstants.medium,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space1),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: enabled 
                            ? AppColorSystem.getTextSecondary(context)
                            : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (trailing != null) ...[
                const SizedBox(width: ThemeConstants.space3),
                trailing,
              ] else if (onTap != null && enabled) ...[
                const SizedBox(width: ThemeConstants.space3),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ThemeConstants.iconSm,
                  color: AppColorSystem.getTextSecondary(context).withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? iconColor,
    bool enabled = true,
  }) {
    final effectiveIconColor = iconColor ?? AppColorSystem.primary;
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: enabled 
                  ? effectiveIconColor.withValues(alpha: 0.1)
                  : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: enabled 
                  ? effectiveIconColor
                  : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space4),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.label1.copyWith(
                    color: enabled 
                        ? AppColorSystem.getTextPrimary(context)
                        : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.7),
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: enabled 
                        ? AppColorSystem.getTextSecondary(context)
                        : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          Switch.adaptive(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppColorSystem.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: ThemeConstants.space6,
      endIndent: ThemeConstants.space6,
      color: AppColorSystem.getDivider(context).withValues(alpha: 0.3),
    );
  }
}