// lib/features/athkar/models/athkar_progress.dart
/// نموذج تقدم الأذكار
class AthkarProgress {
  final String categoryId;
  final Map<int, int> itemProgress; // itemId -> count
  DateTime lastUpdated;

  AthkarProgress({
    required this.categoryId,
    required this.itemProgress,
    required this.lastUpdated,
  });

  factory AthkarProgress.fromJson(Map<String, dynamic> json) {
    return AthkarProgress(
      categoryId: json['categoryId'],
      itemProgress: (json['itemProgress'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(int.parse(k), v as int),
      ) ?? {},
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'itemProgress': itemProgress.map((k, v) => MapEntry(k.toString(), v)),
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}