// lib/app/themes/extensions/theme_extensions.dart
import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/spacing.dart';
import '../core/typography.dart';
import '../core/gradients.dart';
import '../theme_config.dart';

/// Extensions محسنة للوصول السهل لقيم الثيم
extension BuildContextThemeExtensions on BuildContext {
  // ==================== الأساسيات ====================
  
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;
  
  // ==================== Theme Extension ====================
  
  AppThemeExtension get appTheme => theme.extension<AppThemeExtension>()!;
  AppGradientsExtension get gradients => appTheme.gradients;
  AppShadowsExtension get shadows => appTheme.shadows;
  IslamicThemeExtension get islamic => appTheme.islamic;

  // ==================== الألوان ====================
  
  // الألوان الأساسية
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get tertiaryColor => colorScheme.tertiary;
  Color get errorColor => colorScheme.error;
  Color get surfaceColor => colorScheme.surface;
  Color get backgroundColor => colorScheme.surface;
  
  // ألوان النصوص
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get onErrorColor => colorScheme.onError;
  
  // ألوان مخصصة للتطبيق
  Color get cardColor => isDarkMode ? AppColors.darkCard : AppColors.lightCard;
  Color get dividerColor => isDarkMode ? AppColors.darkDivider : AppColors.lightDivider;
  Color get textPrimaryColor => isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get textSecondaryColor => isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get textHintColor => isDarkMode ? AppColors.darkTextHint : AppColors.lightTextHint;
  
  // ألوان الحالة
  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get infoColor => AppColors.info;

  // ==================== أنماط النصوص ====================
  
  // Display
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  
  // Headlines
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  
  // Titles
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  
  // Body
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  
  // Labels
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
  
  // النصوص الإسلامية
  TextStyle get quranTextStyle => islamic.quranTextStyle.copyWith(color: textPrimaryColor);
  TextStyle get hadithTextStyle => islamic.hadithTextStyle.copyWith(color: textPrimaryColor);
  TextStyle get duaTextStyle => islamic.duaTextStyle.copyWith(color: textPrimaryColor);
  TextStyle get prayerNameStyle => islamic.prayerNameStyle.copyWith(color: textPrimaryColor);
  TextStyle get prayerTimeStyle => islamic.prayerTimeStyle.copyWith(color: textSecondaryColor);

  // ==================== التدرجات اللونية ====================
  
  LinearGradient get primaryGradient => gradients.primary;
  LinearGradient get secondaryGradient => gradients.secondary;
  LinearGradient get tertiaryGradient => gradients.tertiary;
  LinearGradient get successGradient => gradients.success;
  LinearGradient get errorGradient => gradients.error;
  LinearGradient get warningGradient => gradients.warning;
  LinearGradient get infoGradient => gradients.info;
  
  // تدرجات خاصة
  LinearGradient get timeBasedGradient => AppGradients.getTimeBasedGradient();
  LinearGradient prayerGradient(String prayerName) => AppGradients.getPrayerGradient(prayerName);
  LinearGradient progressGradient(double progress) => AppGradients.getProgressGradient(progress);

  // ==================== الظلال ====================
  
  List<BoxShadow> get shadowSm => shadows.sm;
  List<BoxShadow> get shadowMd => shadows.md;
  List<BoxShadow> get shadowLg => shadows.lg;
  List<BoxShadow> get shadowXl => shadows.xl;
  List<BoxShadow> get shadowXxl => shadows.xxl;
  
  // ظل ملون
  List<BoxShadow> coloredShadow(Color color) => AppSpacing.coloredShadow(color);

  // ==================== المساحات ====================
  
  // مساحات أساسية
  double get spaceXs => AppSpacing.xs;
  double get spaceSm => AppSpacing.sm;
  double get spaceMd => AppSpacing.md;
  double get spaceLg => AppSpacing.lg;
  double get spaceXl => AppSpacing.xl;
  double get spaceXxl => AppSpacing.xxl;
  double get spaceXxxl => AppSpacing.xxxl;
  double get spaceHuge => AppSpacing.huge;
  
