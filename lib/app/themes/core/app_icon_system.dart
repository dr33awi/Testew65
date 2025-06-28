// lib/app/themes/core/app_icon_system.dart - نظام الأيقونات الموحد
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_theme_constants.dart';

/// نظام الأيقونات الموحد للتطبيق الإسلامي
class AppIconSystem {
  AppIconSystem._();
  
  // ========== ألوان الأيقونات الموحدة ==========
  
  /// اللون الافتراضي للأيقونات العامة
  static const Color defaultIconColor = AppColors.textSecondary;
  
  /// اللون الأساسي للأيقونات المهمة
  static const Color primaryIconColor = AppColors.primary;
  
  /// اللون الثانوي للأيقونات التفاعلية
  static const Color secondaryIconColor = AppColors.secondary;
  
  /// اللون للأيقونات المعطلة
  static const Color disabledIconColor = AppColors.textDisabled;
  
  /// اللون للأيقونات النشطة
  static const Color activeIconColor = AppColors.primary;
  
  /// اللون للأيقونات غير النشطة
  static const Color inactiveIconColor = AppColors.textTertiary;
  
  // ========== ألوان حسب السياق ==========
  
  /// ألوان الأيقونات حسب السياق
  static const Map<IconContext, Color> contextColors = {
    IconContext.navigation: AppColors.primary,           // التنقل
    IconContext.action: AppColors.secondary,             // الإجراءات
    IconContext.content: AppColors.textSecondary,        // المحتوى
    IconContext.status: AppColors.accent,                // الحالة
    IconContext.religious: AppColors.primary,            // ديني
    IconContext.settings: AppColors.textTertiary,        // الإعدادات
    IconContext.notification: AppColors.warning,         // الإشعارات
    IconContext.success: AppColors.success,              // النجاح
    IconContext.warning: AppColors.warning,              // التحذير
    IconContext.error: AppColors.error,                  // الخطأ
    IconContext.info: AppColors.info,                    // المعلومات
  };
  
  // ========== الأيقونات المعيارية ==========
  
  /// خريطة الأيقونات الأساسية للتطبيق
  static const Map<String, IconData> standardIcons = {
    // التنقل الأساسي
    'home': Icons.home_rounded,
    'settings': Icons.settings_rounded,
    'profile': Icons.person_rounded,
    'search': Icons.search_rounded,
    'menu': Icons.menu_rounded,
    'back': Icons.arrow_back_rounded,
    'forward': Icons.arrow_forward_rounded,
    'close': Icons.close_rounded,
    
    // الأيقونات الإسلامية
    'mosque': Icons.mosque_rounded,
    'prayer': Icons.mosque_rounded,
    'quran': Icons.book_rounded,
    'dhikr': Icons.menu_book_rounded,
    'qibla': Icons.explore_rounded,
    'tasbih': Icons.touch_app_rounded,
    'dua': Icons.favorite_border_rounded,
    'calendar': Icons.calendar_today_rounded,
    
    // أوقات الصلاة
    'fajr': Icons.wb_twilight_rounded,
    'sunrise': Icons.flare_rounded,
    'dhuhr': Icons.wb_sunny_rounded,
    'asr': Icons.wb_cloudy_rounded,
    'maghrib': Icons.wb_twilight_rounded,
    'isha': Icons.nights_stay_rounded,
    
    // الإجراءات
    'add': Icons.add_rounded,
    'edit': Icons.edit_rounded,
    'delete': Icons.delete_rounded,
    'share': Icons.share_rounded,
    'save': Icons.bookmark_rounded,
    'favorite': Icons.favorite_rounded,
    'play': Icons.play_arrow_rounded,
    'pause': Icons.pause_rounded,
    'stop': Icons.stop_rounded,
    'refresh': Icons.refresh_rounded,
    
    // الحالات
    'check': Icons.check_circle_rounded,
    'warning': Icons.warning_rounded,
    'error': Icons.error_rounded,
    'info': Icons.info_rounded,
    'help': Icons.help_rounded,
    
    // المحتوى
    'text': Icons.text_fields_rounded,
    'image': Icons.image_rounded,
    'audio': Icons.audiotrack_rounded,
    'video': Icons.videocam_rounded,
    'file': Icons.description_rounded,
    
    // الوقت والتاريخ
    'time': Icons.access_time_rounded,
    'timer': Icons.timer_rounded,
    'alarm': Icons.alarm_rounded,
    'date': Icons.date_range_rounded,
    
    // التفاعل
    'like': Icons.thumb_up_rounded,
    'dislike': Icons.thumb_down_rounded,
    'comment': Icons.comment_rounded,
    'reply': Icons.reply_rounded,
    'send': Icons.send_rounded,
    
    // الإعدادات
    'language': Icons.language_rounded,
    'theme': Icons.palette_rounded,
    'notifications': Icons.notifications_rounded,
    'sound': Icons.volume_up_rounded,
    'vibration': Icons.vibration_rounded,
    'brightness': Icons.brightness_6_rounded,
    
    // الاتصال
    'wifi': Icons.wifi_rounded,
    'bluetooth': Icons.bluetooth_rounded,
    'location': Icons.location_on_rounded,
    'phone': Icons.phone_rounded,
    'email': Icons.email_rounded,
    'web': Icons.web_rounded,
  };
  
