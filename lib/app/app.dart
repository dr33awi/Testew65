// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// استيراد الثيمات
import 'themes/app_theme.dart';
import 'themes/constants/app_constants.dart';
import 'routes/app_router.dart';

class AthkarApp extends StatelessWidget {
  final bool isDarkMode;
  final String language;
  
  const AthkarApp({
    super.key,
    this.isDarkMode = false,
    this.language = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      // استخدام navigatorKey من AppRouter
      navigatorKey: AppRouter.navigatorKey,
      // استخدام AppRouter
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return Directionality(
          textDirection: language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}