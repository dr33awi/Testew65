// lib/app/themes/widgets/feedback/app_notice_card.dart - مُصحح
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// أنواع بطاقات التنبيه
enum NoticeType {
  info,
  warning,
  error,
  success,
}

/// بطاقة تنبيه موحدة
class AppNoticeCard extends StatelessWidget {
  final NoticeType type;
  final String title;
  final String? message;
  final Widget? action;
  final VoidCallback? onClose;
  final bool showIcon;
  final IconData? customIcon;
  final EdgeInsetsGeometry? margin;

  const AppNoticeCard({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.action,
    this.onClose,
    this.showIcon = true,
    this.customIcon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: colors.borderColor,
          width: ThemeConstants.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIcon) ...[
              Icon(
                customIcon ?? _getIcon(),
                color: colors.iconColor,
                size: ThemeConstants.iconMd,
              ),
              ThemeConstants.space3.w,
            ],
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: ThemeConstants.iconSm,
                            color: colors.textColor.withOpacitySafe(0.7),
                          ),
                          onPressed: onClose,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        ),
                    ],
                  ),
                  
                  if (message != null) ...[
                    ThemeConstants.space1.h,
                    Text(
                      message!,
                      style: context.bodyMedium?.copyWith(
                        color: colors.textColor.withOpacitySafe(0.8),
                      ),
                    ),
                  ],
                  
                  if (action != null) ...[
                    ThemeConstants.space3.h,
                    action!,
                  ],
                ],
              ),
            ),
          ],
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

  _NoticeColors _getColors() {
    switch (type) {
      case NoticeType.info:
        return _NoticeColors(
          backgroundColor: ThemeConstants.info.withOpacitySafe(0.1),
          borderColor: ThemeConstants.info.withOpacitySafe(0.3),
          iconColor: ThemeConstants.info,
          textColor: ThemeConstants.info.darken(0.2),
        );
      case NoticeType.warning:
        return _NoticeColors(
          backgroundColor: ThemeConstants.warning.withOpacitySafe(0.1),
          borderColor: ThemeConstants.warning.withOpacitySafe(0.3),
          iconColor: ThemeConstants.warning,
          textColor: ThemeConstants.warning.darken(0.2),
        );
      case NoticeType.error:
        return _NoticeColors(
          backgroundColor: ThemeConstants.error.withOpacitySafe(0.1),
          borderColor: ThemeConstants.error.withOpacitySafe(0.3),
          iconColor: ThemeConstants.error,
          textColor: ThemeConstants.error.darken(0.1),
        );
      case NoticeType.success:
        return _NoticeColors(
          backgroundColor: ThemeConstants.success.withOpacitySafe(0.1),
          borderColor: ThemeConstants.success.withOpacitySafe(0.3),
          iconColor: ThemeConstants.success,
          textColor: ThemeConstants.success.darken(0.2),
        );
    }
  }
}

class _NoticeColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  _NoticeColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });
}