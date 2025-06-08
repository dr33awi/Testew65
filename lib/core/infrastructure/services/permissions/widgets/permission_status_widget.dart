// lib/core/infrastructure/services/permissions/widgets/permission_status_widget.dart

import 'package:flutter/material.dart';
import '../permission_service.dart';

/// Widget لعرض حالة الأذونات بشكل جميل
class PermissionStatusWidget extends StatelessWidget {
  final AppPermissionType permission;
  final AppPermissionStatus status;
  final VoidCallback? onRequest;
  final VoidCallback? onOpenSettings;
  
  const PermissionStatusWidget({
    super.key, // استخدام super parameter
    required this.permission,
    required this.status,
    this.onRequest,
    this.onOpenSettings,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getBorderColor(theme),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(theme),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(),
              color: _getIconColor(theme),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          
          // Permission Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPermissionName(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusText(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getStatusTextColor(theme),
                  ),
                ),
              ],
            ),
          ),
          
          // Action Button
          if (_shouldShowActionButton()) ...[
            const SizedBox(width: 16),
            _buildActionButton(context),
          ],
        ],
      ),
    );
  }
  
  Color _getBackgroundColor(ThemeData theme) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green.withValues(alpha: 0.1); // استخدام withValues
      case AppPermissionStatus.denied:
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red.withValues(alpha: 0.1); // استخدام withValues
      case AppPermissionStatus.restricted:
        return Colors.orange.withValues(alpha: 0.1); // استخدام withValues
      default:
        return theme.cardTheme.color ?? Colors.grey.withValues(alpha: 0.1); // استخدام withValues
    }
  }
  
  Color _getBorderColor(ThemeData theme) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green.withValues(alpha: 0.3); // استخدام withValues
      case AppPermissionStatus.denied:
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red.withValues(alpha: 0.3); // استخدام withValues
      case AppPermissionStatus.restricted:
        return Colors.orange.withValues(alpha: 0.3); // استخدام withValues
      default:
        return theme.dividerColor.withValues(alpha: 0.3); // استخدام withValues
    }
  }
  
  Color _getIconBackgroundColor(ThemeData theme) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green.withValues(alpha: 0.2); // استخدام withValues
      case AppPermissionStatus.denied:
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red.withValues(alpha: 0.2); // استخدام withValues
      case AppPermissionStatus.restricted:
        return Colors.orange.withValues(alpha: 0.2); // استخدام withValues
      default:
        return theme.dividerColor.withValues(alpha: 0.2); // استخدام withValues
    }
  }
  
  Color _getIconColor(ThemeData theme) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green;
      case AppPermissionStatus.denied:
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red;
      case AppPermissionStatus.restricted:
        return Colors.orange;
      default:
        return theme.iconTheme.color ?? Colors.grey;
    }
  }
  
  IconData _getStatusIcon() {
    switch (status) {
      case AppPermissionStatus.granted:
        return Icons.check_circle;
      case AppPermissionStatus.denied:
        return Icons.cancel;
      case AppPermissionStatus.permanentlyDenied:
        return Icons.block;
      case AppPermissionStatus.restricted:
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }
  
  String _getPermissionName() {
    // يمكنك استخدام service للحصول على الاسم
    switch (permission) {
      case AppPermissionType.location:
        return 'الموقع';
      case AppPermissionType.notification:
        return 'الإشعارات';
      case AppPermissionType.storage:
        return 'التخزين';
      case AppPermissionType.doNotDisturb:
        return 'عدم الإزعاج';
      case AppPermissionType.batteryOptimization:
        return 'تحسين البطارية';
      default:
        return 'إذن غير معروف';
    }
  }
  
  String _getStatusText() {
    switch (status) {
      case AppPermissionStatus.granted:
        return 'مسموح';
      case AppPermissionStatus.denied:
        return 'مرفوض - اضغط للسماح';
      case AppPermissionStatus.permanentlyDenied:
        return 'مرفوض نهائياً - افتح الإعدادات';
      case AppPermissionStatus.restricted:
        return 'مقيد من النظام';
      case AppPermissionStatus.limited:
        return 'محدود';
      case AppPermissionStatus.provisional:
        return 'مؤقت';
      default:
        return 'غير معروف';
    }
  }
  
  Color _getStatusTextColor(ThemeData theme) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green;
      case AppPermissionStatus.denied:
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red;
      case AppPermissionStatus.restricted:
        return Colors.orange;
      default:
        return theme.textTheme.bodySmall?.color ?? Colors.grey;
    }
  }
  
  bool _shouldShowActionButton() {
    return status == AppPermissionStatus.denied ||
           status == AppPermissionStatus.permanentlyDenied;
  }
  
  Widget _buildActionButton(BuildContext context) {
    final isPermanentlyDenied = status == AppPermissionStatus.permanentlyDenied;
    
    return TextButton(
      onPressed: isPermanentlyDenied ? onOpenSettings : onRequest,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        isPermanentlyDenied ? 'الإعدادات' : 'السماح',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}