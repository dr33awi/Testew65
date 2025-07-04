// lib/features/tasbih/widgets/tasbih_pattern_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// رسام الأنماط الزخرفية لخلفية المسبحة
class TasbihPatternPainter extends CustomPainter {
  final double rotation;
  final Color color;

  TasbihPatternPainter({
    required this.rotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    
    // حفظ حالة الـ Canvas
    canvas.save();
    
    // تطبيق الدوران من المركز
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);
    
    // رسم النمط الإسلامي المتحرك
    _drawRotatingPattern(canvas, size, paint, fillPaint);
    
    // استعادة حالة الـ Canvas
    canvas.restore();
    
    // رسم عناصر ثابتة
    _drawStaticElements(canvas, size, paint);
  }

  void _drawRotatingPattern(Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // رسم دوائر متحدة المركز
    for (int i = 1; i <= 4; i++) {
      final radius = 50.0 + (i * 40);
      
      // دوائر منقطة
      _drawDottedCircle(canvas, centerX, centerY, radius, strokePaint);
      
      // نجوم على محيط الدوائر
      _drawStarsOnCircle(canvas, centerX, centerY, radius, 8, fillPaint);
    }
    
    // خطوط شعاعية
    _drawRadialLines(canvas, centerX, centerY, strokePaint);
  }

  void _drawDottedCircle(Canvas canvas, double centerX, double centerY, double radius, Paint paint) {
    const int dots = 60;
    const double dotSize = 2.0;
    
    for (int i = 0; i < dots; i++) {
      final angle = (i * 2 * math.pi) / dots;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      
      if (i % 3 == 0) { // رسم نقطة كل 3 مواضع
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  void _drawStarsOnCircle(Canvas canvas, double centerX, double centerY, double radius, int count, Paint paint) {
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * math.pi) / count;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      
      _drawStar(canvas, Offset(x, y), 6, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    const int points = 8;
    final path = Path();
    
    for (int i = 0; i < points; i++) {
      final outerAngle = (i * 2 * math.pi) / points - math.pi / 2;
      final innerAngle = ((i + 0.5) * 2 * math.pi) / points - math.pi / 2;
      
      final outerRadius = size;
      final innerRadius = size * 0.5;
      
      final outerX = center.dx + outerRadius * math.cos(outerAngle);
      final outerY = center.dy + outerRadius * math.sin(outerAngle);
      
      final innerX = center.dx + innerRadius * math.cos(innerAngle);
      final innerY = center.dy + innerRadius * math.sin(innerAngle);
      
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

  void _drawRadialLines(Canvas canvas, double centerX, double centerY, Paint paint) {
    const int lines = 12;
    const double innerRadius = 80;
    const double outerRadius = 200;
    
    for (int i = 0; i < lines; i++) {
      final angle = (i * 2 * math.pi) / lines;
      
      final startX = centerX + innerRadius * math.cos(angle);
      final startY = centerY + innerRadius * math.sin(angle);
      
      final endX = centerX + outerRadius * math.cos(angle);
      final endY = centerY + outerRadius * math.sin(angle);
      
      // رسم خط متقطع
      _drawDashedLine(canvas, Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const double dashLength = 8.0;
    const double gapLength = 6.0;
    
    final distance = (end - start).distance;
    final dashCount = (distance / (dashLength + gapLength)).floor();
    
    for (int i = 0; i < dashCount; i++) {
      final startProgress = (i * (dashLength + gapLength)) / distance;
      final endProgress = (i * (dashLength + gapLength) + dashLength) / distance;
      
      final dashStart = Offset.lerp(start, end, startProgress)!;
      final dashEnd = Offset.lerp(start, end, endProgress)!;
      
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  void _drawStaticElements(Canvas canvas, Size size, Paint paint) {
    // عناصر ثابتة في الزوايا
    final corners = [
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.9, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.9, size.height * 0.9),
    ];
    
    for (final corner in corners) {
      _drawCornerOrnament(canvas, corner, paint);
    }
  }

  void _drawCornerOrnament(Canvas canvas, Offset position, Paint paint) {
    // رسم زخرفة في الزاوية
    final path = Path();
    
    // شكل هلالي بسيط
    path.moveTo(position.dx, position.dy);
    path.quadraticBezierTo(
      position.dx + 15, position.dy - 5,
      position.dx + 20, position.dy + 10,
    );
    path.quadraticBezierTo(
      position.dx + 5, position.dy + 15,
      position.dx, position.dy,
    );
    
    canvas.drawPath(path, paint);
    
    // نقاط زخرفية
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(position.dx + (i * 8), position.dy + 25),
        1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TasbihPatternPainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.color != color;
  }
}