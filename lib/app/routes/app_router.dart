// lib/app/routes/app_router.dart - النسخة النهائية المصححة
import 'package:flutter/material.dart';
import '../../app/themes/app_theme.dart'; // استيراد موحد
import '../../features/home/screens/home_screen.dart';

import '../../features/prayer_times/screens/prayer_times_screen.dart';
import '../../features/prayer_times/screens/prayer_settings_screen.dart';
import '../../features/prayer_times/screens/prayer_notifications_settings_screen.dart';
import '../../features/qibla/screens/qibla_screen.dart';
import '../../features/athkar/screens/athkar_categories_screen.dart';
import '../../features/athkar/screens/athkar_details_screen.dart';
import '../../features/athkar/screens/notification_settings_screen.dart';
import '../../features/tasbih/screens/tasbih_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

class AppRouter {
  // Main Routes
  static const String initialRoute = '/';
  static const String home = '/';
  static const String prayerTimes = '/prayer-times';
  static const String athkar = '/athkar';
  static const String quran = '/quran';
  static const String qibla = '/qibla';
  static const String tasbih = '/tasbih';
  static const String dua = '/dua';
  
  // Feature Routes
  static const String favorites = '/favorites';
  static const String appSettings = '/settings';
  static const String progress = '/progress';
  static const String achievements = '/achievements';
  static const String reminderSettings = '/reminder-settings';
  static const String notificationSettings = '/notification-settings';
  
  // Detail Routes
  static const String athkarDetails = '/athkar-details';
  static const String quranReader = '/quran-reader';
  static const String duaDetails = '/dua-details';
  static const String prayerSettings = '/prayer-settings';
  static const String prayerNotificationsSettings = '/prayer-notifications-settings';
  static const String athkarNotificationsSettings = '/athkar-notifications-settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('AppRouter: Generating route for ${settings.name}');
    
