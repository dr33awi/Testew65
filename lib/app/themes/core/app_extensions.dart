// lib/app/themes/core/app_extensions.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_theme_constants.dart';

/// Extensions للوصول السهل للثيم والألوان
extension ThemeExtensions on BuildContext {
  
  // ========== الثيم العام ==========
  
  ThemeData get theme => Theme.of(this);
  
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;
  
  // ========== الألوان ==========
  
  /// الألوان الأساسية
  Color get primaryColor => AppColors.primary;
  Color get secondaryColor => AppColors.secondary;
  Color get accentColor => AppColors.accent;
  Color get tertiaryColor => AppColors.tertiary;
  
  /// ألوان الحالة
  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get errorColor => AppColors.error;
  Color get infoColor => AppColors.info;
  
  /// ألوان النصوص
  Color get textPrimaryColor => isDarkMode 
      ? AppColors.textPrimaryDark 
      : AppColors.textPrimary;
  Color get textSecondaryColor => isDarkMode 
      ? AppColors.textSecondaryDark 
      : AppColors.textSecondary;
  Color get textTertiaryColor => isDarkMode 
      ? AppColors.textTertiaryDark 
      : AppColors.textTertiary;
  
  /// ألوان الخلفيات
  Color get backgroundColor => isDarkMode 
      ? AppColors.backgroundDark 
      : AppColors.backgroundLight;
  Color get surfaceColor => isDarkMode 
      ? AppColors.surfaceDark 
      : AppColors.surfaceLight;
  Color get cardColor => isDarkMode 
      ? AppColors.cardDark 
      : AppColors.cardLight;
  
  /// ألوان الحدود
  Color get dividerColor => isDarkMode 
      ? AppColors.dividerDark 
      : AppColors.divider;
  Color get borderColor => isDarkMode 
      ? AppColors.borderDark 
      : AppColors.border;
  
  /// الحصول على لون الصلاة
  Color getPrayerColor(String prayerName) {
    return AppColors.getPrayerColor(prayerName);
  }
  
  /// الحصول على لون الفئة
  Color getCategoryColor(String categoryId) {
    return AppColors.getCategoryColor(categoryId);
  }
  
  // ========== التدرجات ==========
  
  LinearGradient get primaryGradient => AppColors.primaryGradient;
  LinearGradient get secondaryGradient => AppColors.secondaryGradient;
  LinearGradient get accentGradient => AppColors.accentGradient;
  LinearGradient get tertiaryGradient => AppColors.tertiaryGradient;
  LinearGradient get successGradient => AppColors.successGradient;
  LinearGradient get warningGradient => AppColors.warningGradient;
  LinearGradient get errorGradient => AppColors.errorGradient;
  LinearGradient get infoGradient => AppColors.infoGradient;
  
  /// تدرج حسب الوقت
  LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    return AppColors.getTimeBasedGradient(dateTime: dateTime);
  }
  
  // ========== أنماط النصوص ==========
  
  TextStyle? get displayLarge => AppTextStyles.displayLarge;
  TextStyle? get displayMedium => AppTextStyles.displayMedium;
  TextStyle? get displaySmall => AppTextStyles.displaySmall;
  
  TextStyle? get headlineLarge => AppTextStyles.headlineLarge;
  TextStyle? get headlineMedium => AppTextStyles.headlineMedium;
  TextStyle? get headlineSmall => AppTextStyles.headlineSmall;
  
  TextStyle? get titleLarge => AppTextStyles.titleLarge;
  TextStyle? get titleMedium => AppTextStyles.titleMedium;
  TextStyle? get titleSmall => AppTextStyles.titleSmall;
  
  TextStyle? get bodyLarge => AppTextStyles.bodyLarge;
  TextStyle? get bodyMedium => AppTextStyles.bodyMedium;
  TextStyle? get bodySmall => AppTextStyles.bodySmall;
  
  TextStyle? get labelLarge => AppTextStyles.labelLarge;
  TextStyle? get labelMedium => AppTextStyles.labelMedium;
  TextStyle? get labelSmall => AppTextStyles.labelSmall;
  
  // أنماط مخصصة
  TextStyle? get islamicStyle => AppTextStyles.islamic;
  TextStyle? get numbersStyle => AppTextStyles.numbers;
  TextStyle? get counterStyle => AppTextStyles.counter;
  
  // ========== معلومات الشاشة ==========
  
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get screenPadding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  
  /// نوع الجهاز
  DeviceType get deviceType => AppThemeConstants.getDeviceType(screenWidth);
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  
  /// عدد الأعمدة للشبكة
  int get gridColumns => AppThemeConstants.getGridColumns(screenWidth);
  
  /// المسافة المتجاوبة
  double get responsiveSpacing => AppThemeConstants.getResponsiveSpacing(screenWidth);
  
  /// حجم الخط المتجاوب
  double getResponsiveFontSize(double baseFontSize) {
    return AppThemeConstants.getResponsiveFontSize(screenWidth, baseFontSize);
  }
}

