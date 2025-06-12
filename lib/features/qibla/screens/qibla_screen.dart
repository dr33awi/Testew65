// lib/features/qibla/screens/qibla_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/qibla_service.dart';
// import '../widgets/qibla_compass.dart'; // تم إزالة الاستيراد
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
      duration: ThemeConstants.durationNormal, // استخدام الثيم الموحد
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth, // استخدام الثيم الموحد
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
    // لم يعد هناك بوصلة مرئية، ولكن قد تكون هذه النصيحة مفيدة لدقة الموقع بشكل عام.
    // تم تغيير الشرط ليناسب دقة الموقع بدلاً من دقة البوصلة.
    if (_qiblaService.qiblaData != null &&
        _qiblaService.qiblaData!.accuracy > 50 && // دقة منخفضة (أكثر من 50 متر)
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
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg), // استخدام الثيم الموحد
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: context.primaryColor),
            const SizedBox(width: ThemeConstants.space3), // استخدام الثيم الموحد
            Text(
              'تحسين دقة الموقع', // تم تعديل النص
              style: context.h5, // استخدام الثيم الموحد
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'لتحسين دقة تحديد الموقع، تأكد من أن جهازك في مكان مفتوح ولديه إشارة GPS جيدة.',
              style: context.bodyMedium, // استخدام الثيم الموحد
            ),
            const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد
            Image.asset(
              'assets/images/gps_signal.gif', // صورة توضيحية جديدة
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.location_on,
                  size: 100,
                  color: context.primaryColor.withOpacity(0.3),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'حسناً',
              style: TextStyle(color: context.primaryColor),
            ),
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
            return RefreshIndicator( // إضافة RefreshIndicator
              onRefresh: _updateQiblaData,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // لتمكين السحب للتحديث دائماً
                  slivers: [
                    // App Bar
                    _buildAppBar(service),

                    // المحتوى
                    if (service.isLoading && service.qiblaData == null)
                      _buildLoadingState()
                    else if (service.errorMessage != null && service.qiblaData == null)
                      _buildErrorState(service)
                    else if (service.qiblaData != null)
                      ..._buildContent(service)
                    else
                      _buildEmptyState(service),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(QiblaService service) {
    return SliverAppBar(
      floating: true, //
      snap: true, //
      backgroundColor: context.backgroundColor,
      surfaceTintColor: Colors.transparent, //
      title: Text(
        'اتجاه القبلة',
        style: context.titleLarge?.semiBold, // استخدام الثيم الموحد
      ),
      actions: [
        // زر المعلومات
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: _showCalibrationInfo,
          tooltip: 'معلومات دقة الموقع', // تم تعديل النص
        ),
        // زر تحديث الموقع
        IconButton(
          icon: service.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                  ),
                )
              : const Icon(Icons.refresh),
          onPressed: service.isLoading ? null : () {
            HapticFeedback.lightImpact();
            _updateQiblaData();
          },
          tooltip: 'تحديث الموقع',
        ),
      ],
    );
  }

  List<Widget> _buildContent(QiblaService service) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4), // استخدام الثيم الموحد
          child: Column(
            children: [
              const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد
              // مؤشر الدقة
              // الآن يعرض دقة الموقع بدلاً من دقة البوصلة الخام
              QiblaAccuracyIndicator(
                accuracy: service.qiblaData!.accuracy,
                isCalibrated: service.isCalibrated,
                onCalibrate: () => service.startCalibration(),
              ),

              const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد

              // لوحة ملخص اتجاه القبلة
              _buildQiblaOverview(service),

              const SizedBox(height: ThemeConstants.space6), // استخدام الثيم الموحد

              // إحصائيات القبلة
              _buildQiblaStats(service),

              const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد

              // معلومات إضافية
              QiblaInfoCard(qiblaData: service.qiblaData!),

              const SizedBox(height: ThemeConstants.space8), // استخدام الثيم الموحد
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildQiblaOverview(QiblaService service) {
    final qiblaData = service.qiblaData!;
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space6), // استخدام الثيم الموحد
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg), // استخدام الثيم الموحد
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withOpacity(ThemeConstants.opacity10), // استخدام الثيم الموحد
            context.primaryColor.withOpacity(ThemeConstants.opacity5), // استخدام الثيم الموحد
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withOpacity(ThemeConstants.opacity10), // استخدام الثيم الموحد
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_on,
            size: 80,
            color: context.primaryColor,
          ),
          const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد
          Text(
            'اتجاه القبلة من موقعك الحالي',
            textAlign: TextAlign.center,
            style: context.titleLarge?.semiBold, // استخدام الثيم الموحد
          ),
          const SizedBox(height: ThemeConstants.space3), // استخدام الثيم الموحد
          Text(
            '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
            style: TextStyle(
              fontSize: 48,
              fontWeight: ThemeConstants.bold, // استخدام الثيم الموحد
              color: context.primaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space2), // استخدام الثيم الموحد
          Text(
            qiblaData.directionDescription,
            style: context.bodyLarge?.copyWith(
              fontWeight: ThemeConstants.medium, // استخدام الثيم الموحد
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد
          Text(
            'المسافة إلى الكعبة: ${qiblaData.distanceDescription}',
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverFillRemaining( //
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoading.circular(size: LoadingSize.large), // استخدام AppLoading
            const SizedBox(height: ThemeConstants.space4), // استخدام الثيم الموحد
            Text(
              'جاري تحديد الموقع...',
              style: context.bodyLarge, // استخدام الثيم الموحد
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return SliverFillRemaining( //
      child: Center(
        child: AppEmptyState.error( // استخدام AppEmptyState.error
          message: service.errorMessage,
          onRetry: _updateQiblaData,
        ),
      ),
    );
  }

  Widget _buildEmptyState(QiblaService service) {
    return SliverFillRemaining( //
      child: Center(
        child: AppEmptyState.custom( // استخدام AppEmptyState.custom
          title: 'لم يتم تحديد الموقع',
          message: 'نحتاج لتحديد موقعك لعرض اتجاه القبلة الصحيح',
          icon: Icons.location_on,
          onAction: service.isLoading ? null : _updateQiblaData,
          actionText: 'تحديد الموقع',
          iconColor: context.primaryColor,
        ),
      ),
    );
  }

  Widget _buildQiblaStats(QiblaService service) {
    final qiblaData = service.qiblaData!;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4), // استخدام الثيم الموحد
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withOpacity(ThemeConstants.opacity10), // استخدام الثيم الموحد
            context.primaryColor.withOpacity(ThemeConstants.opacity5), // استخدام الثيم الموحد
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd), // استخدام الثيم الموحد
        border: Border.all(
          color: context.primaryColor.withOpacity(ThemeConstants.opacity20), // استخدام الثيم الموحد
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
            width: ThemeConstants.borderLight, // استخدام الثيم الموحد
            height: 40,
            color: context.primaryColor.withOpacity(ThemeConstants.opacity20), // استخدام الثيم الموحد
          ),
          _buildStatItem(
            icon: Icons.explore,
            label: 'الاتجاه',
            value: qiblaData.directionDescription,
          ),
          Container(
            width: ThemeConstants.borderLight, // استخدام الثيم الموحد
            height: 40,
            color: context.primaryColor.withOpacity(ThemeConstants.opacity20), // استخدام الثيم الموحد
          ),
          _buildStatItem(
            icon: Icons.gps_fixed,
            label: 'دقة GPS',
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
          size: ThemeConstants.iconMd, // استخدام الثيم الموحد
          color: context.primaryColor,
        ),
        const SizedBox(height: ThemeConstants.space1), // استخدام الثيم الموحد
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: ThemeConstants.space0), // استخدام الثيم الموحد
        Text(
          value,
          style: context.bodyMedium?.copyWith(
            fontWeight: ThemeConstants.bold, // استخدام الثيم الموحد
          ),
        ),
      ],
    );
  }
}

extension on BuildContext {
  get h5 => null;
}

// تم إزالة CompassBackgroundPainter و QiblaArrowPainter و EnhancedCompassPainter
// حيث لم تعد هناك حاجة لرسامين البوصلة بعد إزالة البوصلة المرئية.