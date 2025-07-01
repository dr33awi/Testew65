// lib/app/themes/widgets/feedback/app_notice_card.dart - النسخة المبسطة
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// أنواع بطاقات التنبيه - مبسطة
enum NoticeType {
  info,
  warning,
  error,
  success,
}

/// بطاقة تنبيه موحدة - مبسطة وأنيقة
class AppNoticeCard extends StatelessWidget {
  final NoticeType type;
  final String title;
  final String? message;
  final Widget? action;
  final VoidCallback? onClose;

  const AppNoticeCard({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.action,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: colors.borderColor,
          width: ThemeConstants.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأيقونة
            _buildIcon(colors),
            
            const SizedBox(width: ThemeConstants.space3),
            
            // المحتوى
            Expanded(
              child: _buildContent(context, colors),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(_NoticeColors colors) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space2),
      decoration: BoxDecoration(
        color: colors.iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Icon(
        _getIcon(),
        color: colors.iconColor,
        size: ThemeConstants.iconMd,
      ),
    );
  }

  Widget _buildContent(BuildContext context, _NoticeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // العنوان مع زر الإغلاق
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: context.titleMedium?.copyWith(
                  color: colors.textColor,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ),
            if (onClose != null)
              _buildCloseButton(colors),
          ],
        ),
        
        // الرسالة
        if (message != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            message!,
            style: context.bodyMedium?.copyWith(
              color: colors.textColor.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
        
        // الإجراء
        if (action != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          action!,
        ],
      ],
    );
  }

  Widget _buildCloseButton(_NoticeColors colors) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      child: InkWell(
        onTap: onClose,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space1),
          child: Icon(
            Icons.close,
            size: ThemeConstants.iconSm,
            color: colors.textColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case NoticeType.info:
        return Icons.info_outline;
      case NoticeType.warning:
        return Icons.warning_amber_rounded;
      case NoticeType.error:
        return Icons.error_outline;
      case NoticeType.success:
        return Icons.check_circle_outline;
    }
  }

  _NoticeColors _getColors(BuildContext context) {
    switch (type) {
      case NoticeType.info:
        return _NoticeColors(
          backgroundColor: ThemeConstants.info.withValues(alpha: 0.1),
          borderColor: ThemeConstants.info.withValues(alpha: 0.3),
          iconColor: ThemeConstants.info,
          textColor: context.isDarkMode 
              ? ThemeConstants.info.lighten(0.2)
              : ThemeConstants.info.darken(0.2),
          shadowColor: ThemeConstants.info.withValues(alpha: 0.1),
        );
      case NoticeType.warning:
        return _NoticeColors(
          backgroundColor: ThemeConstants.warning.withValues(alpha: 0.1),
          borderColor: ThemeConstants.warning.withValues(alpha: 0.3),
          iconColor: ThemeConstants.warning,
          textColor: context.isDarkMode 
              ? ThemeConstants.warning.lighten(0.1)
              : ThemeConstants.warning.darken(0.2),
          shadowColor: ThemeConstants.warning.withValues(alpha: 0.1),
        );
      case NoticeType.error:
        return _NoticeColors(
          backgroundColor: ThemeConstants.error.withValues(alpha: 0.1),
          borderColor: ThemeConstants.error.withValues(alpha: 0.3),
          iconColor: ThemeConstants.error,
          textColor: context.isDarkMode 
              ? ThemeConstants.error.lighten(0.1)
              : ThemeConstants.error.darken(0.1),
          shadowColor: ThemeConstants.error.withValues(alpha: 0.1),
        );
      case NoticeType.success:
        return _NoticeColors(
          backgroundColor: ThemeConstants.success.withValues(alpha: 0.1),
          borderColor: ThemeConstants.success.withValues(alpha: 0.3),
          iconColor: ThemeConstants.success,
          textColor: context.isDarkMode 
              ? ThemeConstants.success.lighten(0.1)
              : ThemeConstants.success.darken(0.2),
          shadowColor: ThemeConstants.success.withValues(alpha: 0.1),
        );
    }
  }

  // Factory constructors - مبسطة
  
  /// بطاقة معلومات
  factory AppNoticeCard.info({
    required String title,
    String? message,
    Widget? action,
    VoidCallback? onClose,
  }) {
    return AppNoticeCard(
      type: NoticeType.info,
      title: title,
      message: message,
      action: action,
      onClose: onClose,
    );
  }

  /// بطاقة تحذير
  factory AppNoticeCard.warning({
    required String title,
    String? message,
    Widget? action,
    VoidCallback? onClose,
  }) {
    return AppNoticeCard(
      type: NoticeType.warning,
      title: title,
      message: message,
      action: action,
      onClose: onClose,
    );
  }

  /// بطاقة خطأ
  factory AppNoticeCard.error({
    required String title,
    String? message,
    Widget? action,
    VoidCallback? onClose,
  }) {
    return AppNoticeCard(
      type: NoticeType.error,
      title: title,
      message: message,
      action: action,
      onClose: onClose,
    );
  }

  /// بطاقة نجاح
  factory AppNoticeCard.success({
    required String title,
    String? message,
    Widget? action,
    VoidCallback? onClose,
  }) {
    return AppNoticeCard(
      type: NoticeType.success,
      title: title,
      message: message,
      action: action,
      onClose: onClose,
    );
  }
}

/// ألوان بطاقة التنبيه - مبسطة
class _NoticeColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final Color shadowColor;

  _NoticeColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.shadowColor,
  });
}