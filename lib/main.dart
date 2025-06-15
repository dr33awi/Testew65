// lib/main.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/di/service_locator.dart';
import 'app/app.dart';
import 'app/routes/app_router.dart';
import 'core/infrastructure/services/notifications/notification_service.dart';
import 'core/infrastructure/services/storage/storage_service.dart';
import 'app/themes/constants/app_constants.dart';

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
    // تسجيل Observer لمراقبة دورة حياة التطبيق
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    
    // تهيئة جميع الخدمات
    await _initAllServices();
    
    // Get saved preferences
    final storageService = getIt<StorageService>();
    final isDarkMode = storageService.getBool('isDarkMode') ?? false;
    final language = storageService.getString('language') ?? AppConstants.defaultLanguage;
    
    // إنشاء التطبيق
    final app = AthkarApp(
      isDarkMode: isDarkMode,
      language: language,
    );
    
    runApp(app);
    
    // طلب أذونات الإشعارات بعد تشغيل التطبيق
    Future.delayed(const Duration(seconds: 1), () async {
      await _requestNotificationPermissions();
    });
    
  } catch (e, s) {
    debugPrint('خطأ في تشغيل التطبيق: $e');
    debugPrint('Stack trace: $s');
    runApp(ErrorApp(error: e.toString()));
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
    rethrow;
  }
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

/// تطبيق عرض الأخطاء
class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFAFBF8),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB74C4C).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Color(0xFFB74C4C),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'حدث خطأ في التطبيق',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252921),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB74C4C).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFB74C4C).withOpacity(0.2),
                      ),
                    ),
                    child: SelectableText(
                      error,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF545B4B),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      // إعادة تشغيل التطبيق
                      SystemNavigator.pop();
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('إغلاق التطبيق'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D7052),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}