  // ========== دوال الحصول على الأيقونات ==========
  
  /// الحصول على أيقونة معيارية
  static IconData getIcon(String iconKey) {
    return standardIcons[iconKey] ?? Icons.circle_rounded;
  }
  
  /// الحصول على لون الأيقونة حسب السياق
  static Color getIconColor(IconContext context) {
    return contextColors[context] ?? defaultIconColor;
  }
  
  /// الحصول على أيقونة الصلاة مع لونها
  static IconInfo getPrayerIcon(String prayerName) {
    final iconData = _getPrayerIconData(prayerName);
    final color = AppColors.getPrayerColor(prayerName);
    return IconInfo(icon: iconData, color: color);
  }
  
  /// الحصول على أيقونة الفئة مع لونها
  static IconInfo getCategoryIcon(String categoryId) {
    final iconData = _getCategoryIconData(categoryId);
    final color = AppColors.getCategoryColor(categoryId);
    return IconInfo(icon: iconData, color: color);
  }
  
  /// الحصول على أيقونة الحالة مع لونها
  static IconInfo getStatusIcon(StatusType status) {
    switch (status) {
      case StatusType.success:
        return IconInfo(icon: Icons.check_circle_rounded, color: AppColors.success);
      case StatusType.warning:
        return IconInfo(icon: Icons.warning_rounded, color: AppColors.warning);
      case StatusType.error:
        return IconInfo(icon: Icons.error_rounded, color: AppColors.error);
      case StatusType.info:
        return IconInfo(icon: Icons.info_rounded, color: AppColors.info);
      case StatusType.loading:
        return IconInfo(icon: Icons.hourglass_empty_rounded, color: AppColors.primary);
      case StatusType.completed:
        return IconInfo(icon: Icons.done_all_rounded, color: AppColors.success);
    }
  }
  
  /// الحصول على أيقونة الوقت مع لونها
  static IconInfo getTimeIcon(String timeOfDay) {
    final color = AppColors.getTimeColor(timeOfDay);
    IconData iconData;
    
    switch (timeOfDay) {
      case 'فجر':
        iconData = Icons.wb_twilight_rounded;
        break;
      case 'ضحى':
        iconData = Icons.flare_rounded;
        break;
      case 'ظهيرة':
        iconData = Icons.wb_sunny_rounded;
        break;
      case 'عصر':
        iconData = Icons.wb_cloudy_rounded;
        break;
      case 'مغيب':
        iconData = Icons.wb_twilight_rounded;
        break;
      case 'ليل':
        iconData = Icons.nights_stay_rounded;
        break;
      default:
        iconData = Icons.access_time_rounded;
    }
    
    return IconInfo(icon: iconData, color: color);
  }
  
  // ========== دوال مساعدة خاصة ==========
  
  static IconData _getPrayerIconData(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return Icons.wb_twilight_rounded;
      case 'الشروق':
        return Icons.flare_rounded;
      case 'الظهر':
        return Icons.wb_sunny_rounded;
      case 'العصر':
        return Icons.wb_cloudy_rounded;
      case 'المغرب':
        return Icons.wb_twilight_rounded;
      case 'العشاء':
        return Icons.nights_stay_rounded;
      default:
        return Icons.mosque_rounded;
    }
  }
  
  static IconData _getCategoryIconData(String categoryId) {
    switch (categoryId) {
      case 'اوقات_الصلاة':
        return Icons.mosque_rounded;
      case 'الاذكار':
        return Icons.menu_book_rounded;
      case 'القبلة':
        return Icons.explore_rounded;
      case 'التسبيح':
        return Icons.touch_app_rounded;
      case 'القران':
        return Icons.book_rounded;
      case 'الادعية':
        return Icons.favorite_border_rounded;
      case 'المفضلة':
        return Icons.bookmark_rounded;
      case 'الاعدادات':
        return Icons.settings_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
  
  // ========== أيقونات متحركة ==========
  
  /// الحصول على أيقونة التحميل المتحركة
  static Widget getLoadingIcon({
    Color? color,
    double? size,
  }) {
    return SizedBox(
      width: size ?? AppThemeConstants.iconMd,
      height: size ?? AppThemeConstants.iconMd,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? primaryIconColor,
        ),
      ),
    );
  }
  
  /// أيقونة نبضة للإشعارات
  static Widget getPulsingIcon({
    required IconData icon,
    Color? color,
    double? size,
    Duration duration = const Duration(seconds: 1),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            icon,
            color: color ?? primaryIconColor,
            size: size ?? AppThemeConstants.iconMd,
          ),
        );
      },
    );
  }
}

