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
              child: SafeArea(
                child: Column(
                  children: [
                    // Custom AppBar محسن
                    _buildCustomAppBar(context, service),
                    
                    // المحتوى
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
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
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, QiblaService service) {
    // استخدام نفس التدرج المستخدم في CategoryGrid لفئة qibla
    const gradient = LinearGradient(
      colors: [ThemeConstants.primaryDark, ThemeConstants.primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // زر الرجوع
          AppBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          
          ThemeConstants.space3.w,
          
          // الأيقونة الجانبية مع نفس التدرج المستخدم في CategoryGrid
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.primaryDark.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.explore,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          // العنوان والوصف
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اتجاه القبلة',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  service.qiblaData != null 
                      ? 'الاتجاه: ${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°'
                      : 'البوصلة الذكية',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // زر معلومات المعايرة
          Container(
            margin: const EdgeInsets.only(left: ThemeConstants.space2),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showCalibrationInfo();
                },
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    border: Border.all(
                      color: context.dividerColor.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: context.textSecondaryColor,
                    size: ThemeConstants.iconMd,
                  ),
                ),
              ),
            ),
          ),
          
          // زر التحديث أو مؤشر التحميل
          Container(
            margin: const EdgeInsets.only(left: ThemeConstants.space2),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              child: InkWell(
                onTap: service.isLoading ? null : () {
                  HapticFeedback.lightImpact();
                  _updateQiblaData();
                },
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    border: Border.all(
                      color: context.dividerColor.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: service.isLoading 
                      ? const SizedBox(
                          width: ThemeConstants.iconMd, 
                          height: ThemeConstants.iconMd, 
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(ThemeConstants.primaryDark),
                          ),
                        )
                      : const Icon(
                          Icons.refresh_rounded,
                          color: ThemeConstants.primaryDark,
                          size: ThemeConstants.iconMd,
                        ),
                ),
              ),
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
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
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
    return AppCard( // This is a fallback card for when compass is not available, not the main compass background.
      backgroundColor: Colors.amber.withOpacity(0.1),
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        children: [
          Icon(
            Icons.compass_calibration_outlined,
            size: ThemeConstants.icon2xl,
            color: Colors.amber[700],
          ),
          ThemeConstants.space4.h,
          Text(
            'البوصلة غير متوفرة',
            style: context.titleLarge?.bold,
          ),
          ThemeConstants.space2.h,
          Text(
            'جهازك لا يدعم البوصلة أو أنها معطلة حالياً. يمكنك استخدام اتجاه القبلة من موقعك.',
            textAlign: TextAlign.center,
            style: context.bodyMedium,
          ),
          if (service.qiblaData != null) ...[
            ThemeConstants.space5.h,
            AppCard(
              backgroundColor: context.cardColor,
              elevation: ThemeConstants.elevation2,
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: Column(
                children: [
                  Text(
                    'اتجاه القبلة من موقعك',
                    style: context.titleMedium?.semiBold,
                  ),
                  ThemeConstants.space3.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.navigation,
                        size: ThemeConstants.iconXl,
                        color: context.primaryColor,
                      ),
                      ThemeConstants.space2.w,
                      Text(
                        '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                        style: context.headlineMedium?.copyWith(
                          fontWeight: ThemeConstants.bold,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  ThemeConstants.space2.h,
                  Text(
                    service.qiblaData!.directionDescription,
                    style: context.bodyLarge?.medium,
                  ),
                  ThemeConstants.space3.h,
                  Text(
                    'استخدم بوصلة خارجية للتوجه إلى هذا الاتجاه',
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
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