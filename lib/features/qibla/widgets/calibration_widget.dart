// lib/features/qibla/widgets/calibration_widget.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/themes/index.dart';
import '../services/qibla_service.dart';

/// واجهة معايرة البوصلة
class CalibrationWidget extends StatefulWidget {
  final QiblaService qiblaService;
  final VoidCallback onCalibrationComplete;

  const CalibrationWidget({
    super.key,
    required this.qiblaService,
    required this.onCalibrationComplete,
  });

  @override
  State<CalibrationWidget> createState() => _CalibrationWidgetState();
}

class _CalibrationWidgetState extends State<CalibrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _phoneController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _phoneAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  bool _isCalibrating = false;
  int _calibrationProgress = 0;
  String _currentStep = '';

  @override
  void initState() {
    super.initState();
    
    // حركة الهاتف في شكل 8
    _phoneController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _phoneAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _phoneController,
      curve: Curves.easeInOut,
    ));
    
    // نبضة المعايرة
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // موجات الإشارة
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_waveController);
    
    _phoneController.repeat();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _startCalibration() async {
    setState(() {
      _isCalibrating = true;
      _calibrationProgress = 0;
      _currentStep = 'بدء المعايرة...';
    });

    _pulseController.repeat(reverse: true);
    _waveController.repeat();

    // محاكاة عملية المعايرة مع تقدم
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        setState(() {
          _calibrationProgress = i;
          _currentStep = _getCalibrationStep(i);
        });
      }
    }

    // تنفيذ المعايرة الفعلية
    await widget.qiblaService.startCalibration();
    
    if (mounted) {
      setState(() {
        _isCalibrating = false;
        _calibrationProgress = 100;
        _currentStep = 'تمت المعايرة بنجاح!';
      });
      
      _pulseController.stop();
      _waveController.stop();
      
      // تأخير قصير ثم استدعاء callback
      await Future.delayed(const Duration(milliseconds: 1500));
      widget.onCalibrationComplete();
    }
  }

  String _getCalibrationStep(int progress) {
    if (progress < 20) return 'جارٍ فحص الحساسات...';
    if (progress < 40) return 'قياس المجال المغناطيسي...';
    if (progress < 60) return 'تحليل البيانات...';
    if (progress < 80) return 'حساب التصحيحات...';
    if (progress < 100) return 'إنهاء المعايرة...';
    return 'تمت المعايرة بنجاح!';
  }

  @override
  Widget build(BuildContext context) {
    return IslamicCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.primaryColor.withValues(alpha: 0.05),
          context.primaryColor.withValues(alpha: 0.02),
        ],
      ),
      child: Column(
        children: [
          // العنوان
          _buildHeader(context),
          
          Spaces.large,
          
          // الرسم التوضيحي
          _buildCalibrationAnimation(context),
          
          Spaces.large,
          
          // شريط التقدم (أثناء المعايرة)
          if (_isCalibrating)
            _buildProgressSection(context),
          
          if (!_isCalibrating) ...[
            // التعليمات
            _buildInstructions(context),
            
            Spaces.large,
            
            // خطوات المعايرة
            _buildCalibrationSteps(context),
          ],
          
          Spaces.large,
          
          // أزرار التحكم
          _buildActionButtons(context),
          
          // حالة المعايرة
          if (widget.qiblaService.isCalibrated && !_isCalibrating)
            _buildSuccessStatus(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.primaryColor,
                context.primaryColor.darken(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.tune,
            color: Colors.white,
            size: 20,
          ),
        ),
        Spaces.smallH,
        Text(
          'معايرة البوصلة',
          style: context.titleStyle.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (widget.qiblaService.isCalibrated)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'مُعايرة',
              style: context.captionStyle.copyWith(
                color: context.successColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCalibrationAnimation(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // موجات الإشارة (أثناء المعايرة)
          if (_isCalibrating)
            ..._buildSignalWaves(context),
          
          // الهاتف المتحرك
          AnimatedBuilder(
            animation: _phoneAnimation,
            builder: (context, child) {
              // حساب المسار للحركة في شكل 8
              final t = _phoneAnimation.value;
              final x = 40 * math.sin(t);
              final y = 20 * math.sin(2 * t);
              
              return Transform.translate(
                offset: Offset(x, y),
                child: AnimatedBuilder(
                  animation: _isCalibrating ? _pulseAnimation : 
                           const AlwaysStoppedAnimation(1.0),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isCalibrating ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 80,
                        height: 130,
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: context.primaryColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.primaryColor.withValues(alpha: 0.3),
                              blurRadius: _isCalibrating ? 15 : 8,
                              spreadRadius: _isCalibrating ? 3 : 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 40,
                              color: context.primaryColor,
                            ),
                            Spaces.small,
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _isCalibrating 
                                    ? context.warningColor 
                                    : context.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.explore,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSignalWaves(BuildContext context) {
    return List.generate(3, (index) {
      return AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          final delay = index * 0.3;
          final animValue = (_waveAnimation.value + delay) % 1.0;
          
          return Container(
            width: 60 + (animValue * 120),
            height: 60 + (animValue * 120),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.primaryColor.withValues(
                  alpha: (1 - animValue) * 0.5,
                ),
                width: 2,
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      children: [
        // شريط التقدم
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: context.borderColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 0.8 * 
                       (_calibrationProgress / 100),
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor,
                      context.successColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        
        Spaces.medium,
        
        // النسبة المئوية
        Text(
          '$_calibrationProgress%',
          style: context.titleStyle.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        Spaces.small,
        
        // الخطوة الحالية
        Text(
          _currentStep,
          style: context.bodyStyle.copyWith(
            color: context.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Column(
      children: [
        Text(
          'للحصول على دقة أفضل في تحديد اتجاه القبلة',
          style: context.titleStyle.copyWith(
            color: context.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        
        Spaces.medium,
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.infoColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.infoColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                color: context.infoColor,
                size: 24,
              ),
              Spaces.small,
              Text(
                'قم بتحريك الجهاز في شكل رقم 8 لمدة 10 ثوان\nتأكد من أنك بعيد عن المعادن والأجهزة الإلكترونية',
                style: context.bodyStyle.copyWith(
                  color: context.infoColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalibrationSteps(BuildContext context) {
    final steps = [
      {
        'number': '1',
        'title': 'أمسك الجهاز بشكل أفقي',
        'icon': Icons.phone_android,
        'description': 'ضع الجهاز في راحة يدك بشكل مسطح',
      },
      {
        'number': '2',
        'title': 'حرك الجهاز في شكل رقم 8',
        'icon': Icons.all_out,
        'description': 'اتبع المسار الموضح في الرسم المتحرك',
      },
      {
        'number': '3',
        'title': 'استمر لمدة 10 ثوان',
        'icon': Icons.timer,
        'description': 'حافظ على الحركة حتى انتهاء المعايرة',
      },
    ];

    return Column(
      children: steps.map((step) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCalibrationStep(
            context,
            step['number'] as String,
            step['title'] as String,
            step['description'] as String,
            step['icon'] as IconData,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalibrationStep(
    BuildContext context,
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // رقم الخطوة
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor,
                  context.primaryColor.darken(0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: context.bodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          Spaces.mediumH,
          
          // الأيقونة
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: context.primaryColor,
              size: 18,
            ),
          ),
          
          Spaces.mediumH,
          
          // المحتوى
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: context.captionStyle.copyWith(
                    color: context.secondaryTextColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: IslamicButton.outlined(
                text: 'إعادة تعيين',
                icon: Icons.refresh,
                onPressed: _isCalibrating ? null : () {
                  widget.qiblaService.resetCalibration();
                  setState(() {
                    _calibrationProgress = 0;
                    _currentStep = '';
                  });
                },
              ),
            ),
            
            Spaces.mediumH,
            
            Expanded(
              child: IslamicButton.primary(
                text: _isCalibrating ? 'جارٍ المعايرة...' : 'بدء المعايرة',
                icon: _isCalibrating ? null : Icons.play_arrow,
                onPressed: _isCalibrating ? null : _startCalibration,
                isLoading: _isCalibrating,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessStatus(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.successColor.withValues(alpha: 0.1),
            context.successColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.successColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.successColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          Spaces.mediumH,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تمت المعايرة بنجاح',
                  style: context.bodyStyle.copyWith(
                    color: context.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'البوصلة جاهزة الآن لتحديد اتجاه القبلة بدقة',
                  style: context.captionStyle.copyWith(
                    color: context.successColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}