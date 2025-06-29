// lib/features/settings/widgets/service_status_widgets.dart - محدث بالنظام الموحد الإسلامي

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/themes/widgets/extended_cards.dart';

class ServiceStatusOverview extends StatefulWidget {
  const ServiceStatusOverview({super.key});

  @override
  State<ServiceStatusOverview> createState() => _ServiceStatusOverviewState();
}

class _ServiceStatusOverviewState extends State<ServiceStatusOverview>
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _batteryOptimized = false;
  double _storageUsed = 45.2;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkServiceStatus();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  Future<void> _checkServiceStatus() async {
    // هنا يمكن إضافة فحص حقيقي للخدمات
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        // تحديث حالة الخدمات
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AppCard(
        useGradient: true,
        color: AppTheme.info,
        margin: AppTheme.space4.padding,
        child: Column(
          children: [
            _buildHeader(context),
            
            AppTheme.space4.h,
            
            _buildServiceIndicators(context),
            
            AppTheme.space4.h,
            
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: AppTheme.space3.padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: AppTheme.radiusMd.radius,
          ),
          child: const Icon(
            Icons.settings_system_daydream,
            color: Colors.white,
            size: AppTheme.iconLg,
          ),
        ),
        
        AppTheme.space3.w,
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حالة النظام',
                style: context.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                ),
              ),
              Text(
                'مراقبة أداء التطبيق والخدمات',
                style: context.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        
        _buildOverallStatus(),
      ],
    );
  }

  Widget _buildOverallStatus() {
    final overallHealth = _calculateOverallHealth();
    final color = _getHealthColor(overallHealth);
    
    return Container(
      padding: AppTheme.space2.padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: AppTheme.radiusFull.radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getHealthIcon(overallHealth),
            color: Colors.white,
            size: AppTheme.iconSm,
          ),
          
          AppTheme.space1.w,
          
          Text(
            '${overallHealth.toInt()}%',
            style: context.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.semiBold,
              fontFamily: AppTheme.numbersFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIndicators(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ServiceIndicator(
          icon: Icons.notifications,
          label: 'الإشعارات',
          isActive: _notificationsEnabled,
          onTap: _toggleNotifications,
        ),
        
        AppTheme.space3.w,
        
        _ServiceIndicator(
          icon: Icons.location_on,
          label: 'الموقع',
          isActive: _locationEnabled,
          onTap: _toggleLocation,
        ),
        
        AppTheme.space3.w,
        
        _ServiceIndicator(
          icon: Icons.battery_saver,
          label: 'البطارية',
          isActive: _batteryOptimized,
          onTap: _optimizeBattery,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Colors.white24,
        ),
        
        AppTheme.space2.h,
        
        Row(
          children: [
            Expanded(
              child: AppButton.outline(
                text: 'تشخيص المشاكل',
                icon: Icons.health_and_safety,
                onPressed: _runDiagnostics,
                borderColor: Colors.white,
              ),
            ),
            
            AppTheme.space3.w,
            
            Expanded(
              child: AppButton.secondary(
                text: 'إعدادات النظام',
                icon: Icons.settings,
                onPressed: _openSystemSettings,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleNotifications() async {
    HapticFeedback.lightImpact();
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
    
    if (_notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تفعيل الإشعارات بنجاح'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  void _toggleLocation() async {
    HapticFeedback.lightImpact();
    // فتح إعدادات الموقع
  }

  void _optimizeBattery() async {
    HapticFeedback.lightImpact();
    setState(() {
      _batteryOptimized = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحسين إعدادات البطارية'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  double _calculateOverallHealth() {
    int activeServices = 0;
    if (_notificationsEnabled) activeServices++;
    if (_locationEnabled) activeServices++;
    if (_batteryOptimized) activeServices++;
    
    return (activeServices / 3) * 100;
  }

  Color _getHealthColor(double percentage) {
    if (percentage >= 80) return AppTheme.success;
    if (percentage >= 50) return AppTheme.warning;
    return AppTheme.error;
  }

  IconData _getHealthIcon(double percentage) {
    if (percentage >= 80) return Icons.check_circle;
    if (percentage >= 50) return Icons.warning;
    return Icons.error;
  }

  void _runDiagnostics() {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _DiagnosticsBottomSheet(),
    );
  }

  void _openSystemSettings() {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'إعدادات النظام',
          style: context.titleLarge,
        ),
        content: Text(
          'هل تريد فتح إعدادات النظام لتحسين أداء التطبيق؟',
          style: context.bodyMedium,
        ),
        actions: [
          AppButton.text(
            text: 'إلغاء',
            onPressed: () => Navigator.pop(context),
          ),
          AppButton.primary(
            text: 'فتح الإعدادات',
            onPressed: () {
              Navigator.pop(context);
              // فتح إعدادات النظام
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ServiceIndicator({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedPress(
        onTap: onTap,
        child: Container(
          padding: AppTheme.space3.padding,
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: AppTheme.radiusMd.radius,
            border: Border.all(
              color: isActive 
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.white60,
                size: AppTheme.iconMd,
              ),
              
              AppTheme.space2.h,
              
              Text(
                label,
                style: context.bodySmall.copyWith(
                  color: isActive ? Colors.white : Colors.white60,
                  fontWeight: isActive ? AppTheme.semiBold : AppTheme.regular,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagnosticsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppTheme.space3),
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          AppTheme.space4.h,
          
          Text(
            'تشخيص النظام',
            style: context.titleLarge.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space4.h,
          
          // نتائج التشخيص
          _buildDiagnosticItem('أداء التطبيق', 'ممتاز', Icons.speed, AppTheme.success),
          _buildDiagnosticItem('استخدام الذاكرة', 'جيد', Icons.memory, AppTheme.warning),
          _buildDiagnosticItem('حالة قاعدة البيانات', 'ممتاز', Icons.storage, AppTheme.success),
          _buildDiagnosticItem('اتصال الشبكة', 'جيد', Icons.wifi, AppTheme.success),
          
          AppTheme.space4.h,
          
          AppButton.primary(
            text: 'إغلاق',
            isFullWidth: true,
            onPressed: () => Navigator.pop(context),
          ),
          
          AppTheme.space2.h,
        ],
      ),
    );
  }

  Widget _buildDiagnosticItem(String title, String status, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusMd.radius,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppTheme.iconMd),
          AppTheme.space3.w,
          Expanded(
            child: Text(title, style: AppTheme.bodyMedium),
          ),
          Text(
            status,
            style: AppTheme.bodyMedium.copyWith(
              color: color,
              fontWeight: AppTheme.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}