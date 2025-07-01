// lib/app/themes/widgets/states/app_empty_state.dart - النسخة المبسطة والنهائية
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import '../core/app_button.dart';

/// Widget للحالات الفارغة - مبسط ومتكامل
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;
  final Color? iconColor;
  final double? iconSize;
  final Widget? customIcon;
  final EdgeInsetsGeometry? padding;

  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionText,
    this.iconColor,
    this.iconSize = 80,
    this.customIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? context.textSecondaryColor.withValues(alpha: 0.6);
    final effectivePadding = padding ?? const EdgeInsets.all(ThemeConstants.space6);
    
    return Center(
      child: Padding(
        padding: effectivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة أو Widget مخصص
            if (customIcon != null)
              customIcon!
            else
              _buildIcon(effectiveIconColor),
            
            const SizedBox(height: ThemeConstants.space5),
            
            // العنوان
            Text(
              title,
              style: context.titleLarge?.copyWith(
                fontWeight: ThemeConstants.semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            
            // الرسالة
            if (message != null) ...[
              const SizedBox(height: ThemeConstants.space3),
              Text(
                message!,
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // زر الإجراء
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: ThemeConstants.space6),
              AppButton.primary(
                text: actionText!,
                onPressed: onAction!,
                icon: _getActionIcon(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color effectiveIconColor) {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: effectiveIconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: (iconSize ?? 80) * 0.5,
        color: effectiveIconColor,
      ),
    );
  }

  IconData? _getActionIcon() {
    // إضافة أيقونة مناسبة للإجراء
    if (actionText?.contains('إعادة') == true || actionText?.contains('محاولة') == true) {
      return Icons.refresh;
    } else if (actionText?.contains('بحث') == true || actionText?.contains('مسح') == true) {
      return Icons.search;
    }
    return null;
  }

  // ===== Factory Constructors - الأساسيات =====

  /// لا توجد بيانات
  factory AppEmptyState.noData({
    String? message,
    VoidCallback? onRefresh,
    String? actionText,
  }) {
    return AppEmptyState(
      title: 'لا توجد بيانات',
      message: message ?? 'لم يتم العثور على أي بيانات للعرض',
      icon: Icons.inbox_outlined,
      onAction: onRefresh,
      actionText: actionText,
      iconColor: ThemeConstants.info,
    );
  }

  /// لا توجد نتائج بحث
  factory AppEmptyState.noResults({
    String? searchTerm,
    VoidCallback? onClearSearch,
  }) {
    return AppEmptyState(
      title: 'لا توجد نتائج',
      message: searchTerm != null 
          ? 'لم يتم العثور على نتائج لـ "$searchTerm"'
          : 'لم يتم العثور على نتائج مطابقة لبحثك',
      icon: Icons.search_off,
      onAction: onClearSearch,
      actionText: onClearSearch != null ? 'مسح البحث' : null,
      iconColor: ThemeConstants.warning,
    );
  }

  /// خطأ مع إعادة محاولة
  factory AppEmptyState.error({
    String? message,
    required VoidCallback onRetry,
    String? actionText,
  }) {
    return AppEmptyState(
      title: 'حدث خطأ',
      message: message ?? 'حدث خطأ أثناء تحميل البيانات. يرجى المحاولة مرة أخرى',
      icon: Icons.error_outline,
      iconColor: ThemeConstants.error,
      onAction: onRetry,
      actionText: actionText ?? 'إعادة المحاولة',
    );
  }

  /// لا يوجد اتصال بالإنترنت
  factory AppEmptyState.noConnection({
    String? message,
    required VoidCallback onRetry,
  }) {
    return AppEmptyState(
      title: 'لا يوجد اتصال',
      message: message ?? 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
      icon: Icons.wifi_off,
      iconColor: ThemeConstants.warning,
      onAction: onRetry,
      actionText: 'إعادة المحاولة',
    );
  }

  /// حالة مخصصة كاملة
  factory AppEmptyState.custom({
    required String title,
    String? message,
    IconData icon = Icons.info_outline,
    VoidCallback? onAction,
    String? actionText,
    Color? iconColor,
    double? iconSize,
    Widget? customIcon,
    EdgeInsetsGeometry? padding,
  }) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: icon,
      onAction: onAction,
      actionText: actionText,
      iconColor: iconColor,
      iconSize: iconSize,
      customIcon: customIcon,
      padding: padding,
    );
  }

  /// لقائمة فارغة من الأذكار
  factory AppEmptyState.noAthkar({
    String categoryName = 'الأذكار',
    VoidCallback? onRefresh,
  }) {
    return AppEmptyState(
      title: 'لا توجد $categoryName',
      message: 'لم يتم العثور على أذكار في هذه الفئة',
      icon: Icons.auto_awesome_outlined,
      iconColor: ThemeConstants.primary,
      onAction: onRefresh,
      actionText: onRefresh != null ? 'تحديث' : null,
    );
  }

  /// للمفضلة الفارغة
  factory AppEmptyState.noFavorites({
    VoidCallback? onBrowse,
  }) {
    return AppEmptyState(
      title: 'لا توجد مفضلة',
      message: 'لم تقم بإضافة أي أذكار إلى المفضلة بعد',
      icon: Icons.favorite_border,
      iconColor: ThemeConstants.accent,
      onAction: onBrowse,
      actionText: onBrowse != null ? 'تصفح الأذكار' : null,
    );
  }

  /// لقائمة التاريخ الفارغة
  factory AppEmptyState.noHistory({
    VoidCallback? onBrowse,
  }) {
    return AppEmptyState(
      title: 'لا يوجد تاريخ',
      message: 'لم تقم بقراءة أي أذكار بعد',
      icon: Icons.history,
      iconColor: ThemeConstants.tertiary,
      onAction: onBrowse,
      actionText: onBrowse != null ? 'ابدأ القراءة' : null,
    );
  }
}