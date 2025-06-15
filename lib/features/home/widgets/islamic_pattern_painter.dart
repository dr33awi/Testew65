// lib/features/home/widgets/islamic_pattern_painter.dart
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
      ..strokeWidth = 1.0;

    final double spacing = 80;
    final double rotation = animation * 2 * math.pi;

    // رسم شبكة من النجوم الإسلامية
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        canvas.save();
        canvas.translate(x, y);
        
        // دوران بطيء للنمط
        canvas.rotate(rotation * 0.1);
        
        // رسم نجمة ثمانية مع زخارف
        _drawComplexIslamicPattern(canvas, paint, 30);
        
        canvas.restore();
      }
    }
    
    // إضافة نمط ثانوي
    for (double x = spacing / 2; x < size.width + spacing; x += spacing) {
      for (double y = spacing / 2; y < size.height + spacing; y += spacing) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(-rotation * 0.05);
        
        _drawSecondaryPattern(canvas, paint.copyWith()..color = color.withOpacity(0.5), 20);
        
        canvas.restore();
      }
    }
  }

  void _drawComplexIslamicPattern(Canvas canvas, Paint paint, double radius) {
    // النجمة الثمانية الأساسية
    _drawIslamicStar(canvas, paint, radius, 8);
    
    // دائرة مركزية
    canvas.drawCircle(Offset.zero, radius / 3, paint);
    
    // زخارف إضافية
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final x = radius * 0.7 * math.cos(angle);
      final y = radius * 0.7 * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), radius / 6, paint);
    }
    
    // خطوط شعاعية
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi / 8);
      final start = Offset(
        radius * 0.4 * math.cos(angle),
        radius * 0.4 * math.sin(angle),
      );
      final end = Offset(
        radius * 0.6 * math.cos(angle),
        radius * 0.6 * math.sin(angle),
      );
      
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawSecondaryPattern(Canvas canvas, Paint paint, double radius) {
    // نمط الأرابيسك
    final path = Path();
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // زخرفة داخلية
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) + (math.pi / 6);
      final innerRadius = radius * 0.5;
      final x = innerRadius * math.cos(angle);
      final y = innerRadius * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), radius / 8, paint);
    }
  }

  void _drawIslamicStar(Canvas canvas, Paint paint, double radius, int points) {
    final path = Path();
    final angle = (2 * math.pi) / points;
    
    for (int i = 0; i < points; i++) {
      final outerX = radius * math.cos(i * angle - math.pi / 2);
      final outerY = radius * math.sin(i * angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      
      // نقطة داخلية
      final innerAngle = (i + 0.5) * angle - math.pi / 2;
      final innerRadius = radius * 0.5;
      final innerX = innerRadius * math.cos(innerAngle);
      final innerY = innerRadius * math.sin(innerAngle);
      
      path.lineTo(innerX, innerY);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  Paint copyWith() => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.color != color;
  }
}

extension on Paint {
  copyWith() {}
}