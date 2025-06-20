// lib/app/routes/app_router.dart
import 'package:flutter/material.dart';

// ✅ استيراد النظام المبسط الجديد فقط
import '../themes/index.dart';

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

  // Screen Builders - محدث للنظام المبسط
  static Widget _buildComingSoonScreen(String title) {
    return Scaffold(
      appBar: IslamicAppBar(title: title),
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
            
            Spaces.extraLarge,
            
            Text(
              'قريباً',
              style: AppTypography.heading.copyWith(
                color: ThemeConstants.primary,
              ),
            ),
            
            Spaces.medium,
            
            Text(
              title,
              style: AppTypography.title.copyWith(
                color: ThemeConstants.lightTextSecondary,
              ),
            ),
            
            Spaces.small,
            
            Text(
              'هذه الميزة قيد التطوير',
              style: AppTypography.body.copyWith(
                color: ThemeConstants.lightTextSecondary,
              ),
            ),
            
            Spaces.extraLarge,
            
            IslamicButton.outlined(
              text: 'العودة',
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(),
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
            
            Spaces.extraLarge,
            
            Text(
              '404',
              style: AppTypography.heading.copyWith(
                color: ThemeConstants.error,
              ),
            ),
            
            Spaces.medium,
            
            const Text(
              'الصفحة غير موجودة',
              style: AppTypography.title,
            ),
            
            Spaces.small,
            
            Text(
              'لم نتمكن من العثور على الصفحة المطلوبة',
              style: AppTypography.body.copyWith(
                color: ThemeConstants.lightTextSecondary,
              ),
            ),
            
            if (routeName != null) ...[
              Spaces.medium,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ThemeConstants.lightTextSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  routeName,
                  style: AppTypography.caption.copyWith(
                    color: ThemeConstants.lightTextSecondary,
                  ),
                ),
              ),
            ],
            
            Spaces.extraLarge,
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IslamicButton.outlined(
                  text: 'العودة',
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(),
                ),
                
                Spaces.mediumH,
                
                IslamicButton.primary(
                  text: 'الرئيسية',
                  icon: Icons.home,
                  onPressed: () => Navigator.of(navigatorKey.currentContext!)
                      .pushNamedAndRemoveUntil(home, (route) => false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: const IslamicAppBar(title: 'خطأ'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: ThemeConstants.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 50,
                color: ThemeConstants.error,
              ),
            ),
            
            Spaces.large,
            
            Text(
              message,
              style: AppTypography.body.copyWith(
                color: ThemeConstants.error,
              ),
              textAlign: TextAlign.center,
            ),
            
            Spaces.extraLarge,
            
            IslamicButton.outlined(
              text: 'العودة',
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(navigatorKey.currentContext!).pop(),
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
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();

  // Navigation helper methods
  static Future<T?> push<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T, TO>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  static bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  static void popUntil(bool Function(Route<dynamic>) predicate) {
    return navigatorKey.currentState!.popUntil(predicate);
  }
}