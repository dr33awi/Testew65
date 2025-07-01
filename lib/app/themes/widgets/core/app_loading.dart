// lib/app/themes/widgets/core/app_loading.dart - النسخة المبسطة (circular فقط)
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';

/// أحجام مؤشرات التحميل - مبسطة
enum LoadingSize {
  medium,    // متوسط (الافتراضي)
  large,     // كبير
}

/// مؤشر تحميل موحد - مبسط (circular فقط)
class AppLoading extends StatelessWidget {
  final LoadingSize size;
  final String? message;
  final Color? color;
  final double? value;
  final bool showBackground;
  final double? strokeWidth;

  const AppLoading({
    super.key,
    this.size = LoadingSize.medium,
    this.message,
    this.color,
    this.value,
    this.showBackground = false,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.primaryColor;
    
    Widget loadingIndicator = _buildCircular(effectiveColor);

    // إضافة الرسالة إذا وجدت
    if (message != null) {
      loadingIndicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingIndicator,
          const SizedBox(height: ThemeConstants.space4),
          Text(
            message!,
            style: AppTextStyles.body2.copyWith(
              color: showBackground 
                  ? effectiveColor 
                  : theme.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // إضافة خلفية إذا طُلبت
    if (showBackground) {
      return Container(
        padding: const EdgeInsets.all(ThemeConstants.space6),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          boxShadow: ThemeConstants.shadowLg,
        ),
        child: loadingIndicator,
      );
    }

    return Center(child: loadingIndicator);
  }

  Widget _buildCircular(Color color) {
    final size = _getSize();
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case LoadingSize.medium:
        return 36;
      case LoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  // Factory constructors - مبسطة

  /// مؤشر تحميل دائري عادي
  factory AppLoading.circular({
    LoadingSize size = LoadingSize.medium,
    Color? color,
    double? value,
  }) {
    return AppLoading(
      size: size,
      color: color,
      value: value,
    );
  }

  /// مؤشر تحميل للصفحة الكاملة
  factory AppLoading.page({
    String? message,
    LoadingSize size = LoadingSize.large,
    Color? color,
  }) {
    return AppLoading(
      size: size,
      message: message,
      showBackground: true,
      color: color,
    );
  }

  /// مؤشر تحميل مضمن (للأزرار مثلاً)
  factory AppLoading.inline({
    LoadingSize size = LoadingSize.medium,
    Color? color,
  }) {
    return AppLoading(
      size: size,
      color: color,
    );
  }

  /// مؤشر تحميل مع نص
  factory AppLoading.withMessage({
    required String message,
    LoadingSize size = LoadingSize.medium,
    Color? color,
    bool showBackground = false,
  }) {
    return AppLoading(
      size: size,
      message: message,
      color: color,
      showBackground: showBackground,
    );
  }

  /// مؤشر تقدم (مع قيمة محددة)
  factory AppLoading.progress({
    required double value, // 0.0 - 1.0
    LoadingSize size = LoadingSize.medium,
    Color? color,
    String? message,
  }) {
    return AppLoading(
      size: size,
      value: value,
      color: color,
      message: message,
    );
  }
}