// lib/app/app_initializer.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // لاستخدام debugPrint

import '../core/infrastructure/services/notifications/notification_service.dart';
import '../core/infrastructure/services/permissions/permission_service.dart';
import 'di/service_locator.dart';
import '../main.dart'; // للوصول إلى NavigationService.navigatorKey
import '../app/themes/widgets/dialogs/app_info_dialog.dart'; // لاستخدام AppInfoDialog
import '../app/themes/widgets/core/app_button.dart'; // لاستخدام AppButton
import '../app/routes/app_router.dart'; // لاستخدام AppRouter

class AppInitializer {
  /// يقوم بتهيئة جميع الخدمات والإعدادات الضرورية للتطبيق.
  Future<void> init() async {
    debugPrint('AppInitializer: بدء تهيئة الخدمات...');
    try {
      // 1. تهيئة ServiceLocator (وبالتالي جميع الخدمات المسجلة)
      await ServiceLocator.init();
      debugPrint('AppInitializer: تم تهيئة جميع الخدمات بنجاح.');

      // 2. إعداد خدمة التنقل
      _setupNavigationService();
      debugPrint('AppInitializer: اكتمل إعداد خدمة التنقل.');

      // 3. تسجيل AppLifecycleObserver لمراقبة دورة حياة التطبيق
      WidgetsBinding.instance.addObserver(AppLifecycleObserver());
      debugPrint('AppInitializer: تم تسجيل AppLifecycleObserver.');

      // يمكن إضافة المزيد من خطوات التهيئة هنا إذا لزم الأمر،
      // مثل تحميل البيانات الأولية، إعداد التحليلات، وما إلى ذلك.

    } catch (e, s) {
      debugPrint('AppInitializer: خطأ أثناء التهيئة: $e');
      debugPrint('StackTrace: $s');
      // بناءً على خطورة الخطأ، قد ترغب في إعادة طرحه
      // أو عرض شاشة خطأ حرجة.
      rethrow;
    }
  }

  /// يقوم بإعداد NavigatorKey العام لخدمة التنقل.
  void _setupNavigationService() {
    NavigationService.navigatorKey = GlobalKey<NavigatorState>();
  }

  /// يطلب أذونات الإشعارات بعد بدء تشغيل التطبيق.
  Future<void> requestNotificationPermissions() async {
    try {
      // التحقق مما إذا كانت خدمتي NotificationService و PermissionService مسجلتين قبل محاولة استخدامهما
      if (getIt.isRegistered<NotificationService>() && getIt.isRegistered<PermissionService>()) {
        final notificationService = getIt<NotificationService>();
        final permissionService = getIt<PermissionService>();

        // طلب إذن الإشعارات عبر PermissionService
        final status = await permissionService.requestPermission(AppPermissionType.notification);
        debugPrint('AppInitializer: حالة إذن الإشعارات: $status');

        // إذا تم رفض الإذن بشكل دائم، اعرض حوارًا يوضح للمستخدم كيفية تمكينه.
        if (status == AppPermissionStatus.permanentlyDenied) {
          if (NavigationService.navigatorKey.currentContext != null) {
            // استخدام Future.microtask لضمان أن الحوار يتم عرضه بعد انتهاء عملية بناء الإطار الحالي.
            Future.microtask(() {
              AppInfoDialog.show(
                context: NavigationService.navigatorKey.currentContext!,
                title: 'إذن الإشعارات مطلوب',
                content: 'لتلقي تذكيرات بالأذكار وأوقات الصلاة، نحتاج إلى إذن الإشعارات. يرجى تمكينه من إعدادات التطبيق.',
                icon: Icons.notifications_off_rounded,
                accentColor: Theme.of(NavigationService.navigatorKey.currentContext!).colorScheme.error,
                actions: [
                  DialogAction(
                    label: 'فتح الإعدادات',
                    onPressed: () {
                      permissionService.openAppSettings();
                      AppRouter.pop(); // أغلق الحوار بعد فتح الإعدادات
                    },
                    isPrimary: true,
                  )
                ],
                closeButtonText: 'لاحقًا',
                barrierDismissible: false, // لا يمكن إغلاقه بالنقر خارجًا
              );
            });
          }
        } else if (status == AppPermissionStatus.denied) {
          if (NavigationService.navigatorKey.currentContext != null) {
             // استخدام Future.microtask لضمان أن الحوار يتم عرضه بعد انتهاء عملية بناء الإطار الحالي.
            Future.microtask(() {
              AppInfoDialog.show(
                context: NavigationService.navigatorKey.currentContext!,
                title: 'إذن الإشعارات مطلوب',
                content: 'نحتاج إلى إذن الإشعارات لتذكيرك بأوقات الصلاة والأذكار. يرجى السماح بذلك لتجربة أفضل.',
                icon: Icons.notifications_active_outlined,
                accentColor: Theme.of(NavigationService.navigatorKey.currentContext!).primaryColor,
                actions: [
                  DialogAction(
                    label: 'السماح بالإشعارات',
                    onPressed: () {
                      permissionService.requestPermission(AppPermissionType.notification); // طلب الإذن مرة أخرى
                      AppRouter.pop(); // أغلق الحوار
                    },
                    isPrimary: true,
                  )
                ],
                closeButtonText: 'لاحقًا',
                barrierDismissible: false, // لا يمكن إغلاقه بالنقر خارجًا
              );
            });
          }
        }
      } else {
        debugPrint('AppInitializer: NotificationService أو PermissionService غير متوفرين في GetIt.');
      }
    } catch (e, s) {
      debugPrint('AppInitializer: خطأ في طلب أذونات الإشعارات: $e');
      debugPrint('StackTrace: $s');
    }
  }
}