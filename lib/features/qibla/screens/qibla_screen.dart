// lib/features/qibla/screens/qibla_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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

    _qiblaService = QiblaService(
      logger: getIt<LoggerService>(),
      storage: getIt<StorageService>(),
      permissionService: getIt<PermissionService>(),
    );

    _fadeController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
    );

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateQiblaData();
      _fadeController.forward();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateQiblaData();
    }
  }

  Future<void> _updateQiblaData() async {
    await _qiblaService.updateQiblaData();

    if (!_qiblaService.isCalibrated &&
        _qiblaService.hasCompass &&
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
                    // شريط التنقل العلوي
                    _buildAppBar(context, service),
                    
                    // المحتوى
                    Expanded(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // رسالة الترحيب
                          SliverToBoxAdapter(
                            child: _buildWelcomeCard(context),
                          ),
                          
                          ThemeConstants.space4.sliverBox,
                          
                          // البوصلة أو رسالة الخطأ
                          SliverToBoxAdapter(
                            child: AnimatedSwitcher(
                              duration: ThemeConstants.durationNormal,
                              child: _buildMainContent(service),
                            ),
                          ),
                          
                          ThemeConstants.space4.sliverBox,
                          
                          // معلومات إضافية
                          if (service.qiblaData != null) 
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: ThemeConstants.space4,
                                ),
                                child: QiblaInfoCard(qiblaData: service.qiblaData!),
                              ),
                            ),
                          
                          ThemeConstants.space8.sliverBox,
                        ],
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
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: AppLoading.circular(size: LoadingSize.small),
          ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mosque,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                ThemeConstants.space4.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اتجاه القبلة',
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      
                      ThemeConstants.space1.h,
                      
                      Text(
                        'وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                        style: context.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: ThemeConstants.fontFamilyArabic,
                        ),
                      ),
                      
                      ThemeConstants.space1.h,
                      
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
          ),
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
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          // عنوان البوصلة
          Row(
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
              ThemeConstants.space3.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'البوصلة الذكية',
                      style: context.titleMedium?.semiBold,
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
          ),
          
          ThemeConstants.space4.h,
          
          // البوصلة مدموجة
          SizedBox(
            height: 350,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 350,
      child: AppCard(
        backgroundColor: context.cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoading.circular(size: LoadingSize.large),
            ThemeConstants.space4.h,
            Text(
              'جاري تحديد موقعك...',
              style: context.titleMedium?.medium,
            ),
            ThemeConstants.space2.h,
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
      height: 350,
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
              size: 80,
              color: ThemeConstants.warning,
            ),
            ThemeConstants.space4.h,
            Text(
              'البوصلة غير متوفرة',
              style: context.titleLarge?.bold,
            ),
            ThemeConstants.space2.h,
            Text(
              'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
              textAlign: TextAlign.center,
              style: context.bodyMedium,
            ),
            if (service.qiblaData != null) ...[
              ThemeConstants.space4.h,
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                ),
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
                          color: ThemeConstants.primary,
                        ),
                        ThemeConstants.space2.w,
                        Text(
                          '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                          style: context.headlineMedium?.copyWith(
                            fontWeight: ThemeConstants.bold,
                            color: ThemeConstants.primary,
                          ),
                        ),
                      ],
                    ),
                    ThemeConstants.space2.h,
                    Text(
                      service.qiblaData!.directionDescription,
                      style: context.bodyLarge?.medium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 350,
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