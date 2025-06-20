// lib/features/qibla/widgets/qibla_accuracy_indicator.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/index.dart';

class QiblaAccuracyIndicator extends StatefulWidget {
  final double accuracy; // Accuracy from 0.0 to 100.0 (percentage)
  final bool isCalibrated;
  final VoidCallback? onCalibrate;

  const QiblaAccuracyIndicator({
    super.key,
    required this.accuracy,
    required this.isCalibrated,
    this.onCalibrate,
  });

  @override
  State<QiblaAccuracyIndicator> createState() => _QiblaAccuracyIndicatorState();
}

class _QiblaAccuracyIndicatorState extends State<QiblaAccuracyIndicator>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  double _previousAccuracy = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.accuracy,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: ThemeConstants.curveSmooth,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
  }

  @override
  void didUpdateWidget(QiblaAccuracyIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accuracy != widget.accuracy) {
      _previousAccuracy = oldWidget.accuracy;
      _progressAnimation = Tween<double>(
        begin: _previousAccuracy,
        end: widget.accuracy,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: ThemeConstants.curveSmooth,
      ));
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracyColor = _getAccuracyColor(widget.accuracy);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceMd),
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowMd,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accuracyColor.withValues(alpha: 0.05),
                  accuracyColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: context.borderColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Stack(
              children: [
                // خلفية متحركة
                _buildAnimatedBackground(accuracyColor),
                
                // المحتوى الرئيسي
                _buildContent(context, accuracyColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(Color accuracyColor) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: AccuracyBackgroundPainter(
              animation: _pulseAnimation.value,
              color: accuracyColor.withValues(alpha: 0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color accuracyColor) {
    return Column(
      children: [
        // رأس البطاقة
        Container(
          padding: const EdgeInsets.all(ThemeConstants.spaceMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accuracyColor.withValues(alpha: 0.1),
                accuracyColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(ThemeConstants.radiusLg),
            ),
          ),
          child: Row(
            children: [
              // أيقونة الدقة
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.1),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accuracyColor.withValues(alpha: 0.2),
                            accuracyColor.withValues(alpha: 0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accuracyColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accuracyColor.withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getAccuracyIcon(widget.accuracy),
                        color: accuracyColor,
                        size: ThemeConstants.iconLg,
                      ),
                    ),
                  );
                },
              ),
              
              Spaces.mediumH,
              
              // معلومات الدقة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دقة البوصلة',
                      style: context.titleStyle.copyWith(
                        fontWeight: ThemeConstants.fontBold,
                      ),
                    ),
                    Spaces.small,
                    Text(
                      _getAccuracyDescription(widget.accuracy),
                      style: context.bodyStyle.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // زر المعايرة
              if (!widget.isCalibrated && widget.onCalibrate != null)
                IslamicButton.outlined(
                  text: 'معايرة',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onCalibrate?.call();
                  },
                  icon: Icons.compass_calibration,
                  color: ThemeConstants.warning,
                ),
            ],
          ),
        ),
        
        // مؤشر الدقة
        Padding(
          padding: const EdgeInsets.all(ThemeConstants.spaceMd),
          child: Column(
            children: [
              // مقياس الدقة الدائري
              SizedBox(
                height: 150,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // المقياس الدائري
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CustomPaint(
                            painter: AccuracyGaugePainter(
                              progress: _progressAnimation.value / 100,
                              color: accuracyColor,
                              backgroundColor: context.borderColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        
                        // القيمة في المنتصف
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_progressAnimation.value.toStringAsFixed(0)}%',
                              style: context.headingStyle.copyWith(
                                color: accuracyColor,
                                fontWeight: ThemeConstants.fontBold,
                                fontSize: 32,
                              ),
                            ),
                            Text(
                              'الدقة',
                              style: context.bodyStyle.copyWith(
                                color: context.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              Spaces.large,
              
              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.borderColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildStatusRow(
                      context,
                      'حالة المعايرة',
                      widget.isCalibrated ? 'مكتملة' : 'مطلوبة',
                      widget.isCalibrated ? ThemeConstants.success : ThemeConstants.warning,
                    ),
                    
                    Spaces.medium,
                    
                    Divider(color: context.borderColor.withValues(alpha: 0.2)),
                    
                    Spaces.medium,
                    
                    _buildStatusRow(
                      context,
                      'التداخل المغناطيسي',
                      _getMagneticInterferenceText(widget.accuracy),
                      _getMagneticInterferenceColor(widget.accuracy),
                    ),
                  ],
                ),
              ),
              
              // نصائح لتحسين الدقة
              if (widget.accuracy < 70) ...[
                Spaces.large,
                _buildTipsCard(context),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.bodyStyle.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spaceSm,
            vertical: ThemeConstants.spaceXs,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          ),
          child: Text(
            value,
            style: context.captionStyle.copyWith(
              color: color,
              fontWeight: ThemeConstants.fontSemiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: ThemeConstants.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: ThemeConstants.info.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                decoration: BoxDecoration(
                  color: ThemeConstants.info.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: ThemeConstants.info,
                  size: ThemeConstants.iconMd,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Text(
                  'نصائح لتحسين الدقة',
                  style: context.titleStyle.copyWith(
                    color: ThemeConstants.info,
                    fontWeight: ThemeConstants.fontSemiBold,
                  ),
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          ..._getTips(widget.accuracy).map((tip) => Padding(
            padding: const EdgeInsets.only(top: ThemeConstants.spaceSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  decoration: const BoxDecoration(
                    color: ThemeConstants.info,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: context.bodyStyle.copyWith(
                      color: context.secondaryTextColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return ThemeConstants.success;
    if (accuracy >= 50) return ThemeConstants.warning;
    return ThemeConstants.error;
  }

  IconData _getAccuracyIcon(double accuracy) {
    if (accuracy >= 80) return Icons.gps_fixed;
    if (accuracy >= 50) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  String _getAccuracyDescription(double accuracy) {
    if (accuracy >= 80) return 'دقة ممتازة - البوصلة تعمل بكفاءة عالية';
    if (accuracy >= 60) return 'دقة جيدة - النتائج موثوقة';
    if (accuracy >= 40) return 'دقة متوسطة - قد تحتاج لمعايرة';
    return 'دقة ضعيفة - معايرة مطلوبة فوراً';
  }

  String _getMagneticInterferenceText(double accuracy) {
    if (accuracy >= 70) return 'منخفض';
    if (accuracy >= 40) return 'متوسط';
    return 'عالي';
  }

  Color _getMagneticInterferenceColor(double accuracy) {
    if (accuracy >= 70) return ThemeConstants.success;
    if (accuracy >= 40) return ThemeConstants.warning;
    return ThemeConstants.error;
  }

  List<String> _getTips(double accuracy) {
    final tips = <String>[];
    
    if (accuracy < 70) {
      tips.add('ابتعد عن الأجهزة الإلكترونية والمعادن القريبة');
    }
    if (!widget.isCalibrated) {
      tips.add('قم بمعايرة البوصلة بتحريك الجهاز في شكل رقم 8');
    }
    if (accuracy < 50) {
      tips.add('انتقل إلى مكان مفتوح في الهواء الطلق');
      tips.add('تأكد من عدم وجود مغناطيس أو سماعات قريبة');
    }
    if (accuracy < 30) {
      tips.add('أعد تشغيل التطبيق وحاول مرة أخرى');
    }
    
    return tips;
  }
}

/// رسام مؤشر الدقة الدائري
class AccuracyGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  AccuracyGaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = math.min(size.width / 2, size.height - 40);

    // الخلفية
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );
    
    // شريط التقدم
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * progress,
      false,
      progressPaint,
    );
    
    // المؤشر
    final indicatorAngle = math.pi + (math.pi * progress);
    final indicatorX = center.dx + radius * math.cos(indicatorAngle);
    final indicatorY = center.dy + radius * math.sin(indicatorAngle);
    
    // ظل المؤشر
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    canvas.drawCircle(Offset(indicatorX + 2, indicatorY + 2), 12, shadowPaint);
    
    // المؤشر الرئيسي
    final indicatorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(indicatorX, indicatorY), 12, indicatorPaint);
    
    // حد أبيض للمؤشر
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawCircle(Offset(indicatorX, indicatorY), 12, borderPaint);
  }

  @override
  bool shouldRepaint(covariant AccuracyGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// رسام الخلفية للدقة
class AccuracyBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  AccuracyBackgroundPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // رسم دوائر متحركة تمثل إشارات GPS
    for (int i = 0; i < 4; i++) {
      final radius = 30.0 + (i * 20) + (animation * 15);
      final alpha = (1 - (i * 0.2)) * (0.6 - animation * 0.2);
      
      paint.color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.3),
        radius,
        paint,
      );
    }

    // رسم أشكال البوصلة
    _drawCompassShapes(canvas, size, paint);
  }

  void _drawCompassShapes(Canvas canvas, Size size, Paint paint) {
    // رسم إبر البوصلة المتحركة
    final center = Offset(size.width * 0.8, size.height * 0.7);
    
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + (animation * math.pi / 4);
      const length = 15.0;
      
      final endX = center.dx + length * math.cos(angle);
      final endY = center.dy + length * math.sin(angle);
      
      paint.color = color.withValues(alpha: 0.4);
      canvas.drawLine(center, Offset(endX, endY), paint..strokeWidth = 2);
    }
    
    // دائرة البوصلة
    canvas.drawCircle(center, 20, paint..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}