// lib/app/routes/app_router.dart
import 'package:flutter/material.dart';
import '../../app/themes/app_theme.dart';
import '../../features/home/screens/home_screen.dart';

import '../../features/prayer_times/screens/prayer_times_screen.dart';
import '../../features/prayer_times/screens/prayer_settings_screen.dart';
import '../../features/prayer_times/screens/prayer_notifications_settings_screen.dart';
import 'package:athkar_app/features/qibla/screens/qibla_screen.dart';

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
        return _slideRoute(_buildComingSoonScreen('الأذكار'), settings);
        
      case quran:
        return _slideRoute(_buildComingSoonScreen('القرآن الكريم'), settings);
        
      case qibla:
        return _slideRoute(const QiblaScreen(), settings);
        
      case tasbih:
        return _slideRoute(_buildComingSoonScreen('التسبيح'), settings);
        
      case dua:
        return _slideRoute(_buildComingSoonScreen('الأدعية'), settings);
        
      // Feature Routes
      case favorites:
        return _slideRoute(_buildComingSoonScreen('المفضلة'), settings);
        
      case appSettings:
        return _slideRoute(_buildComingSoonScreen('الإعدادات'), settings);
        
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ThemeConstants.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForFeature(title),
                size: 60,
                color: ThemeConstants.primary,
              ),
            ),
            ThemeConstants.space5.h,
            Text(
              'قريباً',
              style: AppTextStyles.h2.copyWith(
                color: ThemeConstants.primary,
                fontWeight: ThemeConstants.bold,
              ),
            ),
            ThemeConstants.space2.h,
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: ThemeConstants.lightTextSecondary,
              ),
            ),
            ThemeConstants.space1.h,
            Text(
              'هذه الميزة قيد التطوير',
              style: AppTextStyles.body1.copyWith(
                color: ThemeConstants.lightTextHint,
              ),
            ),
            ThemeConstants.space6.h,
            AppButton.outline(
              text: 'العودة',
              onPressed: () => Navigator.of(_navigatorKey.currentContext!).pop(),
              icon: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildNotFoundScreen(String? routeName) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ThemeConstants.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: ThemeConstants.error,
              ),
            ),
            ThemeConstants.space5.h,
            Text(
              '404',
              style: AppTextStyles.h1.copyWith(
                color: ThemeConstants.error,
                fontWeight: ThemeConstants.bold,
              ),
            ),
            ThemeConstants.space2.h,
            const Text(
              'الصفحة غير موجودة',
              style: AppTextStyles.h4,
            ),
            ThemeConstants.space1.h,
            Text(
              'لم نتمكن من العثور على الصفحة المطلوبة',
              style: AppTextStyles.body1.copyWith(
                color: ThemeConstants.lightTextSecondary,
              ),
            ),
            if (routeName != null) ...[
              ThemeConstants.space2.h,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space1,
                ),
                decoration: BoxDecoration(
                  color: ThemeConstants.lightTextHint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Text(
                  routeName,
                  style: AppTextStyles.caption.copyWith(
                    color: ThemeConstants.lightTextHint,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
            ThemeConstants.space6.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton.outline(
                  text: 'العودة',
                  onPressed: () => Navigator.of(_navigatorKey.currentContext!).pop(),
                  icon: Icons.arrow_back,
                ),
                const SizedBox(width: ThemeConstants.space3),
                AppButton.primary(
                  text: 'الرئيسية',
                  onPressed: () => Navigator.of(_navigatorKey.currentContext!)
                      .pushNamedAndRemoveUntil(home, (route) => false),
                  icon: Icons.home,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getIconForFeature(String title) {
    switch (title) {
      case 'مواقيت الصلاة':
        return Icons.mosque;
      case 'الأذكار':
        return Icons.menu_book;
      case 'القرآن الكريم':
        return Icons.book;
      case 'اتجاه القبلة':
        return Icons.explore;
      case 'التسبيح':
        return Icons.touch_app;
      case 'الأدعية':
        return Icons.favorite;
      case 'المفضلة':
        return Icons.bookmark;
      case 'الإعدادات':
        return Icons.settings;
      case 'التقدم اليومي':
        return Icons.trending_up;
      case 'الإنجازات':
        return Icons.emoji_events;
      case 'إعدادات التذكيرات':
        return Icons.notifications;
      case 'إعدادات الإشعارات':
        return Icons.notifications_active;
      case 'إعدادات الصلاة':
        return Icons.mosque;
      default:
        return Icons.construction;
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