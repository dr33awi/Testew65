// lib/features/qibla/screens/qibla_screen.dart - محدث بالنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

// ✅ استيراد النظام الموحد
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/themes/widgets/extended_cards.dart';

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
    with WidgetsBindingObserver, TickerProviderStateMixin {
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
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.compass_calibration,
                color: AppTheme.warning,
                size: 24,
              ),
              AppTheme.space2.w,
              const Text('تحسين دقة البوصلة'),
            ],
          ),
          content: const Text(
            'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusLg.radius,
          ),
          actions: [
            AppButton.text(
              text: 'إلغاء',
              onPressed: () => Navigator.of(context).pop(),
            ),
            AppButton.primary(
              text: 'بدء المعايرة',
              onPressed: () {
                Navigator.of(context).pop();
                _qiblaService.startCalibration();
              },
            ),
          ],
        ),
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
      backgroundColor: AppTheme.background,
      // ✅ استخدام SimpleAppBar الموحد
      appBar: SimpleAppBar(
        title: 'اتجاه القبلة',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: AppTheme.primary,
            ),
            onPressed: _showInstructions,
            tooltip: 'التعليمات',
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _qiblaService,
        child: Consumer<QiblaService>(
          builder: (context, service, _) {
            return Stack(
              children: [
                // بطاقة الترحيب في الأعلى
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildWelcomeCard(context),
                ),
                
                // المحتوى الرئيسي في المنتصف
                Center(
                  child: _buildMainContent(service),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final qiblaColor = AppTheme.getCategoryColor('قبلة');
    
    return Container(
      margin: AppTheme.space4.padding,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusLg.radius,
      ),
      child: ClipRRect(
        borderRadius: AppTheme.radiusLg.radius,
        child: Stack(
          children: [
            // الخلفية المتدرجة
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    qiblaColor,
                    qiblaColor.darken(0.2),
                  ].map((c) => c.withValues(alpha: 0.9)).toList(),
                ),
              ),
            ),
            
            // الطبقة الزجاجية
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            
            // المحتوى
            Padding(
              padding: AppTheme.space5.padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // النصوص
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
                        style: AppTheme.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.bold,
                          fontSize: 16,
                          height: 1.3,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      AppTheme.space2.h,
                      
                      Text(
                        'توجه نحو الكعبة المشرفة واستقبل القبلة',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // العناصر الزخرفية
            _buildDecorativeElements(),
          ],
        ),
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
    return SizedBox(
      width: 320,
      height: 320,
      child: QiblaCompass(
        qiblaDirection: service.qiblaData!.qiblaDirection,
        currentDirection: service.currentDirection, // ✅ استخدام currentDirection المصحح
        accuracy: service.compassAccuracy,
        isCalibrated: service.isCalibrated,
        onCalibrate: () => service.startCalibration(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return AppLoading.page(message: 'جاري تحديد موقعك...');
  }

  Widget _buildErrorState(QiblaService service) {
    return AppEmptyState.error(
      message: service.errorMessage ?? 'فشل تحميل البيانات',
      onRetry: _updateQiblaData,
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // بطاقة تحذير
        AppCard(
          useGradient: true,
          color: AppTheme.warning,
          child: Column(
            children: [
              const Icon(
                Icons.compass_calibration,
                size: 64,
                color: Colors.white,
              ),
              AppTheme.space3.h,
              Text(
                'البوصلة غير متوفرة',
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: AppTheme.bold,
                  color: Colors.white,
                ),
              ),
              AppTheme.space2.h,
              Text(
                'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        if (service.qiblaData != null) ...[
          AppTheme.space4.h,
          _buildStaticQiblaInfo(service),
        ],
      ],
    );
  }

  Widget _buildStaticQiblaInfo(QiblaService service) {
    return QiblaInfoCard(
      qiblaDirection: service.qiblaData!.qiblaDirection,
      locationName: 'الموقع الحالي',
      accuracy: service.compassAccuracy,
      isCalibrated: service.isCalibrated,
      onCalibrate: () => service.startCalibration(),
    );
  }

  Widget _buildInitialState() {
    return AppCard(
      useGradient: true,
      color: AppTheme.getCategoryColor('قبلة'),
      child: Column(
        children: [
          const Icon(
            Icons.my_location,
            size: 64,
            color: Colors.white,
          ),
          AppTheme.space3.h,
          Text(
            'حدد موقعك',
            style: AppTheme.titleLarge.copyWith(
              fontWeight: AppTheme.bold,
              color: Colors.white,
            ),
          ),
          AppTheme.space2.h,
          Text(
            'اضغط هنا لتحديد موقعك وعرض اتجاه القبلة',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          AppTheme.space5.h,
          AppButton.outline(
            text: 'تحديد الموقع',
            onPressed: _updateQiblaData,
            icon: Icons.location_on,
            borderColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية صغيرة
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          // دائرة إضافية
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: AppTheme.getCategoryColor('قبلة'),
              size: 24,
            ),
            AppTheme.space2.w,
            const Text('تعليمات استخدام البوصلة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionItem(
              icon: Icons.my_location,
              title: '1. تفعيل الموقع',
              description: 'تأكد من تفعيل خدمة الموقع على هاتفك',
            ),
            AppTheme.space4.h,
            _buildInstructionItem(
              icon: Icons.compass_calibration,
              title: '2. معايرة البوصلة',
              description: 'حرك هاتفك على شكل الرقم 8 لمعايرة البوصلة',
            ),
            AppTheme.space4.h,
            _buildInstructionItem(
              icon: Icons.phone_android,
              title: '3. وضع الهاتف',
              description: 'امسك الهاتف بشكل مسطح أمامك',
            ),
            AppTheme.space4.h,
            _buildInstructionItem(
              icon: Icons.navigation,
              title: '4. اتباع الاتجاه',
              description: 'اتبع السهم الأخضر للتوجه نحو القبلة',
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: 'فهمت',
            onPressed: () => Navigator.of(context).pop(),
            textColor: AppTheme.getCategoryColor('قبلة'),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.getCategoryColor('قبلة').withValues(alpha: 0.1),
            borderRadius: AppTheme.radiusMd.radius,
          ),
          child: Icon(
            icon,
            color: AppTheme.getCategoryColor('قبلة'),
            size: 20,
          ),
        ),
        AppTheme.space3.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: AppTheme.semiBold,
                ),
              ),
              AppTheme.space1.h,
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}