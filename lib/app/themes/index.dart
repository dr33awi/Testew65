// lib/app/themes/components/index.dart
// استيراد المكونات الموجودة فعلاً في المشروع

import 'package:flutter/material.dart';

// ==================== استيراد الملفات الموجودة ====================
export 'components/app_button.dart';
export 'components/app_card.dart';
export 'components/app_text.dart';
export 'components/app_input.dart';
export 'components/app_app_bar.dart';
export 'components/app_dialog.dart';
export 'components/app_loading.dart';
export 'components/app_spacing.dart';

// استيراد الثيم والألوان والخطوط
export 'app_theme.dart';
export 'colors.dart';
export 'typography.dart';
export 'widgets.dart';

// ==================== Extensions بسيطة فقط ====================

extension AppBuildContextSimple on BuildContext {
  // الثيم
  ThemeData get appTheme => Theme.of(this);
  ColorScheme get appColors => appTheme.colorScheme;
  bool get isAppDark => appTheme.brightness == Brightness.dark;
  
  // الحجم
  Size get appScreenSize => MediaQuery.of(this).size;
  double get appScreenWidth => appScreenSize.width;
  double get appScreenHeight => appScreenSize.height;
  
  // التنقل
  void appPop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> appPush<T>(Widget page) => Navigator.of(this).push(
    MaterialPageRoute(builder: (_) => page),
  );
  
  // الرسائل البسيطة
  void showAppMessage(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  
  void showAppSuccess(String message) => 
      showAppMessage(message, backgroundColor: Colors.green);
  void showAppError(String message) => 
      showAppMessage(message, backgroundColor: Colors.red);
  void showAppInfo(String message) => 
      showAppMessage(message, backgroundColor: Colors.blue);
  void showAppWarning(String message) => 
      showAppMessage(message, backgroundColor: Colors.orange);
}