/// Extensions للأيقونات المخصصة
extension IconExtensions on BuildContext {
  
  /// الحصول على أيقونة الصلاة
  IconData getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return Icons.wb_twilight_rounded;
      case 'dhuhr':
      case 'الظهر':
        return Icons.wb_sunny_rounded;
      case 'asr':
      case 'العصر':
        return Icons.wb_cloudy_rounded;
      case 'maghrib':
      case 'المغرب':
        return Icons.wb_twilight_rounded;
      case 'isha':
      case 'العشاء':
        return Icons.nights_stay_rounded;
      case 'sunrise':
      case 'الشروق':
        return Icons.flare_rounded;
      default:
        return Icons.mosque_rounded;
    }
  }
  
  /// الحصول على أيقونة الفئة
  IconData getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'prayer_times':
        return Icons.mosque_rounded;
      case 'athkar':
        return Icons.menu_book_rounded;
      case 'qibla':
        return Icons.explore_rounded;
      case 'tasbih':
        return Icons.touch_app_rounded;
      case 'quran':
        return Icons.book_rounded;
      case 'dua':
        return Icons.favorite_rounded;
      case 'favorites':
        return Icons.bookmark_rounded;
      case 'settings':
        return Icons.settings_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}

/// Extensions للإشعارات والرسائل
extension SnackBarExtensions on BuildContext {
  
  /// إظهار رسالة نجاح
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showSuccess(
      context: this,
      message: message,
      action: action,
    );
  }
  
  /// إظهار رسالة خطأ
  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showError(
      context: this,
      message: message,
      action: action,
    );
  }
  
  /// إظهار رسالة تحذير
  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showWarning(
      context: this,
      message: message,
      action: action,
    );
  }
  
  /// إظهار رسالة معلومات
  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    AppSnackBar.showInfo(
      context: this,
      message: message,
      action: action,
    );
  }
}

/// نظام الإشعارات الموحد
class AppSnackBar {
  AppSnackBar._();
  
  static void showSuccess({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_rounded,
      action: action,
      duration: duration,
    );
  }
  
  static void showError({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_rounded,
      action: action,
      duration: duration,
    );
  }
  
  static void showWarning({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_rounded,
      action: action,
      duration: duration,
    );
  }
  
  static void showInfo({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_rounded,
      action: action,
      duration: duration,
    );
  }
  
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    SnackBarAction? action,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: AppThemeConstants.iconMd,
            ),
            const SizedBox(width: AppThemeConstants.space3),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
        margin: const EdgeInsets.all(AppThemeConstants.space4),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }
}

