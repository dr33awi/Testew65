// lib/app/routes/app_router.dart - مُصحح للنظام المبسط وبدون إعدادات

import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/prayer_times/screens/prayer_times_screen.dart';
import '../../features/qibla/screens/qibla_screen.dart';
import '../../features/athkar/screens/athkar_categories_screen.dart';
import '../../features/athkar/screens/athkar_details_screen.dart';
import '../../features/tasbih/screens/tasbih_screen.dart';

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
  static const String progress = '/progress';
  static const String achievements = '/achievements';
  
  // Detail Routes
  static const String athkarDetails = '/athkar-details';
  static const String quranReader = '/quran-reader';
  static const String duaDetails = '/dua-details';

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
        
      case progress:
        return _slideRoute(_buildComingSoonScreen('التقدم اليومي'), settings);
        
      case achievements:
        return _slideRoute(_buildComingSoonScreen('الإنجازات'), settings);
        
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
      transitionDuration: AppTheme.durationNormal,
      reverseTransitionDuration: AppTheme.durationFast,
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
      transitionDuration: AppTheme.durationNormal,
      reverseTransitionDuration: AppTheme.durationFast,
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
      appBar: SimpleAppBar(title: title),
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: AppTheme.space6.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getIconForFeature(title),
                  size: 60,
                  color: AppTheme.primary,
                ),
              ),
              
              AppTheme.space5.h,
              
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                  vertical: AppTheme.space2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppTheme.radiusFull.radius,
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'قريباً',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.primary,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ),
              
              AppTheme.space3.h,
              
              Text(
                title,
                style: AppTheme.headlineMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: AppTheme.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              AppTheme.space2.h,
              
              Text(
                'هذه الميزة قيد التطوير وستكون متاحة قريباً إن شاء الله',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              AppTheme.space6.h,
              
              AppButton.primary(
                text: 'العودة للرئيسية',
                onPressed: () {
                  if (Navigator.canPop(_navigatorKey.currentContext!)) {
                    Navigator.pop(_navigatorKey.currentContext!);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      _navigatorKey.currentContext!,
                      home,
                      (route) => false,
                    );
                  }
                },
                icon: Icons.home,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNotFoundScreen(String? routeName) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: AppTheme.space6.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: AppTheme.error,
                ),
              ),
              
              AppTheme.space5.h,
              
              Text(
                '404',
                style: AppTheme.displayMedium.copyWith(
                  color: AppTheme.error,
                  fontWeight: AppTheme.bold,
                ),
              ),
              
              AppTheme.space2.h,
              
              Text(
                'الصفحة غير موجودة',
                style: AppTheme.headlineMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: AppTheme.bold,
                ),
              ),
              
              AppTheme.space2.h,
              
              Text(
                'لم نتمكن من العثور على الصفحة المطلوبة',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              if (routeName != null) ...[
                AppTheme.space3.h,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space3,
                    vertical: AppTheme.space2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.textTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: AppTheme.textTertiary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    routeName,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textTertiary,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ),
              ],
              
              AppTheme.space6.h,
              
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'العودة',
                      onPressed: () {
                        if (Navigator.canPop(_navigatorKey.currentContext!)) {
                          Navigator.pop(_navigatorKey.currentContext!);
                        }
                      },
                      icon: Icons.arrow_back,
                    ),
                  ),
                  
                  AppTheme.space3.w,
                  
                  Expanded(
                    child: AppButton.primary(
                      text: 'الرئيسية',
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        _navigatorKey.currentContext!,
                        home,
                        (route) => false,
                      ),
                      icon: Icons.home,
                    ),
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
      appBar: const SimpleAppBar(title: 'خطأ'),
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: AppTheme.space6.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: AppTheme.error,
                ),
              ),
              
              AppTheme.space4.h,
              
              Text(
                'خطأ في التطبيق',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.error,
                  fontWeight: AppTheme.bold,
                ),
              ),
              
              AppTheme.space2.h,
              
              Text(
                message,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              AppTheme.space6.h,
              
              AppButton.primary(
                text: 'العودة',
                onPressed: () {
                  if (Navigator.canPop(_navigatorKey.currentContext!)) {
                    Navigator.pop(_navigatorKey.currentContext!);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      _navigatorKey.currentContext!,
                      home,
                      (route) => false,
                    );
                  }
                },
                icon: Icons.arrow_back,
                isFullWidth: true,
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
        return Icons.mosque;
      case 'الأذكار':
        return Icons.menu_book;
      case 'القرآن الكريم':
        return Icons.auto_stories;
      case 'اتجاه القبلة':
        return Icons.explore;
      case 'التسبيح':
        return Icons.fingerprint;
      case 'الأدعية':
        return Icons.volunteer_activism;
      case 'المفضلة':
        return Icons.bookmark;
      case 'التقدم اليومي':
        return Icons.trending_up;
      case 'الإنجازات':
        return Icons.emoji_events;
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