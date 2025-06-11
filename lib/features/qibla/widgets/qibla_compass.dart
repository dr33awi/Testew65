// lib/features/qibla/widgets/qibla_compass.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/themes/app_theme.dart';

class QiblaCompass extends StatelessWidget {
  final double qiblaDirection;
  final double currentDirection;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
    required this.currentDirection,
  });

  @override
  Widget build(BuildContext context) {
    // حساب زاوية القبلة النسبية إلى الاتجاه الحالي
    final relativeAngle = (qiblaDirection - currentDirection + 360) % 360;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight) * 0.85;
        
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // إضافة خلفية مدورة للبوصلة
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      context.cardColor,
                      context.cardColor.withOpacity(0.95),
                    ],
                    stops: const [0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              
              // بوصلة متحركة (تدور مع الجهاز)
              Transform.rotate(
                angle: -currentDirection * (math.pi / 180),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      // خطوط البوصلة
                      CustomPaint(
                        size: Size(size, size),
                        painter: CompassPainter(),
                      ),
                      
                      // تسميات الاتجاهات
                      Center(
                        child: Stack(
                          children: [
                            _buildDirectionLabel('N', Alignment.topCenter, context),
                            _buildDirectionLabel('E', Alignment.centerRight, context),
                            _buildDirectionLabel('S', Alignment.bottomCenter, context),
                            _buildDirectionLabel('W', Alignment.centerLeft, context),
                            
                            // إضافة NE, SE, SW, NW
                            _buildDirectionLabel('NE', Alignment(0.7, -0.7), context),
                            _buildDirectionLabel('SE', Alignment(0.7, 0.7), context),
                            _buildDirectionLabel('SW', Alignment(-0.7, 0.7), context),
                            _buildDirectionLabel('NW', Alignment(-0.7, -0.7), context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // مؤشر القبلة (ثابت، يشير دائمًا إلى الكعبة)
              Transform.rotate(
                angle: relativeAngle * (math.pi / 180),
                child: SizedBox(
                  width: size * 0.9,
                  height: size * 0.9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // سهم القبلة المحسن
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 35,
                          height: size * 0.45,
                          child: CustomPaint(
                            painter: QiblaArrowPainter(color: context.primaryColor),
                          ),
                        ),
                      ),
                      
                      // مؤشر القبلة - دائرة في الأعلى
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.primaryColor,
                                  context.primaryColor.withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: context.primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'قبلة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // مركز البوصلة
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              
              // مؤشر اتجاه الجهاز
              Positioned(
                top: (constraints.maxHeight - size) / 2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              
              // زاوية القبلة عددية (إضافة جديدة)
              Positioned(
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: context.cardColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.primaryColor.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 18,
                        color: context.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${relativeAngle.toStringAsFixed(1)}°',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDirectionLabel(
    String text,
    Alignment alignment,
    BuildContext context,
  ) {
    final bool isMainDirection = text.length == 1;
    
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(isMainDirection ? 25 : 30),
        child: Text(
          text,
          style: TextStyle(
            color: text == 'N'
                ? Colors.red
                : isMainDirection 
                    ? context.textSecondaryColor
                    : context.textSecondaryColor.withOpacity(0.7),
            fontSize: isMainDirection ? 16 : 12,
            fontWeight: isMainDirection ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// رسم خطوط البوصلة
class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // الألوان
    final primaryPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final secondaryPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
      
    final mediumPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // رسم الدائرة الخارجية
    canvas.drawCircle(center, radius - 1, primaryPaint);
    
    // رسم دائرة ثانية
    canvas.drawCircle(center, radius * 0.85, Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8);
    
    // رسم خطوط الاتجاهات
    for (int i = 0; i < 360; i += 5) {
      final angle = i * (math.pi / 180);
      final isMainDirection = i % 90 == 0;
      final isMediumDirection = i % 45 == 0;
      final isMinorDirection = i % 15 == 0;
      
      final lineLength = isMainDirection
          ? 20.0
          : isMediumDirection
              ? 15.0
              : isMinorDirection
                  ? 10.0
                  : 5.0;
              
      final startRadius = radius - lineLength;
      final start = Offset(
        center.dx + startRadius * math.cos(angle),
        center.dy + startRadius * math.sin(angle),
      );
      
      final end = Offset(
        center.dx + (radius - 2) * math.cos(angle),
        center.dy + (radius - 2) * math.sin(angle),
      );
      
      // اختيار نوع الخط حسب الاتجاه
      Paint paintToUse;
      if (isMainDirection) {
        paintToUse = primaryPaint;
      } else if (isMediumDirection) {
        paintToUse = mediumPaint;
      } else {
        paintToUse = secondaryPaint;
      }
      
      canvas.drawLine(start, end, paintToUse);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// رسم سهم القبلة محسن
class QiblaArrowPainter extends CustomPainter {
  final Color color;

  QiblaArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color.withOpacity(0.7),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();
    
    // تصميم سهم محسن للقبلة
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.quadraticBezierTo(
      size.width / 2, size.height * 0.6, 
      size.width / 2, size.height * 0.8
    );
    path.quadraticBezierTo(
      size.width / 2, size.height * 0.6, 
      size.width * 0.8, size.height * 0.7
    );
    path.close();

    // رسم الظل أولاً
    canvas.drawPath(path, shadowPaint);
    
    // ثم رسم السهم
    canvas.drawPath(path, paint);
    
    // إضافة تفاصيل على السهم
    final detailPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
      
    final detailPath = Path();
    detailPath.moveTo(size.width / 2, size.height * 0.15);
    detailPath.lineTo(size.width / 2, size.height * 0.4);
    
    canvas.drawPath(detailPath, detailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}