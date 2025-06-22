/// نموذج الاقتباس اليومي
class DailyQuoteModel {
  final String verse;
  final String verseSource;
  final String? verseTheme;
  final String hadith;
  final String hadithSource;
  final String? hadithTheme;

  const DailyQuoteModel({
    required this.verse,
    required this.verseSource,
    this.verseTheme,
    required this.hadith,
    required this.hadithSource,
    this.hadithTheme,
  });

  /// إنشاء من JSON
  factory DailyQuoteModel.fromJson(Map<String, dynamic> json) {
    return DailyQuoteModel(
      verse: json['verse'] ?? '',
      verseSource: json['verse_source'] ?? '',
      verseTheme: json['verse_theme'],
      hadith: json['hadith'] ?? '',
      hadithSource: json['hadith_source'] ?? '',
      hadithTheme: json['hadith_theme'],
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'verse_source': verseSource,
      'verse_theme': verseTheme,
      'hadith': hadith,
      'hadith_source': hadithSource,
      'hadith_theme': hadithTheme,
    };
  }

  /// نسخة معدلة من الكائن
  DailyQuoteModel copyWith({
    String? verse,
    String? verseSource,
    String? verseTheme,
    String? hadith,
    String? hadithSource,
    String? hadithTheme,
  }) {
    return DailyQuoteModel(
      verse: verse ?? this.verse,
      verseSource: verseSource ?? this.verseSource,
      verseTheme: verseTheme ?? this.verseTheme,
      hadith: hadith ?? this.hadith,
      hadithSource: hadithSource ?? this.hadithSource,
      hadithTheme: hadithTheme ?? this.hadithTheme,
    );
  }
}