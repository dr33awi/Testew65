// lib/features/qibla/widgets/qibla_compass.dart - محدث بالنظام الموحد الإسلامي

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

// ✅ استيراد النظام الموحد الإسلامي
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/themes/widgets/extended_cards.dart';

class QiblaCompass extends StatefulWidget {
  final double qiblaDirection;
  final double deviceDirection;
  final double accuracy;
  final bool isCalibrated;
  final VoidCallback? onCalibrate;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
    required this.deviceDirection,
    required this.accuracy,
    this.isCalibrated = false,
    this.onCalibrate,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with TickerProviderStateMixin {
  
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAccurate = widget.accuracy > 0.8;
    
    return AppCard(
      useGradient: true,
      color: AppTheme.tertiary,
      child: Column(
        children: [
          // رأس البوصلة
          _buildCompassHeader(context, isAccurate),
          
          AppTheme.space4.h,
          
          // البوصلة الرئيسية
          _buildMainCompass(context, isAccurate),
          
          AppTheme.space4.h,
          
          // معلومات الاتجاه
          _buildDirectionInfo(context),
          
          if (!widget.isCalibrated && widget.onCalibrate != null) ...[
            AppTheme.space4.h,
            _buildCalibrateButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCompassHeader(BuildContext context, bool isAccurate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: AppTheme.space2.padding,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.explore,
                      color: Colors.white,
                      size: AppTheme.iconMd,
                    ),
                  ),
                );
              },
            ),
            
            AppTheme.space3.w,
            
            Text(
              'اتجاه القبلة',
              style: context.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.bold,
              ),
            ),
          ],
        ),
        
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space1,
          ),
          decoration: BoxDecoration(
            color: (isAccurate ? AppTheme.success : AppTheme.warning)
                .withValues(alpha: 0.2),
            borderRadius: AppTheme.radiusXl.radius,
          ),
          child: Text(
            isAccurate ? 'دقيق' : 'غير دقيق',
            style: context.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCompass(BuildContext context, bool isAccurate) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // البوصلة الخلفية
            CustomPaint(
              size: const Size(250, 250),
              painter: CompassPainter(
                qiblaDirection: widget.qiblaDirection,
                deviceDirection: widget.deviceDirection,
                primaryColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            
            // السهم المركزي
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: (widget.qiblaDirection - widget.deviceDirection) * 
                           (pi / 180),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isAccurate ? AppTheme.success : AppTheme.warning,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isAccurate ? AppTheme.success : AppTheme.warning)
                                .withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // النقطة المركزية
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionInfo(BuildContext context) {
    final qiblaDegrees = widget.qiblaDirection.toStringAsFixed(0);
    final deviceDegrees = widget.deviceDirection.toStringAsFixed(0);
    final accuracyPercent = (widget.accuracy * 100).toStringAsFixed(0);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoItem(
          context,
          'القبلة',
          '$qiblaDegrees°',
          Icons.mosque,
        ),
        _buildInfoItem(
          context,
          'الجهاز',
          '$deviceDegrees°',
          Icons.phone_android,
        ),
        _buildInfoItem(
          context,
          'الدقة',
          '$accuracyPercent%',
          Icons.gps_fixed,
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: AppTheme.space2.padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: AppTheme.radiusMd.radius,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: AppTheme.iconMd,
          ),
        ),
        
        AppTheme.space2.h,
        
        Text(
          value,
          style: context.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        
        Text(
          label,
          style: context.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCalibrateButton(BuildContext context) {
    return AppButton.outline(
      text: 'معايرة البوصلة',
      icon: Icons.tune,
      onPressed: () {
        HapticFeedback.lightImpact();
        widget.onCalibrate?.call();
      },
      borderColor: Colors.white,
    );
  }
}

class CompassPainter extends CustomPainter {
  final double qiblaDirection;
  final double deviceDirection;
  final Color primaryColor;
  final Color backgroundColor;

  CompassPainter({
    required this.qiblaDirection,
    required this.deviceDirection,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // رسم الخلفية
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم الحدود
    final borderPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, borderPaint);

    // رسم العلامات الاتجاهية
    _drawDirectionMarks(canvas, center, radius);
    
    // رسم سهم القبلة
    _drawQiblaArrow(canvas, center, radius - 30);
  }

  void _drawDirectionMarks(Canvas canvas, Offset center, double radius) {
    final markPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // العلامات الأساسية (ش، ج، غ، ق)
    final directions = [
      {'text': 'ش', 'angle': 0.0, 'color': AppTheme.error, 'isMain': true},
      {'text': 'ق', 'angle': 90.0, 'color': primaryColor, 'isMain': true},
      {'text': 'ج', 'angle': 180.0, 'color': primaryColor, 'isMain': true},
      {'text': 'غ', 'angle': 270.0, 'color': primaryColor, 'isMain': true},
    ];

    for (final direction in directions) {
      final angle = (direction['angle'] as double) * (pi / 180);
      final isMain = direction['isMain'] as bool;
      final markRadius = isMain ? radius - 15 : radius - 10;
      final markLength = isMain ? 15 : 8;
      
      final startPoint = Offset(
        center.dx + cos(angle - pi / 2) * markRadius,
        center.dy + sin(angle - pi / 2) * markRadius,
      );
      
      final endPoint = Offset(
        center.dx + cos(angle - pi / 2) * (markRadius + markLength),
        center.dy + sin(angle - pi / 2) * (markRadius + markLength),
      );

      markPaint.color = direction['color'] as Color;
      markPaint.strokeWidth = isMain ? 3 : 1.5;
      
      canvas.drawLine(startPoint, endPoint, markPaint);
      
      // رسم النص
      if (isMain) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: direction['text'] as String,
            style: TextStyle(
              color: direction['color'] as Color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        
        final textOffset = Offset(
          center.dx + cos(angle - pi / 2) * (markRadius + markLength + 15) - 
              textPainter.width / 2,
          center.dy + sin(angle - pi / 2) * (markRadius + markLength + 15) - 
              textPainter.height / 2,
        );
        
        textPainter.paint(canvas, textOffset);
      }
    }

    // العلامات الفرعية
    for (int i = 0; i < 360; i += 30) {
      if (i % 90 != 0) {
        final angle = i * (pi / 180);
        final startPoint = Offset(
          center.dx + cos(angle - pi / 2) * (radius - 5),
          center.dy + sin(angle - pi / 2) * (radius - 5),
        );
        
        final endPoint = Offset(
          center.dx + cos(angle - pi / 2) * (radius + 5),
          center.dy + sin(angle - pi / 2) * (radius + 5),
        );

        markPaint.color = primaryColor.withValues(alpha: 0.5);
        markPaint.strokeWidth = 1;
        
        canvas.drawLine(startPoint, endPoint, markPaint);
      }
    }
  }

  void _drawQiblaArrow(Canvas canvas, Offset center, double radius) {
    final qiblaAngle = (qiblaDirection - deviceDirection) * (pi / 180);
    
    final arrowPaint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    
    // نقطة السهم
    final tipPoint = Offset(
      center.dx + cos(qiblaAngle - pi / 2) * radius,
      center.dy + sin(qiblaAngle - pi / 2) * radius,
    );
    
    // قاعدة السهم
    final leftBase = Offset(
      center.dx + cos(qiblaAngle - pi / 2 + 0.2) * (radius - 20),
      center.dy + sin(qiblaAngle - pi / 2 + 0.2) * (radius - 20),
    );
    
    final rightBase = Offset(
      center.dx + cos(qiblaAngle - pi / 2 - 0.2) * (radius - 20),
      center.dy + sin(qiblaAngle - pi / 2 - 0.2) * (radius - 20),
    );

    arrowPath.moveTo(tipPoint.dx, tipPoint.dy);
    arrowPath.lineTo(leftBase.dx, leftBase.dy);
    arrowPath.lineTo(rightBase.dx, rightBase.dy);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(CompassPainter oldDelegate) {
    return oldDelegate.qiblaDirection != qiblaDirection ||
           oldDelegate.deviceDirection != deviceDirection;
  }
}