// ========== أنواع السياق ==========

/// سياق استخدام الأيقونة
enum IconContext {
  navigation,     // التنقل
  action,         // الإجراءات
  content,        // المحتوى
  status,         // الحالة
  religious,      // ديني
  settings,       // الإعدادات
  notification,   // الإشعارات
  success,        // النجاح
  warning,        // التحذير
  error,          // الخطأ
  info,           // المعلومات
}

/// نوع الحالة
enum StatusType {
  success,        // نجاح
  warning,        // تحذير
  error,          // خطأ
  info,           // معلومات
  loading,        // تحميل
  completed,      // مكتمل
}

// ========== فئة معلومات الأيقونة ==========

/// معلومات الأيقونة مع اللون
class IconInfo {
  final IconData icon;
  final Color color;
  final double? size;
  
  const IconInfo({
    required this.icon,
    required this.color,
    this.size,
  });
  
  /// إنشاء Widget للأيقونة
  Widget toWidget({double? customSize}) {
    return Icon(
      icon,
      color: color,
      size: customSize ?? size ?? AppThemeConstants.iconMd,
    );
  }
  
  /// نسخ مع تعديل الخصائص
  IconInfo copyWith({
    IconData? icon,
    Color? color,
    double? size,
  }) {
    return IconInfo(
      icon: icon ?? this.icon,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}

// ========== Extensions للأيقونات ==========

/// Extensions لسهولة استخدام الأيقونات
extension IconExtensions on BuildContext {
  
  /// الحصول على أيقونة بسياق معين
  Widget iconWithContext(String iconKey, IconContext context, {double? size}) {
    final icon = AppIconSystem.getIcon(iconKey);
    final color = AppIconSystem.getIconColor(context);
    return Icon(icon, color: color, size: size ?? AppThemeConstants.iconMd);
  }
  
  /// الحصول على أيقونة الصلاة
  Widget prayerIcon(String prayerName, {double? size}) {
    final iconInfo = AppIconSystem.getPrayerIcon(prayerName);
    return iconInfo.toWidget(customSize: size);
  }
  
  /// الحصول على أيقونة الفئة
  Widget categoryIcon(String categoryId, {double? size}) {
    final iconInfo = AppIconSystem.getCategoryIcon(categoryId);
    return iconInfo.toWidget(customSize: size);
  }
  
  /// الحصول على أيقونة الحالة
  Widget statusIcon(StatusType status, {double? size}) {
    final iconInfo = AppIconSystem.getStatusIcon(status);
    return iconInfo.toWidget(customSize: size);
  }
  
  /// الحصول على أيقونة الوقت
  Widget timeIcon(String timeOfDay, {double? size}) {
    final iconInfo = AppIconSystem.getTimeIcon(timeOfDay);
    return iconInfo.toWidget(customSize: size);
  }
}

// ========== مكونات الأيقونات الجاهزة ==========

/// زر أيقونة موحد
class AppIconButton extends StatelessWidget {
  final String iconKey;
  final IconContext context;
  final VoidCallback onPressed;
  final double? size;
  final String? tooltip;
  final EdgeInsets? padding;
  
  const AppIconButton({
    super.key,
    required this.iconKey,
    required this.context,
    required this.onPressed,
    this.size,
    this.tooltip,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final icon = AppIconSystem.getIcon(iconKey);
    final color = AppIconSystem.getIconColor(this.context);
    
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: size ?? AppThemeConstants.iconMd,
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: padding ?? EdgeInsets.all(AppThemeConstants.space2),
    );
  }
}

/// أيقونة مع خلفية دائرية
class CircularIcon extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;
  final double? iconSize;
  final VoidCallback? onTap;
  
  const CircularIcon({
    super.key,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.size,
    this.iconSize,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final circleSize = size ?? 48.0;
    final actualIconSize = iconSize ?? AppThemeConstants.iconMd;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: actualIconSize,
        ),
      ),
    );
  }
}

/// أيقونة مع شارة (Badge)
class IconWithBadge extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final int? badgeCount;
  final String? badgeText;
  final Color? badgeColor;
  final double? iconSize;
  
  const IconWithBadge({
    super.key,
    required this.icon,
    this.iconColor,
    this.badgeCount,
    this.badgeText,
    this.badgeColor,
    this.iconSize,
  });
  
  @override
  Widget build(BuildContext context) {
    final showBadge = (badgeCount != null && badgeCount! > 0) || 
                     (badgeText != null && badgeText!.isNotEmpty);
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: iconSize ?? AppThemeConstants.iconMd,
        ),
        
        if (showBadge)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeText ?? badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}