// lib/features/qibla/widgets/qibla_compass.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/themes/index.dart';

/// البوصلة الرئيسية لعرض اتجاه القبلة
class QiblaCompass extends StatefulWidget {
  final double qiblaAngle;
  final double currentDirection;
  final bool isCalibrated;
  final double accuracyPercentage;
  final bool hasCompass;

  const QiblaCompass({
    super.key,
    required this.qiblaAngle,
    required this.currentDirection,
    required this.isCalibrated,
    required this.accuracyPercentage,
    required this.hasCompass,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _qiblaController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _qiblaController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _qiblaController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الخلفية الخارجية
          _buildOuterRing(),
          
          // الدرجات والاتجاهات
          _buildCompassMarks(),
          
          // البوصلة الداخلية
          _buildInnerCompass(),
          
          // مؤشر القبلة
          _buildQiblaIndicator(),
          
          // مؤشر الشمال
          _buildNorthIndicator(),
          
          // المركز
          _buildCenter(),
          
          // مؤشر الدقة
          if (widget.hasCompass)
            _buildAccuracyIndicator(),
        ],
      ),
    );
  }

  Widget _buildOuterRing() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.cardColor,
            context.backgroundColor,
          ],
        ),
      ),
    );
  }

  Widget _buildCompassMarks() {
    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: CompassMarksPainter(
          textColor: context.textColor,
          markColor: context.borderColor,
        ),
      ),
    );
  }

  Widget _buildInnerCompass() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: -widget.currentDirection * (math.pi / 180),
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  context.surfaceColor,
                  context.cardColor,
                ],
              ),
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQiblaIndicator() {
    final isAligned = (widget.qiblaAngle - 180).abs() < 5;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_qiblaController, _glowAnimation]),
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.qiblaAngle * (math.pi / 180),
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              children: [
                // الخط الدليلي
                Positioned(
                  top: 10,
                  left: 99,
                  child: Container(
                    width: 2,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.primaryColor,
                          context.primaryColor.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // أيقونة الكعبة
                Positioned(
                  top: 5,
                  left: 85,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isAligned 
                          ? context.successColor
                          : context.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: isAligned ? [
                        BoxShadow(
                          color: context.successColor.withValues(alpha: _glowAnimation.value * 0.5),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ] : [],
                    ),
                    child: const Icon(
                      Icons.place,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNorthIndicator() {
    return Transform.rotate(
      angle: -widget.currentDirection * (math.pi / 180),
      child: SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 110,
              child: Container(
                width: 20,
                height: 30,
                decoration: BoxDecoration(
                  color: context.errorColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 112,
              child: Text(
                'ش',
                style: context.captionStyle.copyWith(
                  color: context.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenter() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.darken(0.2),
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildAccuracyIndicator() {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.borderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.accuracyPercentage > 70 
                  ? Icons.signal_cellular_4_bar
                  : widget.accuracyPercentage > 40
                      ? Icons.signal_cellular_2_bar
                      : Icons.signal_cellular_1_bar,
              size: 16,
              color: widget.accuracyPercentage > 70 
                  ? context.successColor
                  : widget.accuracyPercentage > 40
                      ? context.warningColor
                      : context.errorColor,
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.accuracyPercentage.toStringAsFixed(0)}%',
              style: context.captionStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// رسام علامات البوصلة
class CompassMarksPainter extends CustomPainter {
  final Color textColor;
  final Color markColor;

  CompassMarksPainter({
    required this.textColor,
    required this.markColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = markColor
      ..strokeWidth = 1;
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // رسم العلامات كل 30 درجة
    for (int i = 0; i < 360; i += 30) {
      final angle = i * (math.pi / 180);
      final isMainDirection = i % 90 == 0;
      
      final startRadius = radius - (isMainDirection ? 20 : 15);
      final endRadius = radius - 5;
      
      final start = Offset(
        center.dx + startRadius * math.cos(angle - math.pi / 2),
        center.dy + startRadius * math.sin(angle - math.pi / 2),
      );
      
      final end = Offset(
        center.dx + endRadius * math.cos(angle - math.pi / 2),
        center.dy + endRadius * math.sin(angle - math.pi / 2),
      );
      
      paint.strokeWidth = isMainDirection ? 2 : 1;
      canvas.drawLine(start, end, paint);
      
      // إضافة النصوص للاتجاهات الرئيسية
      if (isMainDirection) {
        String directionText = '';
        switch (i) {
          case 0:
            directionText = 'ش';
            break;
          case 90:
            directionText = 'ق';
            break;
          case 180:
            directionText = 'ج';
            break;
          case 270:
            directionText = 'غ';
            break;
        }
        
        textPainter.text = TextSpan(
          text: directionText,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        
        final textOffset = Offset(
          center.dx + (radius - 35) * math.cos(angle - math.pi / 2) - textPainter.width / 2,
          center.dy + (radius - 35) * math.sin(angle - math.pi / 2) - textPainter.height / 2,
        );
        
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}