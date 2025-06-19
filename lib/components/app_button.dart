// lib/app/components/app_button.dart
// مكون الزر الموحد للتطبيق - Wrapper فوق النظام المبسط

import 'package:athkar_app/app/themes/widgets.dart';
import 'package:flutter/material.dart';

/// زر التطبيق الموحد
/// لتغيير شكل جميع الأزرار في التطبيق، عدل هنا فقط!
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isFullWidth;
  final bool isLoading;
  final Color? customColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
    this.isLoading = false,
    this.customColor,
  });

  /// زر أساسي
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      variant: AppButtonVariant.primary,
      size: size,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
    );
  }

  /// زر ثانوي
  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      variant: AppButtonVariant.secondary,
      size: size,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
    );
  }

  /// زر محدود
  factory AppButton.outlined({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isFullWidth = false,
    Color? color,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      variant: AppButtonVariant.outlined,
      size: size,
      isFullWidth: isFullWidth,
      customColor: color,
    );
  }

  /// زر خطر
  factory AppButton.danger({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      variant: AppButtonVariant.danger,
      size: size,
      isFullWidth: isFullWidth,
    );
  }

  /// زر نجاح
  factory AppButton.success({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    AppButtonSize size = AppButtonSize.medium,
    bool isFullWidth = false,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      variant: AppButtonVariant.success,
      size: size,
      isFullWidth: isFullWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    // هنا يمكنك تغيير التنفيذ الداخلي دون تأثير على الشاشات!
    
    if (isLoading) {
      return _buildLoadingButton();
    }

    // استخدام النظام المبسط داخلياً
    return _buildIslamicButton();
  }

  Widget _buildIslamicButton() {
    switch (variant) {
      case AppButtonVariant.primary:
        return IslamicButton.primary(
          text: text,
          onPressed: onPressed,
          icon: icon,
          width: isFullWidth ? double.infinity : null,
        );
        
      case AppButtonVariant.secondary:
        return IslamicButton.secondary(
          text: text,
          onPressed: onPressed,
          icon: icon,
          width: isFullWidth ? double.infinity : null,
        );
        
      case AppButtonVariant.outlined:
        return IslamicButton.outlined(
          text: text,
          onPressed: onPressed,
          icon: icon,
          color: customColor,
          width: isFullWidth ? double.infinity : null,
        );
        
      case AppButtonVariant.danger:
        return IslamicButton.primary(
          text: text,
          onPressed: onPressed,
          icon: icon,
          width: isFullWidth ? double.infinity : null,
          // يمكن تخصيص لون الخطر هنا
        );
        
      case AppButtonVariant.success:
        return IslamicButton.primary(
          text: text,
          onPressed: onPressed,
          icon: icon,
          width: isFullWidth ? double.infinity : null,
          // يمكن تخصيص لون النجاح هنا
        );
    }
  }

  Widget _buildLoadingButton() {
    // زر التحميل الموحد
    return IslamicButton.primary(
      text: 'جارٍ التحميل...',
      onPressed: null, // معطل أثناء التحميل
      icon: null,
      width: isFullWidth ? double.infinity : null,
    );
  }

  // ============ يمكنك إضافة تنفيذ بديل هنا ============
  
  /// مثال: استخدام Material Buttons بدلاً من Islamic
  Widget _buildMaterialButton() {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              isFullWidth ? double.infinity : 0,
              _getButtonHeight(),
            ),
          ),
        );
        
      case AppButtonVariant.outlined:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
          label: Text(text),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(
              isFullWidth ? double.infinity : 0,
              _getButtonHeight(),
            ),
          ),
        );
        
      // ... باقي الأنواع
      default:
        return _buildIslamicButton();
    }
  }

  double _getButtonHeight() {
    return switch (size) {
      AppButtonSize.small => 36.0,
      AppButtonSize.medium => 48.0,
      AppButtonSize.large => 56.0,
    };
  }
}

/// أنواع الأزرار
enum AppButtonVariant {
  primary,    // أساسي
  secondary,  // ثانوي
  outlined,   // محدود
  danger,     // خطر
  success,    // نجاح
}

/// أحجام الأزرار
enum AppButtonSize {
  small,      // صغير
  medium,     // متوسط
  large,      // كبير
}

/// زر أيقونة فقط
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final AppButtonSize size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = AppButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    // يمكن تغيير التنفيذ هنا
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      iconSize: _getIconSize(),
    );
  }

  double _getIconSize() {
    return switch (size) {
      AppButtonSize.small => 18.0,
      AppButtonSize.medium => 24.0,
      AppButtonSize.large => 30.0,
    };
  }
}