  // مساحات للمكونات
  double get screenPadding => AppSpacing.screenPadding;
  double get cardPadding => AppSpacing.cardPadding;
  double get buttonPadding => AppSpacing.buttonPadding;
  
  // ==================== الأحجام ====================
  
  // أحجام الأيقونات
  double get iconXs => AppSpacing.iconXs;
  double get iconSm => AppSpacing.iconSm;
  double get iconMd => AppSpacing.iconMd;
  double get iconLg => AppSpacing.iconLg;
  double get iconXl => AppSpacing.iconXl;
  double get iconXxl => AppSpacing.iconXxl;
  
  // أحجام المكونات
  double get buttonHeight => AppSpacing.buttonHeightMd;
  double get inputHeight => AppSpacing.inputHeight;
  double get appBarHeight => AppSpacing.appBarHeight;
  double get bottomNavHeight => AppSpacing.bottomNavHeight;
  
  // ==================== BorderRadius ====================
  
  BorderRadius get radiusXs => AppSpacing.circularXs;
  BorderRadius get radiusSm => AppSpacing.circularSm;
  BorderRadius get radiusMd => AppSpacing.circularMd;
  BorderRadius get radiusLg => AppSpacing.circularLg;
  BorderRadius get radiusXl => AppSpacing.circularXl;
  BorderRadius get radiusXxl => AppSpacing.circularXxl;
  BorderRadius get radiusXxxl => AppSpacing.circularXxxl;
  
  // زوايا للمكونات
  BorderRadius get cardBorderRadius => AppSpacing.cardBorderRadiusValue;
  BorderRadius get inputBorderRadius => AppSpacing.inputBorderRadiusValue;
  BorderRadius get buttonBorderRadius => AppSpacing.buttonBorderRadius;

  // ==================== EdgeInsets ====================
  
  EdgeInsets get paddingXs => AppSpacing.allXs;
  EdgeInsets get paddingSm => AppSpacing.allSm;
  EdgeInsets get paddingMd => AppSpacing.allMd;
  EdgeInsets get paddingLg => AppSpacing.allLg;
  EdgeInsets get paddingXl => AppSpacing.allXl;
  EdgeInsets get paddingXxl => AppSpacing.allXxl;
  
  EdgeInsets get screenPaddingInsets => AppSpacing.screenPaddingInsets;
  EdgeInsets get cardPaddingInsets => AppSpacing.cardPaddingInsets;
  EdgeInsets get buttonPaddingInsets => AppSpacing.buttonPaddingInsets;

  // ==================== مساعدات للألوان ====================
  
  /// الحصول على لون متباين للنص
  Color getContrastingTextColor(Color backgroundColor) {
    return AppColors.getContrastingTextColor(backgroundColor);
  }
  
  /// دمج لونين
  Color blendColors(Color color1, Color color2, double ratio) {
    return AppColors.blendColors(color1, color2, ratio);
  }
  
  /// تطبيق شفافية آمنة
  Color withOpacity(Color color, double opacity) {
    return AppColors.withOpacity(color, opacity);
  }

  // ==================== مساعدات للصلوات ====================
  
  /// الحصول على لون الصلاة
  Color getPrayerColor(String prayerName) {
    return AppColors.getPrayerColor(prayerName);
  }
  
  /// الحصول على أيقونة الصلاة
  IconData getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return Icons.wb_twilight;
      case 'الظهر':
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'العصر':
      case 'asr':
        return Icons.wb_cloudy;
      case 'المغرب':
      case 'maghrib':
        return Icons.wb_twilight;
      case 'العشاء':
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  // ==================== مساعدات لـ SnackBar ====================
  
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: successColor,
        icon: Icons.check_circle,
        action: action,
      ),
    );
  }

  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: errorColor,
        icon: Icons.error,
        action: action,
      ),
    );
  }

  void showWarningSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: warningColor,
        icon: Icons.warning,
        action: action,
      ),
    );
  }

  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      _createSnackBar(
        message: message,
        backgroundColor: infoColor,
        icon: Icons.info,
        action: action,
      ),
    );
  }

  SnackBar _createSnackBar({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    SnackBarAction? action,
  }) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: iconSm),
          AppSpacing.widthSm,
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: radiusLg),
      action: action,
    );
  }
}

