// lib/features/qibla/screens/qibla_screen.dart - مع نمط Glassmorphism
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

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final QiblaService _qiblaService;
  
  // انيميشن التلميع للكارد الترحيبي
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupShimmerAnimation();
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

  void _setupShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
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
      
      AppInfoDialog.show(
        context: context,
        title: 'تحسين دقة البوصلة',
        content: 'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
        icon: Icons.compass_calibration,
        accentColor: context.warningColor,
        actions: [
          DialogAction(
            label: 'بدء المعايرة',
            onPressed: () {
              Navigator.of(context).pop();
              _qiblaService.startCalibration();
            },
            isPrimary: true,
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _qiblaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar(
        title: 'اتجاه القبلة',
        actions: [
          AppBarAction(
            icon: Icons.help_outline,
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
    final qiblaColor = CategoryHelper.getCategoryColor(context, 'qibla');
    
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
              padding: const EdgeInsets.all(ThemeConstants.space5),
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
                        style: context.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
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
                      
                      const SizedBox(height: ThemeConstants.space2),
                      
                      Text(
                        'توجه نحو الكعبة المشرفة واستقبل القبلة',
                        style: context.bodyMedium?.copyWith(
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
            
            // تأثير التلميع المتحرك
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                        stops: [
                          (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnimation.value.clamp(0.0, 1.0),
                          (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ),
                    ),
                  );
                },
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
    return Container(
      width: 320,
      height: 320,
      child: QiblaCompass(
        qiblaDirection: service.qiblaData!.qiblaDirection,
        currentDirection: service.currentDirection,
        accuracy: service.compassAccuracy,
        isCalibrated: service.isCalibrated,
        onCalibrate: () => service.startCalibration(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return _buildSectionCard(
      context: context,
      title: 'جاري تحديد موقعك...',
      subtitle: 'يرجى الانتظار قليلاً',
      primaryColor: CategoryHelper.getCategoryColor(context, 'qibla'),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return _buildSectionCard(
      context: context,
      title: 'خطأ في التحميل',
      subtitle: service.errorMessage ?? 'فشل تحميل البيانات',
      primaryColor: context.errorColor,
      onTap: _updateQiblaData,
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // بطاقة تحذير
        _buildSectionCard(
          context: context,
          title: 'البوصلة غير متوفرة',
          subtitle: 'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
          primaryColor: context.warningColor,
        ),
        
        if (service.qiblaData != null) ...[
          const SizedBox(height: ThemeConstants.space4),
          _buildStaticQiblaInfo(service),
        ],
      ],
    );
  }

  Widget _buildStaticQiblaInfo(QiblaService service) {
    return _buildSectionCard(
      context: context,
      title: 'اتجاه القبلة من موقعك',
      subtitle: '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
      primaryColor: CategoryHelper.getCategoryColor(context, 'qibla'),
    );
  }

  Widget _buildInitialState() {
    return _buildSectionCard(
      context: context,
      title: 'حدد موقعك',
      subtitle: 'اضغط هنا لتحديد موقعك وعرض اتجاه القبلة',
      primaryColor: CategoryHelper.getCategoryColor(context, 'qibla'),
      onTap: _updateQiblaData,
    );
  }

  // دالة موحدة لإنشاء كاردات الأقسام
  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color primaryColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor,
                      primaryColor.darken(0.2),
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
                padding: const EdgeInsets.all(ThemeConstants.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // النصوص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
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
                        
                        const SizedBox(height: ThemeConstants.space2),
                        
                        Text(
                          subtitle,
                          style: context.bodyMedium?.copyWith(
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
              
              // طبقة التفاعل
              if (onTap != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                    splashColor: Colors.white.withValues(alpha: 0.2),
                    highlightColor: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              
              // العناصر الزخرفية
              _buildDecorativeElements(),
            ],
          ),
        ),
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
              color: CategoryHelper.getCategoryColor(context, 'qibla'),
              size: 24,
            ),
            const SizedBox(width: 8),
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
            const SizedBox(height: 16),
            _buildInstructionItem(
              icon: Icons.compass_calibration,
              title: '2. معايرة البوصلة',
              description: 'حرك هاتفك على شكل الرقم 8 لمعايرة البوصلة',
            ),
            const SizedBox(height: 16),
            _buildInstructionItem(
              icon: Icons.phone_android,
              title: '3. وضع الهاتف',
              description: 'امسك الهاتف بشكل مسطح أمامك',
            ),
            const SizedBox(height: 16),
            _buildInstructionItem(
              icon: Icons.navigation,
              title: '4. اتباع الاتجاه',
              description: 'اتبع السهم الأخضر للتوجه نحو القبلة',
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'فهمت',
              style: TextStyle(
                color: CategoryHelper.getCategoryColor(context, 'qibla'),
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
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
            color: CategoryHelper.getCategoryColor(context, 'qibla').withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            icon,
            color: CategoryHelper.getCategoryColor(context, 'qibla'),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleSmall?.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                  color: context.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: context.bodySmall?.copyWith(
                  color: context.textSecondaryColor,
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