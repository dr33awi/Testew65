// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// استيراد الثيمات
import 'themes/index.dart';
import '../core/constants/app_constants.dart';
import 'routes/app_router.dart';

class AthkarApp extends StatelessWidget {
  const AthkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: AppConstants.appName,
          
          // استخدام الثيم الجديد
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.themeMode,
          
          // اللغة والترجمة
          locale: Locale(themeNotifier.language),
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
              textDirection: themeNotifier.language == 'ar' 
                  ? TextDirection.rtl 
                  : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}