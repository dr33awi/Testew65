// lib/features/home/widgets/enhanced_islamic_pattern_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double animation;

  IslamicPatternPainter({
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // رسم نمط إسلامي متقدم
    _drawAdvancedIslamicPattern(canvas, size, paint, fillPaint);
  }

  void _drawAdvancedIslamicPattern(Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // رسم الأشكال الهندسية الإسلامية
    _drawGeometricPattern(canvas, centerX, centerY, strokePaint);
    
    // رسم النجوم الثمانية
    _drawOctagonalStars(canvas, size, strokePaint);
    
    // رسم الأرابيسك
    _drawArabesquePattern(canvas, size, strokePaint);
    
    // رسم الكتابة العربية المزخرفة
    _drawCalligraphicElements(canvas, size, strokePaint);
    
    // رسم عناصر نباتية
    _drawFloralElements(canvas, size, strokePaint, fillPaint);
  }

  void _drawGeometricPattern(Canvas canvas, double centerX, double centerY, Paint paint) {
    // رسم نمط هندسي معقد
    final radius = 40.0;
    
    // دائرة مركزية
    canvas.drawCircle(Offset(centerX, centerY), radius / 3, paint);
    
    // أشكال سداسية متداخلة
    for (int layer = 1; layer <= 3; layer++) {
      final layerRadius = radius * layer / 3;
      _drawHexagon(canvas, centerX, centerY, layerRadius, paint);
      
      // نقاط على الزوايا
      for (int i = 0; i < 6; i++) {
        final angle = (i * math.pi / 3);
        final x = centerX + layerRadius * math.cos(angle);
        final y = centerY + layerRadius * math.sin(angle);
        
        canvas.drawCircle(Offset(x, y), 2, paint..style = PaintingStyle.fill);
      }
    }
  }

  void _drawHexagon(Canvas canvas, double centerX, double centerY, double radius, Paint paint) {
    final path = Path();
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
  }

  void _drawOctagonalStars(Canvas canvas, Size size, Paint paint) {
    // رسم نجوم ثمانية في الزوايا
    final positions = [
      Offset(size.width * 0.15, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.15, size.height * 0.85),
      Offset(size.width * 0.85, size.height * 0.85),
    ];
    
    for (final pos in positions) {
      _drawEightPointedStar(canvas, pos, 15, paint);
    }
  }

  void _drawEightPointedStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    final double angle = 2 * math.pi / points;
    
    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = (i + 0.5) * angle - math.pi / 2;
      
      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);
      
      final innerX = center.dx + (radius * 0.6) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.6) * math.sin(innerAngle);
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      
      path.lineTo(innerX, innerY);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawArabesquePattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط الأرابيسك المتدفق
    final path = Path();
    
    // منحنيات متدفقة
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.1,
      size.width * 0.5, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.5,
      size.width * 0.9, size.height * 0.3,
    );
    
    // منحنى ثاني
    path.moveTo(size.width * 0.1, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.5,
      size.width * 0.4, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.6, size.height * 0.9,
      size.width * 0.9, size.height * 0.7,
    );
    
    canvas.drawPath(path, paint);
  }

  void _drawCalligraphicElements(Canvas canvas, Size size, Paint paint) {
    // رسم عناصر تشبه الخط العربي
    final path = Path();
    
    // خط منحني يشبه "بسم الله"
    path.moveTo(size.width * 0.2, size.height * 0.4);
    path.cubicTo(
      size.width * 0.3, size.height * 0.35,
      size.width * 0.4, size.height * 0.45,
      size.width * 0.5, size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.6, size.height * 0.35,
      size.width * 0.7, size.height * 0.45,
      size.width * 0.8, size.height * 0.4,
    );
    
    // نقاط الحروف
    final dots = [
      Offset(size.width * 0.25, size.height * 0.42),
      Offset(size.width * 0.45, size.height * 0.38),
      Offset(size.width * 0.65, size.height * 0.42),
      Offset(size.width * 0.75, size.height * 0.38),
    ];
    
    canvas.drawPath(path, paint);
    
    for (final dot in dots) {
      canvas.drawCircle(dot, 1.5, paint..style = PaintingStyle.fill);
    }
  }

  void _drawFloralElements(Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    // رسم عناصر نباتية وزهور إسلامية
    
    // زهرة في الزاوية العلوية اليمنى
    final flowerCenter = Offset(size.width * 0.8, size.height * 0.2);
    _drawIslamicFlower(canvas, flowerCenter, 12, strokePaint, fillPaint);
    
    // أوراق نباتية
    final leaves = [
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.9),
    ];
    
    for (final leaf in leaves) {
      _drawIslamicLeaf(canvas, leaf, strokePaint, fillPaint);
    }
  }

  void _drawIslamicFlower(Canvas canvas, Offset center, double radius, Paint strokePaint, Paint fillPaint) {
    // رسم زهرة إسلامية بستة بتلات
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final petalCenter = Offset(
        center.dx + (radius * 0.7) * math.cos(angle),
        center.dy + (radius * 0.7) * math.sin(angle),
      );
      
      // بتلة على شكل قطرة
      final path = Path();
      path.addOval(Rect.fromCenter(
        center: petalCenter,
        width: radius * 0.6,
        height: radius * 0.8,
      ));
      
      canvas.save();
      canvas.translate(petalCenter.dx, petalCenter.dy);
      canvas.rotate(angle);
      canvas.translate(-petalCenter.dx, -petalCenter.dy);
      canvas.drawPath(path, strokePaint);
      canvas.restore();
    }
    
    // مركز الزهرة
    canvas.drawCircle(center, radius * 0.3, fillPaint);
  }

  void _drawIslamicLeaf(Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    // رسم ورقة نباتية بشكل إسلامي
    final path = Path();
    
    path.moveTo(position.dx, position.dy);
    path.quadraticBezierTo(
      position.dx + 15, position.dy - 10,
      position.dx + 10, position.dy - 20,
    );
    path.quadraticBezierTo(
      position.dx + 5, position.dy - 15,
      position.dx, position.dy,
    );
    path.quadraticBezierTo(
      position.dx - 5, position.dy - 15,
      position.dx - 10, position.dy - 20,
    );
    path.quadraticBezierTo(
      position.dx - 15, position.dy - 10,
      position.dx, position.dy,
    );
    
    canvas.drawPath(path, strokePaint);
    
    // عرق الورقة
    canvas.drawLine(
      position,
      Offset(position.dx, position.dy - 20),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.color != color;
  }
}