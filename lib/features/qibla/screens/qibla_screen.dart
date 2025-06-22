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
                    child: SizedBox(height: 16),
                  ),
                  
                  // المحتوى الرئيسي
                  SliverToBoxAdapter(
                    child: _buildMainContent(service),
                  ),
                  
                  // معلومات إضافية
                  if (service.qiblaData != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: QiblaInfoCard(qiblaData: service.qiblaData!),
                      ),
                    ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.mosque,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اتجاه القبلة',
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: _showQiblaInfo,
                  icon: Icon(
                    Icons.info_outline,
                    color: context.textSecondaryColor,
                  ),
                  tooltip: 'معلومات حول القبلة',
                ),
              ),
              
              const SizedBox(width: 8),
              
              if (!service.isLoading)
                Container(
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _updateQiblaData();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: context.textSecondaryColor,
                    ),
                    tooltip: 'تحديث الموقع',
                  ),
                ),
              
              if (service.isLoading)
                Padding(
                  padding: const EdgeInsets.all(12),
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF4F46E5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mosque,
              color: Colors.white,
              size: 35,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اتجاه القبلة',
                  style: context.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: 'Amiri',
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'استخدم البوصلة للتوجه نحو الكعبة المشرفة',
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // عنوان البوصلة
          _buildCompassHeader(service),
          
          const SizedBox(height: 16),
          
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.compass_calibration,
              color: Color(0xFF6366F1),
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'البوصلة الذكية',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
              onPressed: () => service.startCalibration(),
              icon: const Icon(Icons.compass_calibration),
              label: const Text('معايرة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحديد موقعك...',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'خطأ في التحميل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.errorMessage ?? 'فشل تحميل البيانات',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _updateQiblaData,
            icon: const Icon(Icons.refresh),
            label: const Text('المحاولة مرة أخرى'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.compass_calibration_outlined,
            size: 60,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
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
            const SizedBox(height: 16),
            _buildStaticQiblaInfo(service),
          ],
        ],
      ),
    );
  }

  Widget _buildStaticQiblaInfo(QiblaService service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'اتجاه القبلة من موقعك',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.navigation,
                size: 40,
                color: Color(0xFF6366F1),
              ),
              const SizedBox(width: 8),
              Text(
                '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                style: context.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6366F1),
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
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_searching,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'حدد موقعك',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط على زر التحديث لتحديد موقعك وعرض اتجاه القبلة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _updateQiblaData,
            icon: const Icon(Icons.my_location),
            label: const Text('تحديد الموقع'),
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
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }
}