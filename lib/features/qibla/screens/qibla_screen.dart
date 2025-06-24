// lib/features/qibla/screens/qibla_screen.dart - نسخة محسنة بالنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/qibla_service.dart';
import '../widgets/qibla_compass.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with WidgetsBindingObserver {
  late final QiblaService _qiblaService;

  @override
  void initState() {
    super.initState();
    _initializeService();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateQiblaData());
  }

  void _initializeService() {
    _qiblaService = QiblaService(
      logger: getIt<LoggerService>(),
      storage: getIt<StorageService>(),
      permissionService: getIt<PermissionService>(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateQiblaData();
    }
  }

  Future<void> _updateQiblaData() async {
    await _qiblaService.updateQiblaData();
    
    if (_shouldShowCalibrationTip()) {
      _showCalibrationTip();
    }
  }

  bool _shouldShowCalibrationTip() {
    return !_qiblaService.isCalibrated &&
           _qiblaService.hasCompass &&
           _qiblaService.compassAccuracy < 0.7;
  }

  void _showCalibrationTip() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      AppInfoDialog.show(
        context: context,
        title: 'تحسين دقة البوصلة',
        content: 'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
        icon: Icons.compass_calibration,
        accentColor: context.warningColor,
        actions: [
          DialogAction(
            label: 'بدء المعايرة',
            onPressed: () {
              Navigator.of(context).pop();
              _qiblaService.startCalibration();
            },
            isPrimary: true,
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _qiblaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar(
        title: 'اتجاه القبلة',
        actions: [
          AppBarAction(
            icon: Icons.info_outline,
            onPressed: _showQiblaInfo,
            tooltip: 'معلومات حول القبلة',
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _qiblaService,
        child: Consumer<QiblaService>(
          builder: (context, service, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // بطاقة الترحيب
                SliverToBoxAdapter(
                  child: _buildWelcomeCard(context),
                ),
                
                ThemeConstants.space4.sliverBox,
                
                // المحتوى الرئيسي
                SliverToBoxAdapter(
                  child: _buildMainContent(service),
                ),
                
                // معلومات القبلة
                if (service.qiblaData != null)
                  SliverToBoxAdapter(
                    child: _buildQiblaInfoCard(service),
                  ),
                
                ThemeConstants.space8.sliverBox,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        gradient: CategoryHelper.getCategoryGradient(context, 'qibla'),
        boxShadow: [
          BoxShadow(
            color: CategoryHelper.getCategoryColor(context, 'qibla').withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة القبلة
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.explore,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اتجاه القبلة',
                  style: context.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  'توجه نحو الكعبة المشرفة',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          
          // أيقونة البوصلة
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              Icons.navigation,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(QiblaService service) {
    if (service.isLoading) {
      return _buildLoadingState();
    } else if (service.errorMessage != null) {
      return _buildErrorState(service);
    } else if (!service.hasCompass) {
      return _buildNoCompassState(service);
    } else if (service.qiblaData != null) {
      return _buildCompassView(service);
    } else {
      return _buildInitialState();
    }
  }

  Widget _buildCompassView(QiblaService service) {
    return Column(
      children: [
        // عنوان البوصلة باستخدام AppCard.info الموحد
        AppCard.info(
          title: 'البوصلة الذكية',
          subtitle: 'حرك هاتفك لتحديد اتجاه القبلة',
          icon: Icons.compass_calibration,
          iconColor: CategoryHelper.getCategoryColor(context, 'qibla'),
          trailing: !service.isCalibrated 
            ? AppButton.outline(
                text: 'معايرة',
                onPressed: () => service.startCalibration(),
                icon: Icons.compass_calibration,
                color: context.warningColor,
                size: ButtonSize.small,
              )
            : null,
        ).padded(ThemeConstants.space4.horizontal),
        
        ThemeConstants.space4.h,
        
        // البوصلة
        SizedBox(
          height: 320,
          child: QiblaCompass(
            qiblaDirection: service.qiblaData!.qiblaDirection,
            currentDirection: service.currentDirection,
            accuracy: service.compassAccuracy,
            isCalibrated: service.isCalibrated,
            onCalibrate: () => service.startCalibration(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return AppCard.completion(
      title: 'جاري تحديد موقعك...',
      message: 'يرجى الانتظار قليلاً',
      icon: Icons.location_searching,
      primaryColor: CategoryHelper.getCategoryColor(context, 'qibla'),
    ).padded(ThemeConstants.space4.horizontal);
  }

  Widget _buildErrorState(QiblaService service) {
    return AppCard.completion(
      title: 'خطأ في التحميل',
      message: service.errorMessage ?? 'فشل تحميل البيانات',
      icon: Icons.error_outline,
      primaryColor: context.errorColor,
      actions: [
        CardAction(
          icon: Icons.refresh,
          label: 'المحاولة مرة أخرى',
          onPressed: _updateQiblaData,
          isPrimary: true,
        ),
      ],
    ).padded(ThemeConstants.space4.horizontal);
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Column(
      children: [
        // بطاقة تحذير
        AppNoticeCard.warning(
          title: 'البوصلة غير متوفرة',
          message: 'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
          margin: ThemeConstants.space4.horizontal,
        ),
        
        if (service.qiblaData != null) ...[
          ThemeConstants.space4.h,
          _buildStaticQiblaInfo(service),
        ],
      ],
    );
  }

  Widget _buildStaticQiblaInfo(QiblaService service) {
    return AppCard.stat(
      title: 'اتجاه القبلة من موقعك',
      value: '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
      icon: Icons.navigation,
      color: CategoryHelper.getCategoryColor(context, 'qibla'),
    ).padded(ThemeConstants.space4.horizontal);
  }

  Widget _buildInitialState() {
    return AppCard.completion(
      title: 'حدد موقعك',
      message: 'اضغط على زر التحديث لتحديد موقعك وعرض اتجاه القبلة',
      icon: Icons.location_searching,
      primaryColor: CategoryHelper.getCategoryColor(context, 'qibla'),
      actions: [
        CardAction(
          icon: Icons.my_location,
          label: 'تحديد الموقع',
          onPressed: _updateQiblaData,
          isPrimary: true,
        ),
      ],
    ).padded(ThemeConstants.space4.horizontal);
  }

  Widget _buildQiblaInfoCard(QiblaService service) {
    final qiblaData = service.qiblaData!;
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          // الكارد الأساسي
          AppCard.info(
            title: _getLocationName(qiblaData),
            subtitle: 'موقعك الحالي',
            icon: Icons.location_on,
            iconColor: CategoryHelper.getCategoryColor(context, 'qibla'),
            trailing: _buildAccuracyBadge(qiblaData),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // معلومات القبلة السريعة
          Row(
            children: [
              Expanded(
                child: _buildQuickInfoTile(
                  context,
                  icon: Icons.navigation,
                  label: 'الاتجاه',
                  value: '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
                  subtitle: qiblaData.directionDescription,
                ),
              ),
              const SizedBox(width: ThemeConstants.space3),
              Expanded(
                child: _buildQuickInfoTile(
                  context,
                  icon: Icons.straighten,
                  label: 'المسافة',
                  value: qiblaData.distanceDescription,
                  subtitle: 'للكعبة المشرفة',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
  }) {
    return AppCard(
      type: CardType.stat,
      style: CardStyle.glassmorphism,
      primaryColor: CategoryHelper.getCategoryColor(context, 'qibla'),
      padding: const EdgeInsets.all(ThemeConstants.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.9),
                size: 16,
              ),
              const SizedBox(width: ThemeConstants.space1),
              Text(
                label,
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.space1),
          Text(
            value,
            style: context.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          Text(
            subtitle,
            style: context.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }


  String _getLocationName(dynamic qiblaData) {
    if (qiblaData.cityName != null && qiblaData.countryName != null) {
      return '${qiblaData.cityName}، ${qiblaData.countryName}';
    } else if (qiblaData.cityName != null) {
      return qiblaData.cityName!;
    } else if (qiblaData.countryName != null) {
      return qiblaData.countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }



  Widget _buildAccuracyBadge(dynamic qiblaData) {
    Color color;
    String text;
    IconData icon;
    
    if (qiblaData.hasHighAccuracy) {
      color = context.successColor;
      text = 'دقيق';
      icon = Icons.gps_fixed;
    } else if (qiblaData.hasMediumAccuracy) {
      color = context.warningColor;
      text = 'متوسط';
      icon = Icons.gps_not_fixed;
    } else {
      color = context.errorColor;
      text = 'ضعيف';
      icon = Icons.gps_off;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: context.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showQiblaInfo() {
    AppInfoDialog.show(
      context: context,
      title: 'عن اتجاه القبلة',
      content: 'القبلة هي الاتجاه الذي يتوجه إليه المسلمون في صلاتهم، وهي الكعبة المشرفة في مكة المكرمة.',
      subtitle: 'قال الله تعالى: "وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
      icon: Icons.mosque,
      accentColor: CategoryHelper.getCategoryColor(context, 'qibla'),
    );
  }
}