// lib/features/athkar/models/athkar_stats.dart
/// نموذج إحصائيات الأذكار
class AthkarStats {
  int totalCompleted;
  final Map<String, int> dailyStats; // date -> count
  final Map<String, int> categoryStats; // categoryId -> count
  DateTime lastUpdated;

  AthkarStats({
    required this.totalCompleted,
    required this.dailyStats,
    required this.categoryStats,
    required this.lastUpdated,
  });

  factory AthkarStats.fromJson(Map<String, dynamic> json) {
    return AthkarStats(
      totalCompleted: json['totalCompleted'] ?? 0,
      dailyStats: Map<String, int>.from(json['dailyStats'] ?? {}),
      categoryStats: Map<String, int>.from(json['categoryStats'] ?? {}),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalCompleted': totalCompleted,
    'dailyStats': dailyStats,
    'categoryStats': categoryStats,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  /// الحصول على عدد الأذكار المكتملة في يوم معين
  int getCompletedForDate(DateTime date) {
    final dateKey = date.toIso8601String().split('T')[0];
    return dailyStats[dateKey] ?? 0;
  }

  /// الحصول على عدد الأذكار المكتملة لفئة معينة
  int getCompletedForCategory(String categoryId) {
    return categoryStats[categoryId] ?? 0;
  }

  /// الحصول على متوسط الأذكار اليومية
  double getDailyAverage() {
    if (dailyStats.isEmpty) return 0;
    final total = dailyStats.values.reduce((a, b) => a + b);
    return total / dailyStats.length;
  }

  /// الحصول على أكثر فئة استخداماً
  String? getMostUsedCategory() {
    if (categoryStats.isEmpty) return null;
    
    return categoryStats.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}