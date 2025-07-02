// lib/features/athkar/models/athkar_model.dart - الإصدار المُصلح

import 'package:flutter/material.dart';

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
      color: _colorFromHex(json['color'] ?? '#5D7052'),
      notifyTime: _timeOfDayFromString(json['notify_time']),
      athkar: items.map((e) => AthkarItem.fromJson(e)).toList(),
    );
  }

  // ✅ إصلاح تحليل الأيقونات لتتطابق مع ملف JSON
  static IconData _iconFromString(String iconString) {
    // إزالة "Icons." من النص
    final cleanIcon = iconString.replaceAll('Icons.', '');
    
    switch (cleanIcon) {
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'nightlight_round':
        return Icons.nightlight_round;
      case 'bedtime':
        return Icons.bedtime;
      case 'alarm':
        return Icons.alarm;
      case 'mosque':
        return Icons.mosque;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'menu_book':
        return Icons.menu_book;
      // إضافة المزيد حسب ملف JSON
      default:
        print('⚠️ أيقونة غير معروفة: $iconString');
        return Icons.auto_awesome; // أيقونة افتراضية
    }
  }

  // ✅ إصلاح تحليل الألوان
  static Color _colorFromHex(String hex) {
    try {
      // إزالة # إذا كانت موجودة
      hex = hex.replaceAll('#', '');
      
      // إضافة FF للشفافية إذا لم تكن موجودة
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      print('⚠️ خطأ في تحليل اللون: $hex');
      return const Color(0xFF5D7052); // لون افتراضي
    }
  }

  static TimeOfDay? _timeOfDayFromString(String? time) {
    if (time == null || time.isEmpty) return null;
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