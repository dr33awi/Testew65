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
import '../widgets/qibla_accuracy_indicator.dart';

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
    if (!_qiblaService.isCalibrated && 
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: context.primaryColor),
            const SizedBox(width: 10),
            const Text('تحسين دقة البوصلة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
              style: context.bodyMedium,
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/compass_calibration.gif',
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.rotate_right,
                  size: 100,
                  color: context.primaryColor.withOpacity(0.3),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _qiblaService.startCalibration();
            },
            child: Text(
              'بدء المعايرة',
              style: TextStyle(color: context.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('لاحقاً'),
          ),
        ],
      ),
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
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 100,
                    floating: true,
                    pinned: true,
                    backgroundColor: context.backgroundColor,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'اتجاه القبلة',
                        style: TextStyle(
                          color: context.textPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      // زر المعلومات
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: _showCalibrationInfo,
                      ),
                      // زر تحديث الموقع
                      if (!service.isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _updateQiblaData();
                          },
                        ),
                    ],
                  ),
                  
                  // المحتوى الرئيسي
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // مؤشر الدقة
                          if (service.hasCompass)
                            QiblaAccuracyIndicator(
                              accuracy: service.compassAccuracy,
                              isCalibrated: service.isCalibrated,
                              onCalibrate: () => service.startCalibration(),
                            ),
                          
                          const SizedBox(height: 16),
                          
                          // البوصلة أو رسالة الخطأ
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _buildMainContent(service),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // معلومات إضافية
                          if (service.qiblaData != null) ...[
                            _buildQiblaStats(service),
                            const SizedBox(height: 16),
                            QiblaInfoCard(qiblaData: service.qiblaData!),
                          ],
                          
                          const SizedBox(height: 100),
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
    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.cardColor,
            context.cardColor.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // خلفية متحركة
            Positioned.fill(
              child: CustomPaint(
                painter: CompassBackgroundPainter(
                  color: context.primaryColor.withOpacity(0.05),
                ),
              ),
            ),
            
            // البوصلة
            Padding(
              padding: const EdgeInsets.all(20),
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
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 350,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'جاري تحديد الموقع...',
              style: context.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return SizedBox(
      height: 350,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: context.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                service.errorMessage ?? 'حدث خطأ غير متوقع',
                textAlign: TextAlign.center,
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _updateQiblaData,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.compass_calibration_outlined,
            size: 60,
            color: Colors.amber[700],
          ),
          const SizedBox(height: 16),
          Text(
            'البوصلة غير متوفرة',
            style: context.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
            textAlign: TextAlign.center,
            style: context.bodyMedium,
          ),
          
          if (service.qiblaData != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'اتجاه القبلة من موقعك',
                    style: context.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 36,
                        color: context.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.qiblaData!.directionDescription,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'استخدم بوصلة خارجية للتوجه إلى هذا الاتجاه',
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_searching,
              size: 80,
              color: context.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'اضغط على زر التحديث لتحديد موقعك',
              style: context.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQiblaStats(QiblaService service) {
    final qiblaData = service.qiblaData!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withOpacity(0.1),
            context.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.straighten,
            label: 'المسافة',
            value: qiblaData.distanceDescription,
          ),
          Container(
            width: 1,
            height: 40,
            color: context.primaryColor.withOpacity(0.2),
          ),
          _buildStatItem(
            icon: Icons.explore,
            label: 'الاتجاه',
            value: qiblaData.directionDescription,
          ),
          Container(
            width: 1,
            height: 40,
            color: context.primaryColor.withOpacity(0.2),
          ),
          _buildStatItem(
            icon: Icons.gps_fixed,
            label: 'الدقة',
            value: qiblaData.hasHighAccuracy ? 'عالية' : 
                   qiblaData.hasMediumAccuracy ? 'متوسطة' : 'منخفضة',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: context.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// رسام خلفية البوصلة
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