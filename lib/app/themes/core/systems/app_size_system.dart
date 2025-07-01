// lib/app/themes/core/systems/app_size_system.dart - النسخة النظيفة (موحدة مع ThemeConstants)
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';

/// نظام الأحجام الموحد - يستخدم قيم ThemeConstants لتجنب التضارب
class AppSizeSystem {
  AppSizeSystem._();

  // ===== استخدام قيم ThemeConstants مباشرة لتجنب التضارب =====
  
  /// أحجام المكونات المختلفة - موحدة مع ThemeConstants
  static const Map<ComponentSize, ComponentSizes> _componentSizes = {
    ComponentSize.xs: ComponentSizes(
      height: ThemeConstants.heightXs,
      width: 64,
      iconSize: ThemeConstants.iconXs,
      fontSize: ThemeConstants.textSizeXs,
      padding: EdgeInsets.all(ThemeConstants.space2),
      borderRadius: ThemeConstants.radiusXs,
    ),
    ComponentSize.sm: ComponentSizes(
      height: ThemeConstants.heightSm,
      width: 80,
      iconSize: ThemeConstants.iconSm,
      fontSize: ThemeConstants.textSizeSm,
      padding: EdgeInsets.all(ThemeConstants.space3),
      borderRadius: ThemeConstants.radiusSm,
    ),
    ComponentSize.md: ComponentSizes(
      height: ThemeConstants.heightMd,
      width: 120,
      iconSize: ThemeConstants.iconMd, // ✅ موحد مع ThemeConstants
      fontSize: ThemeConstants.textSizeMd,
      padding: EdgeInsets.all(ThemeConstants.space4),
      borderRadius: ThemeConstants.radiusMd,
    ),
    ComponentSize.lg: ComponentSizes(
      height: ThemeConstants.heightLg,
      width: 160,
      iconSize: ThemeConstants.iconLg,
      fontSize: ThemeConstants.textSizeLg,
      padding: EdgeInsets.all(ThemeConstants.space5),
      borderRadius: ThemeConstants.radiusLg,
    ),
    ComponentSize.xl: ComponentSizes(
      height: ThemeConstants.heightXl,
      width: 200,
      iconSize: ThemeConstants.iconXl,
      fontSize: ThemeConstants.textSizeXl,
      padding: EdgeInsets.all(ThemeConstants.space6),
      borderRadius: ThemeConstants.radiusXl,
    ),
    ComponentSize.xxl: ComponentSizes(
      height: ThemeConstants.height2xl,
      width: 240,
      iconSize: ThemeConstants.icon2xl,
      fontSize: ThemeConstants.textSize2xl,
      padding: EdgeInsets.all(ThemeConstants.space8),
      borderRadius: ThemeConstants.radius2xl,
    ),
  };

  // ===== دوال الحصول على الأحجام =====

  /// الحصول على ارتفاع المكون
  static double getHeight(ComponentSize size) {
    return _componentSizes[size]?.height ?? ThemeConstants.heightMd;
  }

  /// الحصول على عرض المكون
  static double getWidth(ComponentSize size) {
    return _componentSizes[size]?.width ?? 120;
  }

  /// الحصول على حجم الأيقونة
  static double getIconSize(ComponentSize size) {
    return _componentSizes[size]?.iconSize ?? ThemeConstants.iconMd;
  }

  /// الحصول على حجم الخط
  static double getFontSize(ComponentSize size) {
    return _componentSizes[size]?.fontSize ?? ThemeConstants.textSizeMd;
  }

  /// الحصول على الحشو الداخلي
  static EdgeInsets getPadding(ComponentSize size) {
    return _componentSizes[size]?.padding ?? const EdgeInsets.all(ThemeConstants.space4);
  }

  /// الحصول على نصف قطر الحدود
  static double getBorderRadius(ComponentSize size) {
    return _componentSizes[size]?.borderRadius ?? ThemeConstants.radiusMd;
  }

