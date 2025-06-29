// lib/features/settings/screens/settings_screen.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ✅ استيراد النظام الموحد
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/themes/widgets/extended_cards.dart';

import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/settings_services_manager.dart';
import '../widgets/service_status_widgets.dart' hide ServiceStatus;
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
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
          _showErrorSnackBar('فشل تحميل الإعدادات. تم استخدام القيم الافتراضية.');
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
        _showSuccessSnackBar('تم تحديث الإعدادات');
      } else {
        _initializeServices();
        _showSuccessSnackBar('تم إعادة تهيئة الخدمات');
      }
    } catch (e) {
      _logger?.error(
        message: '[Settings] فشل في تحديث الإعدادات',
        error: e,
      );
      _showErrorSnackBar('فشل في تحديث الإعدادات: ${e.toString()}');
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
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final newSettings = _settings.copyWith(isDarkMode: value);
      final success = await _servicesManager!.saveSettings(newSettings);
      
      if (success) {
        _showSuccessSnackBar(
          value ? 'تم تفعيل الوضع الليلي' : 'تم تفعيل الوضع النهاري'
        );
        _logger?.logEvent('theme_changed', parameters: {'isDarkMode': value});
      } else {
        _showErrorSnackBar('فشل تغيير المظهر');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تغيير الثيم', error: e);
      _showErrorSnackBar('فشل تغيير المظهر: ${e.toString()}');
    }
  }
  
  Future<void> _toggleVibration(bool value) async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
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
      _showErrorSnackBar('فشل تحديث إعدادات الاهتزاز: ${e.toString()}');
    }
  }
  
  Future<void> _toggleSound(bool value) async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final newSettings = _settings.copyWith(soundEnabled: value);
      await _servicesManager!.saveSettings(newSettings);
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تحديث الصوت', error: e);
      _showErrorSnackBar('فشل تحديث إعدادات الصوت: ${e.toString()}');
    }
  }
  
  Future<void> _handleNotificationPermission() async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
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
          _showSuccessSnackBar('تم منح إذن الإشعارات');
          _logger?.logEvent('notification_permission_granted');
        } else {
          _showPermissionDeniedDialog('الإشعارات');
        }
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل في معالجة إذن الإشعارات', error: e);
      _showErrorSnackBar('فشل في معالجة إذن الإشعارات: ${e.toString()}');
    }
  }
  
  Future<void> _handleLocationUpdate() async {
    HapticFeedback.lightImpact();
    
    if (_servicesManager == null) {
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
      return;
    }
    
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    
    try {
      _showInfoSnackBar('جاري تحديث الموقع...');
      
      final result = await _servicesManager!.updatePrayerLocation();
      
      if (result.isSuccess) {
        _showSuccessSnackBar('تم تحديث الموقع بنجاح');
        
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
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
      return;
    }
    
    if (_settings.batteryOptimizationDisabled) {
      _showInfoSnackBar('إعدادات البطارية محسنة بالفعل');
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
          _showSuccessSnackBar('تم تحسين إعدادات البطارية');
        } else {
          _showBatteryOptimizationFailedDialog();
        }
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل تحسين البطارية', error: e);
      _showErrorSnackBar('فشل تحسين إعدادات البطارية: ${e.toString()}');
    }
  }
  
  Future<void> _requestAllPermissions() async {
    HapticFeedback.mediumImpact();
    
    if (_servicesManager == null) {
      _showErrorSnackBar('مدير الإعدادات غير متوفر');
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
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _PermissionProgressDialog(),
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
          _showSuccessSnackBar('تم منح جميع الأذونات بنجاح!');
        } else {
          _showPartialPermissionDialog(result);
        }
      } else {
        _showErrorSnackBar('فشل في طلب الأذونات: ${result.error ?? "خطأ غير معروف"}');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
      _logger?.error(message: '[Settings] فشل طلب الأذونات', error: e);
      _showErrorSnackBar('حدث خطأ أثناء طلب الأذونات: ${e.toString()}');
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
      _showErrorSnackBar('فشل في مشاركة التطبيق');
    }
  }
  
  Future<void> _rateApp() async {
    try {
      const appUrl = 'https://play.google.com/store/apps/details?id=com.athkar.app';
      if (await canLaunchUrl(Uri.parse(appUrl))) {
        await launchUrl(Uri.parse(appUrl));
        _logger?.logEvent('app_rated');
      } else {
        _showErrorSnackBar('لا يمكن فتح متجر التطبيقات');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل فتح تقييم التطبيق', error: e);
      _showErrorSnackBar('فشل في فتح صفحة التقييم');
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
        _showSuccessSnackBar('تم نسخ البريد الإلكتروني للدعم');
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل فتح الدعم', error: e);
      _showErrorSnackBar('فشل في فتح البريد الإلكتروني');
    }
  }
  
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => _AboutDialog(
        servicesManager: _servicesManager,
        onContactSupport: _contactSupport,
      ),
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
  
  // ==================== Helper Methods ====================
  
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
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: destructive ? AppTheme.error : AppTheme.primary),
              AppTheme.space2.w,
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: cancelText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton.primary(
            text: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor: destructive ? AppTheme.error : null,
          ),
        ],
      ),
    ) ?? false;
  }
  
  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إذن $permissionName مطلوب'),
        content: Text(
          'لاستخدام هذه الميزة، يجب منح إذن $permissionName. يمكنك تفعيله من إعدادات التطبيق.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: 'لاحقاً',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: 'فتح الإعدادات',
            onPressed: () async {
              Navigator.of(context).pop();
              if (_servicesManager != null) {
                await _servicesManager!.openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }
  
  void _showBatteryOptimizationFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحسين البطارية'),
        content: const Text(
          'لم نتمكن من تحسين إعدادات البطارية تلقائياً. يرجى فتح إعدادات النظام وإيقاف تحسين البطارية لهذا التطبيق يدوياً.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: 'لاحقاً',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: 'فتح الإعدادات',
            onPressed: () async {
              Navigator.of(context).pop();
              if (_servicesManager != null) {
                await _servicesManager!.openAppSettings(AppSettingsType.battery);
              }
            },
          ),
        ],
      ),
    );
  }
  
  void _showPartialPermissionDialog(BatchPermissionResult result) {
    final deniedPermissions = result.deniedPermissions
        .map((p) => _getPermissionDisplayName(p))
        .join('، ');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('أذونات مفقودة'),
        content: Text(
          'تم منح بعض الأذونات بنجاح، لكن الأذونات التالية لم يتم منحها:\n\n$deniedPermissions\n\nيمكنك منحها لاحقاً من إعدادات التطبيق.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: 'موافق',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: 'فتح الإعدادات',
            onPressed: () async {
              Navigator.of(context).pop();
              if (_servicesManager != null) {
                await _servicesManager!.openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (_errorMessage != null && _servicesManager == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: SimpleAppBar(
          title: 'الإعدادات',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
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
        backgroundColor: AppTheme.background,
        appBar: const SimpleAppBar(title: 'الإعدادات'),
        body: AppLoading.page(message: 'جاري تحميل الإعدادات...'),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: SimpleAppBar(
        title: 'الإعدادات',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSettings,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSettings,
        color: AppTheme.primary,
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
  
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: AppTheme.space8),
      child: Column(
        children: [
          AppTheme.space4.h,
          
          if (_errorMessage != null) _buildErrorBanner(),
          
          if (_servicesManager != null)
            ServiceStatusOverview(
              status: _serviceStatus,
              servicesManager: _servicesManager!,
              onRefresh: _refreshSettings,
            ),
          
          SettingsSection(
            title: 'الأذونات والصلاحيات',
            icon: Icons.security_outlined,
            children: [
              SettingCard(
                icon: Icons.notifications_active_outlined,
                title: 'الإشعارات',
                subtitle: _settings.notificationsEnabled 
                    ? 'الإشعارات مفعلة - اضغط للتخصيص' 
                    : 'الإشعارات معطلة - اضغط للتفعيل',
                onTap: _handleNotificationPermission,
                trailing: _settings.notificationsEnabled
                    ? const Icon(Icons.settings, color: AppTheme.primary)
                    : const Icon(Icons.add_circle, color: AppTheme.warning),
                color: _settings.notificationsEnabled 
                    ? AppTheme.success 
                    : AppTheme.warning,
              ),
              SettingCard(
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
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                        ),
                      )
                    : _serviceStatus.locationAvailable
                        ? const Icon(Icons.refresh, color: AppTheme.primary)
                        : const Icon(Icons.add_location, color: AppTheme.warning),
                color: _serviceStatus.locationAvailable
                    ? AppTheme.success
                    : AppTheme.warning,
              ),
              SettingCard(
                icon: Icons.battery_saver_outlined,
                title: 'تحسين البطارية',
                subtitle: _settings.batteryOptimizationDisabled
                    ? 'تم تحسين إعدادات البطارية'
                    : 'يُنصح بتحسين إعدادات البطارية',
                onTap: _handleBatteryOptimization,
                color: _settings.batteryOptimizationDisabled 
                    ? AppTheme.success 
                    : AppTheme.warning,
                trailing: _settings.batteryOptimizationDisabled
                    ? const Icon(Icons.check_circle, color: AppTheme.success)
                    : const Icon(Icons.warning, color: AppTheme.warning),
              ),
              SettingCard(
                icon: Icons.admin_panel_settings_outlined,
                title: 'طلب جميع الأذونات',
                subtitle: 'تفعيل جميع الأذونات دفعة واحدة',
                onTap: _requestAllPermissions,
                color: AppTheme.primary,
                trailing: const Icon(Icons.security_update_good, color: AppTheme.primary),
              ),
            ],
          ),
          
          SettingsSection(
            title: 'الإشعارات والتنبيهات',
            icon: Icons.notifications_outlined,
            children: [
              SettingCard.navigation(
                icon: Icons.menu_book_outlined,
                title: 'إشعارات الأذكار',
                subtitle: 'تخصيص تذكيرات الأذكار اليومية',
                onTap: () => Navigator.pushNamed(
                  context, 
                  AppRouter.athkarNotificationsSettings,
                ),
              ),
              SettingCard.navigation(
                icon: Icons.mosque_outlined,
                title: 'إشعارات الصلاة',
                subtitle: 'تخصيص تنبيهات أوقات الصلاة',
                onTap: () => Navigator.pushNamed(context, AppRouter.prayerNotificationsSettings),
              ),
              SettingCard.toggle(
                icon: Icons.volume_up_outlined,
                title: 'الصوت',
                subtitle: 'تفعيل الأصوات مع الإشعارات',
                value: _settings.soundEnabled,
                onChanged: _servicesManager != null ? _toggleSound : null,
              ),
              SettingCard.toggle(
                icon: Icons.vibration_outlined,
                title: 'الاهتزاز',
                subtitle: 'تفعيل الاهتزاز مع الإشعارات',
                value: _settings.vibrationEnabled,
                onChanged: _servicesManager != null ? _toggleVibration : null,
              ),
            ],
          ),
          
          SettingsSection(
            title: 'المظهر والعرض',
            icon: Icons.palette_outlined,
            children: [
              SettingCard.toggle(
                icon: _settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'وضع العرض',
                subtitle: _settings.isDarkMode ? 'الوضع الليلي مفعل' : 'الوضع النهاري مفعل',
                value: _settings.isDarkMode,
                onChanged: _servicesManager != null ? _toggleTheme : null,
                color: _settings.isDarkMode ? Colors.orange : Colors.blue,
              ),
            ],
          ),
          
          SettingsSection(
            title: 'الدعم والمعلومات',
            icon: Icons.help_outline,
            children: [
              SettingCard.navigation(
                icon: Icons.share_outlined,
                title: 'مشاركة التطبيق',
                subtitle: 'شارك التطبيق مع الأصدقاء والعائلة',
                onTap: _shareApp,
              ),
              SettingCard.navigation(
                icon: Icons.star_outline,
                title: 'تقييم التطبيق',
                subtitle: 'قيم التطبيق على المتجر وادعمنا',
                onTap: _rateApp,
              ),
              SettingCard.navigation(
                icon: Icons.support_agent_outlined,
                title: 'تواصل معنا',
                subtitle: 'أرسل استفساراتك ومقترحاتك',
                onTap: _contactSupport,
              ),
              SettingCard.navigation(
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
  
  Widget _buildErrorBanner() {
    return Container(
      margin: AppTheme.space4.padding,
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusMd.radius,
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: AppTheme.error,
            size: 20,
          ),
          AppTheme.space2.w,
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.error,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _errorMessage = null),
            icon: const Icon(
              Icons.close,
              color: AppTheme.error,
              size: 20,
            ),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // ==================== Helper Methods ====================
  
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.info,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }
}

// ==================== Dialogs مساعدة ====================

class _AboutDialog extends StatelessWidget {
  final SettingsServicesManager? servicesManager;
  final VoidCallback onContactSupport;

  const _AboutDialog({
    required this.servicesManager,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.radiusXl.radius,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppTheme.space6.padding,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusXl),
                  topRight: Radius.circular(AppTheme.radiusXl),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppTheme.radiusMd.radius,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  AppTheme.space3.h,
                  Text(
                    AppConstants.appName,
                    style: AppTheme.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.bold,
                    ),
                  ),
                  Text(
                    'حصن المسلم',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: AppTheme.space6.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.info_outline,
                    label: 'الإصدار',
                    value: AppConstants.appVersion,
                  ),
                  AppTheme.space2.h,
                  _InfoRow(
                    icon: Icons.build_outlined,
                    label: 'رقم البناء',
                    value: AppConstants.appBuildNumber,
                  ),
                  AppTheme.space4.h,
                  Text(
                    'تطبيق شامل للمسلم يحتوي على الأذكار اليومية ومواقيت الصلاة واتجاه القبلة والمزيد من الميزات الإسلامية المفيدة.',
                    style: AppTheme.bodyMedium.copyWith(height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                  AppTheme.space4.h,
                  Container(
                    padding: AppTheme.space4.padding,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: AppTheme.radiusMd.radius,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: AppTheme.error,
                          size: AppTheme.iconSm,
                        ),
                        AppTheme.space2.w,
                        Expanded(
                          child: Text(
                            'صُنع بحب لخدمة المسلمين في جميع أنحاء العالم',
                            style: AppTheme.labelMedium.copyWith(
                              color: AppTheme.primary,
                              fontWeight: AppTheme.semiBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppTheme.space4.h,
                  Center(
                    child: Text(
                      '© 2024 جميع الحقوق محفوظة',
                      style: AppTheme.labelSmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: AppTheme.space4.padding,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'إغلاق',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  AppTheme.space3.w,
                  Expanded(
                    child: AppButton.primary(
                      text: 'تواصل معنا',
                      icon: Icons.support_agent,
                      onPressed: () {
                        Navigator.pop(context);
                        onContactSupport();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoading(size: 24),
          AppTheme.space4.h,
          Text(
            'جاري طلب الأذونات...',
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppTheme.iconSm,
            color: AppTheme.textSecondary,
          ),
          AppTheme.space2.w,
          Expanded(
            child: Text(
              '$label: ',
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTheme.labelMedium.copyWith(
              fontWeight: AppTheme.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}