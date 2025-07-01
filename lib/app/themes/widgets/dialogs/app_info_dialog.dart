// lib/app/themes/widgets/dialogs/app_info_dialog.dart - النسخة المبسطة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../text_styles.dart';
import '../../core/theme_extensions.dart';

/// حوار موحد لعرض المعلومات - مبسط
class AppInfoDialog extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final Color? accentColor;
  final String closeButtonText;
  final List<DialogAction>? actions;
  final bool barrierDismissible;

  const AppInfoDialog({
    super.key,
    required this.title,
    this.content,
    this.icon = Icons.info_outline,
    this.accentColor,
    this.closeButtonText = 'إغلاق',
    this.actions,
    this.barrierDismissible = true,
  });

  /// عرض حوار عام
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? content,
    IconData icon = Icons.info_outline,
    Color? accentColor,
    String closeButtonText = 'إغلاق',
    List<DialogAction>? actions,
    bool barrierDismissible = true,
  }) {
    HapticFeedback.lightImpact();
    
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
          icon: icon,
          accentColor: accentColor,
          closeButtonText: closeButtonText,
          actions: actions,
          barrierDismissible: barrierDismissible,
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
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      content: content,
      icon: isDestructive ? Icons.warning_amber_outlined : Icons.help_outline,
      accentColor: isDestructive ? ThemeConstants.error : null,
      closeButtonText: cancelText,
      actions: [
        DialogAction(
          label: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          isPrimary: true,
          isDestructive: isDestructive,
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
  }) {
    return show<T>(
      context: context,
      title: title,
      content: message,
      icon: Icons.check_circle_outline,
      accentColor: ThemeConstants.success,
      closeButtonText: buttonText,
    );
  }

  /// عرض حوار خطأ
  static Future<T?> showError<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'حسناً',
  }) {
    return show<T>(
      context: context,
      title: title,
      content: message,
      icon: Icons.error_outline,
      accentColor: ThemeConstants.error,
      closeButtonText: buttonText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.primaryColor;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(ThemeConstants.space6),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: _buildGlassContainer(context, color),
      ),
    );
  }

  Widget _buildGlassContainer(BuildContext context, Color color) {
    final gradientColors = [
      color.withValues(alpha: 0.9),
      color.darken(0.1).withValues(alpha: 0.7),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
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
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الرأس مع الأيقونة والعنوان
          _buildHeader(context),
          
          // المحتوى
          if (content != null) ...[
            const SizedBox(height: ThemeConstants.space4),
            _buildContentSection(context),
          ],
          
          // الإجراءات
          const SizedBox(height: ThemeConstants.space6),
          _buildActions(context, color),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
        
        const SizedBox(width: ThemeConstants.space4),
        
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

  Widget _buildContentSection(BuildContext context) {
    return Container(
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
        textAlign: TextAlign.center,
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
                color: Colors.white,
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

/// إجراء في الحوار - مبسط
class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;
  
  const DialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });
}