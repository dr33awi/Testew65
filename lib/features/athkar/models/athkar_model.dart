// lib/features/athkar/models/athkar_model.dart - مُصحح
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

/// نموذج الذكر الفردي
class AthkarItem {
  final int id;
  final String text;
  final int count;
  final String? fadl;
  final String? source;

  const AthkarItem({
    required this.id,
    required this.text,
    required this.count,
    this.fadl,
    this.source,
  });

  factory AthkarItem.fromJson(Map<String, dynamic> json) {
    return AthkarItem(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      count: json['count'] ?? 1,
      fadl: json['fadl'],
      source: json['source'],
    );
  }
}

/// فئة الأذكار
class AthkarCategory {
  final String id;
  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final TimeOfDay? notifyTime;
  final List<AthkarItem> athkar;

  const AthkarCategory({
    required this.id,
    required this.title,
    this.description,
    required this.icon,
    required this.color,
    this.notifyTime,
    required this.athkar,
  });

  factory AthkarCategory.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items = json['athkar'] ?? [];
    return AthkarCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      icon: _iconFromString(json['icon'] ?? '', json['id'] ?? ''),
      color: _colorFromHex(json['color'] ?? '#5D7052'),
      notifyTime: _timeOfDayFromString(json['notify_time']),
      athkar: items.map((e) => AthkarItem.fromJson(e)).toList(),
    );
  }

  static IconData _iconFromString(String data, String categoryId) {
    // ✅ استخدام النظام الموحد للأيقونات
    return AppIconsSystem.getCategoryIcon(categoryId);
  }

  static Color _colorFromHex(String hex) {
    // ✅ استخدام النظام الموحد للألوان مع fallback للـ hex
    try {
      if (hex.isNotEmpty && hex != '#ffffff' && hex != '#000000') {
        final buffer = StringBuffer();
        if (hex.length == 6 || hex.length == 7) buffer.write('ff');
        buffer.write(hex.replaceFirst('#', ''));
        return Color(int.parse(buffer.toString(), radix: 16));
      }
    } catch (e) {
      // في حالة فشل تحويل الـ hex، نستخدم النظام الموحد
    }
    
    // استخدام النظام الموحد كـ fallback
    return AppColorSystem.primary;
  }

  static TimeOfDay? _timeOfDayFromString(String? time) {
    if (time == null) return null;
    try {
      final parts = time.split(':');
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}