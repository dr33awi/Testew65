// lib/features/tasbih/widgets/tasbih_bead_widget.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

/// ويدجت حبة المسبحة الرقمية
class TasbihBeadWidget extends StatelessWidget {
  final double size;
  final List<Color> gradient;
  final bool isPressed;
  final Widget child;

  const TasbihBeadWidget({
    super.key,
    required this.size,
    required this.gradient,
    required this.isPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPressed 
              ? gradient.map((c) => c.darken(0.1)).toList()
              : gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: 0.3),
            blurRadius: isPressed ? 25 : 20,
            offset: Offset(0, isPressed ? 8 : 12),
            spreadRadius: isPressed ? 2 : 4,
          ),
          BoxShadow(
            color: gradient[1].withValues(alpha: 0.1),
            blurRadius: isPressed ? 35 : 30,
            offset: Offset(0, isPressed ? 12 : 18),
            spreadRadius: isPressed ? 4 : 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}