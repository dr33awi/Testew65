// lib/app/themes/core/spacing.dart
import 'package:flutter/material.dart';

/// نظام المساحات والأحجام الموحد
/// يستخدم مقياس متسق لجميع المساحات في التطبيق
class AppSpacing {
  AppSpacing._();

  // ==================== مقياس المساحات الأساسي ====================
  
  /// مقياس أساسي 4px - يضمن التناسق
  static const double _baseUnit = 4.0;
  
  static const double xs = _baseUnit;        // 4
  static const double sm = _baseUnit * 2;    // 8
  static const double md = _baseUnit * 3;    // 12
  static const double lg = _baseUnit * 4;    // 16
  static const double xl = _baseUnit * 5;    // 20
  static const double xxl = _baseUnit * 6;   // 24
  static const double xxxl = _baseUnit * 8;  // 32
  static const double huge = _baseUnit * 12; // 48

  // ==================== مساحات مخصصة للتطبيق ====================
  
  /// مساحات الشاشات
  static const double screenPadding = lg;           // 16
  static const double sectionSpacing = xxl;        // 24
  static const double itemSpacing = md;            // 12
  
  /// مساحات البطاقات
  static const double cardPadding = xl;            // 20
  static const double cardMargin = lg;             // 16
  static const double cardSpacing = md;            // 12
  
  /// مساحات الأزرار
  static const double buttonPadding = lg;          // 16
  static const double buttonSpacing = md;          // 12
  
  // ==================== أحجام الأيقونات ====================
  
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;
  
  // ==================== الزوايا المنحنية ====================
  
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusXxxl = 24.0;
  static const double radiusFull = 9999.0;
  
  // ==================== سُمك الحدود ====================
  
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 3.0;
  
  // ==================== مستويات الارتفاع ====================
  
  static const double elevation0 = 0.0;
  static const double elevation1 = 2.0;
  static const double elevation2 = 4.0;
  static const double elevation3 = 8.0;
  static const double elevation4 = 12.0;
  static const double elevation5 = 16.0;
  
  // ==================== أحجام المكونات ====================
  
  /// أحجام الأزرار
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;
  
  /// أحجام الحقول
  static const double inputHeight = 48.0;
  static const double inputBorderRadius = radiusLg;
  
  /// أحجام شرائط التطبيق
  static const double appBarHeight = 60.0;
  static const double bottomNavHeight = 70.0;
  
  /// أحجام البطاقات
  static const double cardMinHeight = 80.0;
  static const double cardBorderRadius = radiusXxl;
  
  // ==================== مساعدات للمساحات ====================
  
  /// تحويل المساحات إلى SizedBox عمودي
  static Widget height(double space) => SizedBox(height: space);
  
  /// تحويل المساحات إلى SizedBox أفقي
  static Widget width(double space) => SizedBox(width: space);
  
  /// مساحات عمودية جاهزة
  static Widget get heightXs => height(xs);
  static Widget get heightSm => height(sm);
  static Widget get heightMd => height(md);
  static Widget get heightLg => height(lg);
  static Widget get heightXl => height(xl);
  static Widget get heightXxl => height(xxl);
  static Widget get heightXxxl => height(xxxl);
  static Widget get heightHuge => height(huge);
  
  /// مساحات أفقية جاهزة
  static Widget get widthXs => width(xs);
  static Widget get widthSm => width(sm);
  static Widget get widthMd => width(md);
  static Widget get widthLg => width(lg);
  static Widget get widthXl => width(xl);
  static Widget get widthXxl => width(xxl);
  static Widget get widthXxxl => width(xxxl);
  static Widget get widthHuge => width(huge);
  
  /// مساحات للـ Sliver
  static Widget sliverHeight(double space) => 
      SliverToBoxAdapter(child: height(space));
  
  static Widget get sliverHeightXs => sliverHeight(xs);
  static Widget get sliverHeightSm => sliverHeight(sm);
  static Widget get sliverHeightMd => sliverHeight(md);
  static Widget get sliverHeightLg => sliverHeight(lg);
  static Widget get sliverHeightXl => sliverHeight(xl);
  static Widget get sliverHeightXxl => sliverHeight(xxl);
  
  // ==================== EdgeInsets مُعرَّفة مسبقاً ====================
  
