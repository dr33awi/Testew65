// lib/features/home/models/daily_quote_model.dart

/// نموذج الاقتباس اليومي
class DailyQuoteModel {
  final String verse;
  final String verseSource;
  final String hadith;
  final String hadithSource;
  
  const DailyQuoteModel({
    required this.verse,
    required this.verseSource,
    required this.hadith,
    required this.hadithSource,
  });
  
  /// إنشاء من JSON
  factory DailyQuoteModel.fromJson(Map<String, dynamic> json) {
    return DailyQuoteModel(
      verse: json['verse'] ?? '',
      verseSource: json['verse_source'] ?? '',
      hadith: json['hadith'] ?? '',
      hadithSource: json['hadith_source'] ?? '',
    );
  }
  
  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'verse_source': verseSource,
      'hadith': hadith,
      'hadith_source': hadithSource,
    };
  }
  
  /// نسخ مع تعديل
  DailyQuoteModel copyWith({
    String? verse,
    String? verseSource,
    String? hadith,
    String? hadithSource,
  }) {
    return DailyQuoteModel(
      verse: verse ?? this.verse,
      verseSource: verseSource ?? this.verseSource,
      hadith: hadith ?? this.hadith,
      hadithSource: hadithSource ?? this.hadithSource,
    );
  }
}