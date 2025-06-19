// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart'; // تم حذفه - غير مستخدم

// استيراد النظام الجديد المبسط
import 'themes/app_theme.dart';
import '../core/constants/app_constants.dart';
import 'routes/app_router.dart';
// import '../app/di/service_locator.dart'; // تم حذفه - غير مستخدم

class AthkarApp extends StatelessWidget {
  const AthkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام النظام المبسط مع ValueListenableBuilder
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: AppConstants.appName,
          
          // استخدام الثيم المبسط
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          
          // اللغة والترجمة
          locale: const Locale('ar'), // يمكنك ربطها بـ SharedPreferences لاحقاً
          supportedLocales: const [
            Locale('ar'), // العربية
            Locale('en'), // الإنجليزية
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // التنقل
          navigatorKey: AppRouter.navigatorKey,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
          
          // إعدادات إضافية
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl, // يمكنك ربطها باللغة لاحقاً
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}