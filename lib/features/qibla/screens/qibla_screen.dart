// lib/features/qibla/screens/qibla_screen.dart - شاشة القبلة بالثيم الإسلامي الموحد
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../services/qibla_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with TickerProviderStateMixin {
  late QiblaService _qiblaService;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _qiblaService = getService<QiblaService>();
    
    // إعداد الحركات
    _rotationController = AnimationController(
      duration: AppTheme.durationSlow,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // تحديث البيانات إذا لزم الأمر
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_qiblaService.qiblaData == null || _qiblaService.qiblaData!.isStale) {
        _qiblaService.updateQiblaData();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppAppBar.basic(
        title: 'اتجاه القبلة',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _qiblaService.updateQiblaData(),
            tooltip: 'تحديث الموقع',
          ),
          AppTheme.space2.w,
        ],
      ),
      body: AnimatedBuilder(
        animation: _qiblaService,
        builder: (context, child) {
          if (_qiblaService.isLoading) {
            return _buildLoadingState();
          }
          
          if (_qiblaService.errorMessage != null) {
            return _buildErrorState();
          }
          
          if (_qiblaService.qiblaData == null) {
            return _buildInitialState();
          }
          
          return _buildQiblaContent();
        },
      ),
    );
  }

  // حالة التحميل
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoading.page(message: 'جاري تحديد موقعك...'),
          AppTheme.space6.h,
          AppCard.basic(
            title: 'الحصول على الموقع',
            subtitle: 'نحتاج موقعك لحساب اتجاه القبلة بدقة',
            icon: Icons.location_searching,
            color: AppTheme.info,
          ),
        ],
      ),
    );
  }

  // حالة الخطأ
  Widget _buildErrorState() {
    return Padding(
      padding: AppTheme.space6.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppCard.basic(
            title: 'خطأ في تحديد الموقع',
            subtitle: _qiblaService.errorMessage!,
            icon: Icons.error_outline,
            color: AppTheme.error,
          ),
          AppTheme.space6.h,
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'إعادة المحاولة',
                  icon: Icons.refresh,
                  onPressed: () => _qiblaService.updateQiblaData(),
                ),
              ),
              AppTheme.space3.w,
              Expanded(
                child: AppButton.primary(
                  text: 'الإعدادات',
                  icon: Icons.settings,
                  onPressed: () => context.permissionService.openAppSettings(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // الحالة الأولية
  Widget _buildInitialState() {
    return Padding(
      padding: AppTheme.space6.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppCard.basic(
            title: 'مرحباً بك',
            subtitle: 'اضغط على الزر أدناه لتحديد موقعك وحساب اتجاه القبلة',
            icon: Icons.explore,
            color: AppTheme.primary,
          ),
          AppTheme.space6.h,
          AppButton.primary(
            text: 'تحديد الموقع',
            icon: Icons.my_location,
            onPressed: () => _qiblaService.updateQiblaData(),
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  // المحتوى الرئيسي للقبلة
  Widget _buildQiblaContent() {
    final qiblaData = _qiblaService.qiblaData!;
    
    return SingleChildScrollView(
      padding: AppTheme.space4.padding,
      child: Column(
        children: [
          // معلومات الموقع
          _buildLocationInfo(qiblaData),
          AppTheme.space4.h,
          
          // البوصلة الرئيسية
          _buildMainCompass(qiblaData),
          AppTheme.space4.h,
          
          // معلومات الاتجاه
          _buildDirectionInfo(qiblaData),
          AppTheme.space4.h,
          
          // حالة البوصلة
          _buildCompassStatus(),
          AppTheme.space4.h,
          
          // إحصائيات إضافية
          _buildQiblaStats(qiblaData),
        ],
      ),
    );
  }

  // معلومات الموقع
  Widget _buildLocationInfo(qiblaData) {
    return AppCard.basic(
      title: qiblaData.cityName ?? 'موقعك الحالي',
      subtitle: qiblaData.countryName,
      icon: Icons.location_on,
      color: AppTheme.info,
    );
  }

  // البوصلة الرئيسية
  Widget _buildMainCompass(qiblaData) {
    return Container(
      width: double.infinity,
      padding: AppTheme.space6.padding,
      child: Column(
        children: [
          // البوصلة
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.oliveGoldGradient,
                    boxShadow: AppTheme.shadowLg,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // خلفية البوصلة
                      Container(
                        width: 220,
                        height: 220,
                        decoration: const BoxDecoration(
                          color: AppTheme.background,
                          shape: BoxShape.circle,
                        ),
                      ),
                      
                      // الاتجاهات الأساسية
                      _buildCompassDirections(),
                      
                      // سهم الشمال (البوصلة)
                      if (_qiblaService.hasCompass)
                        Transform.rotate(
                          angle: -_qiblaService.currentDirection * (math.pi / 180),
                          child: Container(
                            width: 4,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.info,
                              borderRadius: AppTheme.radiusFull.radius,
                            ),
                          ),
                        ),
                      
                      // سهم القبلة
                      Transform.rotate(
                        angle: (_qiblaService.hasCompass ? _qiblaService.qiblaAngle : qiblaData.qiblaDirection) * (math.pi / 180),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.navigation,
                              size: AppTheme.iconXl + AppTheme.space2,
                              color: AppTheme.primary,
                            ),
                            Text(
                              'القبلة',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.primary,
                                fontWeight: AppTheme.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // النقطة المركزية
                      Container(
                        width: AppTheme.space3,
                        height: AppTheme.space3,
                        decoration: const BoxDecoration(
                          color: AppTheme.textPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          AppTheme.space4.h,
          
          // الدرجة الرقمية
          Container(
            padding: AppTheme.space3.padding,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: Text(
              '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.primary,
                fontWeight: AppTheme.bold,
                fontFamily: AppTheme.numbersFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // الاتجاهات الأساسية للبوصلة
  Widget _buildCompassDirections() {
    const directions = [
      {'label': 'ش', 'angle': 0.0},
      {'label': 'ج', 'angle': 90.0},
      {'label': 'ج', 'angle': 180.0},
      {'label': 'غ', 'angle': 270.0},
    ];
    
    return Stack(
      children: directions.map((direction) {
        final angle = direction['angle'] as double;
        final label = direction['label'] as String;
        return Transform.rotate(
          angle: angle * (math.pi / 180),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: AppTheme.space2),
              child: Text(
                label,
                style: AppTheme.labelMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: AppTheme.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // معلومات الاتجاه
  Widget _buildDirectionInfo(qiblaData) {
    return Row(
      children: [
        Expanded(
          child: AppCard.stat(
            title: 'الاتجاه',
            value: qiblaData.directionDescription,
            icon: Icons.explore,
            color: AppTheme.tertiary,
          ),
        ),
        AppTheme.space3.w,
        Expanded(
          child: AppCard.stat(
            title: 'المسافة',
            value: qiblaData.distanceDescription,
            icon: Icons.straighten,
            color: AppTheme.secondary,
          ),
        ),
      ],
    );
  }

  // حالة البوصلة
  Widget _buildCompassStatus() {
    if (!_qiblaService.hasCompass) {
      return AppCard.basic(
        title: 'البوصلة غير متوفرة',
        subtitle: 'يتم عرض الاتجاه الثابت بناءً على موقعك',
        icon: Icons.compass_calibration,
        color: AppTheme.warning,
      );
    }
    
    return Column(
      children: [
        AppCard.basic(
          title: _qiblaService.isCalibrated ? 'البوصلة مُعايَرة' : 'البوصلة تحتاج معايرة',
          subtitle: _qiblaService.isCalibrated 
              ? 'البوصلة تعمل بدقة عالية'
              : 'حرك الهاتف في شكل ثمانية للمعايرة',
          icon: _qiblaService.isCalibrated ? Icons.check_circle : Icons.warning,
          color: _qiblaService.isCalibrated ? AppTheme.success : AppTheme.warning,
        ),
        
        if (!_qiblaService.isCalibrated) ...[
          AppTheme.space3.h,
          AppButton.primary(
            text: 'معايرة البوصلة',
            icon: Icons.tune,
            onPressed: () => _qiblaService.startCalibration(),
            isFullWidth: true,
          ),
        ],
      ],
    );
  }

  // إحصائيات القبلة
  Widget _buildQiblaStats(qiblaData) {
    return AppInfo.stats(
      title: 'تفاصيل الحساب',
      statistics: {
        'خط العرض': '${qiblaData.latitude.toStringAsFixed(4)}°',
        'خط الطول': '${qiblaData.longitude.toStringAsFixed(4)}°',
        'دقة الموقع': '${qiblaData.accuracy.toStringAsFixed(1)} م',
        'آخر تحديث': AppTheme.formatDuration(qiblaData.age),
        if (_qiblaService.hasCompass) 'دقة البوصلة': '${(_qiblaService.compassAccuracy * 100).toStringAsFixed(0)}%',
      },
      icon: Icons.analytics,
    );
  }
}