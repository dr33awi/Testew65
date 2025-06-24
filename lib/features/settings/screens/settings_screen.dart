// lib/features/settings/screens/settings_screen.dart - مُصحح

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/layout/app_bar.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/settings_services_manager.dart';
import '../widgets/service_status_widgets.dart';
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
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const _PermissionProgressDialog(),
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
  
  // ==================== Helper Methods - استخدام ألوان من Context ====================
  
  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: context.successColor, // استخدام context بدلاً من ThemeConstants
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
  
  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: context.errorColor, // استخدام context بدلاً من ThemeConstants
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: _refreshSettings,
        ),
      ),
    );
  }
  
  void _showInfoMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: context.primaryColor, // استخدام context
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
    if (!mounted) return false;
    
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
                  color: (destructive ? context.errorColor : context.primaryColor)
                      .withOpacitySafe(0.1), // استخدام Extension المُصحح
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: destructive ? context.errorColor : context.primaryColor,
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
              backgroundColor: destructive ? context.errorColor : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }
  
  void _showPermissionDeniedDialog(String permissionName) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إذن $permissionName مطلوب'),
        content: Text(
          'لاستخدام هذه الميزة، يجب منح إذن $permissionName. يمكنك تفعيله من إعدادات التطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (_servicesManager != null) {
                await _servicesManager!.openAppSettings();
              }
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }
  
  void _showBatteryOptimizationFailedDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.battery_saver, color: context.warningColor),
            ThemeConstants.space2.w,
            const Text('تحسين البطارية'),
          ],
        ),
        content: const Text(
          'لم نتمكن من تحسين إعدادات البطارية تلقائياً. يرجى فتح إعدادات النظام وإيقاف تحسين البطارية لهذا التطبيق يدوياً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (_servicesManager != null) {
                await _servicesManager!.openAppSettings(AppSettingsType.battery);
              }
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }
  
  void _showPartialPermissionDialog(BatchPermissionResult result) {
    if (!mounted) return;
    
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (_servicesManager != null) {
                await _servicesManager!.openAppSettings();
              }
            },
            child: const Text('فتح الإعدادات'),
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
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.simple(
          title: 'الإعدادات',
          actions: [
            AppBarAction(
              icon: Icons.refresh,
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
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.simple(title: 'الإعدادات'),
        body: _buildLoadingView(),
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
        child: _buildContent(),
      ),
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.errorColor, // استخدام context
            ),
            ThemeConstants.space4.h,
            Text(
              'فشل تحميل الإعدادات',
              style: context.headlineSmall?.copyWith(
                color: context.errorColor,
                fontWeight: ThemeConstants.bold,
              ),
              textAlign: TextAlign.center,
            ),
            ThemeConstants.space3.h,
            Text(
              _errorMessage ?? 'حدث خطأ غير معروف',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            ThemeConstants.space6.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _errorMessage = null);
                    _useDefaultValues();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('استخدام الافتراضية'),
                ),
                ThemeConstants.space3.w,
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _errorMessage = null);
                    _initializeServices();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الإعدادات...'),
        ],
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
              SettingsTile(
                icon: Icons.notifications_active_outlined,
                title: 'الإشعارات',
                subtitle: _settings.notificationsEnabled 
                    ? 'الإشعارات مفعلة - اضغط للتخصيص' 
                    : 'الإشعارات معطلة - اضغط للتفعيل',
                onTap: _handleNotificationPermission,
                trailing: _settings.notificationsEnabled
                    ? Icon(Icons.settings, color: context.primaryColor)
                    : Icon(Icons.add_circle, color: context.warningColor),
                iconColor: _settings.notificationsEnabled 
                    ? context.successColor 
                    : context.warningColor,
                badge: !_settings.notificationsEnabled 
                    ? SettingsBadge.warning()
                    : null,
                enabled: _servicesManager != null,
              ),
              SettingsTile(
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
                        ? Icon(Icons.refresh, color: context.primaryColor)
                        : Icon(Icons.add_location, color: context.warningColor),
                enabled: !_isRefreshing && _servicesManager != null,
                iconColor: _serviceStatus.locationAvailable
                    ? context.successColor
                    : context.warningColor,
                badge: !_serviceStatus.locationAvailable 
                    ? SettingsBadge.warning()
                    : null,
              ),
              SettingsTile(
                icon: Icons.battery_saver_outlined,
                title: 'تحسين البطارية',
                subtitle: _settings.batteryOptimizationDisabled
                    ? 'تم تحسين إعدادات البطارية'
                    : 'يُنصح بتحسين إعدادات البطارية',
                onTap: _handleBatteryOptimization,
                iconColor: _settings.batteryOptimizationDisabled 
                    ? context.successColor 
                    : context.warningColor,
                trailing: _settings.batteryOptimizationDisabled
                    ? Icon(Icons.check_circle, color: context.successColor)
                    : Icon(Icons.warning, color: context.warningColor),
                badge: !_settings.batteryOptimizationDisabled 
                    ? SettingsBadge.warning()
                    : null,
                enabled: _servicesManager != null,
              ),
              SettingsTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'طلب جميع الأذونات',
                subtitle: 'تفعيل جميع الأذونات دفعة واحدة',
                onTap: _requestAllPermissions,
                iconColor: context.primaryColor,
                trailing: Icon(Icons.security_update_good, color: context.primaryColor),
                enabled: _servicesManager != null,
              ),
            ],
          ),
          
          SettingsSection(
            title: 'الإشعارات والتنبيهات',
            icon: Icons.notifications_outlined,
            children: [
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
                icon: Icons.mosque_outlined,
                title: 'إشعارات الصلاة',
                subtitle: 'تخصيص تنبيهات أوقات الصلاة',
                onTap: () => Navigator.pushNamed(context, AppRouter.prayerNotificationsSettings),
                enabled: _settings.notificationsEnabled,
              ),
              SettingsTile(
                icon: Icons.volume_up_outlined,
                title: 'الصوت',
                subtitle: 'تفعيل الأصوات مع الإشعارات',
                trailing: SettingsSwitch(
                  value: _settings.soundEnabled,
                  onChanged: _servicesManager != null ? _toggleSound : null,
                  enabled: _settings.notificationsEnabled && _servicesManager != null,
                ),
                enabled: _settings.notificationsEnabled,
              ),
              SettingsTile(
                icon: Icons.vibration_outlined,
                title: 'الاهتزاز',
                subtitle: 'تفعيل الاهتزاز مع الإشعارات',
                trailing: SettingsSwitch(
                  value: _settings.vibrationEnabled,
                  onChanged: _servicesManager != null ? _toggleVibration : null,
                  activeColor: context.primaryColor,
                  enabled: _servicesManager != null,
                ),
              ),
            ],
          ),
          
          SettingsSection(
            title: 'المظهر والعرض',
            icon: Icons.palette_outlined,
            children: [
              SettingsTile(
                icon: _settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'وضع العرض',
                subtitle: _settings.isDarkMode ? 'الوضع الليلي مفعل' : 'الوضع النهاري مفعل',
                trailing: SettingsSwitch(
                  value: _settings.isDarkMode,
                  onChanged: _servicesManager != null ? _toggleTheme : null,
                  activeColor: context.primaryColor,
                  enabled: _servicesManager != null,
                ),
                iconColor: _settings.isDarkMode ? Colors.orange : Colors.blue,
              ),
            ],
          ),
          
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
  
  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.errorColor.withOpacitySafe(0.1), // استخدام Extension المُصحح
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(color: context.errorColor.withOpacitySafe(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: context.errorColor,
            size: 20,
          ),
          ThemeConstants.space2.w,
          Expanded(
            child: Text(
              _errorMessage!,
              style: context.bodySmall?.copyWith(
                color: context.errorColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _errorMessage = null),
            icon: Icon(
              Icons.close,
              color: context.errorColor,
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
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space6),
              decoration: BoxDecoration(
                gradient: context.primaryGradient, // استخدام context
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
                      color: Colors.white.withOpacitySafe(0.2),
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
                      color: Colors.white.withOpacitySafe(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
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
                      color: context.primaryColor.withOpacitySafe(0.1),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: context.errorColor,
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
                        onContactSupport();
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
    );
  }
}

class _PermissionProgressDialog extends StatelessWidget {
  const _PermissionProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          ThemeConstants.space4.h,
          const Text('جاري طلب الأذونات...'),
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
            size: ThemeConstants.iconSm,
            color: context.textSecondaryColor,
          ),
          ThemeConstants.space2.w,
          Expanded(
            child: Text(
              '$label: ',
              style: context.labelMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: context.labelMedium?.copyWith(
              fontWeight: ThemeConstants.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}