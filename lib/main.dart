// lib/main.dart (محدث)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/di/service_locator.dart';
import 'package:athkar_app/app/themes/core/theme_notifier.dart';import 'core/infrastructure/services/notifications/notification_service.dart';
import 'core/infrastructure/services/storage/storage_service.dart';
import 'core/constants/app_constants.dart';
// استيراد الثيمات
import 'app/themes/app_theme.dart';
import 'app/routes/app_router.dart';

Future<void> main() async {
  // تهيئة ربط Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة بيانات اللغة المحلية للتواريخ
  await initializeDateFormatting('ar', null);
  
  // تعيين اتجاه التطبيق
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  try {
    // إعداد NavigationService
    _setupNavigationService();
    
    // تسجيل Observer لمراقبة دورة حياة التطبيق
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    
    // تهيئة جميع الخدمات
    await _initAllServices();
    
    // Get saved preferences  
    final storageService = getIt<StorageService>();
    final language = storageService.getString('language') ?? AppConstants.defaultLanguage;
    
    // إنشاء التطبيق مع ThemeNotifier
    runApp(MyApp(language: language));
    
    // طلب أذونات الإشعارات عند بدء التطبيق
    await _requestNotificationPermissions();
    
  } catch (e, s) {
    debugPrint('خطأ في تشغيل التطبيق: $e');
    debugPrint('Stack trace: $s');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('حدث خطأ أثناء تهيئة التطبيق: $e'),
          ),
        ),
      ),
    );
  }
}

// التطبيق الجديد مع إدارة الثيم
class MyApp extends StatelessWidget {
  final String language;
  
  const MyApp({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: getIt<ThemeNotifier>(),
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: Locale(language),
          supportedLocales: const [
            Locale('ar'), // العربية
            Locale('en'), // الإنجليزية
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // إضافة navigatorKey
          navigatorKey: NavigationService.navigatorKey,
          // استخدام AppRouter
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}

/// تهيئة جميع الخدمات
Future<void> _initAllServices() async {
  try {
    // تهيئة ServiceLocator
    await ServiceLocator.init();
    debugPrint('جميع الخدمات تم تهيئتها بنجاح');
  } catch (e) {
    debugPrint('خطأ في تهيئة الخدمات: $e');
    // التطبيق سيستمر مع الخدمات الأساسية على الأقل
    rethrow;
  }
}

/// إعداد خدمة التنقل
void _setupNavigationService() {
  NavigationService.navigatorKey = GlobalKey<NavigatorState>();
}

/// طلب أذونات الإشعارات
Future<void> _requestNotificationPermissions() async {
  try {
    // التحقق من وجود خدمة الإشعارات أولاً
    if (getIt.isRegistered<NotificationService>()) {
      final notificationService = getIt<NotificationService>();
      final hasPermission = await notificationService.requestPermission();
      debugPrint('حالة إذن الإشعارات: $hasPermission');
    } else {
      debugPrint('خدمة الإشعارات غير متوفرة');
    }
  } catch (e) {
    debugPrint('خطأ في طلب أذونات الإشعارات: $e');
  }
}

// خدمة التنقل
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

/// مراقب دورة حياة التطبيق
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('حالة التطبيق: $state');
    
    if (state == AppLifecycleState.detached) {
      _disposeResources();
    }
  }
  
  Future<void> _disposeResources() async {
    try {
      debugPrint('تنظيف الموارد...');
      
      if (getIt.isRegistered<NotificationService>()) {
        final notificationService = getIt<NotificationService>();
        await notificationService.dispose();
      }
      
      // استخدام الطريقة الثابتة بشكل صحيح
      await ServiceLocator.dispose();
      
      debugPrint('تم تنظيف الموارد بنجاح');
    } catch (e) {
      debugPrint('خطأ في تنظيف الموارد: $e');
    }
  }
}