  /// حشو متماثل
  static EdgeInsets all(double space) => EdgeInsets.all(space);
  static EdgeInsets get allXs => all(xs);
  static EdgeInsets get allSm => all(sm);
  static EdgeInsets get allMd => all(md);
  static EdgeInsets get allLg => all(lg);
  static EdgeInsets get allXl => all(xl);
  static EdgeInsets get allXxl => all(xxl);
  
  /// حشو أفقي
  static EdgeInsets horizontal(double space) => 
      EdgeInsets.symmetric(horizontal: space);
  static EdgeInsets get horizontalXs => horizontal(xs);
  static EdgeInsets get horizontalSm => horizontal(sm);
  static EdgeInsets get horizontalMd => horizontal(md);
  static EdgeInsets get horizontalLg => horizontal(lg);
  static EdgeInsets get horizontalXl => horizontal(xl);
  static EdgeInsets get horizontalXxl => horizontal(xxl);
  
  /// حشو عمودي
  static EdgeInsets vertical(double space) => 
      EdgeInsets.symmetric(vertical: space);
  static EdgeInsets get verticalXs => vertical(xs);
  static EdgeInsets get verticalSm => vertical(sm);
  static EdgeInsets get verticalMd => vertical(md);
  static EdgeInsets get verticalLg => vertical(lg);
  static EdgeInsets get verticalXl => vertical(xl);
  static EdgeInsets get verticalXxl => vertical(xxl);
  
  /// حشو مخصص للمكونات
  static EdgeInsets get screenPaddingInsets => all(screenPadding);
  static EdgeInsets get cardPaddingInsets => all(cardPadding);
  static EdgeInsets get buttonPaddingInsets => 
      EdgeInsets.symmetric(horizontal: lg, vertical: md);
  
  // ==================== BorderRadius مُعرَّف مسبقاً ====================
  
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
  static BorderRadius get circularXs => circular(radiusXs);
  static BorderRadius get circularSm => circular(radiusSm);
  static BorderRadius get circularMd => circular(radiusMd);
  static BorderRadius get circularLg => circular(radiusLg);
  static BorderRadius get circularXl => circular(radiusXl);
  static BorderRadius get circularXxl => circular(radiusXxl);
  static BorderRadius get circularXxxl => circular(radiusXxxl);
  
  /// زوايا مخصصة للمكونات
  static BorderRadius get cardBorderRadiusValue => circular(cardBorderRadius);
  static BorderRadius get inputBorderRadiusValue => circular(inputBorderRadius);
  static BorderRadius get buttonBorderRadius => circular(radiusLg);
  
  // ==================== BoxShadow مُعرَّفة مسبقاً ====================
  
  /// ظلال مختلفة الأحجام
  static List<BoxShadow> shadow({
    required double elevation,
    Color color = const Color(0x1A000000),
    double spreadRadius = 0,
  }) {
    return [
      BoxShadow(
        color: color,
        blurRadius: elevation,
        offset: Offset(0, elevation / 2),
        spreadRadius: spreadRadius,
      ),
    ];
  }
  
  static List<BoxShadow> get shadowSm => shadow(elevation: elevation1);
  static List<BoxShadow> get shadowMd => shadow(elevation: elevation2);
  static List<BoxShadow> get shadowLg => shadow(elevation: elevation3);
  static List<BoxShadow> get shadowXl => shadow(elevation: elevation4);
  static List<BoxShadow> get shadowXxl => shadow(elevation: elevation5);
  
  /// ظل ملون للبطاقات الخاصة
  static List<BoxShadow> coloredShadow(Color color, {double elevation = 8.0}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: elevation * 3,
        offset: Offset(0, elevation * 1.5),
        spreadRadius: 2,
      ),
    ];
  }
}

/// Extension للأرقام لتحويلها لمساحات
extension SpacingExtension on num {
  /// تحويل لـ SizedBox عمودي
  Widget get h => SizedBox(height: toDouble());
  
  /// تحويل لـ SizedBox أفقي  
  Widget get w => SizedBox(width: toDouble());
  
  /// تحويل لـ SliverBox
  Widget get sliverBox => SliverToBoxAdapter(child: h);
  
  /// تحويل لـ EdgeInsets متماثل
  EdgeInsets get all => EdgeInsets.all(toDouble());
  
  /// تحويل لـ EdgeInsets أفقي
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  
  /// تحويل لـ EdgeInsets عمودي
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  
  /// تحويل لـ BorderRadius
  BorderRadius get circular => BorderRadius.circular(toDouble());
}