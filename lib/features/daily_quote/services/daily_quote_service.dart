// lib/features/daily_quote/services/daily_quote_service.dart (محدث)

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/daily_quote_model.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

/// خدمة الاقتباسات اليومية المحدثة
class DailyQuoteService {
  final StorageService _storage;
  final LoggerService _logger;
  
  static const String _dailyQuoteKey = 'daily_quote';
  static const String _lastUpdateKey = 'daily_quote_last_update';
  static const String _quotesJsonPath = 'assets/data/daily_quotes.json';
  
  // Cache للبيانات المحملة من JSON
  List<Map<String, dynamic>>? _cachedVerses;
  List<Map<String, dynamic>>? _cachedHadiths;
  List<Map<String, dynamic>>? _cachedDuas;
  Map<String, dynamic>? _metadata;
  
  DailyQuoteService({
    required StorageService storage,
    required LoggerService logger,
  }) : _storage = storage,
       _logger = logger;

  /// الحصول على الاقتباس اليومي
  Future<DailyQuoteModel> getDailyQuote() async {
    try {
      _logger.debug(message: '[DailyQuoteService] بدء تحميل الاقتباس اليومي');
      
      // التحقق من وجود اقتباس محفوظ لليوم
      final today = DateTime.now();
      final lastUpdate = _getLastUpdateDate();
      
      if (lastUpdate != null && _isSameDay(lastUpdate, today)) {
        // إرجاع الاقتباس المحفوظ إذا كان لنفس اليوم
        final savedQuote = _getSavedQuote();
        if (savedQuote != null) {
          _logger.info(message: '[DailyQuoteService] تم إرجاع الاقتباس المحفوظ');
          return savedQuote;
        }
      }
      
      // تحميل البيانات من JSON إذا لم تكن محملة
      await _loadJsonData();
      
      // إنشاء اقتباس جديد لليوم
      final newQuote = _generateDailyQuote();
      
      // حفظ الاقتباس الجديد
      await _saveQuote(newQuote);
      await _saveLastUpdateDate(today);
      
      _logger.info(message: '[DailyQuoteService] تم إنشاء اقتباس جديد لليوم');
      return newQuote;
      
    } catch (e, stackTrace) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في الحصول على الاقتباس اليومي',
        error: e,
        stackTrace: stackTrace,
      );
      
