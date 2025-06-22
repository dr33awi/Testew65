// lib/features/settings/widgets/service_status_widgets.dart (مُنظف)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/device/battery/battery_service.dart';
import '../services/settings_services_manager.dart';

class ServiceStatusOverview extends StatefulWidget {
  final ServiceStatus status;
  final SettingsServicesManager servicesManager;
  final VoidCallback? onRefresh;

  const ServiceStatusOverview({
    super.key,
    required this.status,
    required this.servicesManager,
    this.onRefresh,
  });

  @override
  State<ServiceStatusOverview> createState() => _ServiceStatusOverviewState();
}

class _ServiceStatusOverviewState extends State<ServiceStatusOverview> {

  @override
  Widget build(BuildContext context) {
    final healthyServices = _getHealthyServicesCount();
    final totalServices = _getTotalServicesCount();
    final healthPercentage = (healthyServices / totalServices * 100).round();

    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: _getHealthGradient(healthPercentage),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: _getHealthColor(healthPercentage).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onRefresh,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, healthPercentage),
                ThemeConstants.space4.h,
                _buildServicesGrid(context),
                ThemeConstants.space4.h,
                _buildBatteryInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int healthPercentage) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            _getHealthIcon(healthPercentage),
            color: Colors.white,
            size: 24,
          ),
        ),
        ThemeConstants.space3.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حالة الخدمات',
                style: context.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                _getHealthDescription(healthPercentage),
                style: context.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$healthPercentage%',
            style: context.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ServiceIndicator(
            icon: Icons.notifications,
            label: 'الإشعارات',
            isActive: widget.status.isNotificationEnabled,
            onTap: () => _handleNotificationTap(context),
          ),
        ),
        ThemeConstants.space3.w,
        Expanded(
          child: _ServiceIndicator(
            icon: Icons.location_on,
            label: 'الموقع',
            isActive: widget.status.isLocationEnabled,
            onTap: () => _handleLocationTap(context),
          ),
        ),
        ThemeConstants.space3.w,
        Expanded(
          child: _ServiceIndicator(
            icon: Icons.battery_saver,
            label: 'البطارية',
            isActive: widget.status.isBatteryOptimized,
            onTap: () => _handleBatteryTap(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryInfo(BuildContext context) {
    final batteryState = widget.status.batteryState;
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            batteryState.isCharging ? Icons.battery_charging_full : Icons.battery_std,
            color: Colors.white.withValues(alpha: 0.8),
            size: 20,
          ),
          ThemeConstants.space2.w,
          Text(
            'البطارية: ${batteryState.level}%',
            style: context.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (batteryState.isPowerSaveMode) ...[
            ThemeConstants.space2.w,
            Icon(
              Icons.power_settings_new,
              color: Colors.orange,
              size: 16,
            ),
            ThemeConstants.space1.w,
            Text(
              'وضع توفير الطاقة',
              style: context.labelSmall?.copyWith(
                color: Colors.orange,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =============== معالجات الأحداث ===============

  Future<void> _handleNotificationTap(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    if (widget.status.isNotificationEnabled) {
      _showServiceOptions(
        context,
        'إعدادات الإشعارات',
        [
          ServiceOption(
            icon: Icons.settings,
            title: 'تخصيص الإشعارات',
            subtitle: 'إدارة أنواع الإشعارات والتوقيتات',
            onTap: () => Navigator.pushNamed(context, '/notification-settings'),
          ),
        ],
      );
    } else {
      final result = await widget.servicesManager.requestPermission(
        AppPermissionType.notification,
      );
      
      if (result.isSuccess) {
        _showSuccessMessage(context, 'تم تفعيل الإشعارات بنجاح');
      } else {
        _showPermissionDeniedDialog(context, 'الإشعارات');
      }
    }
  }

  Future<void> _handleLocationTap(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    if (widget.status.isLocationEnabled) {
      _showServiceOptions(
        context,
        'إعدادات الموقع',
        [
          ServiceOption(
            icon: Icons.refresh,
            title: 'تحديث الموقع',
            subtitle: 'إعادة تحديد الموقع الحالي',
            onTap: () => _updateLocation(context),
          ),
          ServiceOption(
            icon: Icons.calculate,
            title: 'إعدادات الحساب',
            subtitle: 'تخصيص طريقة حساب مواقيت الصلاة',
            onTap: () => Navigator.pushNamed(context, '/prayer-settings'),
          ),
        ],
      );
    } else {
      final result = await widget.servicesManager.requestPermission(
        AppPermissionType.location,
      );
      
      if (result.isSuccess) {
        await _updateLocation(context);
      } else {
        _showPermissionDeniedDialog(context, 'الموقع');
      }
    }
  }

  Future<void> _handleBatteryTap(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    if (widget.status.isBatteryOptimized) {
      _showServiceOptions(
        context,
        'إعدادات البطارية',
        [
          ServiceOption(
            icon: Icons.info,
            title: 'معلومات البطارية',
            subtitle: 'عرض تفاصيل حالة البطارية الحالية',
            onTap: () => _showBatteryDetails(context),
          ),
          ServiceOption(
            icon: Icons.settings,
            title: 'إعدادات النظام',
            subtitle: 'فتح إعدادات البطارية في النظام',
            onTap: () => widget.servicesManager.permissionService.openAppSettings(
              AppSettingsType.battery,
            ),
          ),
        ],
      );
    } else {
      final result = await widget.servicesManager.optimizeBatterySettings();
      
      if (result.isSuccess && result.isOptimized) {
        _showSuccessMessage(context, 'تم تحسين إعدادات البطارية');
      } else {
        _showBatteryOptimizationDialog(context);
      }
    }
  }

  // =============== Helper Methods ===============

  int _getHealthyServicesCount() {
    int count = 0;
    if (widget.status.isNotificationEnabled) count++;
    if (widget.status.isLocationEnabled) count++;
    if (widget.status.isBatteryOptimized) count++;
    return count;
  }

  int _getTotalServicesCount() => 3;

  Color _getHealthColor(int percentage) {
    if (percentage >= 80) return ThemeConstants.success;
    if (percentage >= 50) return ThemeConstants.warning;
    return ThemeConstants.error;
  }

  Gradient _getHealthGradient(int percentage) {
    final color = _getHealthColor(percentage);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        color.withValues(alpha: 0.8),
      ],
    );
  }

  IconData _getHealthIcon(int percentage) {
    if (percentage >= 80) return Icons.check_circle;
    if (percentage >= 50) return Icons.warning;
    return Icons.error;
  }

  String _getHealthDescription(int percentage) {
    if (percentage >= 80) return 'جميع الخدمات تعمل بشكل مثالي';
    if (percentage >= 50) return 'معظم الخدمات تعمل بشكل جيد';
    return 'تحتاج بعض الخدمات إلى تفعيل';
  }

  // =============== العمليات ===============

  Future<void> _updateLocation(BuildContext context) async {
    final result = await widget.servicesManager.updatePrayerLocation();
    
    if (result.isSuccess) {
      _showSuccessMessage(context, 'تم تحديث الموقع بنجاح');
    } else {
      _showErrorMessage(context, 'فشل في تحديث الموقع');
    }
  }

  void _showBatteryDetails(BuildContext context) {
    final batteryState = widget.status.batteryState;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.battery_std, color: context.primaryColor),
            ThemeConstants.space2.w,
            const Text('معلومات البطارية'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BatteryInfoRow(
              icon: Icons.battery_std,
              label: 'مستوى الشحن',
              value: '${batteryState.level}%',
            ),
            _BatteryInfoRow(
              icon: batteryState.isCharging ? Icons.power : Icons.power_off,
              label: 'حالة الشحن',
              value: batteryState.isCharging ? 'يشحن' : 'لا يشحن',
            ),
            _BatteryInfoRow(
              icon: Icons.power_settings_new,
              label: 'وضع توفير الطاقة',
              value: batteryState.isPowerSaveMode ? 'مفعل' : 'معطل',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showBatteryOptimizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.battery_saver, color: ThemeConstants.warning),
            ThemeConstants.space2.w,
            const Text('تحسين البطارية'),
          ],
        ),
        content: const Text(
          'لضمان عمل التذكيرات في الخلفية، يُنصح بإيقاف تحسين البطارية لهذا التطبيق من إعدادات النظام.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.servicesManager.permissionService.openAppSettings(
                AppSettingsType.battery,
              );
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  void _showServiceOptions(
    BuildContext context,
    String title,
    List<ServiceOption> options,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusXl),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ThemeConstants.space4.h,
            Text(
              title,
              style: context.titleLarge?.copyWith(
                fontWeight: ThemeConstants.bold,
              ),
            ),
            ThemeConstants.space4.h,
            ...options.map((option) => _ServiceOptionTile(option: option)),
            ThemeConstants.space2.h,
          ],
        ),
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إذن $permissionName مطلوب'),
        content: Text(
          'لاستخدام هذه الميزة، يجب منح إذن $permissionName. يمكنك تفعيله من إعدادات التطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.servicesManager.permissionService.openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 20),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
}

// =============== Widgets مساعدة ===============

class _ServiceIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _ServiceIndicator({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: isActive ? null : Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.6),
              size: 20,
            ),
          ),
          ThemeConstants.space2.h,
          Text(
            label,
            style: context.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
              fontSize: 11,
              fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BatteryInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BatteryInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: ThemeConstants.iconSm,
            color: context.textSecondaryColor,
          ),
          ThemeConstants.space3.w,
          Expanded(
            child: Text(
              label,
              style: context.bodyMedium,
            ),
          ),
          Text(
            value,
            style: context.bodyMedium?.copyWith(
              fontWeight: ThemeConstants.semiBold,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceOptionTile extends StatelessWidget {
  final ServiceOption option;

  const _ServiceOptionTile({
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (option.isDestructive ? ThemeConstants.error : context.primaryColor)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          option.icon,
          color: option.isDestructive ? ThemeConstants.error : context.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        option.title,
        style: context.titleSmall?.copyWith(
          color: option.isDestructive ? ThemeConstants.error : null,
        ),
      ),
      subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
      onTap: () {
        Navigator.pop(context);
        option.onTap?.call();
      },
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: context.textSecondaryColor,
      ),
    );
  }
}

// =============== Models ===============

class ServiceOption {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;

  ServiceOption({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDestructive = false,
  });
}