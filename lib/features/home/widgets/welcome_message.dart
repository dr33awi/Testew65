// lib/features/home/widgets/welcome_message.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final icon = _getIcon(hour);
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getGradientColors(hour),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: _getGradientColors(hour)[0].withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ThemeConstants.iconLg,
            ),
          ),
          ThemeConstants.space3.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: context.titleLarge?.semiBold,
                ),
                Text(
                  message,
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) {
      return 'أهلاً بك';
    } else if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return 'أهلاً بك';
    } else if (hour < 20) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير';
    }
  }

  String _getMessage(int hour) {
    if (hour < 5) {
      return 'حان وقت صلاة قيام الليل';
    } else if (hour < 10) {
      return 'لا تنس أذكار الصباح';
    } else if (hour < 14) {
      return 'وقت مناسب لقراءة القرآن';
    } else if (hour < 17) {
      return 'لا تنس أذكار المساء';
    } else if (hour < 20) {
      return 'وقت الدعاء والاستغفار';
    } else {
      return 'لا تنس أذكار النوم';
    }
  }

  IconData _getIcon(int hour) {
    if (hour < 5) {
      return Icons.nights_stay;
    } else if (hour < 12) {
      return Icons.wb_sunny;
    } else if (hour < 17) {
      return Icons.wb_twilight;
    } else if (hour < 20) {
      return Icons.wb_twilight_sharp;
    } else {
      return Icons.nightlight_round;
    }
  }

  List<Color> _getGradientColors(int hour) {
    if (hour < 5) {
      return [const Color(0xFF1F1C2C), const Color(0xFF928DAB)]; // ليل
    } else if (hour < 8) {
      return [const Color(0xFF4A90E2), const Color(0xFF7B68EE)]; // فجر
    } else if (hour < 12) {
      return [const Color(0xFFFFD700), const Color(0xFFFFA000)]; // صباح
    } else if (hour < 17) {
      return [const Color(0xFFFF8C00), const Color(0xFFFF6347)]; // ظهر
    } else if (hour < 20) {
      return [const Color(0xFFFF7043), const Color(0xFF9C27B0)]; // مغرب
    } else {
      return [const Color(0xFF3F51B5), const Color(0xFF1A237E)]; // ليل
    }
  }
}