      // إرجاع اقتباس افتراضي في حالة الخطأ
      return _getDefaultQuote();
    }
  }

  /// تحميل البيانات من ملف JSON
  Future<void> _loadJsonData() async {
    if (_cachedVerses != null && _cachedHadiths != null && _cachedDuas != null) {
      _logger.debug(message: '[DailyQuoteService] البيانات محملة مسبقاً في الكاش');
      return; // البيانات محملة مسبقاً
    }
    
    try {
      _logger.info(message: '[DailyQuoteService] جاري تحميل البيانات من JSON');
      
      // قراءة ملف JSON
      final String jsonString = await rootBundle.loadString(_quotesJsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // استخراج البيانات
      _cachedVerses = List<Map<String, dynamic>>.from(jsonData['verses'] ?? []);
      _cachedHadiths = List<Map<String, dynamic>>.from(jsonData['hadiths'] ?? []);
      _cachedDuas = List<Map<String, dynamic>>.from(jsonData['duas'] ?? []);
      _metadata = jsonData['metadata'];
      
      _logger.info(
        message: '[DailyQuoteService] تم تحميل البيانات بنجاح',
        data: {
          'verses_count': _cachedVerses?.length,
          'hadiths_count': _cachedHadiths?.length,
          'duas_count': _cachedDuas?.length,
          'version': _metadata?['version'],
        },
      );
      
      // التحقق من سلامة البيانات
      if (_cachedVerses!.isEmpty || _cachedHadiths!.isEmpty) {
        throw Exception('البيانات المحملة فارغة أو غير صحيحة');
      }
      
    } catch (e, stackTrace) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في تحميل البيانات من JSON',
        error: e,
        stackTrace: stackTrace,
      );
      
      // استخدام بيانات افتراضية في حالة الخطأ
      _loadFallbackData();
    }
  }

  /// تحميل بيانات احتياطية في حالة فشل تحميل JSON
  void _loadFallbackData() {
    _logger.warning(message: '[DailyQuoteService] استخدام البيانات الاحتياطية');
    
    _cachedVerses = [
      {
        'text': 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
        'source': 'سورة الطلاق - آية 2-3',
        'translation': 'ومن يتق الله يجعل له مخرجا ويرزقه من حيث لا يحتسب',
        'reference': 'القرآن الكريم',
        'theme': 'التقوى والرزق'
      },
      {
        'text': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
        'source': 'سورة الشرح - آية 6',
        'translation': 'إن مع العسر يسرا',
        'reference': 'القرآن الكريم',
        'theme': 'الأمل والتفاؤل'
      },
      {
        'text': 'وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ ۖ إِنَّهُ لَا يَيْأَسُ مِن رَّوْحِ اللَّهِ إِلَّا الْقَوْمُ الْكَافِرُونَ',
        'source': 'سورة يوسف - آية 87',
        'translation': 'ولا تيأسوا من روح الله إنه لا ييأس من روح الله إلا القوم الكافرون',
        'reference': 'القرآن الكريم',
        'theme': 'عدم اليأس'
      },
    ];
    
    _cachedHadiths = [
      {
        'text': 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
        'source': 'صحيح البخاري',
        'narrator': 'أبو هريرة رضي الله عنه',
        'reference': 'السنة النبوية',
        'theme': 'التسبيح والتحميد'
      },
      {
        'text': 'الْمُؤْمِنُ لِلْمُؤْمِنِ كَالْبُنْيَانِ يَشُدُّ بَعْضُهُ بَعْضًا',
        'source': 'صحيح البخاري',
        'narrator': 'أبو موسى الأشعري رضي الله عنه',
        'reference': 'السنة النبوية',
        'theme': 'التعاون والتكافل'
      },
      {
        'text': 'بَشِّرُوا وَلَا تُنَفِّرُوا، وَيَسِّرُوا وَلَا تُعَسِّرُوا',
        'source': 'صحيح البخاري',
        'narrator': 'أنس بن مالك رضي الله عنه',
        'reference': 'السنة النبوية',
        'theme': 'التبشير والتيسير'
      },
    ];
    
    _cachedDuas = [
      {
        'text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        'source': 'سورة البقرة - آية 201',
        'translation': 'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار',
        'reference': 'القرآن الكريم',
        'theme': 'دعاء جامع'
      },
      {
        'text': 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
        'source': 'سورة طه - آية 25-26',
        'translation': 'رب اشرح لي صدري ويسر لي أمري',
        'reference': 'القرآن الكريم',
        'theme': 'دعاء التيسير'
      },
      {
        'text': 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
        'source': 'رواه أبو داود',
        'translation': 'اللهم أعني على ذكرك وشكرك وحسن عبادتك',
        'reference': 'السنة النبوية',
        'theme': 'دعاء الذكر والشكر'
      },
    ];

    _metadata = {
      'version': '1.0.0-fallback',
      'last_updated': DateTime.now().toIso8601String(),
      'total_verses': _cachedVerses!.length,
      'total_hadiths': _cachedHadiths!.length,
      'total_duas': _cachedDuas!.length,
    };
  }

  /// إنشاء اقتباس يومي باستخدام seed مبني على التاريخ للحصول على نفس الاقتباس كل يوم
  DailyQuoteModel _generateDailyQuote() {
    // التأكد من تحميل البيانات
    if (_cachedVerses == null || _cachedHadiths == null || _cachedDuas == null) {
      _loadFallbackData();
    }
    
    // استخدام التاريخ كـ seed للحصول على نفس الاقتباس كل يوم
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(seed);
    
    // اختيار عشوائي مبني على التاريخ
    final selectedVerse = _cachedVerses![random.nextInt(_cachedVerses!.length)];
    final selectedHadith = _cachedHadiths![random.nextInt(_cachedHadiths!.length)];
    
    _logger.debug(
      message: '[DailyQuoteService] تم اختيار اقتباس جديد',
      data: {
        'verse_theme': selectedVerse['theme'],
        'hadith_theme': selectedHadith['theme'],
        'date_seed': seed,
      }
    );
    
    return DailyQuoteModel(
      verse: selectedVerse['text'] ?? '',
      verseSource: selectedVerse['source'] ?? '',
      hadith: selectedHadith['text'] ?? '',
      hadithSource: selectedHadith['source'] ?? '',
    );
  }

  /// الحصول على اقتباس افتراضي
  DailyQuoteModel _getDefaultQuote() {
    _logger.info(message: '[DailyQuoteService] استخدام الاقتباس الافتراضي');
    return const DailyQuoteModel(
      verse: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      verseSource: 'سورة الشرح - آية 6',
      hadith: 'بَشِّرُوا وَلَا تُنَفِّرُوا، وَيَسِّرُوا وَلَا تُعَسِّرُوا',
      hadithSource: 'صحيح البخاري',
    );
  }

  /// حفظ الاقتباس
  Future<void> _saveQuote(DailyQuoteModel quote) async {
    try {
      await _storage.setMap(_dailyQuoteKey, quote.toJson());
      _logger.debug(message: '[DailyQuoteService] تم حفظ الاقتباس');
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في حفظ الاقتباس',
        error: e,
      );
    }
  }

  /// الحصول على الاقتباس المحفوظ
  DailyQuoteModel? _getSavedQuote() {
    final data = _storage.getMap(_dailyQuoteKey);
    if (data != null) {
      try {
        return DailyQuoteModel.fromJson(data);
      } catch (e) {
        _logger.error(
          message: '[DailyQuoteService] خطأ في قراءة الاقتباس المحفوظ',
          error: e,
        );
      }
    }
    return null;
  }

  /// حفظ تاريخ آخر تحديث
  Future<void> _saveLastUpdateDate(DateTime date) async {
    try {
      await _storage.setString(_lastUpdateKey, date.toIso8601String());
      _logger.debug(
        message: '[DailyQuoteService] تم حفظ تاريخ التحديث',
        data: {'date': date.toIso8601String()},
      );
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في حفظ تاريخ التحديث',
        error: e,
      );
    }
  }

  /// الحصول على تاريخ آخر تحديث
  DateTime? _getLastUpdateDate() {
    final dateString = _storage.getString(_lastUpdateKey);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        _logger.error(
          message: '[DailyQuoteService] خطأ في قراءة تاريخ آخر تحديث',
          error: e,
        );
      }
    }
    return null;
  }

  /// التحقق من تطابق اليوم
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// تحديث الاقتباس يدويًا (إجبار اقتباس جديد)
  Future<DailyQuoteModel> refreshQuote() async {
    try {
      _logger.info(message: '[DailyQuoteService] بدء التحديث اليدوي للاقتباس');
      
      // إعادة تحميل البيانات من JSON
      await _loadJsonData();
      
      // إنشاء اقتباس جديد عشوائي (بدون استخدام seed التاريخ)
      final random = Random();
      final selectedVerse = _cachedVerses![random.nextInt(_cachedVerses!.length)];
      final selectedHadith = _cachedHadiths![random.nextInt(_cachedHadiths!.length)];
      
      final newQuote = DailyQuoteModel(
        verse: selectedVerse['text'] ?? '',
        verseSource: selectedVerse['source'] ?? '',
        hadith: selectedHadith['text'] ?? '',
        hadithSource: selectedHadith['source'] ?? '',
      );
      
      await _saveQuote(newQuote);
      await _saveLastUpdateDate(DateTime.now());
      
      _logger.info(message: '[DailyQuoteService] تم تحديث الاقتباس يدويًا بنجاح');
      return newQuote;
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في تحديث الاقتباس',
        error: e,
      );
      return _getDefaultQuote();
    }
  }

  /// مسح الاقتباسات المحفوظة
  Future<void> clearSavedQuotes() async {
    try {
      await _storage.remove(_dailyQuoteKey);
      await _storage.remove(_lastUpdateKey);
      _logger.info(message: '[DailyQuoteService] تم مسح الاقتباسات المحفوظة');
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في مسح الاقتباسات',
        error: e,
      );
    }
  }

  /// إعادة تحميل البيانات من JSON
  Future<void> reloadJsonData() async {
    try {
      _logger.info(message: '[DailyQuoteService] إعادة تحميل البيانات من JSON');
      _cachedVerses = null;
      _cachedHadiths = null;
      _cachedDuas = null;
      _metadata = null;
      await _loadJsonData();
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في إعادة تحميل البيانات',
        error: e,
      );
    }
  }

  /// الحصول على إحصائيات البيانات المحملة
  Map<String, int> getDataStats() {
    return {
      'verses': _cachedVerses?.length ?? 0,
      'hadiths': _cachedHadiths?.length ?? 0,
      'duas': _cachedDuas?.length ?? 0,
    };
  }

  /// الحصول على معلومات الإصدار
  Map<String, dynamic>? getMetadata() {
    return _metadata;
  }

  /// الحصول على اقتباس محدد بالفهرس (للاختبار والمعاينة)
  Future<DailyQuoteModel> getQuoteByIndex({
    required int verseIndex,
    required int hadithIndex,
  }) async {
    await _loadJsonData();
    
    if (_cachedVerses == null || _cachedHadiths == null) {
      return _getDefaultQuote();
    }
    
    final verse = _cachedVerses![verseIndex % _cachedVerses!.length];
    final hadith = _cachedHadiths![hadithIndex % _cachedHadiths!.length];
    
    _logger.debug(
      message: '[DailyQuoteService] تم إنشاء اقتباس بالفهرس',
      data: {
        'verse_index': verseIndex,
        'hadith_index': hadithIndex,
      }
    );
    
    return DailyQuoteModel(
      verse: verse['text'] ?? '',
      verseSource: verse['source'] ?? '',
      hadith: hadith['text'] ?? '',
      hadithSource: hadith['source'] ?? '',
    );
  }

  /// الحصول على قائمة كل الآيات (للعرض)
  Future<List<Map<String, dynamic>>> getAllVerses() async {
    await _loadJsonData();
    return _cachedVerses ?? [];
  }

  /// الحصول على قائمة كل الأحاديث (للعرض)
  Future<List<Map<String, dynamic>>> getAllHadiths() async {
    await _loadJsonData();
    return _cachedHadiths ?? [];
  }

  /// الحصول على قائمة كل الأدعية (للعرض)
  Future<List<Map<String, dynamic>>> getAllDuas() async {
    await _loadJsonData();
    return _cachedDuas ?? [];
  }

  /// البحث في جميع النصوص
  Future<List<Map<String, dynamic>>> searchQuotes(String query) async {
    if (query.trim().isEmpty) return [];
    
    await _loadJsonData();
    
    final results = <Map<String, dynamic>>[];
    final normalizedQuery = query.toLowerCase().trim();
    
    // البحث في الآيات
    for (final verse in _cachedVerses ?? []) {
      if (_containsQuery(verse, normalizedQuery)) {
        results.add({...verse, 'type': 'verse'});
      }
    }
    
    // البحث في الأحاديث
    for (final hadith in _cachedHadiths ?? []) {
      if (_containsQuery(hadith, normalizedQuery)) {
        results.add({...hadith, 'type': 'hadith'});
      }
    }
    
    // البحث في الأدعية
    for (final dua in _cachedDuas ?? []) {
      if (_containsQuery(dua, normalizedQuery)) {
        results.add({...dua, 'type': 'dua'});
      }
    }
    
    _logger.info(
      message: '[DailyQuoteService] نتائج البحث',
      data: {
        'query': query,
        'results_count': results.length,
      }
    );
    
    return results;
  }

  /// التحقق من وجود النص في العنصر
  bool _containsQuery(Map<String, dynamic> item, String query) {
    final searchableFields = ['text', 'translation', 'theme', 'source', 'narrator'];
    
    for (final field in searchableFields) {
      final value = item[field];
      if (value != null && value.toString().toLowerCase().contains(query)) {
        return true;
      }
    }
    
    return false;
  }

  /// التحقق من حالة التحميل
  bool get isDataLoaded => _cachedVerses != null && _cachedHadiths != null && _cachedDuas != null;

  /// التحقق من صحة البيانات
  bool get isDataValid => 
      isDataLoaded && 
      _cachedVerses!.isNotEmpty && 
      _cachedHadiths!.isNotEmpty;
}