/// نظام الحوارات الموحد
class AppInfoDialog {
  AppInfoDialog._();
  
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: TextStyle(color: context.textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? context.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
              ),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'حسناً',
    IconData? icon,
    Color? accentColor,
    List<DialogAction>? actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: accentColor ?? context.primaryColor,
                size: AppThemeConstants.iconLg,
              ),
              const SizedBox(width: AppThemeConstants.space2),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
        ),
        actions: actions?.map((action) => 
          action.isPrimary 
              ? ElevatedButton(
                  onPressed: action.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor ?? context.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
                    ),
                  ),
                  child: Text(
                    action.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : TextButton(
                  onPressed: action.onPressed,
                  child: Text(
                    action.label,
                    style: TextStyle(
                      color: accentColor ?? context.primaryColor,
                    ),
                  ),
                ),
        ).toList() ?? [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              buttonText,
              style: TextStyle(
                color: accentColor ?? context.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// إجراء في الحوار
class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  
  const DialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

/// مساعدين للفئات والصلوات
class CategoryHelper {
  CategoryHelper._();
  
  /// الحصول على لون الفئة
  static Color getCategoryColor(BuildContext context, String categoryId) {
    return context.getCategoryColor(categoryId);
  }
  
  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'prayer_times':
        return Icons.mosque_rounded;
      case 'athkar':
        return Icons.menu_book_rounded;
      case 'qibla':
        return Icons.explore_rounded;
      case 'tasbih':
        return Icons.touch_app_rounded;
      case 'quran':
        return Icons.book_rounded;
      case 'dua':
        return Icons.favorite_rounded;
      case 'favorites':
        return Icons.bookmark_rounded;
      case 'settings':
        return Icons.settings_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
  
  /// الحصول على وصف الفئة
  static String getCategoryDescription(String categoryId) {
    switch (categoryId) {
      case 'prayer_times':
        return 'أوقات الصلوات الخمس';
      case 'athkar':
        return 'أذكار الصباح والمساء';
      case 'qibla':
        return 'البوصلة الإسلامية';
      case 'tasbih':
        return 'تسبيح رقمي';
      case 'quran':
        return 'القرآن الكريم';
      case 'dua':
        return 'الأدعية المأثورة';
      case 'favorites':
        return 'المحفوظات المفضلة';
      case 'settings':
        return 'إعدادات التطبيق';
      default:
        return '';
    }
  }
  
  /// الحصول على الوقت الافتراضي للتذكير
  static TimeOfDay getDefaultReminderTime(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return const TimeOfDay(hour: 7, minute: 0);
      case 'evening':
        return const TimeOfDay(hour: 18, minute: 0);
      case 'night':
        return const TimeOfDay(hour: 21, minute: 0);
      default:
        return const TimeOfDay(hour: 8, minute: 0);
    }
  }
  
  /// هل يجب تفعيل التذكير تلقائياً
  static bool shouldAutoEnable(String categoryId) {
    return ['morning', 'evening'].contains(categoryId);
  }
}

/// مساعدين للاقتباسات
class QuoteHelper {
  QuoteHelper._();
  
  /// الحصول على ألوان الاقتباس
  static List<Color> getQuoteColors(BuildContext context, String type) {
    switch (type) {
      case 'verse':
        return [
          context.primaryColor,
          context.primaryColor.darken(0.2),
        ];
      case 'hadith':
        return [
          context.accentColor,
          context.accentColor.darken(0.2),
        ];
      case 'dua':
        return [
          context.tertiaryColor,
          context.tertiaryColor.darken(0.2),
        ];
      default:
        return [
          context.secondaryColor,
          context.secondaryColor.darken(0.2),
        ];
    }
  }
  
  /// الحصول على اللون الأساسي للاقتباس
  static Color getQuotePrimaryColor(BuildContext context, String type) {
    return getQuoteColors(context, type).first;
  }
}

/// مساعدين للحركة
class AppAnimations {
  AppAnimations._();
  
  /// حركة الظهور التدريجي
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      builder: (context, value, child) {
        return Opacity(
          opacity: delay == Duration.zero 
              ? value 
              : (value > delay.inMilliseconds / (duration + delay).inMilliseconds ? 
                  (value - delay.inMilliseconds / (duration + delay).inMilliseconds) * 
                  (duration + delay).inMilliseconds / duration.inMilliseconds : 0),
          child: child,
        );
      },
      child: child,
    );
  }
  
  /// حركة الانزلاق من الأسفل
  static Widget slideUp({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    double offset = 50.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offset * value),
          child: child,
        );
      },
      child: child,
    );
  }
  
  /// حركة التكبير
  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    double beginScale = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: beginScale, end: 1.0),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}