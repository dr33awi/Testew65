// lib/features/qibla/screens/qibla_screen.dart (مُصلح)
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
    
    // عرض نصيحة المعايرة إذا لزم الأمر
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
          title: const Text('تحسين دقة البوصلة'),
          content: const Text('لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('لاحقاً'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _qiblaService.startCalibration();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('بدء المعايرة'),
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
      backgroundColor: context.backgroundColor,
      body: ChangeNotifierProvider.value(
        value: _qiblaService,
        child: Consumer<QiblaService>(
          builder: (context, service, _) {
            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // شريط التنقل
                  SliverToBoxAdapter(
                    child: _buildAppBar(context, service),
                  ),
                  
                  // رسالة الترحيب
                  SliverToBoxAdapter(
                    child: _buildWelcomeCard(context),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: ThemeConstants.space4),
                  ),
                  
                  // المحتوى الرئيسي
                  SliverToBoxAdapter(
                    child: _buildMainContent(service),
                  ),
                  
                  // معلومات إضافية
                  if (service.qiblaData != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(ThemeConstants.space4),
                        child: QiblaInfoCard(qiblaData: service.qiblaData!),
                      ),
                    ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: ThemeConstants.space8),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, QiblaService service) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // أيقونة التطبيق - استخدام ألوان الثيم الموحدة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              gradient: context.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: ThemeConstants.shadowSm,
            ),
            child: Icon(
              ThemeConstants.iconQibla,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // العنوان
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
                  'توجه نحو الكعبة المشرفة',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // الإجراءات
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showQiblaInfo();
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: context.primaryColor,
                  ),
                  tooltip: 'معلومات حول القبلة',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              if (!service.isLoading)
                Container(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    border: Border.all(
                      color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                    ),
                    boxShadow: ThemeConstants.shadowSm,
                  ),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _updateQiblaData();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: context.primaryColor,
                    ),
                    tooltip: 'تحديث الموقع',
                  ),
                ),
              
              if (service.isLoading)
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: context.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                width: ThemeConstants.borderThin,
              ),
            ),
            child: Icon(
              ThemeConstants.iconQibla,
              color: Colors.white,
              size: 35,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space4),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اتجاه القبلة',
                  style: context.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
                
                const SizedBox(height: ThemeConstants.space2),
                
                Text(
                  'وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                    fontFamily: ThemeConstants.fontFamilyQuran,
                    height: 1.8,
                  ),
                ),
                
                const SizedBox(height: ThemeConstants.space2),
                
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                      width: ThemeConstants.borderThin,
                    ),
                  ),
                  child: Text(
                    'استخدم البوصلة للتوجه نحو الكعبة المشرفة',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          // عنوان البوصلة
          _buildCompassHeader(service),
          
          const SizedBox(height: ThemeConstants.space4),
          
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
      ),
    );
  }

  Widget _buildCompassHeader(QiblaService service) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: ThemeConstants.opacity20),
          width: ThemeConstants.borderThin,
        ),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: ThemeConstants.opacity20),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              Icons.compass_calibration,
              color: context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'البوصلة الذكية',
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  'حرك هاتفك لتحديد اتجاه القبلة',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          if (!service.isCalibrated)
            OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                service.startCalibration();
              },
              icon: const Icon(Icons.compass_calibration),
              label: const Text('معايرة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.warningColor,
                side: BorderSide(
                  color: context.warningColor,
                  width: ThemeConstants.borderMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              gradient: context.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: ThemeConstants.space4),
          Text(
            'جاري تحديد موقعك...',
            style: context.titleMedium?.copyWith(
              fontWeight: ThemeConstants.semiBold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            'يرجى الانتظار قليلاً',
            style: context.bodySmall?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: context.errorColor.withValues(alpha: ThemeConstants.opacity10),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.errorColor.withValues(alpha: ThemeConstants.opacity30),
                width: ThemeConstants.borderThin,
              ),
            ),
            child: Icon(
              Icons.error_outline,
              size: ThemeConstants.icon3xl,
              color: context.errorColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space4),
          Text(
            'خطأ في التحميل',
            style: context.titleLarge?.copyWith(
              fontWeight: ThemeConstants.bold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            service.errorMessage ?? 'فشل تحميل البيانات',
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space4),
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              _updateQiblaData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('المحاولة مرة أخرى'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        color: context.warningColor.withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: context.warningColor.withValues(alpha: ThemeConstants.opacity30),
          width: ThemeConstants.borderThin,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.compass_calibration_outlined,
            size: ThemeConstants.icon3xl,
            color: context.warningColor,
          ),
          const SizedBox(height: ThemeConstants.space3),
          Text(
            'البوصلة غير متوفرة',
            style: context.titleLarge?.copyWith(
              fontWeight: ThemeConstants.bold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          if (service.qiblaData != null) ...[
            const SizedBox(height: ThemeConstants.space4),
            _buildStaticQiblaInfo(service),
          ],
        ],
      ),
    );
  }

  Widget _buildStaticQiblaInfo(QiblaService service) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        children: [
          Text(
            'اتجاه القبلة من موقعك',
            style: context.titleMedium?.copyWith(
              fontWeight: ThemeConstants.semiBold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigation,
                size: ThemeConstants.icon2xl,
                color: context.primaryColor,
              ),
              const SizedBox(width: ThemeConstants.space2),
              Text(
                '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                style: context.headlineMedium?.copyWith(
                  fontWeight: ThemeConstants.bold,
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            service.qiblaData!.directionDescription,
            style: context.bodyLarge?.copyWith(
              fontWeight: ThemeConstants.medium,
              color: context.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              gradient: context.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_searching,
              size: ThemeConstants.icon3xl,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: ThemeConstants.space4),
          Text(
            'حدد موقعك',
            style: context.titleLarge?.copyWith(
              fontWeight: ThemeConstants.bold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            'اضغط على زر التحديث لتحديد موقعك وعرض اتجاه القبلة',
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space4),
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              _updateQiblaData();
            },
            icon: const Icon(Icons.my_location),
            label: const Text('تحديد الموقع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQiblaInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عن اتجاه القبلة'),
        content: const Text(
          'القبلة هي الاتجاه الذي يتوجه إليه المسلمون في صلاتهم، وهي الكعبة المشرفة في مكة المكرمة. قال الله تعالى: "وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'فهمت',
              style: TextStyle(color: context.primaryColor),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
      ),
    );
  }
}