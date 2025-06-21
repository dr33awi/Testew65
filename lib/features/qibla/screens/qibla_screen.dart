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
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final QiblaService _qiblaService;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupAnimations();
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

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
    );

    _fadeController.forward();
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
      
      AppInfoDialog.show(
        context: context,
        title: 'تحسين دقة البوصلة',
        content: 'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
        icon: Icons.compass_calibration,
        accentColor: ThemeConstants.primary,
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
    });
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
                    
                    SliverToBoxAdapter(
                      child: SizedBox(height: ThemeConstants.space4),
                    ),
                    
                    // المحتوى الرئيسي
                    SliverToBoxAdapter(
                      child: AnimatedSwitcher(
                        duration: ThemeConstants.durationNormal,
                        child: _buildMainContent(service),
                      ),
                    ),
                    
                    // معلومات إضافية
                    if (service.qiblaData != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(ThemeConstants.space4),
                          child: QiblaInfoCard(qiblaData: service.qiblaData!),
                        ),
                      ),
                    
                    SliverToBoxAdapter(
                      child: SizedBox(height: ThemeConstants.space8),
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

  Widget _buildAppBar(BuildContext context, QiblaService service) {
    return CustomAppBar(
      title: 'اتجاه القبلة',
      actions: [
        AppBarAction(
          icon: Icons.info_outline,
          onPressed: _showQiblaInfo,
          tooltip: 'معلومات حول القبلة',
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
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.9),
            ThemeConstants.primary.darken(0.1).withValues(alpha: 0.9),
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
          
          SizedBox(width: ThemeConstants.space4),
          
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
                
                SizedBox(height: ThemeConstants.space1),
                
                Text(
                  'وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: ThemeConstants.fontFamilyArabic,
                  ),
                ),
                
                SizedBox(height: ThemeConstants.space1),
                
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
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          // عنوان البوصلة
          _buildCompassHeader(service),
          
          SizedBox(height: ThemeConstants.space4),
          
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: ThemeConstants.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            Icons.compass_calibration,
            color: ThemeConstants.primary,
            size: ThemeConstants.iconMd,
          ),
        ),
        
        SizedBox(width: ThemeConstants.space3),
        
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
          AppButton.outline(
            text: 'معايرة',
            onPressed: () => service.startCalibration(),
            size: ButtonSize.small,
            icon: Icons.compass_calibration,
            color: ThemeConstants.warning,
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      child: AppCard(
        backgroundColor: context.cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
            SizedBox(height: ThemeConstants.space4),
            Text(
              'جاري تحديد موقعك...',
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: ThemeConstants.space2),
            Text(
              'يرجى الانتظار قليلاً',
              style: context.bodySmall?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      child: AppEmptyState.error(
        message: service.errorMessage ?? 'فشل تحميل البيانات',
        onRetry: _updateQiblaData,
      ),
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard(
        backgroundColor: ThemeConstants.warning.withValues(alpha: 0.1),
        child: Column(
          children: [
            Icon(
              Icons.compass_calibration_outlined,
              size: 60,
              color: ThemeConstants.warning,
            ),
            SizedBox(height: ThemeConstants.space3),
            Text(
              'البوصلة غير متوفرة',
              style: context.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ThemeConstants.space2),
            Text(
              'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
              textAlign: TextAlign.center,
              style: context.bodyMedium,
            ),
            if (service.qiblaData != null) ...[
              SizedBox(height: ThemeConstants.space4),
              _buildStaticQiblaInfo(service),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStaticQiblaInfo(QiblaService service) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: Column(
        children: [
          Text(
            'اتجاه القبلة من موقعك',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ThemeConstants.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigation,
                size: ThemeConstants.iconXl,
                color: ThemeConstants.primary,
              ),
              SizedBox(width: ThemeConstants.space2),
              Text(
                '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                style: context.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeConstants.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space2),
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      child: AppEmptyState.custom(
        title: 'حدد موقعك',
        message: 'اضغط على زر التحديث لتحديد موقعك وعرض اتجاه القبلة',
        icon: Icons.location_searching,
        iconColor: ThemeConstants.primary.withValues(alpha: 0.5),
        onAction: _updateQiblaData,
        actionText: 'تحديد الموقع',
      ),
    );
  }

  void _showQiblaInfo() {
    AppInfoDialog.show(
      context: context,
      title: 'عن اتجاه القبلة',
      content: 'القبلة هي الاتجاه الذي يتوجه إليه المسلمون في صلاتهم، وهي الكعبة المشرفة في مكة المكرمة. قال الله تعالى: "وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
      icon: Icons.mosque,
      accentColor: ThemeConstants.primary,
    );
  }
}