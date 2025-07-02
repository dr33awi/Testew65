// lib/features/qibla/screens/qibla_screen.dart - محدثة للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد
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
  
  // انيميشن للبطاقة الترحيبية
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
      duration: ThemeConstants.durationVerySlow,
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: ThemeConstants.curveSmooth,
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
    Future.delayed(ThemeConstants.durationVerySlow, () {
      if (!mounted) return;
      
      // ✅ استخدام AppInfoDialog من النظام الموحد
      AppInfoDialog.show(
        context: context,
        title: 'تحسين دقة البوصلة',
        content: 'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
        icon: Icons.compass_calibration,
        accentColor: AppColorSystem.warning,
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
      backgroundColor: AppColorSystem.getBackground(context), // ✅ من النظام الموحد
      // ✅ CustomAppBar من النظام الموحد
      appBar: CustomAppBar(
        title: 'اتجاه القبلة',
        backgroundColor: AppColorSystem.getBackground(context),
        foregroundColor: AppColorSystem.getTextPrimary(context),
        actions: [
          // أيقونة المساعدة
          IconButton(
            icon: Icon(
              AppIconsSystem.info,
              color: AppColorSystem.getTextPrimary(context),
            ),
            onPressed: _showInstructions,
            tooltip: 'التعليمات',
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _qiblaService,
        child: Consumer<QiblaService>(
          builder: (context, service, _) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // بطاقة الترحيب
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(ThemeConstants.space4),
                    child: _buildWelcomeCard(),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: SizedBox(height: ThemeConstants.space4),
                ),
                
                // المحتوى الرئيسي
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                    child: _buildMainContent(service),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: SizedBox(height: ThemeConstants.space8),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ✅ بطاقة ترحيب باستخدام AppCard
  Widget _buildWelcomeCard() {
    return AppCard.quote(
      quote: '"وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
      author: 'سورة البقرة',
      category: 'توجه نحو الكعبة المشرفة واستقبل القبلة',
      primaryColor: AppColorSystem.getCategoryColor('qibla'),
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
    return Column(
      children: [
        // ✅ معلومات الموقع باستخدام AppCard
        AppCard.info(
          title: 'الموقع محدد بنجاح',
          subtitle: 'استخدم البوصلة أدناه لتحديد اتجاه القبلة',
          icon: AppIconsSystem.success,
          iconColor: AppColorSystem.success,
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // البوصلة
        SizedBox(
          width: 320,
          height: 320,
          child: QiblaCompass(
            qiblaDirection: service.qiblaData!.qiblaDirection,
            currentDirection: service.currentDirection,
            accuracy: service.compassAccuracy,
            isCalibrated: service.isCalibrated,
            onCalibrate: () => service.startCalibration(),
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // ✅ معلومات الاتجاه باستخدام AppCard
        _buildDirectionInfoCard(service),
      ],
    );
  }

  Widget _buildDirectionInfoCard(QiblaService service) {
    final direction = service.qiblaData!.qiblaDirection;
    return AppCard.info(
      title: 'اتجاه القبلة من موقعك',
      subtitle: '${direction.toStringAsFixed(1)}° من الشمال',
      icon: AppIconsSystem.qibla,
      iconColor: AppColorSystem.getCategoryColor('qibla'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: AppColorSystem.getCategoryColor('qibla').withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        child: Text(
          '${direction.toStringAsFixed(1)}°',
          style: AppTextStyles.label1.copyWith(
            color: AppColorSystem.getCategoryColor('qibla'),
            fontWeight: ThemeConstants.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        // ✅ حالة التحميل باستخدام AppLoading
        AppLoading.withMessage(
          message: 'جاري تحديد موقعك وحساب اتجاه القبلة...',
          size: LoadingSize.large,
          color: AppColorSystem.getCategoryColor('qibla'),
          showBackground: true,
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // ✅ نصيحة أثناء التحميل
        AppNoticeCard.info(
          title: 'نصيحة',
          message: 'تأكد من تفعيل خدمة الموقع للحصول على أفضل النتائج',
        ),
      ],
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return Column(
      children: [
        // ✅ حالة الخطأ باستخدام AppEmptyState
        AppEmptyState.error(
          message: service.errorMessage ?? 'فشل تحميل البيانات',
          onRetry: _updateQiblaData,
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // ✅ تحذير الخطأ
        AppNoticeCard.error(
          title: 'خطأ في التحميل',
          message: 'تحقق من اتصال الإنترنت وإعدادات الموقع',
          action: AppButton.outline(
            text: 'إعادة المحاولة',
            onPressed: _updateQiblaData,
            color: AppColorSystem.error,
          ),
        ),
      ],
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Column(
      children: [
        // ✅ تحذير عدم وجود بوصلة
        AppNoticeCard.warning(
          title: 'البوصلة غير متوفرة',
          message: 'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
        ),
        
        if (service.qiblaData != null) ...[
          const SizedBox(height: ThemeConstants.space4),
          _buildDirectionInfoCard(service),
          const SizedBox(height: ThemeConstants.space4),
          // ✅ معلومات إضافية
          AppCard.info(
            title: 'استخدم البوصلة الخارجية',
            subtitle: 'يمكنك استخدام بوصلة خارجية مع الاتجاه المعروض أعلاه',
            icon: Icons.compass_calibration,
            iconColor: AppColorSystem.info,
          ),
        ],
      ],
    );
  }

  Widget _buildInitialState() {
    return Column(
      children: [
        // ✅ حالة البداية
        AppEmptyState.custom(
          title: 'حدد موقعك',
          message: 'اضغط هنا لتحديد موقعك وعرض اتجاه القبلة',
          icon: Icons.my_location,
          actionText: 'تحديد الموقع',
          onAction: _updateQiblaData,
          iconColor: AppColorSystem.getCategoryColor('qibla'),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // ✅ نصائح للبداية
        AppNoticeCard.info(
          title: 'متطلبات التشغيل',
          message: 'يحتاج التطبيق إلى تفعيل خدمة الموقع والبوصلة للعمل بشكل صحيح',
        ),
      ],
    );
  }

  // ✅ التعليمات باستخدام AppInfoDialog
  void _showInstructions() {
    AppInfoDialog.show(
      context: context,
      title: 'تعليمات استخدام البوصلة',
      icon: Icons.help_outline,
      accentColor: AppColorSystem.getCategoryColor('qibla'),
      content: _buildInstructionsContent(),
      closeButtonText: 'فهمت',
    );
  }

  String _buildInstructionsContent() {
    return '''
1. تفعيل الموقع
تأكد من تفعيل خدمة الموقع على هاتفك

2. معايرة البوصلة  
حرك هاتفك على شكل الرقم 8 لمعايرة البوصلة

3. وضع الهاتف
امسك الهاتف بشكل مسطح أمامك

4. اتباع الاتجاه
اتبع السهم الأخضر للتوجه نحو القبلة
''';
  }
}