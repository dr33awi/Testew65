// lib/app/themes/widgets/dialogs/app_info_dialog.dart - محسن مع Glass Morphism
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../text_styles.dart';
import '../../core/theme_extensions.dart';

/// حوار عام لعرض المعلومات مع Glass Morphism
class AppInfoDialog extends StatelessWidget {
  final String title;
  final String? content;
  final String? subtitle;
  final IconData icon;
  final Color? accentColor;
  final String closeButtonText;
  final List<DialogAction>? actions;
  final Widget? customContent;
  final bool barrierDismissible;
  final double? width;
  final double? height;
  final bool enableGlass;

  const AppInfoDialog({
    super.key,
    required this.title,
    this.content,
    this.subtitle,
    this.icon = Icons.info_outline,
    this.accentColor,
    this.closeButtonText = 'إغلاق',
    this.actions,
    this.customContent,
    this.barrierDismissible = true,
    this.width,
    this.height,
    this.enableGlass = true,
  });

  /// عرض الحوار
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? content,
    String? subtitle,
    IconData icon = Icons.info_outline,
    Color? accentColor,
    String closeButtonText = 'إغلاق',
    List<DialogAction>? actions,
    Widget? customContent,
    bool barrierDismissible = true,
    bool hapticFeedback = true,
    double? width,
    double? height,
    bool enableGlass = true,
  }) {
    if (hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: ThemeConstants.durationNormal,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppInfoDialog(
          title: title,
          content: content,
          subtitle: subtitle,
          icon: icon,
          accentColor: accentColor,
          closeButtonText: closeButtonText,
          actions: actions,
          customContent: customContent,
          barrierDismissible: barrierDismissible,
          width: width,
          height: height,
          enableGlass: enableGlass,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: ThemeConstants.curveDefault,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: ThemeConstants.curveDefault,
            ).drive(Tween(begin: 0.8, end: 1.0)),
            child: child,
          ),
        );
      },
    );
  }

  /// عرض حوار تأكيد
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    IconData icon = Icons.help_outline,
    Color? accentColor,
    bool destructive = false,
    Color? confirmButtonColor,
  }) {
    return show<bool>(
      context: context,
      title: title,
      content: content,
      icon: icon,
      accentColor: destructive ? ThemeConstants.error : accentColor,
      closeButtonText: cancelText,
      actions: [
        DialogAction(
          label: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          isPrimary: true,
          isDestructive: destructive,
        ),
      ],
    );
  }

  /// عرض حوار نجاح
  static Future<T?> showSuccess<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'تم',
    List<DialogAction>? actions,
  }) {
    return show<T>(
      context: context,
      title: title,
      content: message,
      icon: Icons.check_circle_outline,
      accentColor: ThemeConstants.success,
      closeButtonText: buttonText,
      actions: actions,
    );
  }

  /// عرض حوار خطأ
  static Future<T?> showError<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'حسناً',
    List<DialogAction>? actions,
  }) {
    return show<T>(
      context: context,
      title: title,
      content: message,
      icon: Icons.error_outline,
      accentColor: ThemeConstants.error,
      closeButtonText: buttonText,
      actions: actions,
    );
  }

  /// عرض حوار تحذير
  static Future<T?> showWarning<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'فهمت',
    List<DialogAction>? actions,
  }) {
    return show<T>(
      context: context,
      title: title,
      content: message,
      icon: Icons.warning_amber_rounded,
      accentColor: ThemeConstants.warning,
      closeButtonText: buttonText,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(ThemeConstants.space6),
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: _buildGlassContainer(context, color, isDark),
      ),
    );
  }

  Widget _buildGlassContainer(BuildContext context, Color color, bool isDark) {
    final gradientColors = [
      color.withValues(alpha: enableGlass ? 0.9 : 1.0),
      color.darken(0.1).withValues(alpha: enableGlass ? 0.7 : 0.9),
    ];

    Widget container = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildContent(context, color),
    );

    if (enableGlass) {
      container = ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: container,
        ),
      );
    }

    return container;
  }

  Widget _buildContent(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الرأس مع الأيقونة والعنوان
          _buildHeader(context, color),
          
          // المحتوى
          if (customContent != null || content != null || subtitle != null) ...[
            ThemeConstants.space4.h,
            Flexible(
              child: customContent ?? _buildDefaultContent(context, color) ?? const SizedBox(),
            ),
          ],
          
          // الإجراءات
          ThemeConstants.space6.h,
          _buildActions(context, color),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color color) {
    return Row(
      children: [
        // الأيقونة
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: ThemeConstants.iconLg,
          ),
        ),
        
        ThemeConstants.space4.w,
        
        // العنوان
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.semiBold,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildDefaultContent(BuildContext context, Color color) {
    if (content == null && subtitle == null) return null;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.space4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                content!,
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
            ),
          
          if (subtitle != null) ...[
            if (content != null) ThemeConstants.space3.h,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space3,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: ThemeConstants.iconSm,
                  ),
                  ThemeConstants.space2.w,
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: ThemeConstants.medium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, Color color) {
    final allActions = <DialogAction>[
      if (actions != null) ...actions!,
      DialogAction(
        label: closeButtonText,
        onPressed: () => Navigator.of(context).pop(),
        isPrimary: actions == null || actions!.isEmpty,
        isSecondary: actions != null && actions!.isNotEmpty,
      ),
    ];
    
    if (allActions.length == 1) {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(context, allActions.first, color),
      );
    }
    
    return Column(
      children: [
        // الأزرار الأساسية
        ...allActions.where((a) => a.isPrimary).map((action) => 
          Padding(
            padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
            child: SizedBox(
              width: double.infinity,
              child: _buildActionButton(context, action, color),
            ),
          )
        ),
        
        // الأزرار الثانوية
        if (allActions.any((a) => !a.isPrimary))
          Row(
            children: allActions.where((a) => !a.isPrimary).map((action) => 
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
                  child: _buildActionButton(context, action, color),
                ),
              )
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, DialogAction action, Color color) {
    if (action.isPrimary) {
      return Container(
        decoration: BoxDecoration(
          color: action.isDestructive 
            ? ThemeConstants.error
            : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              action.onPressed();
            },
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space4,
              ),
              child: Text(
                action.label,
                style: AppTextStyles.button.copyWith(
                  color: action.isDestructive ? Colors.white : color,
                  fontWeight: ThemeConstants.semiBold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    
    // زر ثانوي
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            action.onPressed();
          },
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space3,
            ),
            child: Text(
              action.label,
              style: AppTextStyles.buttonSmall.copyWith(
                color: action.isDestructive 
                  ? ThemeConstants.error.lighten(0.3)
                  : Colors.white,
                fontWeight: ThemeConstants.medium,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// إجراء في الحوار - محسن
class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isSecondary;
  final bool isDestructive;
  
  const DialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isSecondary = false,
    this.isDestructive = false,
  });
}