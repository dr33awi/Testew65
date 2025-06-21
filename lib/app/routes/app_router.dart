// lib/app/routes/app_router.dart (محدث لشاشات الإعدادات)

import 'package:flutter/material.dart';
import '../themes/index.dart';

// الشاشات الأساسية
import '../../features/home/screens/home_screen.dart';
import '../../features/prayer_times/screens/prayer_times_screen.dart';
import '../../features/prayer_times/screens/prayer_settings_screen.dart';
import '../../features/prayer_times/screens/prayer_notifications_settings_screen.dart';
import '../../features/qibla/screens/qibla_screen.dart';
import '../../features/athkar/screens/athkar_categories_screen.dart';
import '../../features/athkar/screens/athkar_details_screen.dart';
import '../../features/athkar/screens/notification_settings_screen.dart';
import '../../features/tasbih/screens/tasbih_screen.dart';

// شاشات الإعدادات الجديدة
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/theme_settings_screen.dart';
import '../../features/settings/screens/notifications_settings_screen.dart';
import '../../features/settings/screens/permissions_settings_screen.dart';
import '../../features/settings/screens/about_settings_screen.dart';

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

  // ==================== Settings Routes الجديدة ====================
  
  // المظهر والعرض
  static const String themeSettings = '/settings/theme';
  static const String displaySettings = '/settings/display';
  static const String languageSettings = '/settings/language';
  
  // الإشعارات والتنبيهات
  static const String generalNotifications = '/settings/notifications';
  static const String prayerNotifications = '/settings/notifications/prayer';
  static const String athkarNotifications = '/settings/notifications/athkar';
  static const String notificationHistory = '/settings/notifications/history';
  
  // الأذونات والصلاحيات
  static const String permissionsSettings = '/settings/permissions';
  static const String privacySettings = '/settings/privacy';
  
  // البيانات والتخزين
  static const String dataSettings = '/settings/data';
  static const String backupSettings = '/settings/backup';
  
  // الدعم والمعلومات
  static const String aboutSettings = '/settings/about';
  static const String helpSettings = '/settings/help';
  static const String supportSettings = '/settings/support';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('AppRouter: Generating route for ${settings.name}');
    
    switch (settings.name) {
      // ==================== Main Screens ====================
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      
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
        
      // ==================== Feature Routes ====================
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

      // ==================== Settings Routes الجديدة ====================
      
      // المظهر والعرض
      case themeSettings:
        return _slideRoute(const ThemeSettingsScreen(), settings);
        
      case displaySettings:
        return _slideRoute(_buildComingSoonScreen('إعدادات العرض'), settings);
        
      case languageSettings:
        return _slideRoute(_buildComingSoonScreen('إعدادات اللغة'), settings);
      
      // الإشعارات والتنبيهات
      case generalNotifications:
        return _slideRoute(const NotificationsSettingsScreen(), settings);
        
      case prayerNotifications:
        return _slideRoute(_buildComingSoonScreen('إشعارات الصلاة'), settings);
        
      case athkarNotifications:
        return _slideRoute(_buildComingSoonScreen('إشعارات الأذكار'), settings);
        
      case notificationHistory:
        return _slideRoute(_buildComingSoonScreen('سجل الإشعارات'), settings);
      
      // الأذونات والصلاحيات
      case permissionsSettings:
        return _slideRoute(const PermissionsSettingsScreen(), settings);
        
      case privacySettings:
        return _slideRoute(_buildComingSoonScreen('إعدادات الخصوصية'), settings);
      
        
      case backupSettings:
        return _slideRoute(_buildComingSoonScreen('إعدادات النسخ الاحتياطي'), settings);
      
      // الدعم والمعلومات
      case aboutSettings:
        return _slideRoute(const AboutSettingsScreen(), settings);
        
      case helpSettings:
        return _slideRoute(_buildComingSoonScreen('مركز المساعدة'), settings);
        
      case supportSettings:
        return _slideRoute(_buildComingSoonScreen('الدعم الفني'), settings);
        
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
      
      // Settings Icons
      case 'إعدادات العرض':
        return Icons.display_settings;
      case 'إعدادات اللغة':
        return Icons.language;
      case 'إشعارات الصلاة':
        return Icons.mosque;
      case 'إشعارات الأذكار':
        return Icons.menu_book;
      case 'سجل الإشعارات':
        return Icons.history;
      case 'إعدادات الخصوصية':
        return Icons.privacy_tip;
      case 'إعدادات النسخ الاحتياطي':
        return Icons.backup;
      case 'مركز المساعدة':
        return Icons.help_center;
      case 'الدعم الفني':
        return Icons.support_agent;
      
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

  // ==================== Settings Navigation Helpers ====================

  /// Navigate to specific settings screen
  static Future<void> navigateToSettings({
    required String settingsType,
    Object? arguments,
  }) async {
    String route;
    
    switch (settingsType.toLowerCase()) {
      case 'theme':
        route = themeSettings;
        break;
      case 'display':
        route = displaySettings;
        break;
      case 'language':
        route = languageSettings;
        break;
      case 'notifications':
        route = generalNotifications;
        break;
      case 'permissions':
        route = permissionsSettings;
        break;
      case 'privacy':
        route = privacySettings;
        break;
      case 'data':
        route = dataSettings;
        break;
      case 'backup':
        route = backupSettings;
        break;
      case 'about':
        route = aboutSettings;
        break;
      case 'help':
        route = helpSettings;
        break;
      case 'support':
        route = supportSettings;
        break;
      default:
        route = appSettings;
    }

    await push(route, arguments: arguments);
  }

  /// Navigate to notification settings by type
  static Future<void> navigateToNotificationSettings(String type) async {
    String route;
    
    switch (type.toLowerCase()) {
      case 'prayer':
        route = prayerNotifications;
        break;
      case 'athkar':
        route = athkarNotifications;
        break;
      case 'history':
        route = notificationHistory;
        break;
      default:
        route = generalNotifications;
    }

    await push(route);
  }

  /// Quick navigation to main settings sections
  static Future<void> openThemeSettings() => push(themeSettings);
  static Future<void> openNotificationSettings() => push(generalNotifications);
  static Future<void> openPermissionSettings() => push(permissionsSettings);
  static Future<void> openDataSettings() => push(dataSettings);
  static Future<void> openAboutSettings() => push(aboutSettings);

  /// Navigation with result handling
  static Future<T?> pushForResult<T>(
    String routeName, {
    Object? arguments,
    Duration? timeout,
  }) async {
    final future = push<T>(routeName, arguments: arguments);
    
    if (timeout != null) {
      return await future.timeout(timeout);
    }
    
    return await future;
  }

  /// Safe navigation (checks if route exists)
  static Future<bool> safePush(String routeName, {Object? arguments}) async {
    try {
      await push(routeName, arguments: arguments);
      return true;
    } catch (e) {
      debugPrint('Navigation error: $e');
      return false;
    }
  }

  /// Reset to main settings screen
  static Future<void> resetToMainSettings() async {
    await pushAndRemoveUntil(
      appSettings,
      (route) => route.settings.name == home,
    );
  }
}