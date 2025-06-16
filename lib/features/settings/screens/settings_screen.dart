// lib/features/settings/screens/settings_screen.dart (نسخة محسنة ومقاومة للأخطاء)

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
  const SettingsScreen({super.key}

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
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> 
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  // مدير الخدمات الموحد
  SettingsServicesManager? _servicesManager;
  LoggerService? _logger;
  
  // Animation
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  // State
  AppSettings _settings = const AppSettings();
  ServiceStatus _serviceStatus = ServiceStatus.initial();
  bool _loading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  
  // Subscriptions
  Stream<AppSettings>? _settingsStream;
  Stream<ServiceStatus>? _serviceStatusStream;
  
  // للحفاظ على الحالة عند تغيير الصفحات
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeServices();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    // لا نحذف _servicesManager هنا لأنه singleton
    super.dispose();
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
  
  void _initializeServices() {
    try {
      // محاولة الحصول على الخدمات
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
      // الحصول على Streams من المدير مع معالجة null
      _settingsStream = _servicesManager!.settingsStream;
      _serviceStatusStream = _servicesManager!.serviceStatusStream;
      
      // الاستماع لتغييرات الإعدادات مع معالجة الأخطاء
      _settingsStream?.listen(
        (settings) {
          if (mounted) {
            setState(() {
              _settings = settings;
              _errorMessage = null; // مسح الخطأ عند نجاح التحديث
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
      
      // الاستماع لتغييرات حالة الخدمات مع معالجة الأخطاء
      _serviceStatusStream?.listen(
        (status) {
          if (mounted) {
            setState(() {
              _serviceStatus = status;
              _errorMessage = null; // مسح الخطأ عند نجاح التحديث
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
    
    // محاولة استخدام قيم افتراضية
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
      await Future.delayed(const Duration(milliseconds: 300)); // تأثير تحميل
      
      final result = await _servicesManager!.loadSettings();
      
      if (result.isSuccess && result.settings != null && result.serviceStatus != null) {
        setState(() {
          _settings = result.settings!;
          _serviceStatus = result.serviceStatus!;
          _loading = false;
          _errorMessage = null;
        });
        
        _animationController.forward();
        
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
      
      // استخدام قيم افتراضية
      _useDefaultValues();
      
      // إظهار snackbar للخطأ
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
        // إعادة تهيئة الخدمات
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
  
  // ==================== معالجات الإعدادات (مع معالجة أخطاء محسنة) ====================
  
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
        HapticFeedback.mediumImpact(); // تجربة الاهتزاز
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
        // فتح إعدادات الإشعارات
        Navigator.pushNamed(context, AppRouter.notificationSettings);
      } else {
        // طلب الإذن باستخدام مدير الخدمات
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
  
  Future<void> _clearCache() async {
    HapticFeedback.mediumImpact();
    
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final shouldClear = await _showConfirmationDialog(
        title: 'مسح البيانات المؤقتة',
        content: 'سيتم مسح جميع البيانات المؤقتة والذاكرة المؤقتة. هذا قد يحسن أداء التطبيق.',
        confirmText: 'مسح',
        cancelText: 'إلغاء',
        icon: Icons.cleaning_services,
        destructive: true,
      );
      
      if (shouldClear) {
        final result = await _servicesManager!.clearApplicationCache();
        
        if (result.isSuccess) {
          _showSuccessMessage('تم مسح البيانات المؤقتة بنجاح');
        } else {
          _showErrorMessage('فشل مسح البيانات المؤقتة: ${result.error ?? "خطأ غير معروف"}');
        }
      }
    } catch (e) {
      _logger?.error(message: '[Settings] فشل مسح الكاش', error: e);
      _showErrorMessage('فشل مسح البيانات المؤقتة: ${e.toString()}');
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
      
      // عرض dialog للتقدم
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _PermissionProgressDialog(),
      );
      
      final result = await _servicesManager!.requestMultiplePermissions(
        permissions,
        onProgress: (progress) {
          // يمكن تحديث UI للتقدم هنا
        },
      );
      
      if (mounted) {
        Navigator.pop(context); // إغلاق dialog التقدم
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
        Navigator.pop(context); // إغلاق dialog التقدم
      }
      _logger?.error(message: '[Settings] فشل طلب الأذونات', error: e);
      _showErrorMessage('حدث خطأ أثناء طلب الأذونات: ${e.toString()}');
    }
  }
  
  // ==================== باقي الدوال (نفس النسخة السابقة مع معالجة أخطاء محسنة) ====================
  
  Future<void> _shareApp() async {
    // ... نفس الكود السابق مع try-catch
  }
  
  Future<void> _rateApp() async {
    // ... نفس الكود السابق مع try-catch
  }
  
  Future<void> _contactSupport() async {
    // ... نفس الكود السابق مع try-catch
  }
  
  String _getPermissionsSummary() {
    final permissions = _serviceStatus.permissions;
    final granted = permissions.values
        .where((status) => status == AppPermissionStatus.granted)
        .length;
    return 'ممنوحة: $granted من ${permissions.length}';
  }
  
  void _showAboutDialog() {
    // ... نفس الكود السابق
  }
  
  // ==================== Helper Methods ====================
  
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
        backgroundColor: ThemeConstants.success,
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
        backgroundColor: ThemeConstants.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        duration: const Duration(seconds: 6), // مدة أطول للأخطاء
        action: SnackBarAction(
          label: 'إعادة المحاولة',
          textColor: Colors.white,
          onPressed: _refreshSettings,
        ),
      ),
    );
  }
  
  void _showWarningMessage(String message, {SnackBarAction? action}) {
    if (!mounted) return;
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
            Icon(Icons.battery_saver, color: ThemeConstants.warning),
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
    // ... نفس الكود السابق
  }
  
  String _getPermissionDisplayName(AppPermissionType permission) {
    // ... نفس الكود السابق
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // للـ AutomaticKeepAliveClientMixin
    
    // إذا كان هناك خطأ في الخدمات، عرض شاشة خطأ
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
    
    // إذا كان لا يزال يحمل
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
              color: ThemeConstants.error,
            ),
            ThemeConstants.space4.h,
            Text(
              'فشل تحميل الإعدادات',
              style: context.headlineSmall?.copyWith(
                color: ThemeConstants.error,
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
                    _animationController.forward();
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
          
          // عرض رسالة خطأ إذا كانت موجودة
          if (_errorMessage != null) _buildErrorBanner(),
          
          // عرض حالة الخدمات الموحدة إذا كانت متوفرة
          if (_servicesManager != null)
            ServiceStatusOverview(
              status: _serviceStatus,
              servicesManager: _servicesManager!,
              onRefresh: _refreshSettings,
            ),
          
          // إعدادات سريعة للأذونات
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
                    : Icon(Icons.add_circle, color: ThemeConstants.warning),
                iconColor: _settings.notificationsEnabled 
                    ? ThemeConstants.success 
                    : ThemeConstants.warning,
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
                        : Icon(Icons.add_location, color: ThemeConstants.warning),
                enabled: !_isRefreshing && _servicesManager != null,
                iconColor: _serviceStatus.locationAvailable
                    ? ThemeConstants.success
                    : ThemeConstants.warning,
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
                    ? ThemeConstants.success 
                    : ThemeConstants.warning,
                trailing: _settings.batteryOptimizationDisabled
                    ? Icon(Icons.check_circle, color: ThemeConstants.success)
                    : Icon(Icons.warning, color: ThemeConstants.warning),
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
          
          // إعدادات الإشعارات والتنبيهات
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
          
          // إعدادات المظهر
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
          
          // إعدادات النظام
          SettingsSection(
            title: 'إعدادات النظام',
            icon: Icons.settings_outlined,
            children: [
              SettingsTile(
                icon: Icons.cleaning_services_outlined,
                title: 'مسح البيانات المؤقتة',
                subtitle: 'تحسين أداء التطبيق ومساحة التخزين',
                onTap: _clearCache,
                enabled: _servicesManager != null,
              ),
              SettingsTile(
                icon: Icons.info_outlined,
                title: 'معلومات النظام',
                subtitle: 'عرض معلومات الجهاز والأداء',
                onTap: () => _showSystemInfoDialog(),
                enabled: _servicesManager != null,
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
  
  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: ThemeConstants.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(color: ThemeConstants.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: ThemeConstants.error,
            size: 20,
          ),
          ThemeConstants.space2.w,
          Expanded(
            child: Text(
              _errorMessage!,
              style: context.bodySmall?.copyWith(
                color: ThemeConstants.error,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _errorMessage = null),
            icon: Icon(
              Icons.close,
              color: ThemeConstants.error,
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
  
  void _showSystemInfoDialog() async {
    if (_servicesManager == null) {
      _showErrorMessage('مدير الإعدادات غير متوفر');
      return;
    }
    
    try {
      final statistics = await _servicesManager!.getStatistics();
      
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => _SystemInfoDialog(
          statistics: statistics,
          serviceStatus: _serviceStatus,
        ),
      );
    } catch (e) {
      _logger?.error(message: '[Settings] فشل الحصول على معلومات النظام', error: e);
      _showErrorMessage('فشل في الحصول على معلومات النظام: ${e.toString()}');
    }
  }
}

// ==================== Dialogs مساعدة ====================

class _PermissionProgressDialog extends StatelessWidget {
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

class _SystemInfoDialog extends StatelessWidget {
  final SettingsStatistics statistics;
  final ServiceStatus serviceStatus;

  const _SystemInfoDialog({
    required this.statistics,
    required this.serviceStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.info, color: context.primaryColor),
          ThemeConstants.space2.w,
          const Text('معلومات النظام'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('حالة الخدمات', [
              _InfoRow(
                icon: Icons.check_circle,
                label: 'الخدمات الصحية',
                value: statistics.serviceStatusHealthy ? 'نعم' : 'لا',
              ),
              _InfoRow(
                icon: Icons.battery_std,
                label: 'البطارية',
                value: '${serviceStatus.batteryState.level}%',
              ),
              _InfoRow(
                icon: Icons.power_settings_new,
                label: 'وضع توفير الطاقة',
                value: serviceStatus.batteryState.isPowerSaveMode ? 'مفعل' : 'معطل',
              ),
            ]),
            
            ThemeConstants.space4.h,
            
            _buildSection('إحصائيات الأذونات', [
              _InfoRow(
                icon: Icons.request_page,
                label: 'إجمالي الطلبات',
                value: '${statistics.permissionStats.totalRequests}',
              ),
              _InfoRow(
                icon: Icons.check,
                label: 'الممنوحة',
                value: '${statistics.permissionStats.grantedCount}',
              ),
              _InfoRow(
                icon: Icons.close,
                label: 'المرفوضة',
                value: '${statistics.permissionStats.deniedCount}',
              ),
              _InfoRow(
                icon: Icons.percent,
                label: 'معدل القبول',
                value: '${statistics.permissionStats.acceptanceRate.toStringAsFixed(1)}%',
              ),
            ]),
            
            if (statistics.lastSyncTime != null) ...[
              ThemeConstants.space4.h,
              _buildSection('آخر تحديث', [
                _InfoRow(
                  icon: Icons.schedule,
                  label: 'التوقيت',
                  value: _formatDateTime(statistics.lastSyncTime!),
                ),
              ]),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: ThemeConstants.bold,
            fontSize: 16,
          ),
        ),
        ThemeConstants.space2.h,
        ...children,
      ],
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}

// Widget لمعلومة في الـ Dialog
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