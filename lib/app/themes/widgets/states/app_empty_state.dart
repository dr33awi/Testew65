// lib/app/themes/widgets/states/app_empty_state.dart
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../core/app_button.dart';

/// أنواع الحالات الفارغة
enum EmptyStateType {
  noData,
  noResults,
  error,
  noConnection,
  custom,
}

/// widget للحالات الفارغة
class AppEmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? message;
  final IconData? icon;
  final String? imagePath;
  final Widget? customIcon;
  final VoidCallback? onAction;
  final String? actionText;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final bool showAction;

  const AppEmptyState({
    super.key,
    this.type = EmptyStateType.noData,
    this.title,
    this.message,
    this.icon,
    this.imagePath,
    this.customIcon,
    this.onAction,
    this.actionText,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // الحصول على البيانات الافتراضية حسب النوع
    final defaultData = _getDefaultData();
    final effectiveTitle = title ?? defaultData.title;
    final effectiveMessage = message ?? defaultData.message;
    final effectiveIcon = icon ?? defaultData.icon;
    final effectiveActionText = actionText ?? defaultData.actionText;
    final effectiveIconColor = iconColor ?? defaultData.iconColor ?? theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5);
    
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة أو الصورة
            if (customIcon != null)
              customIcon!
            else if (imagePath != null)
              Image.asset(
                imagePath!,
                width: iconSize ?? 120,
                height: iconSize ?? 120,
              )
            else
              Container(
                width: iconSize ?? 100,
                height: iconSize ?? 100,
                decoration: BoxDecoration(
                  color: effectiveIconColor?.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  effectiveIcon,
                  size: (iconSize ?? 100) * 0.5,
                  color: effectiveIconColor,
                ),
              ),
            
            const SizedBox(height: ThemeConstants.space5),
            
            // العنوان
            Text(
              effectiveTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            
            // الرسالة
            if (effectiveMessage != null) ...[
              const SizedBox(height: ThemeConstants.space3),
              Text(
                effectiveMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // زر الإجراء
            if (showAction && onAction != null && effectiveActionText != null) ...[
              const SizedBox(height: ThemeConstants.space6),
              AppButton.primary(
                text: effectiveActionText,
                onPressed: onAction!,
                icon: _getActionIcon(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData? _getActionIcon() {
    switch (type) {
      case EmptyStateType.noConnection:
        return Icons.refresh;
      case EmptyStateType.error:
        return Icons.refresh;
      default:
        return null;
    }
  }

  _EmptyStateData _getDefaultData() {
    switch (type) {
      case EmptyStateType.noData:
        return _EmptyStateData(
          title: 'لا توجد بيانات',
          message: 'لم يتم العثور على أي بيانات للعرض',
          icon: Icons.inbox_outlined,
          actionText: null,
          iconColor: ThemeConstants.info,
        );
        
      case EmptyStateType.noResults:
        return _EmptyStateData(
          title: 'لا توجد نتائج',
          message: 'لم يتم العثور على نتائج مطابقة لبحثك',
          icon: Icons.search_off,
          actionText: 'مسح البحث',
          iconColor: ThemeConstants.warning,
        );
        
      case EmptyStateType.error:
        return _EmptyStateData(
          title: 'حدث خطأ',
          message: 'حدث خطأ أثناء تحميل البيانات. يرجى المحاولة مرة أخرى',
          icon: Icons.error_outline,
          actionText: 'إعادة المحاولة',
          iconColor: ThemeConstants.error,
        );
        
      case EmptyStateType.noConnection:
        return _EmptyStateData(
          title: 'لا يوجد اتصال',
          message: 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
          icon: Icons.wifi_off,
          actionText: 'إعادة المحاولة',
          iconColor: ThemeConstants.error,
        );
        
      case EmptyStateType.custom:
        return _EmptyStateData(
          title: 'لا توجد بيانات',
          message: null,
          icon: Icons.info_outline,
          actionText: null,
          iconColor: null,
        );
    }
  }

  // Factory constructors
  factory AppEmptyState.noData({
    String? message,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return AppEmptyState(
      type: EmptyStateType.noData,
      message: message,
      onAction: onAction,
      actionText: actionText,
    );
  }

  factory AppEmptyState.noResults({
    String? message,
    VoidCallback? onClear,
  }) {
    return AppEmptyState(
      type: EmptyStateType.noResults,
      message: message,
      onAction: onClear,
    );
  }

  factory AppEmptyState.error({
    String? message,
    required VoidCallback onRetry,
  }) {
    return AppEmptyState(
      type: EmptyStateType.error,
      message: message,
      onAction: onRetry,
    );
  }

  factory AppEmptyState.noConnection({
    required VoidCallback onRetry,
  }) {
    return AppEmptyState(
      type: EmptyStateType.noConnection,
      onAction: onRetry,
    );
  }

  factory AppEmptyState.custom({
    required String title,
    String? message,
    required IconData icon,
    VoidCallback? onAction,
    String? actionText,
    Color? iconColor,
  }) {
    return AppEmptyState(
      type: EmptyStateType.custom,
      title: title,
      message: message,
      icon: icon,
      onAction: onAction,
      actionText: actionText,
      iconColor: iconColor,
    );
  }
}

/// بيانات الحالة الفارغة الافتراضية
class _EmptyStateData {
  final String title;
  final String? message;
  final IconData icon;
  final String? actionText;
  final Color? iconColor;

  _EmptyStateData({
    required this.title,
    required this.message,
    required this.icon,
    required this.actionText,
    required this.iconColor,
  });
}