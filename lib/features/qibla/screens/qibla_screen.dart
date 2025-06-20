// lib/features/qibla/screens/qibla_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../../app/themes/index.dart';
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
      curve: Curves.easeInOut,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.compass_calibration,
              color: ThemeConstants.primary,
              size: ThemeConstants.iconLg,
            ),
            Spaces.mediumH,
            const Text('تحسين دقة البوصلة'),
          ],
        ),
        content: const Text(
          'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
        ),
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
              backgroundColor: ThemeConstants.primary,
            ),
            child: const Text('بدء المعايرة'),
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
                          
                          Spaces.large.sliverBox,
                          
                          // البوصلة أو رسالة الخطأ
                          SliverToBoxAdapter(
                            child: AnimatedSwitcher(
                              duration: ThemeConstants.durationNormal,
                              child: _buildMainContent(service),
                            ),
                          ),
                          
                          Spaces.large.sliverBox,
                          
                          // معلومات إضافية
                          if (service.qiblaData != null) 
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: ThemeConstants.spaceLg,
                                ),
                                child: QiblaInfoCard(qiblaData: service.qiblaData!),
                              ),
                            ),
                          
                          Spaces.extraLarge.sliverBox,
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
    return IslamicAppBar(
      title: 'اتجاه القبلة',
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: _showQiblaInfo,
          tooltip: 'معلومات حول القبلة',
        ),
        if (!service.isLoading)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              HapticFeedback.lightImpact();
              _updateQiblaData();
            },
            tooltip: 'تحديث الموقع',
          ),
        if (service.isLoading)
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.spaceLg),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ThemeConstants.primary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return IslamicCard.gradient(
      gradient: LinearGradient(
        colors: [
          ThemeConstants.primary.withValues(alpha: 0.9),
          ThemeConstants.primary.darken(0.1).withValues(alpha: 0.9),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      margin: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
                
                Spaces.large.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اتجاه القبلة',
                        style: context.headingStyle.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.fontBold,
                        ),
                      ),
                      
                      Spaces.small,
                      
                      IslamicText.dua(
                        text: 'وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ',
                        textAlign: TextAlign.start,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: ThemeConstants.fontSizeMd,
                      ),
                      
                      Spaces.small,
                      
                      Text(
                        'استخدم البوصلة للتوجه نحو الكعبة المشرفة',
                        style: context.bodyStyle.copyWith(
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
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        children: [
          // عنوان البوصلة
          IslamicCard.simple(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.spaceMd),
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
                Spaces.mediumH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'البوصلة الذكية',
                        style: context.titleStyle.copyWith(
                          fontWeight: ThemeConstants.fontSemiBold,
                        ),
                      ),
                      Text(
                        'حرك هاتفك لتحديد اتجاه القبلة',
                        style: context.captionStyle,
                      ),
                    ],
                  ),
                ),
                if (!service.isCalibrated)
                  IslamicButton.outlined(
                    text: 'معايرة',
                    onPressed: () => service.startCalibration(),
                    icon: Icons.compass_calibration,
                    color: ThemeConstants.warning,
                  ),
              ],
            ),
          ),
          
          Spaces.large,
          
          // البوصلة
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceLg),
      height: 350,
      child: IslamicCard.simple(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IslamicLoading(message: 'جاري تحديد موقعك...'),
            Spaces.medium,
            Text(
              'يرجى الانتظار قليلاً',
              style: context.captionStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceLg),
      height: 350,
      child: EmptyState(
        icon: Icons.error_outline,
        title: 'فشل تحميل البيانات',
        subtitle: service.errorMessage ?? 'حدث خطأ غير متوقع',
        iconColor: ThemeConstants.error,
        action: IslamicButton.primary(
          text: 'المحاولة مرة أخرى',
          icon: Icons.refresh,
          onPressed: _updateQiblaData,
        ),
      ),
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceLg),
      child: IslamicCard.simple(
        color: ThemeConstants.warning.withValues(alpha: 0.1),
        child: Column(
          children: [
            Icon(
              Icons.compass_calibration_outlined,
              size: 80,
              color: ThemeConstants.warning,
            ),
            Spaces.large,
            Text(
              'البوصلة غير متوفرة',
              style: context.titleStyle.copyWith(
                fontWeight: ThemeConstants.fontBold,
              ),
            ),
            Spaces.medium,
            Text(
              'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
              textAlign: TextAlign.center,
              style: context.bodyStyle,
            ),
            if (service.qiblaData != null) ...[
              Spaces.large,
              IslamicCard.simple(
                child: Column(
                  children: [
                    Text(
                      'اتجاه القبلة من موقعك',
                      style: context.titleStyle.copyWith(
                        fontWeight: ThemeConstants.fontSemiBold,
                      ),
                    ),
                    Spaces.medium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.navigation,
                          size: ThemeConstants.iconXl,
                          color: ThemeConstants.primary,
                        ),
                        Spaces.medium.w,
                        Text(
                          '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                          style: context.headingStyle.copyWith(
                            fontWeight: ThemeConstants.fontBold,
                            color: ThemeConstants.primary,
                          ),
                        ),
                      ],
                    ),
                    Spaces.medium,
                    Text(
                      service.qiblaData!.directionDescription,
                      style: context.bodyStyle.copyWith(
                        fontWeight: ThemeConstants.fontMedium,
                      ),
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceLg),
      height: 350,
      child: EmptyState(
        icon: Icons.location_searching,
        title: 'حدد موقعك',
        subtitle: 'اضغط على زر التحديث لتحديد موقعك وعرض اتجاه القبلة',
        iconColor: ThemeConstants.primary.withValues(alpha: 0.5),
        action: IslamicButton.primary(
          text: 'تحديد الموقع',
          icon: Icons.my_location,
          onPressed: _updateQiblaData,
        ),
      ),
    );
  }

  void _showQiblaInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.mosque,
              color: ThemeConstants.primary,
              size: ThemeConstants.iconLg,
            ),
            Spaces.mediumH,
            const Text('عن اتجاه القبلة'),
          ],
        ),
        content: const Text(
          'القبلة هي الاتجاه الذي يتوجه إليه المسلمون في صلاتهم، وهي الكعبة المشرفة في مكة المكرمة. قال الله تعالى: "وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.primary,
            ),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}