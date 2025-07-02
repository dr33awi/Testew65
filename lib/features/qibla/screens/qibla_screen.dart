// lib/features/qibla/screens/qibla_screen.dart - محسن بالمكونات الجديدة
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/qibla_service.dart';
import '../widgets/qibla_compass.dart';
import '../widgets/qibla_widgets.dart'; // ✅ المكونات الجديدة

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final QiblaService _qiblaService;
  
  // ✅ استخدام ThemeConstants للأنيميشن
  late AnimationController _pageController;
  late Animation<double> _fadeAnimation;

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

  // ✅ استخدام ThemeConstants للأنيميشن
  void _setupAnimations() {
    _pageController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: ThemeConstants.curveSmooth,
    ));

    _pageController.forward();
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
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _qiblaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorSystem.getBackground(context),
      appBar: CustomAppBar(
        title: 'اتجاه القبلة',
        backgroundColor: AppColorSystem.getBackground(context),
        foregroundColor: AppColorSystem.getTextPrimary(context),
        actions: [
          // زر المعلومات
          AppBarAction(
            icon: AppIconsSystem.info,
            onPressed: _showInstructions,
            tooltip: 'التعليمات',
          ),
          
          // زر الإعدادات
          AppBarAction(
            icon: AppIconsSystem.settings,
            onPressed: _showSettings,
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _qiblaService,
        child: Consumer<QiblaService>(
          builder: (context, service, _) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // الرأس الترحيبي
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(ThemeConstants.space4),
                      child: _buildWelcomeSection(),
                    ),
                  ),
                  
                  // المحتوى الرئيسي
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                      child: _buildMainContent(service),
                    ),
                  ),
                  
                  // معلومات إضافية
                  if (service.qiblaData != null && !service.isLoading)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(ThemeConstants.space4),
                        child: _buildAdditionalInfo(service),
                      ),
                    ),
                  
                  // المساحة السفلية
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

  // ✅ قسم الترحيب محسن
  Widget _buildWelcomeSection() {
    return Column(
      children: [
        // الاقتباس الرئيسي
        AppCard.quote(
          quote: '"وَحَيْثُ مَا كُنتُمْ فَوَلُّوا وُجُوهَكُمْ شَطْرَهُ"',
          author: 'سورة البقرة - آية 144',
          category: 'توجه نحو الكعبة المشرفة واستقبل القبلة',
          primaryColor: AppColorSystem.getCategoryColor('qibla'),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // بطاقة معلومات مكة
        QiblaWidgets.buildMeccaInfoCard(),
      ],
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

  // ✅ عرض البوصلة محسن بالمكونات الجديدة
  Widget _buildCompassView(QiblaService service) {
    return Column(
      children: [
        // بطاقة حالة القبلة
        QiblaWidgets.buildQiblaStatusCard(service),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // البوصلة
        Container(
          margin: const EdgeInsets.symmetric(vertical: ThemeConstants.space4),
          child: SizedBox(
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
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // بطاقة معلومات القبلة التفصيلية
        QiblaWidgets.buildQiblaInfoCard(
          service.qiblaData!,
          service.currentDirection,
          context,
        ),
      ],
    );
  }

  // ✅ معلومات إضافية
  Widget _buildAdditionalInfo(QiblaService service) {
    return Column(
      children: [
        // بطاقة حالة البوصلة
        QiblaWidgets.buildCompassStatusCard(service),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // بطاقة معلومات الموقع
        QiblaWidgets.buildLocationCard(service.qiblaData!, context),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // نصائح الاستخدام
        QiblaWidgets.buildUsageTipsCard(context),
      ],
    );
  }

  // ✅ حالة التحميل محسنة
  Widget _buildLoadingState() {
    return Column(
      children: [
        AppLoading.withMessage(
          message: 'جاري تحديد موقعك وحساب اتجاه القبلة...',
          size: LoadingSize.large,
          color: AppColorSystem.getCategoryColor('qibla'),
          showBackground: true,
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        AppNoticeCard.info(
          title: 'نصيحة أثناء التحميل',
          message: 'تأكد من تفعيل خدمة الموقع والبوصلة للحصول على أفضل النتائج',
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // بطاقة التعليمات أثناء التحميل
        AppCard.info(
          title: 'ماذا يحدث الآن؟',
          subtitle: 'نحن نحدد موقعك ونحسب اتجاه القبلة بدقة عالية',
          icon: Icons.location_searching,
          iconColor: AppColorSystem.info,
        ),
      ],
    );
  }

  // ✅ حالة الخطأ محسنة
  Widget _buildErrorState(QiblaService service) {
    return Column(
      children: [
        AppEmptyState.error(
          message: service.errorMessage ?? 'فشل تحميل البيانات',
          onRetry: _updateQiblaData,
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        AppNoticeCard.error(
          title: 'خطأ في التحميل',
          message: 'تحقق من اتصال الإنترنت وإعدادات الموقع',
          action: AppButton.outline(
            text: 'إعادة المحاولة',
            onPressed: _updateQiblaData,
            color: AppColorSystem.error,
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // نصائح حل المشاكل
        AppCard.info(
          title: 'نصائح لحل المشكلة',
          subtitle: 'اتبع هذه الخطوات لحل المشكلة',
          icon: AppIconsSystem.info,
          iconColor: AppColorSystem.warning,
        ),
      ],
    );
  }

  // ✅ حالة عدم وجود بوصلة
  Widget _buildNoCompassState(QiblaService service) {
    return Column(
      children: [
        AppNoticeCard.warning(
          title: 'البوصلة غير متوفرة',
          message: 'جهازك لا يدعم البوصلة أو أنها معطلة حالياً',
        ),
        
        if (service.qiblaData != null) ...[
          const SizedBox(height: ThemeConstants.space4),
          
          // معلومات الاتجاه فقط
          QiblaWidgets.buildQiblaInfoCard(
            service.qiblaData!,
            0, // لا يوجد اتجاه حالي
            context,
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
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

  // ✅ حالة البداية
  Widget _buildInitialState() {
    return Column(
      children: [
        AppEmptyState.custom(
          title: 'حدد موقعك',
          message: 'اضغط هنا لتحديد موقعك وعرض اتجاه القبلة',
          icon: Icons.my_location,
          actionText: 'تحديد الموقع',
          onAction: _updateQiblaData,
          iconColor: AppColorSystem.getCategoryColor('qibla'),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        AppNoticeCard.info(
          title: 'متطلبات التشغيل',
          message: 'يحتاج التطبيق إلى تفعيل خدمة الموقع والبوصلة للعمل بشكل صحيح',
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // بطاقة الميزات
        AppCard.info(
          title: 'ما الذي ستحصل عليه؟',
          subtitle: 'اتجاه دقيق للقبلة مع بوصلة تفاعلية وميزات متقدمة',
          icon: AppIconsSystem.qibla,
          iconColor: AppColorSystem.getCategoryColor('qibla'),
        ),
      ],
    );
  }

  // ✅ التعليمات محسنة
  void _showInstructions() {
    AppInfoDialog.show(
      context: context,
      title: 'تعليمات استخدام البوصلة',
      icon: Icons.help_outline,
      accentColor: AppColorSystem.getCategoryColor('qibla'),
      content: _buildInstructionsContent(),
      actions: [
        DialogAction(
          label: 'عرض النصائح',
          onPressed: () {
            Navigator.of(context).pop();
            _showDetailedTips();
          },
        ),
      ],
      closeButtonText: 'فهمت',
    );
  }

  void _showDetailedTips() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        margin: const EdgeInsets.all(ThemeConstants.space4),
        child: QiblaWidgets.buildUsageTipsCard(context),
      ),
    );
  }

  void _showSettings() {
    AppInfoDialog.show(
      context: context,
      title: 'إعدادات القبلة',
      content: 'هذه الميزة ستكون متوفرة قريباً في التحديثات القادمة',
      icon: AppIconsSystem.settings,
      accentColor: AppColorSystem.info,
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

5. تجنب التشويش
ابتعد عن الأجهزة الإلكترونية والمعادن
''';
  }
}