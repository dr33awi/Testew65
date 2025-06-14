// lib/features/qibla/screens/qibla_screen.dart
import 'dart:math' as math;
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
import '../widgets/qibla_info_card.dart';
// import '../widgets/qibla_accuracy_indicator.dart'; // Removed this import

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final QiblaService _qiblaService;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool _showCalibrationDialog = false;

  @override
  void initState() {
    super.initState();

    // يتم إنشاء QiblaService هنا في initState
    // لضمان الحصول على BuildContext صالح لـ ServiceLocator
    _qiblaService = QiblaService(
      logger: getIt<LoggerService>(),
      storage: getIt<StorageService>(),
      permissionService: getIt<PermissionService>(),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addObserver(this);

    // تحديث بيانات القبلة عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateQiblaData();
      _fadeController.forward();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // تحديث البيانات عند العودة إلى التطبيق
    if (state == AppLifecycleState.resumed) {
      _updateQiblaData();
    }
  }

  Future<void> _updateQiblaData() async {
    await _qiblaService.updateQiblaData();

    // إظهار نصيحة المعايرة إذا كانت الدقة منخفضة
    // وتأكد من أننا لم نعرضها بالفعل
    if (!_qiblaService.isCalibrated &&
        _qiblaService.hasCompass && // تأكد من وجود بوصلة
        _qiblaService.compassAccuracy < 0.7 &&
        !_showCalibrationDialog) {
      _showCalibrationDialog = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showCalibrationInfo();
        }
      });
    }
  }

  void _showCalibrationInfo() {
    AppInfoDialog.show(
      context: context,
      title: 'تحسين دقة البوصلة',
      content: 'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
      icon: Icons.compass_calibration,
      accentColor: context.primaryColor,
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ThemeConstants.space4),
          // Placeholder for GIF as assets are not directly accessible here
          Icon(
            Icons.rotate_right,
            size: 100,
            color: context.primaryColor.withOpacity(0.3),
          ),
        ],
      ),
      actions: [
        DialogAction(
          label: 'بدء المعايرة',
          onPressed: () {
            Navigator.of(context).pop();
            _qiblaService.startCalibration();
          },
          isPrimary: true,
        ),
        DialogAction(
          label: 'لاحقاً',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    _qiblaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: ChangeNotifierProvider.value(
        value: _qiblaService,
        child: Consumer<QiblaService>(
          builder: (context, service, _) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    pinned: false,
                    backgroundColor: context.backgroundColor,
                    elevation: 0,
                    toolbarHeight: 60,
                    flexibleSpace: PreferredSize(
                      preferredSize: const Size.fromHeight(60.0),
                      child: CustomAppBar(
                        title: 'اتجاه القبلة',
                        actions: [
                          AppBarAction(
                            icon: Icons.info_outline,
                            onPressed: _showCalibrationInfo,
                            tooltip: 'معلومات حول المعايرة',
                          ),
                          if (!service.isLoading)
                            AppBarAction(
                              icon: Icons.refresh,
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _updateQiblaData();
                              },
                              tooltip: 'تحديث الموقع',
                            ),
                          if (service.isLoading)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: AppLoading.circular(size: LoadingSize.small),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                      child: Column(
                        children: [
                          ThemeConstants.space4.h,

                          // البوصلة أو رسالة الخطأ
                          AnimatedSwitcher(
                            duration: ThemeConstants.durationNormal,
                            child: _buildMainContent(service),
                          ),

                          ThemeConstants.space6.h,

                          // معلومات إضافية
                          if (service.qiblaData != null) ...[
                            QiblaInfoCard(qiblaData: service.qiblaData!),
                          ],

                          ThemeConstants.space12.h,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
    // Removed CompassBackgroundPainter to remove the visual background
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          // Removed background painter to remove the visual card-like effect
          /*
          Positioned.fill(
            child: CustomPaint(
              painter: CompassBackgroundPainter(
                color: context.primaryColor.withOpacity(0.05),
              ),
            ),
          ),
          */

          // البوصلة
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: QiblaCompass(
              qiblaDirection: service.qiblaData!.qiblaDirection,
              currentDirection: service.currentDirection,
              accuracy: service.compassAccuracy,
              isCalibrated: service.isCalibrated,
              onCalibrate: () => service.startCalibration(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 350,
      child: Center(
        child: AppLoading.circular(
          size: LoadingSize.large,
        ),
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return SizedBox(
      height: 350,
      child: AppEmptyState.error(
        message: service.errorMessage ?? 'فشل تحميل البيانات. يرجى المحاولة لاحقاً.',
        onRetry: _updateQiblaData,
      ),
    );
  }

Widget _buildNoCompassState(QiblaService service) {
  return Container(
    // الحاوية الخارجية بخلفية صفراء خفيفة
    decoration: BoxDecoration(
      color: Colors.amber.withOpacity(0.1),
      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      border: Border.all(
        color: Colors.amber.withOpacity(0.3),
        width: ThemeConstants.borderLight,
      ),
    ),
    padding: const EdgeInsets.all(ThemeConstants.space6),
    child: Column(
      children: [
        // الأيقونة
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.compass_calibration_outlined,
            size: ThemeConstants.icon2xl,
            color: Colors.amber[700],
          ),
        ),
        
        ThemeConstants.space4.h,
        
        // العنوان
        Text(
          'البوصلة غير متوفرة',
          style: context.titleLarge?.bold,
        ),
        
        ThemeConstants.space2.h,
        
        // الوصف
        Text(
          'جهازك لا يدعم البوصلة أو أنها معطلة حالياً. يمكنك استخدام اتجاه القبلة من موقعك.',
          textAlign: TextAlign.center,
          style: context.bodyMedium,
        ),
        
        // معلومات القبلة إن وجدت
        if (service.qiblaData != null) ...[
          ThemeConstants.space5.h,
          
          // بطاقة معلومات القبلة
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              boxShadow: ThemeConstants.shadowMd,
            ),
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Column(
              children: [
                Text(
                  'اتجاه القبلة من موقعك',
                  style: context.titleMedium?.semiBold,
                ),
                
                ThemeConstants.space3.h,
                
                // الاتجاه بالدرجات
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.space2),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.navigation,
                        size: ThemeConstants.iconXl,
                        color: context.primaryColor,
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                          style: context.headlineMedium?.copyWith(
                            fontWeight: ThemeConstants.bold,
                            color: context.primaryColor,
                          ),
                        ),
                        Text(
                          service.qiblaData!.directionDescription,
                          style: context.bodyMedium?.medium,
                        ),
                      ],
                    ),
                  ],
                ),
                
                ThemeConstants.space4.h,
                
                // ملاحظة
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    border: Border.all(
                      color: context.primaryColor.withOpacity(0.2),
                      width: ThemeConstants.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: ThemeConstants.iconSm,
                        color: context.primaryColor,
                      ),
                      ThemeConstants.space2.w,
                      Expanded(
                        child: Text(
                          'استخدم بوصلة خارجية للتوجه إلى هذا الاتجاه',
                          style: context.bodySmall?.copyWith(
                            color: context.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

  Widget _buildInitialState() {
    return SizedBox(
      height: 350,
      child: AppEmptyState.custom(
        title: 'حدد موقعك',
        message: 'اضغط على زر التحديث لتحديد موقعك وعرض اتجاه القبلة',
        icon: Icons.location_searching,
        iconColor: context.primaryColor.withOpacity(0.5),
        onAction: _updateQiblaData,
        actionText: 'تحديد الموقع',
      ),
    );
  }
}

// رسام خلفية البوصلة (هذا الكلاس لم يعد يُستخدم في _buildCompassView بعد التعديل الأخير)
class CompassBackgroundPainter extends CustomPainter {
  final Color color;

  CompassBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // رسم دوائر متحدة المركز
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        center,
        maxRadius * (i / 5),
        paint..color = color.withOpacity(0.5 - (i * 0.08)),
      );
    }

    // رسم خطوط شعاعية
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final start = Offset(
        center.dx + (maxRadius * 0.3) * math.cos(angle),
        center.dy + (maxRadius * 0.3) * math.sin(angle),
      );
      final end = Offset(
        center.dx + maxRadius * math.cos(angle),
        center.dy + maxRadius * math.sin(angle),
      );

      canvas.drawLine(
        start,
        end,
        paint..color = color.withOpacity(0.2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}