  /// الحصول على جميع أحجام المكون
  static ComponentSizes getSizes(ComponentSize size) {
    return _componentSizes[size] ?? _componentSizes[ComponentSize.md]!;
  }

  // ===== دوال مخصصة للمكونات المختلفة =====

  /// أحجام الأزرار
  static ButtonSizes getButtonSizes(ComponentSize size) {
    final base = getSizes(size);
    return ButtonSizes(
      height: base.height,
      minWidth: base.width,
      padding: base.padding,
      borderRadius: base.borderRadius,
      iconSize: base.iconSize,
      fontSize: base.fontSize,
    );
  }

  /// أحجام حقول الإدخال
  static InputSizes getInputSizes(ComponentSize size) {
    final base = getSizes(size);
    return InputSizes(
      height: base.height,
      padding: base.padding,
      borderRadius: base.borderRadius,
      fontSize: base.fontSize,
      iconSize: base.iconSize,
    );
  }

  /// أحجام البطاقات
  static CardSizes getCardSizes(ComponentSize size) {
    final base = getSizes(size);
    return CardSizes(
      padding: EdgeInsets.all(base.padding.left * 1.5),
      borderRadius: base.borderRadius,
      titleFontSize: base.fontSize + 2,
      contentFontSize: base.fontSize,
      iconSize: base.iconSize + 4,
    );
  }

  /// أحجام مؤشرات التحميل
  static LoadingSizes getLoadingSizes(ComponentSize size) {
    final base = getSizes(size);
    return LoadingSizes(
      size: base.iconSize + 8,
      strokeWidth: (base.iconSize / 8).clamp(2.0, 4.0),
    );
  }

  /// أحجام الحوارات
  static DialogSizes getDialogSizes(ComponentSize size) {
    final base = getSizes(size);
    return DialogSizes(
      padding: EdgeInsets.all(base.padding.left * 1.5),
      borderRadius: base.borderRadius + 4,
      titleFontSize: base.fontSize + 4,
      contentFontSize: base.fontSize,
      iconSize: base.iconSize + 8,
    );
  }

  // ===== دوال مساعدة =====

  /// الحصول على حجم متجاوب حسب عرض الشاشة
  static ComponentSize getResponsiveSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < ThemeConstants.breakpointMobile) {
      return ComponentSize.sm; // هواتف صغيرة
    } else if (width < ThemeConstants.breakpointTablet) {
      return ComponentSize.md; // هواتف عادية
    } else if (width < ThemeConstants.breakpointDesktop) {
      return ComponentSize.lg; // أجهزة لوحية
    } else {
      return ComponentSize.xl; // أجهزة سطح المكتب
    }
  }

  /// التحقق من صحة الحجم
  static bool isValidSize(ComponentSize size) {
    return _componentSizes.containsKey(size);
  }

  /// الحصول على جميع الأحجام المتاحة
  static List<ComponentSize> getAllSizes() {
    return ComponentSize.values;
  }

  /// مقارنة الأحجام
  static int compareSize(ComponentSize a, ComponentSize b) {
    return a.index.compareTo(b.index);
  }

  /// الحصول على الحجم التالي
  static ComponentSize? getNextSize(ComponentSize current) {
    final currentIndex = current.index;
    if (currentIndex < ComponentSize.values.length - 1) {
      return ComponentSize.values[currentIndex + 1];
    }
    return null;
  }

  /// الحصول على الحجم السابق
  static ComponentSize? getPreviousSize(ComponentSize current) {
    final currentIndex = current.index;
    if (currentIndex > 0) {
      return ComponentSize.values[currentIndex - 1];
    }
    return null;
  }
}

// ===== التعدادات والفئات المساعدة =====

/// أحجام المكونات المختلفة
enum ComponentSize {
  xs,    // صغير جداً
  sm,    // صغير
  md,    // متوسط (الافتراضي)
  lg,    // كبير
  xl,    // كبير جداً
  xxl,   // الأكبر
}