    switch (settings.name) {
      // Main Screen
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      
      // Main Features
      case prayerTimes:
        return _slideRoute(const PrayerTimesScreen(), settings);
        
      case athkar:
        return _slideRoute(const AthkarCategoriesScreen(), settings);
        
      case athkarDetails:
        final categoryId = settings.arguments as String?;
        if (categoryId != null) {
          return _slideRoute(
            AthkarDetailsScreen(categoryId: categoryId), 
            settings
          );
        } else {
          return _slideRoute(
            _buildErrorScreen('معرف الفئة مطلوب'), 
            settings
          );
        }
        
      case quran:
        return _slideRoute(_buildComingSoonScreen('القرآن الكريم'), settings);
        
      case qibla:
        return _slideRoute(const QiblaScreen(), settings);

      case tasbih:
        return _slideRoute(const TasbihScreen(), settings);
        
      case dua:
        return _slideRoute(_buildComingSoonScreen('الأدعية'), settings);
        
      // Feature Routes
      case favorites:
        return _slideRoute(_buildComingSoonScreen('المفضلة'), settings);
        
      case appSettings:
        return _slideRoute(const SettingsScreen(), settings);
        
      case progress:
        return _slideRoute(_buildComingSoonScreen('التقدم اليومي'), settings);
        
      case achievements:
        return _slideRoute(_buildComingSoonScreen('الإنجازات'), settings);
        
      case reminderSettings:
        return _slideRoute(_buildComingSoonScreen('إعدادات التذكيرات'), settings);
        
      case notificationSettings:
        return _slideRoute(_buildComingSoonScreen('إعدادات الإشعارات'), settings);
        
      case prayerSettings:
        return _slideRoute(const PrayerSettingsScreen(), settings);
        
      case prayerNotificationsSettings:
        return _slideRoute(const PrayerNotificationsSettingsScreen(), settings);
        
      case athkarNotificationsSettings:
        return _slideRoute(const AthkarNotificationSettingsScreen(), settings);
        
      // Default
      default:
        return _fadeRoute(_buildNotFoundScreen(settings.name), settings);
    }
  }

  // Route Builders
  static Route<T> _fadeRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: ThemeConstants.durationNormal,
      reverseTransitionDuration: ThemeConstants.durationFast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static Route<T> _slideRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: ThemeConstants.durationNormal,
      reverseTransitionDuration: ThemeConstants.durationFast,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // Screen Builders
  static Widget _buildComingSoonScreen(String title) {
    return Scaffold(
      appBar: CustomAppBar.simple(title: title),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColorSystem.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForFeature(title),
                  size: 60,
                  color: AppColorSystem.primary,
                ),
              ),
              const SizedBox(height: ThemeConstants.space5),
              Text(
                'قريباً',
                style: AppTextStyles.h2.copyWith(
                  color: AppColorSystem.primary,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              const SizedBox(height: ThemeConstants.space2),
              Text(
                title,
                style: AppTextStyles.h4.copyWith(
                  color: AppColorSystem.getTextSecondary(context),
                ),
              ),
              const SizedBox(height: ThemeConstants.space1),
              Text(
                'هذه الميزة قيد التطوير',
                style: AppTextStyles.body1.copyWith(
                  color: AppColorSystem.getTextSecondary(context).withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: ThemeConstants.space6),
              AppButton.outline(
                text: 'العودة',
                onPressed: () => Navigator.of(context).pop(),
                icon: AppIconsSystem.back,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNotFoundScreen(String? routeName) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColorSystem.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline, // استخدام أيقونة مباشرة
                  size: 60,
                  color: AppColorSystem.error,
                ),
              ),
              const SizedBox(height: ThemeConstants.space5),
              const Text(
                '404',
                style: TextStyle( // استخدام TextStyle مباشرة لتجنب const errors
                  fontSize: ThemeConstants.textSize4xl,
                  fontWeight: ThemeConstants.bold,
                  color: AppColorSystem.error,
                  fontFamily: ThemeConstants.fontFamily,
                ),
              ),
              const SizedBox(height: ThemeConstants.space2),
              const Text(
                'الصفحة غير موجودة',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: ThemeConstants.space1),
              Text(
                'لم نتمكن من العثور على الصفحة المطلوبة',
                style: AppTextStyles.body1.copyWith(
                  color: AppColorSystem.getTextSecondary(context),
                ),
              ),
              if (routeName != null) ...[
                const SizedBox(height: ThemeConstants.space2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorSystem.getTextSecondary(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Text(
                    routeName,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColorSystem.getTextSecondary(context).withValues(alpha: 0.7),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: ThemeConstants.space6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton.outline(
                    text: 'العودة',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: AppIconsSystem.back,
                  ),
                  const SizedBox(width: ThemeConstants.space3),
                  AppButton.primary(
                    text: 'الرئيسية',
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(home, (route) => false),
                    icon: AppIconsSystem.home,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: CustomAppBar.simple(title: 'خطأ'),
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColorSystem.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline, // استخدام أيقونة مباشرة
                  size: 50,
                  color: AppColorSystem.error,
                ),
              ),
              const SizedBox(height: ThemeConstants.space4),
              Text(
                message,
                style: AppTextStyles.h5.copyWith(
                  color: AppColorSystem.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ThemeConstants.space6),
              AppButton.outline(
                text: 'العودة',
                onPressed: () => Navigator.of(context).pop(),
                icon: AppIconsSystem.back,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _getIconForFeature(String title) {
    switch (title) {
      case 'مواقيت الصلاة':
        return AppIconsSystem.prayer;
      case 'الأذكار':
        return AppIconsSystem.athkar;
      case 'القرآن الكريم':
        return AppIconsSystem.quran;
      case 'اتجاه القبلة':
        return AppIconsSystem.qibla;
      case 'التسبيح':
        return AppIconsSystem.dua;
      case 'الأدعية':
        return AppIconsSystem.dua;
      case 'المفضلة':
        return AppIconsSystem.favorite;
      case 'الإعدادات':
        return AppIconsSystem.settings;
      case 'التقدم اليومي':
        return AppIconsSystem.progress;
      case 'الإنجازات':
        return AppIconsSystem.success;
      case 'إعدادات التذكيرات':
        return AppIconsSystem.notifications;
      case 'إعدادات الإشعارات':
        return AppIconsSystem.notifications;
      case 'إعدادات الصلاة':
        return AppIconsSystem.prayer;
      default:
        return AppIconsSystem.info;
    }
  }

  // Navigator key for global navigation
  static final GlobalKey<NavigatorState> _navigatorKey = 
      GlobalKey<NavigatorState>();
  
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  // Navigation helper methods
  static Future<T?> push<T>(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T, TO>(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return _navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T>([T? result]) {
    return _navigatorKey.currentState!.pop<T>(result);
  }

  static bool canPop() {
    return _navigatorKey.currentState!.canPop();
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    return _navigatorKey.currentState!.popUntil(predicate);
  }
}