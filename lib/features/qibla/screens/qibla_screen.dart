// lib/features/qibla/screens/qibla_screen.dart (محول للنظام الموحد)
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
      backgroundColor: context.backgroundColor, // ✅ من النظام الموحد
      // ✅ CustomAppBar من النظام الموحد
      appBar: CustomAppBar(
        title: 'اتجاه القبلة',
        backgroundColor: context.backgroundColor,
        foregroundColor: context.textPrimaryColor,
        actions: [
          // أيقونة المساعدة بيضاء
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
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
                  child: _buildWelcomeCard(),
                ),
                
                ThemeConstants.space4.sliverBox,
                
                // المحتوى الرئيسي
                SliverToBoxAdapter(
                  child: Center(
                    child: _buildMainContent(service),
                  ),
                ),
                
                ThemeConstants.space8.sliverBox,
              ],
            );
          },
        ),
      ),
    );
  }

  // ✅ بطاقة ترحيب باستخدام AppCard
  Widget _buildWelcomeCard() {
    return AppCard(
      type: CardType.quote,
      style: CardStyle.gradient,
      primaryColor: context.getCategoryColor('qibla'),
      content: '"وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
      source: 'توجه نحو الكعبة المشرفة واستقبل القبلة',
      subtitle: 'سورة البقرة',
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
          icon: Icons.location_on,
          iconColor: context.successColor,
        ),
        
        ThemeConstants.space4.h,
        
        // البوصلة
        Container(
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
        
        ThemeConstants.space4.h,
        
        // ✅ معلومات الاتجاه باستخدام AppCard
        _buildDirectionInfoCard(service),
      ],
    );
  }

  Widget _buildDirectionInfoCard(QiblaService service) {
    final direction = service.qiblaData!.qiblaDirection;
    return AppCard.stat(
      title: 'اتجاه القبلة من موقعك',
      value: '${direction.toStringAsFixed(1)}°',
      icon: Icons.explore,
      color: context.getCategoryColor('qibla'),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        // ✅ حالة التحميل باستخدام AppLoading
        AppLoading.page(
          message: 'جاري تحديد موقعك وحساب اتجاه القبلة...',
          type: LoadingType.circular,
        ),
        
        ThemeConstants.space4.h,
        
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
        
        ThemeConstants.space4.h,
        
        // ✅ تحذير الخطأ
        AppNoticeCard.error(
          title: 'خطأ في التحميل',
          message: 'تحقق من اتصال الإنترنت وإعدادات الموقع',
          action: AppButton.outline(
            text: 'إعادة المحاولة',
            onPressed: _updateQiblaData,
            color: context.errorColor,
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
          ThemeConstants.space4.h,
          _buildDirectionInfoCard(service),
          ThemeConstants.space4.h,
          // ✅ معلومات إضافية
          AppCard.info(
            title: 'استخدم البوصلة الخارجية',
            subtitle: 'يمكنك استخدام بوصلة خارجية مع الاتجاه المعروض أعلاه',
            icon: Icons.compass_calibration,
            iconColor: context.infoColor,
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
          iconColor: context.getCategoryColor('qibla'),
        ),
        
        ThemeConstants.space4.h,
        
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
      accentColor: context.getCategoryColor('qibla'),
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInstructionItem(
            icon: Icons.my_location,
            title: '1. تفعيل الموقع',
            description: 'تأكد من تفعيل خدمة الموقع على هاتفك',
          ),
          ThemeConstants.space4.h,
          _buildInstructionItem(
            icon: Icons.compass_calibration,
            title: '2. معايرة البوصلة',
            description: 'حرك هاتفك على شكل الرقم 8 لمعايرة البوصلة',
          ),
          ThemeConstants.space4.h,
          _buildInstructionItem(
            icon: Icons.phone_android,
            title: '3. وضع الهاتف',
            description: 'امسك الهاتف بشكل مسطح أمامك',
          ),
          ThemeConstants.space4.h,
          _buildInstructionItem(
            icon: Icons.navigation,
            title: '4. اتباع الاتجاه',
            description: 'اتبع السهم الأخضر للتوجه نحو القبلة',
          ),
        ],
      ),
      closeButtonText: 'فهمت',
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
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: ThemeConstants.iconSm,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleSmall?.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                  color: Colors.white,
                ),
              ),
              
              ThemeConstants.space1.h,
              
              Text(
                description,
                style: context.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
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