/// Extensions للألوان المتقدمة
extension ColorExtensionsAdvanced on Color {
  /// إنشاء تدرج إلى لون آخر
  LinearGradient gradientTo(
    Color endColor, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [this, endColor],
    );
  }

  /// إنشاء تدرج شفاف
  LinearGradient get fadeGradient => AppGradients.transparent(this);

  /// إنشاء overlay
  LinearGradient overlayGradient({
    double startOpacity = 0.0,
    double endOpacity = 0.6,
  }) {
    return AppGradients.overlay(
      color: this,
      startOpacity: startOpacity,
      endOpacity: endOpacity,
    );
  }

  /// تطبيق شفافية آمنة
  Color withOpacitySafe(double opacity) {
    return withValues(alpha: opacity.clamp(0.0, 1.0));
  }
}

/// Extensions لأنماط النصوص المتقدمة
extension TextStyleExtensionsAdvanced on TextStyle {
  /// نصوص عربية
  TextStyle get arabic => copyWith(fontFamily: AppTypography.fontFamilyArabic);
  TextStyle get quran => copyWith(fontFamily: AppTypography.fontFamilyQuran);
  TextStyle get english => copyWith(fontFamily: AppTypography.fontFamilyEnglish);

  /// أوزان سريعة
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get light => copyWith(fontWeight: AppTypography.light);
  TextStyle get regular => copyWith(fontWeight: AppTypography.regular);
  TextStyle get medium => copyWith(fontWeight: AppTypography.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTypography.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTypography.bold);
  TextStyle get extraBold => copyWith(fontWeight: AppTypography.extraBold);
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);

  /// أحجام سريعة
  TextStyle get xs => copyWith(fontSize: AppTypography.size10);
  TextStyle get sm => copyWith(fontSize: AppTypography.size12);
  TextStyle get md => copyWith(fontSize: AppTypography.size14);
  TextStyle get lg => copyWith(fontSize: AppTypography.size16);
  TextStyle get xl => copyWith(fontSize: AppTypography.size18);
  TextStyle get xxl => copyWith(fontSize: AppTypography.size20);
  TextStyle get xxxl => copyWith(fontSize: AppTypography.size24);

  /// ارتفاع الأسطر
  TextStyle get tightHeight => copyWith(height: AppTypography.lineHeightTight);
  TextStyle get normalHeight => copyWith(height: AppTypography.lineHeightNormal);
  TextStyle get relaxedHeight => copyWith(height: AppTypography.lineHeightRelaxed);
  TextStyle get looseHeight => copyWith(height: AppTypography.lineHeightLoose);

  /// تباعد الأحرف
  TextStyle get tightLetters => copyWith(letterSpacing: -0.5);
  TextStyle get normalLetters => copyWith(letterSpacing: 0.0);
  TextStyle get wideLetters => copyWith(letterSpacing: 0.5);
  TextStyle get extraWideLetters => copyWith(letterSpacing: 1.0);
}

/// Extensions للمساحات السريعة
extension QuickSpacing on num {
  /// مساحات عمودية
  Widget get h => SizedBox(height: toDouble());
  Widget get height => h;
  
  /// مساحات أفقية
  Widget get w => SizedBox(width: toDouble());
  Widget get width => w;
  
  /// مساحات Sliver
  Widget get sliverBox => SliverToBoxAdapter(child: h);
  
  /// EdgeInsets
  EdgeInsets get padding => EdgeInsets.all(toDouble());
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: toDouble());
  
  /// BorderRadius
  BorderRadius get radius => BorderRadius.circular(toDouble());
  
  /// أحجام Box
  Widget box({double? width, double? height}) => SizedBox(
    width: width ?? toDouble(),
    height: height ?? toDouble(),
  );
}