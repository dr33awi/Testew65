// lib/features/qibla/screens/qibla_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../models/qibla_model.dart';
import '../services/qibla_service.dart';
import '../widgets/qibla_compass.dart';
import '../widgets/qibla_info_card.dart';
import '../widgets/calibration_widget.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> 
    with TickerProviderStateMixin {
  late final QiblaService _qiblaService;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _showCalibration = false;

  @override
  void initState() {
    super.initState();
    _qiblaService = getService<QiblaService>();
    
    // إعداد الحركات
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    
    // الاستماع لتغييرات الخدمة
    _qiblaService.addListener(_onQiblaServiceUpdate);
    
    // تحديث البيانات إذا لم تكن موجودة
    if (_qiblaService.qiblaData == null) {
      _qiblaService.updateQiblaData();
    }
  }

  @override
  void dispose() {
    _qiblaService.removeListener(_onQiblaServiceUpdate);
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onQiblaServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshData() async {
    await _qiblaService.updateQiblaData();
  }

  void _toggleCalibration() {
    setState(() {
      _showCalibration = !_showCalibration;
    });
  }

  void _startCalibration() async {
    await _qiblaService.startCalibration();
    if (mounted) {
      context.showSuccessMessage('تمت المعايرة بنجاح');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'اتجاه القبلة',
        actions: [
          IconButton(
            onPressed: _toggleCalibration,
            icon: Icon(
              _qiblaService.isCalibrated ? Icons.tune : Icons.tune_outlined,
              color: _qiblaService.isCalibrated 
                  ? context.successColor 
                  : context.secondaryTextColor,
            ),
            tooltip: 'إعدادات المعايرة',
          ),
          IconButton(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث الموقع',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_qiblaService.isLoading) {
      return _buildLoadingState();
    }

    if (_qiblaService.errorMessage != null) {
      return _buildErrorState();
    }

    if (_qiblaService.qiblaData == null) {
      return _buildEmptyState();
    }

    if (_showCalibration) {
      return _buildCalibrationView();
    }

    return _buildQiblaContent();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        context.primaryColor.withValues(alpha: 0.3),
                        context.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.explore,
                    size: 60,
                    color: context.primaryColor,
                  ),
                ),
              );
            },
          ),
          
          Spaces.large,
          
          const IslamicLoading(
            message: 'جارٍ تحديد موقعك...',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: context.errorColor,
            ),
            
            Spaces.large,
            
            Text(
              'خطأ في تحديد الاتجاه',
              style: context.titleStyle.copyWith(
                color: context.errorColor,
              ),
            ),
            
            Spaces.medium,
            
            Text(
              _qiblaService.errorMessage ?? 'حدث خطأ غير متوقع',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            Spaces.extraLarge,
            
            IslamicButton.primary(
              text: 'إعادة المحاولة',
              icon: Icons.refresh,
              onPressed: _refreshData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.explore,
      title: 'لم يتم تحديد الاتجاه',
      subtitle: 'اضغط على الزر أدناه لتحديد اتجاه القبلة',
      action: IslamicButton.primary(
        text: 'تحديد الاتجاه',
        icon: Icons.my_location,
        onPressed: _refreshData,
      ),
    );
  }

  Widget _buildCalibrationView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.mediumPadding),
      child: Column(
        children: [
          CalibrationWidget(
            qiblaService: _qiblaService,
            onCalibrationComplete: () {
              setState(() {
                _showCalibration = false;
              });
            },
          ),
          
          Spaces.large,
          
          IslamicButton.outlined(
            text: 'العودة للبوصلة',
            icon: Icons.arrow_back,
            onPressed: _toggleCalibration,
          ),
        ],
      ),
    );
  }

  Widget _buildQiblaContent() {
    final qiblaData = _qiblaService.qiblaData!;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.mediumPadding),
      child: Column(
        children: [
          // معلومات الموقع
          QiblaInfoCard(
            qiblaModel: qiblaData,
            compassAccuracy: _qiblaService.accuracyPercentage,
            hasCompass: _qiblaService.hasCompass,
          ),
          
          Spaces.large,
          
          // البوصلة الرئيسية
          QiblaCompass(
            qiblaAngle: _qiblaService.qiblaAngle,
            currentDirection: _qiblaService.currentDirection,
            isCalibrated: _qiblaService.isCalibrated,
            accuracyPercentage: _qiblaService.accuracyPercentage,
            hasCompass: _qiblaService.hasCompass,
          ),
          
          Spaces.large,
          
          // معلومات إضافية
          _buildAdditionalInfo(qiblaData),
          
          Spaces.large,
          
          // أزرار الإجراءات
          _buildActionButtons(),
          
          // مساحة إضافية
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(QiblaModel qiblaData) {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.infoColor,
              ),
              Spaces.smallH,
              Text(
                'معلومات إضافية',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildInfoRow(
            'الاتجاه بالدرجات',
            '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
            Icons.compass_calibration,
            context.primaryColor,
          ),
          
          Spaces.medium,
          
          _buildInfoRow(
            'الاتجاه النسبي',
            qiblaData.directionDescription,
            Icons.navigation,
            context.secondaryColor,
          ),
          
          if (qiblaData.cityName != null) ...[
            Spaces.medium,
            _buildInfoRow(
              'المدينة',
              qiblaData.cityName!,
              Icons.location_city,
              context.infoColor,
            ),
          ],
          
          Spaces.medium,
          
          _buildInfoRow(
            'دقة الموقع',
            '${qiblaData.accuracy.toStringAsFixed(1)} متر',
            Icons.gps_fixed,
            qiblaData.hasHighAccuracy 
                ? context.successColor 
                : qiblaData.hasMediumAccuracy 
                    ? context.warningColor 
                    : context.errorColor,
          ),
          
          if (!_qiblaService.hasCompass) ...[
            Spaces.medium,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: context.warningColor,
                    size: 20,
                  ),
                  Spaces.smallH,
                  Expanded(
                    child: Text(
                      'البوصلة غير متوفرة على هذا الجهاز',
                      style: context.captionStyle.copyWith(
                        color: context.warningColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        Spaces.mediumH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.captionStyle,
              ),
              Text(
                value,
                style: context.bodyStyle.medium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: IslamicButton.outlined(
                text: 'معايرة البوصلة',
                icon: Icons.tune,
                onPressed: _qiblaService.hasCompass ? _startCalibration : null,
              ),
            ),
            Spaces.mediumH,
            Expanded(
              child: IslamicButton.primary(
                text: 'تحديث الموقع',
                icon: Icons.my_location,
                onPressed: _refreshData,
              ),
            ),
          ],
        ),
        
        if (!_qiblaService.isCalibrated && _qiblaService.hasCompass) ...[
          Spaces.medium,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.infoColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: context.infoColor,
                ),
                Spaces.smallH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نصيحة',
                        style: context.captionStyle.copyWith(
                          color: context.infoColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'لدقة أفضل، قم بمعايرة البوصلة عبر تحريك الجهاز في شكل رقم 8',
                        style: context.captionStyle.copyWith(
                          color: context.infoColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}