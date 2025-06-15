// lib/features/athkar/models/athkar_model.dart
import 'package:flutter/material.dart';

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
      icon: _iconFromString(json['icon'] ?? ''),
      color: _colorFromHex(json['color'] ?? '#ffffff'),
      notifyTime: _timeOfDayFromString(json['notify_time']),
      athkar: items.map((e) => AthkarItem.fromJson(e)).toList(),
    );
  }

  static IconData _iconFromString(String data) {
    switch (data) {
      case 'Icons.wb_sunny':
        return Icons.wb_sunny;
      case 'Icons.nights_stay':
        return Icons.nights_stay;
      default:
        return Icons.auto_awesome;
    }
  }

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static TimeOfDay? _timeOfDayFromString(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }
}
