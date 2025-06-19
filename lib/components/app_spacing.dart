// lib/app/components/app_spacing.dart
// مساحات التطبيق الموحدة

import 'package:athkar_app/app/themes/widgets.dart';
import 'package:flutter/material.dart';

/// مساحات التطبيق الموحدة
/// لتغيير المساحات في التطبيق، عدل هنا فقط!
class AppSpacing {
  AppSpacing._();

  // ==================== المساحات الأساسية ====================
  
  static const double tiny = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const double huge = 48.0;

  // ==================== Widgets المساحات ====================
  
  /// مساحة عمودية صغيرة
  static Widget get verticalTiny => const VSpace(tiny);
  static Widget get verticalSmall => const VSpace(small);
  static Widget get verticalMedium => const VSpace(medium);
  static Widget get verticalLarge => const VSpace(large);
  static Widget get verticalExtraLarge => const VSpace(extraLarge);
  static Widget get verticalHuge => const VSpace(huge);

  /// مساحة أفقية صغيرة
  static Widget get horizontalTiny => const HSpace(tiny);
  static Widget get horizontalSmall => const HSpace(small);
  static Widget get horizontalMedium => const HSpace(medium);
  static Widget get horizontalLarge => const HSpace(large);
  static Widget get horizontalExtraLarge => const HSpace(extraLarge);
  static Widget get horizontalHuge => const HSpace(huge);

  /// إنشاء مساحات مخصصة
  static Widget vertical(double height) => VSpace(height);
  static Widget horizontal(double width) => HSpace(width);

  // ==================== EdgeInsets ====================
  
  /// حشو متماثل
  static EdgeInsets get paddingTiny => const EdgeInsets.all(tiny);
  static EdgeInsets get paddingSmall => const EdgeInsets.all(small);
  static EdgeInsets get paddingMedium => const EdgeInsets.all(medium);
  static EdgeInsets get paddingLarge => const EdgeInsets.all(large);
  static EdgeInsets get paddingExtraLarge => const EdgeInsets.all(extraLarge);

  /// حشو أفقي
  static EdgeInsets get paddingHorizontalTiny => 
      const EdgeInsets.symmetric(horizontal: tiny);
  static EdgeInsets get paddingHorizontalSmall => 
      const EdgeInsets.symmetric(horizontal: small);
  static EdgeInsets get paddingHorizontalMedium => 
      const EdgeInsets.symmetric(horizontal: medium);
  static EdgeInsets get paddingHorizontalLarge => 
      const EdgeInsets.symmetric(horizontal: large);

  /// حشو عمودي
  static EdgeInsets get paddingVerticalTiny => 
      const EdgeInsets.symmetric(vertical: tiny);
  static EdgeInsets get paddingVerticalSmall => 
      const EdgeInsets.symmetric(vertical: small);
  static EdgeInsets get paddingVerticalMedium => 
      const EdgeInsets.symmetric(vertical: medium);
  static EdgeInsets get paddingVerticalLarge => 
      const EdgeInsets.symmetric(vertical: large);

  /// حشو مخصص
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    } else if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    } else {
      return EdgeInsets.only(
        top: top ?? 0,
        bottom: bottom ?? 0,
        left: left ?? 0,
        right: right ?? 0,
      );
    }
  }

  // ==================== مساحات خاصة بالمكونات ====================
  
  /// مساحات الشاشات
  static EdgeInsets get screenPadding => paddingMedium;
  static EdgeInsets get screenPaddingHorizontal => paddingHorizontalMedium;
  
  /// مساحات البطاقات
  static EdgeInsets get cardPadding => paddingLarge;
  static EdgeInsets get cardMargin => paddingMedium;
  
  /// مساحات الأزرار
  static EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
    horizontal: large,
    vertical: medium,
  );
  
  /// مساحات القوائم
  static EdgeInsets get listItemPadding => const EdgeInsets.symmetric(
    horizontal: medium,
    vertical: small,
  );
  
  /// مساحات الحقول
  static EdgeInsets get inputPadding => const EdgeInsets.symmetric(
    horizontal: medium,
    vertical: medium,
  );

  // ==================== مساعدات سريعة ====================
  
  /// فصل بين العناصر
  static Widget get separator => verticalMedium;
  static Widget get smallSeparator => verticalSmall;
  static Widget get largeSeparator => verticalLarge;
  
  /// فاصل أفقي
  static Widget get horizontalSeparator => horizontalMedium;
  static Widget get smallHorizontalSeparator => horizontalSmall;
  static Widget get largeHorizontalSeparator => horizontalLarge;
}

/// Widget لإنشاء layout بمساحات منتظمة
class AppColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const AppColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = AppSpacing.medium,
    this.padding,
  });

  /// عمود مع مساحات صغيرة
  factory AppColumn.small({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    EdgeInsetsGeometry? padding,
  }) {
    return AppColumn(
      children: children,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      spacing: AppSpacing.small,
      padding: padding,
    );
  }

  /// عمود مع مساحات كبيرة
  factory AppColumn.large({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    EdgeInsetsGeometry? padding,
  }) {
    return AppColumn(
      children: children,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      spacing: AppSpacing.large,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget column = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: _buildChildrenWithSpacing(),
    );

    if (padding != null) {
      column = Padding(
        padding: padding!,
        child: column,
      );
    }

    return column;
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];
    
    final spacedChildren = <Widget>[];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      // إضافة مساحة بين العناصر (ما عدا العنصر الأخير)
      if (i < children.length - 1) {
        spacedChildren.add(AppSpacing.vertical(spacing));
      }
    }
    
    return spacedChildren;
  }
}

/// Widget لإنشاء row بمساحات منتظمة
class AppRow extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const AppRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = AppSpacing.medium,
    this.padding,
  });

  /// صف مع مساحات صغيرة
  factory AppRow.small({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    EdgeInsetsGeometry? padding,
  }) {
    return AppRow(
      children: children,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      spacing: AppSpacing.small,
      padding: padding,
    );
  }

  /// صف مع مساحات كبيرة
  factory AppRow.large({
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    EdgeInsetsGeometry? padding,
  }) {
    return AppRow(
      children: children,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      spacing: AppSpacing.large,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget row = Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: _buildChildrenWithSpacing(),
    );

    if (padding != null) {
      row = Padding(
        padding: padding!,
        child: row,
      );
    }

    return row;
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];
    
    final spacedChildren = <Widget>[];
    
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      
      // إضافة مساحة بين العناصر (ما عدا العنصر الأخير)
      if (i < children.length - 1) {
        spacedChildren.add(AppSpacing.horizontal(spacing));
      }
    }
    
    return spacedChildren;
  }
}

/// Extension لتسهيل استخدام المساحات
extension WidgetSpacingExtension on Widget {
  /// إضافة حشو للWidget
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// إضافة حشو أفقي
  Widget paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  /// إضافة حشو عمودي
  Widget paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  /// إضافة هامش
  Widget marginAll(double margin) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }
}