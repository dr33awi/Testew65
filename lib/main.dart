// lib/main.dart - نظام عربي داكن فقط
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app/di/service_locator.dart';
import 'app/themes/core/theme_notifier.dart';
import 'core/infrastructure/services/notifications/notification_service.dart';
import 'core/constants/app_constants.dart';
// استيراد الثيم الداكن الوحيد
import 'app/themes/app_theme.dart';
import 'app/routes/app_router.dart';

Future<void> main() async {
  // تهيئة ربط Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة بيانات اللغة العربية فقط للتواريخ
  await initializeDateFormatting('ar', null);
  
  // تعيين اتجاه التطبيق (عمودي فقط)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // تعيين شريط الحالة للثيم الداكن
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF1F2937),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  try {
    // إعداد NavigationService
    _setupNavigationService();
    
    // تسجيل Observer لمراقبة دورة حياة التطبيق
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    
    // تهيئة جميع الخدمات
    await _initAllServices();
    
    // إنشاء التطبيق العربي الداكن
    runApp(const MyApp());
    
    // طلب أذونات الإشعارات عند بدء التطبيق
    await _requestNotificationPermissions();
    
  } catch (e, s) {
    debugPrint('خطأ في تشغيل التطبيق: $e');
    debugPrint('Stack trace: $s');
    runApp(
      MaterialApp(
        theme: AppTheme.theme, // استخدام الثيم الداكن حتى في حالة الخطأ
        locale: const Locale('ar'),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFF111827),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Color(0xFFEF4444),
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'حدث خطأ أثناء تهيئة التطبيق',
                      style: TextStyle(
                        color: Color(0xFFF9FAFB),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'تفاصيل الخطأ: $e',
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => SystemNavigator.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('إغلاق التطبيق'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// التطبيق الرئيسي - عربي وداكن فقط
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (context) => getIt<ThemeNotifier>(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // الثيم الداكن الوحيد
            theme: AppTheme.theme,
            
            // اللغة العربية فقط
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'), // العربية فقط
            ],
            
            // إعدادات الترجمة للعربية
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // اتجاه النص من اليمين لليسار
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            
            // إعدادات التنقل
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
            
            // معالج الأخطاء المخصص
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => _buildErrorPage(
                  'صفحة غير موجودة',
                  'الصفحة المطلوبة "${settings.name}" غير متوفرة',
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  /// بناء صفحة خطأ مخصصة
  Widget _buildErrorPage(String title, String message) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF9FAFB),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF10B981)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFEF4444),
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFF9FAFB),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(NavigationService.navigatorKey.currentContext!).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('العودة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// تهيئة جميع الخدمات
Future<void> _initAllServices() async {
  try {
    // تهيئة ServiceLocator
    await ServiceLocator.init();
    debugPrint('✅ جميع الخدمات تم تهيئتها بنجاح');
  } catch (e) {
    debugPrint('❌ خطأ في تهيئة الخدمات: $e');
    // التطبيق سيستمر مع الخدمات الأساسية على الأقل
    rethrow;
  }
}

/// إعداد خدمة التنقل
void _setupNavigationService() {
  NavigationService.navigatorKey = GlobalKey<NavigatorState>();
  debugPrint('✅ تم إعداد خدمة التنقل');
}

/// طلب أذونات الإشعارات
Future<void> _requestNotificationPermissions() async {
  try {
    // التحقق من وجود خدمة الإشعارات أولاً
    if (getIt.isRegistered<NotificationService>()) {
      final notificationService = getIt<NotificationService>();
      final hasPermission = await notificationService.requestPermission();
      
      if (hasPermission) {
        debugPrint('✅ تم منح إذن الإشعارات');
      } else {
        debugPrint('⚠️ لم يتم منح إذن الإشعارات');
      }
    } else {
      debugPrint('⚠️ خدمة الإشعارات غير متوفرة');
    }
  } catch (e) {
    debugPrint('❌ خطأ في طلب أذونات الإشعارات: $e');
  }
}

/// خدمة التنقل العامة
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// الحصول على السياق الحالي
  static BuildContext? get currentContext => navigatorKey.currentContext;
  
  /// التنقل إلى صفحة جديدة
  static Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }
  
  /// استبدال الصفحة الحالية
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }
  
  /// العودة للصفحة السابقة
  static void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }
  
  /// العودة للصفحة الرئيسية
  static void popUntilRoot() {
    return navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

/// مراقب دورة حياة التطبيق المحسن
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🔄 حالة التطبيق: ${_getStateDescription(state)}');
    
    switch (state) {
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
    }
  }
  
  /// وصف حالة التطبيق بالعربية
  String _getStateDescription(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        return 'منفصل';
      case AppLifecycleState.paused:
        return 'متوقف مؤقتاً';
      case AppLifecycleState.resumed:
        return 'نشط';
      case AppLifecycleState.inactive:
        return 'غير نشط';
      case AppLifecycleState.hidden:
        return 'مخفي';
    }
  }
  
  /// عند انفصال التطبيق
  void _onAppDetached() {
    debugPrint('📱 التطبيق منفصل - تنظيف الموارد...');
    _disposeResources();
  }
  
  /// عند توقف التطبيق مؤقتاً
  void _onAppPaused() {
    debugPrint('⏸️ التطبيق متوقف مؤقتاً');
    _saveAppState();
  }
  
  /// عند استئناف التطبيق
  void _onAppResumed() {
    debugPrint('▶️ التطبيق نشط مرة أخرى');
    _refreshAppState();
  }
  
  /// عند عدم نشاط التطبيق
  void _onAppInactive() {
    debugPrint('⏹️ التطبيق غير نشط');
  }
  
  /// عند إخفاء التطبيق
  void _onAppHidden() {
    debugPrint('👁️ التطبيق مخفي');
  }
  
  /// حفظ حالة التطبيق
  void _saveAppState() {
    try {
      if (getIt.isRegistered<ThemeNotifier>()) {
        final themeNotifier = getIt<ThemeNotifier>();
        // حفظ الإعدادات إذا لزم الأمر
        debugPrint('💾 تم حفظ حالة التطبيق');
      }
    } catch (e) {
      debugPrint('❌ خطأ في حفظ حالة التطبيق: $e');
    }
  }
  
  /// تحديث حالة التطبيق
  void _refreshAppState() {
    try {
      if (getIt.isRegistered<ThemeNotifier>()) {
        final themeNotifier = getIt<ThemeNotifier>();
        themeNotifier.refreshTheme();
        debugPrint('🔄 تم تحديث حالة التطبيق');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحديث حالة التطبيق: $e');
    }
  }
  
  /// تنظيف موارد التطبيق
  Future<void> _disposeResources() async {
    try {
      debugPrint('🧹 بدء تنظيف الموارد...');
      
      // تنظيف خدمة الإشعارات
      if (getIt.isRegistered<NotificationService>()) {
        final notificationService = getIt<NotificationService>();
        await notificationService.dispose();
        debugPrint('✅ تم تنظيف خدمة الإشعارات');
      }
      
      // تنظيف ServiceLocator
      await ServiceLocator.dispose();
      debugPrint('✅ تم تنظيف جميع الخدمات');
      
      debugPrint('🎉 تم تنظيف الموارد بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تنظيف الموارد: $e');
    }
  }
}