// lib/app/app.dart - مُصحح للنظام المبسط
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استيراد الثيم الجديد
import '../core/constants/app_constants.dart';
import 'routes/app_router.dart';
import '../main.dart'; // لاستخدام NavigationService

class AthkarApp extends StatelessWidget {
  final String language;
  
  const AthkarApp({
    super.key,
    this.language = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      
      // ✅ الثيم الداكن الوحيد
      theme: AppTheme.theme,
      themeMode: ThemeMode.dark,
      
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
      
      // استخدام NavigationService الموحد
      navigatorKey: NavigationService.navigatorKey,
      
      // استخدام AppRouter للتوجيه
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      
      debugShowCheckedModeBanner: false,
    );
  }
}