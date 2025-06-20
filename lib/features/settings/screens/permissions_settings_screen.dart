// lib/features/settings/screens/permissions_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/core/infrastructure/services/permissions/permission_service.dart';
import 'package:athkar_app/core/infrastructure/services/permissions/widgets/permission_status_widget.dart';

class PermissionsSettingsScreen extends StatefulWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  State<PermissionsSettingsScreen> createState() => _PermissionsSettingsScreenState();
}

class _PermissionsSettingsScreenState extends State<PermissionsSettingsScreen> {
  Map<AppPermissionType, AppPermissionStatus> _permissionStatuses = {};
  bool _isLoading = true;
  bool _isRequestingBatch = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final permissionService = context.permissionService;
      final statuses = await permissionService.checkAllPermissions();
      
      setState(() {
        _permissionStatuses = statuses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        context.showErrorMessage('حدث خطأ في تحميل حالة الأذونات');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: IslamicAppBar(title: 'الأذونات والصلاحيات'),
        body: Center(child: IslamicLoading(message: 'جاري فحص الأذونات...')),
      );
    }

    return Scaffold(
      appBar: const IslamicAppBar(title: 'الأذونات والصلاحيات'),
      body: RefreshIndicator(
        onRefresh: _loadPermissions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(context.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // معلومات عامة
              _buildGeneralInfo(context),
              
              Spaces.large,
              
              // حالة الأذونات
              _buildPermissionsOverview(context),
              
              Spaces.large,
              
              // قائمة الأذونات
              _buildPermissionsList(context),
              
              Spaces.large,
              
              // أزرار الإجراءات
              _buildActionButtons(context),
              
              Spaces.large,
              
              // نصائح وإرشادات
              _buildTipsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralInfo(BuildContext context) {
    return IslamicCard(
      gradient: ThemeConstants.primaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security,
                color: Colors.white,
                size: 32,
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أذونات التطبيق',
                      style: context.titleStyle.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.fontBold,
                      ),
                    ),
                    Spaces.xs,
                    Text(
                      'يحتاج التطبيق لبعض الأذونات لتوفير أفضل تجربة لك',
                      style: context.bodyStyle.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsOverview(BuildContext context) {
    final grantedCount = _permissionStatuses.values
        .where((status) => status == AppPermissionStatus.granted)
        .length;
    final totalCount = _permissionStatuses.length;
    final percentage = totalCount > 0 ? (grantedCount / totalCount) * 100 : 0;

    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'ملخص الأذونات',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // شريط التقدم
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'الأذونات الممنوحة',
                          style: context.bodyStyle,
                        ),
                        Text(
                          '$grantedCount من $totalCount',
                          style: context.bodyStyle.copyWith(
                            fontWeight: ThemeConstants.fontSemiBold,
                          ),
                        ),
                      ],
                    ),
                    Spaces.xs,
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: context.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage >= 80 
                            ? context.successColor
                            : percentage >= 50
                                ? context.warningColor
                                : context.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
              Spaces.mediumH,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.smallPadding,
                  vertical: context.smallPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: (percentage >= 80 
                      ? context.successColor
                      : percentage >= 50
                          ? context.warningColor
                          : context.errorColor).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.smallRadius),
                ),
                child: Text(
                  '${percentage.round()}%',
                  style: context.captionStyle.copyWith(
                    color: percentage >= 80 
                        ? context.successColor
                        : percentage >= 50
                            ? context.warningColor
                            : context.errorColor,
                    fontWeight: ThemeConstants.fontBold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsList(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.list_alt_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'قائمة الأذونات',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // قائمة الأذونات
          ..._permissionStatuses.entries.map((entry) {
            final permission = entry.key;
            final status = entry.value;
            
            return Column(
              children: [
                PermissionStatusWidget(
                  permission: permission,
                  status: status,
                  onRequest: () => _requestPermission(permission),
                  onOpenSettings: () => _openSettings(permission),
                ),
                if (entry != _permissionStatuses.entries.last) 
                  Spaces.medium,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final hasUngranted = _permissionStatuses.values
        .any((status) => status != AppPermissionStatus.granted);

    return Column(
      children: [
        if (hasUngranted) ...[
          SizedBox(
            width: double.infinity,
            child: IslamicButton.primary(
              text: 'طلب جميع الأذونات',
              icon: Icons.security_outlined,
              isLoading: _isRequestingBatch,
              onPressed: _requestAllPermissions,
            ),
          ),
          Spaces.medium,
        ],
        
        SizedBox(
          width: double.infinity,
          child: IslamicButton.outlined(
            text: 'فتح إعدادات النظام',
            icon: Icons.settings_outlined,
            onPressed: _openAppSettings,
          ),
        ),
        
        Spaces.medium,
        
        SizedBox(
          width: double.infinity,
          child: IslamicButton.outlined(
            text: 'تحديث الحالة',
            icon: Icons.refresh_outlined,
            onPressed: _loadPermissions,
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'نصائح مفيدة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildTipItem(
            context: context,
            icon: Icons.location_on_outlined,
            title: 'إذن الموقع',
            description: 'مطلوب لحساب أوقات الصلاة بدقة حسب موقعك الجغرافي',
          ),
          
          Spaces.small,
          
          _buildTipItem(
            context: context,
            icon: Icons.notifications_outlined,
            title: 'إذن الإشعارات',
            description: 'ضروري لتلقي تذكيرات الصلاة والأذكار في الوقت المناسب',
          ),
          
          Spaces.small,
          
          _buildTipItem(
            context: context,
            icon: Icons.battery_saver_outlined,
            title: 'تحسين البطارية',
            description: 'يمنع النظام من إيقاف التطبيق ويضمن وصول الإشعارات',
          ),
          
          Spaces.small,
          
          _buildTipItem(
            context: context,
            icon: Icons.storage_outlined,
            title: 'إذن التخزين',
            description: 'لحفظ الأذكار المفضلة وإنشاء النسخ الاحتياطية',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconSm,
          color: context.secondaryTextColor,
        ),
        Spaces.smallH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.bodyStyle.copyWith(
                  fontWeight: ThemeConstants.fontMedium,
                ),
              ),
              Spaces.xs,
              Text(
                description,
                style: context.captionStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Action Methods
  Future<void> _requestPermission(AppPermissionType permission) async {
    try {
      final permissionService = context.permissionService;
      final status = await permissionService.requestPermission(permission);
      
      if (mounted) {
        setState(() {
          _permissionStatuses[permission] = status;
        });
        
        final permissionName = permissionService.getPermissionName(permission);
        
        if (status == AppPermissionStatus.granted) {
          context.showSuccessMessage('تم منح إذن $permissionName');
        } else if (status == AppPermissionStatus.permanentlyDenied) {
          context.showWarningMessage(
            'تم رفض إذن $permissionName نهائياً. يمكنك تفعيله من الإعدادات'
          );
        } else {
          context.showErrorMessage('لم يتم منح إذن $permissionName');
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء طلب الإذن');
      }
    }
  }

  Future<void> _requestAllPermissions() async {
    if (mounted) {
      setState(() {
        _isRequestingBatch = true;
      });
    }

    try {
      final permissionService = context.permissionService;
      final pendingPermissions = _permissionStatuses.entries
          .where((entry) => entry.value != AppPermissionStatus.granted)
          .map((entry) => entry.key)
          .toList();

      if (pendingPermissions.isEmpty) {
        if (mounted) {
          context.showInfoMessage('جميع الأذونات ممنوحة بالفعل');
        }
        return;
      }

      final result = await permissionService.requestMultiplePermissions(
        permissions: pendingPermissions,
        onProgress: (progress) {
          // يمكن إضافة مؤشر تقدم هنا
        },
        showExplanationDialog: true,
      );

      if (result.wasCancelled) {
        if (mounted) {
          context.showInfoMessage('تم إلغاء طلب الأذونات');
        }
        return;
      }

      // تحديث الحالات
      if (mounted) {
        setState(() {
          _permissionStatuses.addAll(result.results);
        });

        if (result.allGranted) {
          context.showSuccessMessage('تم منح جميع الأذونات بنجاح');
        } else {
          context.showWarningMessage(
            'تم منح ${result.results.length - result.deniedPermissions.length} '
            'من ${result.results.length} أذونات'
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء طلب الأذونات');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingBatch = false;
        });
      }
    }
  }

  Future<void> _openSettings(AppPermissionType permission) async {
    try {
      final permissionService = context.permissionService;
      final opened = await permissionService.openAppSettings();
      
      if (!opened && mounted) {
        context.showErrorMessage('لم نتمكن من فتح الإعدادات');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء فتح الإعدادات');
      }
    }
  }

  Future<void> _openAppSettings() async {
    try {
      final permissionService = context.permissionService;
      final opened = await permissionService.openAppSettings();
      
      if (opened && mounted) {
        context.showInfoMessage('يمكنك تفعيل الأذونات من إعدادات النظام');
      } else if (mounted) {
        context.showErrorMessage('لم نتمكن من فتح الإعدادات');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء فتح الإعدادات');
      }
    }
  }
}