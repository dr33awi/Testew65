// lib/features/settings/widgets/service_status_widgets.dart - محدثة للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد
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
      child: AppCard.custom(
        type: CardType.normal,
        style: CardStyle.gradient,
        primaryColor: _getHealthColor(healthPercentage),
        gradientColors: [
          _getHealthColor(healthPercentage),
          _getHealthColor(healthPercentage).darken(0.2),
        ],
        padding: const EdgeInsets.all(ThemeConstants.space5),
        onTap: widget.onRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, healthPercentage),
            const SizedBox(height: ThemeConstants.space4),
            _buildServicesGrid(context),
            const SizedBox(height: ThemeConstants.space4),
            _buildBatteryInfo(context),
          ],
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
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            _getHealthIcon(healthPercentage),
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: ThemeConstants.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حالة الخدمات',
                style: AppTextStyles.h5.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                _getHealthDescription(healthPercentage),
                style: AppTextStyles.caption.copyWith(
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
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            '$healthPercentage%',
            style: AppTextStyles.label1.copyWith(
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
            icon: AppIconsSystem.notifications,
            label: 'الإشعارات',
            isActive: widget.status.isNotificationEnabled,
            onTap: () => _handleNotificationTap(context),
          ),
        ),
        const SizedBox(width: ThemeConstants.space3),
        Expanded(
          child: _ServiceIndicator(
            icon: Icons.location_on,
            label: 'الموقع',
            isActive: widget.status.isLocationEnabled,
            onTap: () => _handleLocationTap(context),
          ),
        ),
        const SizedBox(width: ThemeConstants.space3),
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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            batteryState.isCharging ? Icons.battery_charging_full : Icons.battery_std,
            color: Colors.white.withValues(alpha: 0.8),
            size: 20,
          ),
          const SizedBox(width: ThemeConstants.space2),
          Text(
            'البطارية: ${batteryState.level}%',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (batteryState.isPowerSaveMode) ...[
            const SizedBox(width: ThemeConstants.space2),
            Icon(
              Icons.power_settings_new,
              color: Colors.orange,
              size: 16,
            ),
            const SizedBox(width: ThemeConstants.space1),
            Text(
              'وضع توفير الطاقة',
              style: AppTextStyles.caption.copyWith(
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
            icon: AppIconsSystem.settings,
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
            icon: AppIconsSystem.loading,
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
            icon: AppIconsSystem.info,
            title: 'معلومات البطارية',
            subtitle: 'عرض تفاصيل حالة البطارية الحالية',
            onTap: () => _showBatteryDetails(context),
          ),
          ServiceOption(
            icon: AppIconsSystem.settings,
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
    if (percentage >= 80) return AppColorSystem.success;
    if (percentage >= 50) return AppColorSystem.warning;
    return AppColorSystem.error;
  }

  IconData _getHealthIcon(int percentage) {
    if (percentage >= 80) return AppIconsSystem.success;
    if (percentage >= 50) return AppIconsSystem.getStateIcon('warning');
    return AppIconsSystem.getStateIcon('error');
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
    
    AppInfoDialog.show(
      context: context,
      title: 'معلومات البطارية',
      content: '''مستوى الشحن: ${batteryState.level}%

حالة الشحن: ${batteryState.isCharging ? 'يشحن' : 'لا يشحن'}

وضع توفير الطاقة: ${batteryState.isPowerSaveMode ? 'مفعل' : 'معطل'}''',
      icon: Icons.battery_std,
      accentColor: AppColorSystem.info,
    );
  }

  void _showBatteryOptimizationDialog(BuildContext context) {
    AppInfoDialog.show(
      context: context,
      title: 'تحسين البطارية',
      content: 'لضمان عمل التذكيرات في الخلفية، يُنصح بإيقاف تحسين البطارية لهذا التطبيق من إعدادات النظام.',
      icon: Icons.battery_saver,
      accentColor: AppColorSystem.warning,
      actions: [
        DialogAction(
          label: 'فتح الإعدادات',
          onPressed: () {
            Navigator.of(context).pop();
            widget.servicesManager.permissionService.openAppSettings(
              AppSettingsType.battery,
            );
          },
          isPrimary: true,
        ),
      ],
    );
  }

  void _showServiceOptions(
    BuildContext context,
    String title,
    List<ServiceOption> options,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColorSystem.getCard(context),
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
                color: AppColorSystem.getDivider(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: ThemeConstants.space4),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                fontWeight: ThemeConstants.bold,
              ),
            ),
            const SizedBox(height: ThemeConstants.space4),
            ...options.map((option) => _ServiceOptionTile(option: option)),
            const SizedBox(height: ThemeConstants.space2),
          ],
        ),
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context, String permissionName) {
    AppInfoDialog.show(
      context: context,
      title: 'إذن $permissionName مطلوب',
      content: 'لاستخدام هذه الميزة، يجب منح إذن $permissionName. يمكنك تفعيله من إعدادات التطبيق.',
      icon: AppIconsSystem.getStateIcon('warning'),
      accentColor: AppColorSystem.warning,
      actions: [
        DialogAction(
          label: 'فتح الإعدادات',
          onPressed: () {
            Navigator.of(context).pop();
            widget.servicesManager.permissionService.openAppSettings();
          },
          isPrimary: true,
        ),
      ],
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    AppSnackBar.showSuccess(context: context, message: message);
  }

  void _showErrorMessage(BuildContext context, String message) {
    AppSnackBar.showError(context: context, message: message);
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
      child: AnimatedPress(
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
                boxShadow: isActive ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.6),
                size: 20,
              ),
            ),
            const SizedBox(height: ThemeConstants.space2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
                fontSize: 11,
                fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            option.onTap?.call();
          },
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (option.isDestructive 
                        ? AppColorSystem.error 
                        : AppColorSystem.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.isDestructive 
                        ? AppColorSystem.error 
                        : AppColorSystem.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: AppTextStyles.label1.copyWith(
                          color: option.isDestructive 
                              ? AppColorSystem.error 
                              : AppColorSystem.getTextPrimary(context),
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: ThemeConstants.space1),
                        Text(
                          option.subtitle!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColorSystem.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColorSystem.getTextSecondary(context),
                ),
              ],
            ),
          ),
        ),
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