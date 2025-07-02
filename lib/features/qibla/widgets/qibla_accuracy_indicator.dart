// lib/features/qibla/widgets/qibla_accuracy_indicator.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousAccuracy = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.accuracy,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    ));
    _animationController.forward();
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
        parent: _animationController,
        curve: ThemeConstants.curveSmooth,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: ThemeConstants.radiusLg,
      child: Column(
        children: [
          // رأس البطاقة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getAccuracyColor(widget.accuracy).withOpacity(0.1),
                  _getAccuracyColor(widget.accuracy).withOpacity(0.05),
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
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  decoration: BoxDecoration(
                    color: _getAccuracyColor(widget.accuracy).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getAccuracyIcon(widget.accuracy),
                    color: _getAccuracyColor(widget.accuracy),
                    size: ThemeConstants.iconMd,
                  ),
                ),
                ThemeConstants.space3.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'دقة البوصلة',
                        style: context.titleMedium?.semiBold,
                      ),
                      Text(
                        _getAccuracyDescription(widget.accuracy),
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.isCalibrated && widget.onCalibrate != null)
                  AppButton.outline(
                    text: 'معايرة',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onCalibrate?.call();
                    },
                    size: ButtonSize.small,
                    icon: Icons.compass_calibration,
                    color: ThemeConstants.warning, // لون مميز لزر المعايرة
                  ),
              ],
            ),
          ),
          
          // مؤشر الدقة
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Column(
              children: [
                // شريط التقدم
                SizedBox(
                  height: 120,
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(double.infinity, 120),
                        painter: AccuracyGaugePainter(
                          progress: _progressAnimation.value / 100, // Pass as 0-1
                          color: _getAccuracyColor(_progressAnimation.value),
                          backgroundColor: context.dividerColor.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_progressAnimation.value.toStringAsFixed(0)}%',
                                style: context.displaySmall?.copyWith(
                                  color: _getAccuracyColor(_progressAnimation.value),
                                  fontWeight: ThemeConstants.bold,
                                ),
                              ),
                              Text(
                                'الدقة',
                                style: context.bodySmall?.copyWith(
                                  color: context.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                ThemeConstants.space4.h,
                
                // معلومات إضافية
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: ThemeConstants.radiusMd.circular,
                    border: Border.all(
                      color: context.dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildStatusRow(
                        context,
                        'المعايرة',
                        widget.isCalibrated ? 'مكتملة' : 'مطلوبة',
                        widget.isCalibrated ? ThemeConstants.success : ThemeConstants.warning,
                      ),
                      ThemeConstants.space2.h,
                      Divider(color: context.dividerColor.withOpacity(0.2)),
                      ThemeConstants.space2.h,
                      _buildStatusRow(
                        context,
                        'التداخل المغناطيسي',
                        _getMagneticInterferenceText(widget.accuracy),
                        _getMagneticInterferenceColor(widget.accuracy),
                      ),
                    ],
                  ),
                ),
                
                ThemeConstants.space3.h,
                
                // نصائح لتحسين الدقة
                if (widget.accuracy < 70) // Show tips if accuracy is not good
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.space3),
                    decoration: BoxDecoration(
                      color: ThemeConstants.info.withOpacity(0.1),
                      borderRadius: ThemeConstants.radiusMd.circular,
                      border: Border.all(
                        color: ThemeConstants.info.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: ThemeConstants.info,
                          size: ThemeConstants.iconSm,
                        ),
                        ThemeConstants.space2.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'نصائح لتحسين الدقة:',
                                style: context.bodySmall?.copyWith(
                                  fontWeight: ThemeConstants.semiBold,
                                  color: ThemeConstants.info,
                                ),
                              ),
                              ThemeConstants.space1.h,
                              ..._getTips(widget.accuracy).map((tip) => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: context.bodySmall?.copyWith(
                                        color: context.textSecondaryColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        tip,
                                        style: context.bodySmall?.copyWith(
                                          color: context.textSecondaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space2,
            vertical: ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: ThemeConstants.radiusSm.circular,
          ),
          child: Text(
            value,
            style: context.bodySmall?.copyWith(
              color: color,
              fontWeight: ThemeConstants.medium,
            ),
          ),
        ),
      ],
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
    if (accuracy >= 80) return 'دقة ممتازة';
    if (accuracy >= 60) return 'دقة جيدة';
    if (accuracy >= 40) return 'دقة متوسطة';
    return 'دقة ضعيفة جداً';
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
      tips.add('ابتعد عن الأجهزة الإلكترونية والمعادن');
    }
    if (!widget.isCalibrated) {
      tips.add('قم بمعايرة البوصلة بتحريك الجهاز في شكل رقم 8');
    }
    if (accuracy < 50) {
      tips.add('انتقل إلى مكان مفتوح في الهواء الطلق');
      tips.add('تأكد من عدم وجود مغناطيس أو سماعات قريبة');
    }
    
    return tips;
  }
}

// رسام مؤشر الدقة (Gauge)
class AccuracyGaugePainter extends CustomPainter {
  final double progress; // Progress from 0.0 to 1.0
  final Color color;
  final Color backgroundColor;

  AccuracyGaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20); // Adjust center for gauge style
    final radius = math.min(size.width / 2, size.height - 40); // Adjust radius

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from 180 degrees (left)
      math.pi, // Sweep 180 degrees (to right)
      false,
      backgroundPaint,
    );
    
    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from 180 degrees
      math.pi * progress, // Sweep based on progress
      false,
      progressPaint,
    );
    
    // Indicator (thumb)
    final indicatorAngle = math.pi + (math.pi * progress);
    final indicatorX = center.dx + radius * math.cos(indicatorAngle);
    final indicatorY = center.dy + radius * math.sin(indicatorAngle);
    
    final indicatorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(indicatorX, indicatorY), 10, indicatorPaint);
    
    // White border for indicator
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawCircle(Offset(indicatorX, indicatorY), 10, borderPaint);
  }

  @override
  bool shouldRepaint(covariant AccuracyGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}