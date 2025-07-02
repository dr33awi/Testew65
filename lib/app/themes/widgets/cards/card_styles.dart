// lib/app/themes/widgets/cards/card_styles.dart - النسخة المبسطة (بدون تكرار)
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/systems/app_container_builder.dart';
import 'card_types.dart';

/// بناء أنماط البطاقات - مبسط ويستخدم AppContainerBuilder
class CardStyleBuilder {
  CardStyleBuilder._();

  /// بناء النمط - استخدام النظام الموحد
  static Widget buildStyled({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
  }) {
    // تحديد نمط الحاوية حسب نمط البطاقة
    ContainerStyle containerStyle;
    switch (properties.style) {
      case CardStyle.gradient:
        containerStyle = ContainerStyle.gradient;
        break;
      case CardStyle.glassmorphism:
        containerStyle = ContainerStyle.glassGradient;
        break;
      default:
        containerStyle = ContainerStyle.basic;
    }

    // استخدام AppContainerBuilder بدلاً من تكرار المنطق
    return AppContainerBuilder.buildContainer(
      child: content,
      style: containerStyle,
      backgroundColor: properties.backgroundColor,
      gradientColors: properties.gradientColors,
      padding: (properties.padding as EdgeInsets?) ?? const EdgeInsets.all(ThemeConstants.space4),
      borderRadius: properties.borderRadius ?? ThemeConstants.radiusMd,
      showShadow: properties.showShadow,
      onTap: properties.onTap,
      onLongPress: properties.onLongPress,
    );
  }
}