/// فئة تحتوي على جميع أحجام المكون
class ComponentSizes {
  final double height;
  final double width;
  final double iconSize;
  final double fontSize;
  final EdgeInsets padding;
  final double borderRadius;

  const ComponentSizes({
    required this.height,
    required this.width,
    required this.iconSize,
    required this.fontSize,
    required this.padding,
    required this.borderRadius,
  });
}

/// أحجام مخصصة للأزرار
class ButtonSizes {
  final double height;
  final double minWidth;
  final EdgeInsets padding;
  final double borderRadius;
  final double iconSize;
  final double fontSize;

  const ButtonSizes({
    required this.height,
    required this.minWidth,
    required this.padding,
    required this.borderRadius,
    required this.iconSize,
    required this.fontSize,
  });
}

/// أحجام مخصصة لحقول الإدخال
class InputSizes {
  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;
  final double iconSize;

  const InputSizes({
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.fontSize,
    required this.iconSize,
  });
}

/// أحجام مخصصة للبطاقات
class CardSizes {
  final EdgeInsets padding;
  final double borderRadius;
  final double titleFontSize;
  final double contentFontSize;
  final double iconSize;

  const CardSizes({
    required this.padding,
    required this.borderRadius,
    required this.titleFontSize,
    required this.contentFontSize,
    required this.iconSize,
  });
}

/// أحجام مخصصة لمؤشرات التحميل
class LoadingSizes {
  final double size;
  final double strokeWidth;

  const LoadingSizes({
    required this.size,
    required this.strokeWidth,
  });
}

/// أحجام مخصصة للحوارات
class DialogSizes {
  final EdgeInsets padding;
  final double borderRadius;
  final double titleFontSize;
  final double contentFontSize;
  final double iconSize;

  const DialogSizes({
    required this.padding,
    required this.borderRadius,
    required this.titleFontSize,
    required this.contentFontSize,
    required this.iconSize,
  });
}

/// Extension لتسهيل الاستخدام
extension ComponentSizeExtension on ComponentSize {
  /// الحصول على الارتفاع
  double get height => AppSizeSystem.getHeight(this);
  
  /// الحصول على العرض
  double get width => AppSizeSystem.getWidth(this);
  
  /// الحصول على حجم الأيقونة
  double get iconSize => AppSizeSystem.getIconSize(this);
  
  /// الحصول على حجم الخط
  double get fontSize => AppSizeSystem.getFontSize(this);
  
  /// الحصول على الحشو الداخلي
  EdgeInsets get padding => AppSizeSystem.getPadding(this);
  
  /// الحصول على نصف قطر الحدود
  double get borderRadius => AppSizeSystem.getBorderRadius(this);
  
  /// الحصول على جميع الأحجام
  ComponentSizes get sizes => AppSizeSystem.getSizes(this);
  
  /// الحصول على أحجام الأزرار
  ButtonSizes get buttonSizes => AppSizeSystem.getButtonSizes(this);
  
  /// الحصول على أحجام الإدخال
  InputSizes get inputSizes => AppSizeSystem.getInputSizes(this);
  
  /// الحصول على أحجام البطاقات
  CardSizes get cardSizes => AppSizeSystem.getCardSizes(this);
  
  /// الحصول على أحجام التحميل
  LoadingSizes get loadingSizes => AppSizeSystem.getLoadingSizes(this);
  
  /// الحصول على أحجام الحوارات
  DialogSizes get dialogSizes => AppSizeSystem.getDialogSizes(this);
}

/// Extension للسياق للحصول على الحجم المتجاوب
extension ResponsiveSizeExtension on BuildContext {
  /// الحصول على الحجم المتجاوب
  ComponentSize get responsiveSize => AppSizeSystem.getResponsiveSize(this);
}