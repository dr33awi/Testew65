// lib/features/daily_quote/services/daily_quote_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/daily_quote_model.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

/// خدمة الاقتباسات اليومية
class DailyQuoteService {
  final StorageService _storage;
  final LoggerService _logger;
  
  static const String _dailyQuoteKey = 'daily_quote';
  static const String _lastUpdateKey = 'daily_quote_last_update';
  static const String _quotesJsonPath = 'assets/data/daily_quotes.json';
  static const String _dailyDuaKey = 'daily_dua';
  static const String _favoriteQuotesKey = 'favorite_quotes';
  
  // Cache للبيانات المحملة من JSON
  Map<String, dynamic>? _cachedData;
  bool _isDataLoaded = false;
  
  DailyQuoteService({
    required StorageService storage,
    required LoggerService logger,
  }) : _storage = storage,
       _logger = logger;

  /// تحميل البيانات بشكل مسبق
  Future<void> initializeData() async {
    if (_isDataLoaded) return;
    
    try {
      await _loadJsonData();
      _isDataLoaded = true;
      _logger.info(message: '[DailyQuoteService] تم تهيئة البيانات بنجاح');
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في تهيئة البيانات',
        error: e,
      );
      _loadFallbackData();
      _isDataLoaded = true;
    }
  }

  /// الحصول على الاقتباس اليومي
  Future<DailyQuoteModel> getDailyQuote() async {
    try {
      // تأكد من تحميل البيانات
      await initializeData();
      
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
      
      // إنشاء اقتباس جديد لليوم
      final newQuote = _generateDailyQuote();
      
      // حفظ الاقتباس الجديد
      await _saveQuote(newQuote);
      await _saveLastUpdateDate(today);
      
      _logger.info(message: '[DailyQuoteService] تم إنشاء اقتباس جديد لليوم');
      return newQuote;
      
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في الحصول على الاقتباس اليومي',
        error: e,
      );
      
      // إرجاع اقتباس افتراضي في حالة الخطأ
      return _getDefaultQuote();
    }
  }

  /// توليد seed ثابت بناءً على التاريخ
  int _generateDailySeed(DateTime date) {
    // تكوين seed ثابت لكل يوم
    // نستخدم السنة والشهر واليوم لضمان تغيير النص كل يوم
    final year = date.year;
    final month = date.month;
    final day = date.day;
    
    // تكوين seed بناءً على التاريخ
    return (year * 10000) + (month * 100) + day;
  }

  /// الحصول على اقتباس محدد بالتاريخ (للاختبار)
  Future<DailyQuoteModel> getQuoteForDate(DateTime date) async {
    await initializeData();
    
    if (_cachedData == null) {
      return _getDefaultQuote();
    }
    
    final verses = (_cachedData!['verses'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final hadiths = (_cachedData!['hadiths'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    if (verses.isEmpty || hadiths.isEmpty) {
      return _getDefaultQuote();
    }
    
    // توليد seed للتاريخ المحدد
    final seed = _generateDailySeed(date);
    final random = Random(seed);
    
    final selectedVerse = verses[random.nextInt(verses.length)];
    final selectedHadith = hadiths[random.nextInt(hadiths.length)];
    
    return DailyQuoteModel(
      verse: selectedVerse['text'] ?? '',
      verseSource: selectedVerse['source'] ?? '',
      verseTheme: selectedVerse['theme'],
      hadith: selectedHadith['text'] ?? '',
      hadithSource: selectedHadith['source'] ?? '',
      hadithTheme: selectedHadith['theme'],
    );
  }

  /// تحميل البيانات من ملف JSON
  Future<void> _loadJsonData() async {
    if (_cachedData != null) {
      return; // البيانات محملة مسبقاً
    }
    
    try {
      _logger.info(message: '[DailyQuoteService] جاري تحميل البيانات من JSON');
      
      // قراءة ملف JSON
      final String jsonString = await rootBundle.loadString(_quotesJsonPath);
      final decodedData = json.decode(jsonString);
      
      // التحقق من صحة البيانات
      if (!_validateJsonData(decodedData)) {
        throw Exception('البيانات المحملة غير صالحة');
      }
      
      _cachedData = decodedData;
      
      _logger.info(
        message: '[DailyQuoteService] تم تحميل البيانات بنجاح',
        data: {
          'verses_count': (_cachedData?['verses'] as List?)?.length ?? 0,
          'hadiths_count': (_cachedData?['hadiths'] as List?)?.length ?? 0,
          'duas_count': (_cachedData?['duas'] as List?)?.length ?? 0,
        },
      );
      
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في تحميل البيانات من JSON',
        error: e,
      );
      
      // استخدام بيانات افتراضية في حالة الخطأ
      throw e; // إعادة رمي الخطأ للتعامل معه في المستوى الأعلى
    }
  }

  /// التحقق من صحة البيانات المحملة
  bool _validateJsonData(Map<String, dynamic> data) {
    try {
      final verses = data['verses'] as List?;
      final hadiths = data['hadiths'] as List?;
      final duas = data['duas'] as List?;
      
      if (verses == null || verses.isEmpty) return false;
      if (hadiths == null || hadiths.isEmpty) return false;
      if (duas == null || duas.isEmpty) return false;
      
      // التحقق من صحة العناصر الأساسية
      final firstVerse = verses.first as Map<String, dynamic>?;
      final firstHadith = hadiths.first as Map<String, dynamic>?;
      final firstDua = duas.first as Map<String, dynamic>?;
      
      return firstVerse?['text'] != null &&
             firstVerse?['source'] != null &&
             firstHadith?['text'] != null &&
             firstHadith?['source'] != null &&
             firstDua?['text'] != null &&
             firstDua?['source'] != null;
             
    } catch (e) {
      return false;
    }
  }

  /// تحميل بيانات احتياطية في حالة فشل تحميل JSON
  void _loadFallbackData() {
    _logger.warning(message: '[DailyQuoteService] استخدام البيانات الاحتياطية');
    
    _cachedData = {
      'verses': [
        {
          'text': 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
          'source': 'سورة الطلاق - آية 2-3',
          'translation': 'And whoever fears Allah - He will make for him a way out and provide for him from where he does not expect',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
          'source': 'سورة الشرح - آية 6',
          'translation': 'Indeed, with hardship comes ease',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ ۖ إِنَّهُ لَا يَيْأَسُ مِن رَّوْحِ اللَّهِ إِلَّا الْقَوْمُ الْكَافِرُونَ',
          'source': 'سورة يوسف - آية 87',
          'translation': 'And do not despair of relief from Allah. Indeed, no one despairs of relief from Allah except the disbelieving people',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'وَلَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
          'source': 'سورة إبراهيم - آية 7',
          'translation': 'If you are grateful, I will certainly give you more',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
          'source': 'سورة الرعد - آية 28',
          'translation': 'Unquestionably, by the remembrance of Allah hearts are assured',
          'reference': 'القرآن الكريم'
        },
      ],
      'hadiths': [
        {
          'text': 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
          'source': 'صحيح البخاري',
          'narrator': 'أبو هريرة',
          'reference': 'السنة النبوية'
        },
        {
          'text': 'الْمُؤْمِنُ لِلْمُؤْمِنِ كَالْبُنْيَانِ يَشُدُّ بَعْضُهُ بَعْضًا',
          'source': 'صحيح البخاري',
          'narrator': 'أبو موسى الأشعري',
          'reference': 'السنة النبوية'
        },
        {
          'text': 'بَشِّرُوا وَلَا تُنَفِّرُوا، وَيَسِّرُوا وَلَا تُعَسِّرُوا',
          'source': 'صحيح البخاري',
          'narrator': 'أنس بن مالك',
          'reference': 'السنة النبوية'
        },
        {
          'text': 'مَن كَانَ فِي حَاجَةِ أَخِيهِ كَانَ اللَّهُ فِي حَاجَتِهِ',
          'source': 'صحيح البخاري',
          'narrator': 'عبد الله بن عمر',
          'reference': 'السنة النبوية'
        },
        {
          'text': 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
          'source': 'صحيح البخاري',
          'narrator': 'أنس بن مالك',
          'reference': 'السنة النبوية'
        },
      ],
      'duas': [
        {
          'text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          'source': 'سورة البقرة - آية 201',
          'translation': 'Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
          'source': 'سورة طه - آية 25-26',
          'translation': 'My Lord, expand for me my breast and ease for me my task',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
          'source': 'رواه أبو داود',
          'translation': 'O Allah, help me to remember You, to thank You, and to worship You in the best manner',
          'reference': 'السنة النبوية'
        },
        {
          'text': 'رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا',
          'source': 'سورة البقرة - آية 286',
          'translation': 'Our Lord, do not impose blame upon us if we have forgotten or erred',
          'reference': 'القرآن الكريم'
        },
        {
          'text': 'رَبِّ زِدْنِي عِلْمًا',
          'source': 'سورة طه - آية 114',
          'translation': 'My Lord, increase me in knowledge',
          'reference': 'القرآن الكريم'
        },
      ]
    };
  }

  /// إنشاء اقتباس يومي ثابت لنفس اليوم
  DailyQuoteModel _generateDailyQuote() {
    // التأكد من تحميل البيانات
    if (_cachedData == null) {
      _loadFallbackData();
    }
    
    // استخراج البيانات
    final verses = (_cachedData!['verses'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final hadiths = (_cachedData!['hadiths'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    if (verses.isEmpty || hadiths.isEmpty) {
      return _getDefaultQuote();
    }
    
    // توليد seed ثابت بناءً على التاريخ الحالي
    final today = DateTime.now();
    final seed = _generateDailySeed(today);
    final random = Random(seed);
    
    // اختيار ثابت لنفس اليوم
    final selectedVerse = verses[random.nextInt(verses.length)];
    final selectedHadith = hadiths[random.nextInt(hadiths.length)];
    
    return DailyQuoteModel(
      verse: selectedVerse['text'] ?? '',
      verseSource: selectedVerse['source'] ?? '',
      verseTheme: selectedVerse['theme'],
      hadith: selectedHadith['text'] ?? '',
      hadithSource: selectedHadith['source'] ?? '',
      hadithTheme: selectedHadith['theme'],
    );
  }

  /// الحصول على دعاء يومي ثابت
  Map<String, dynamic> getRandomDua() {
    if (_cachedData == null) {
      _loadFallbackData();
    }
    
    final duas = (_cachedData!['duas'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    if (duas.isEmpty) {
      return {
        'text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        'source': 'سورة البقرة - آية 201',
        'translation': 'Our Lord, give us in this world [that which is] good and in the Hereafter [that which is] good and protect us from the punishment of the Fire',
        'reference': 'القرآن الكريم'
      };
    }
    
    // توليد seed ثابت بناءً على التاريخ الحالي
    final today = DateTime.now();
    final seed = _generateDailySeed(today);
    final random = Random(seed + 1); // +1 لاختلاف بسيط عن الآية والحديث
    
    return duas[random.nextInt(duas.length)];
  }



  /// الحصول على اقتباس افتراضي
  DailyQuoteModel _getDefaultQuote() {
    return const DailyQuoteModel(
      verse: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      verseSource: 'سورة الشرح - آية 6',
      verseTheme: 'الأمل والفرج',
      hadith: 'بَشِّرُوا وَلَا تُنَفِّرُوا، وَيَسِّرُوا وَلَا تُعَسِّرُوا',
      hadithSource: 'صحيح البخاري',
      hadithTheme: 'التبشير والتيسير',
    );
  }

  /// حفظ الاقتباس
  Future<void> _saveQuote(DailyQuoteModel quote) async {
    try {
      await _storage.setMap(_dailyQuoteKey, quote.toJson());
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في حفظ الاقتباس',
        error: e,
      );
    }
  }

  /// الحصول على الاقتباس المحفوظ
  DailyQuoteModel? _getSavedQuote() {
    try {
      final data = _storage.getMap(_dailyQuoteKey);
      if (data != null) {
        return DailyQuoteModel.fromJson(data);
      }
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في قراءة الاقتباس المحفوظ',
        error: e,
      );
    }
    return null;
  }

  /// حفظ تاريخ آخر تحديث
  Future<void> _saveLastUpdateDate(DateTime date) async {
    try {
      await _storage.setString(_lastUpdateKey, date.toIso8601String());
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في حفظ تاريخ التحديث',
        error: e,
      );
    }
  }

  /// الحصول على تاريخ آخر تحديث
  DateTime? _getLastUpdateDate() {
    try {
      final dateString = _storage.getString(_lastUpdateKey);
      if (dateString != null) {
        return DateTime.parse(dateString);
      }
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في قراءة تاريخ آخر تحديث',
        error: e,
      );
    }
    return null;
  }

  /// التحقق من تطابق اليوم
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// تحديث الاقتباس يدويًا (يولد اقتباس جديد بـ seed عشوائي)
  Future<DailyQuoteModel> refreshQuote() async {
    try {
      // إعادة تحميل البيانات من JSON
      _cachedData = null;
      _isDataLoaded = false;
      await initializeData();
      
      // توليد اقتباس جديد بـ seed عشوائي
      final newQuote = _generateRandomQuote();
      await _saveQuote(newQuote);
      await _saveLastUpdateDate(DateTime.now());
      
      _logger.info(message: '[DailyQuoteService] تم تحديث الاقتباس يدويًا');
      return newQuote;
    } catch (e) {
      _logger.error(
        message: '[DailyQuoteService] خطأ في تحديث الاقتباس',
        error: e,
      );
      return _getDefaultQuote();
    }
  }

  /// توليد اقتباس عشوائي (للتحديث اليدوي)
  DailyQuoteModel _generateRandomQuote() {
    if (_cachedData == null) {
      _loadFallbackData();
    }
    
    final verses = (_cachedData!['verses'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final hadiths = (_cachedData!['hadiths'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    if (verses.isEmpty || hadiths.isEmpty) {
      return _getDefaultQuote();
    }
    
    // استخدام seed عشوائي للتحديث اليدوي
    final random = Random();
    
    final selectedVerse = verses[random.nextInt(verses.length)];
    final selectedHadith = hadiths[random.nextInt(hadiths.length)];
    
    return DailyQuoteModel(
      verse: selectedVerse['text'] ?? '',
      verseSource: selectedVerse['source'] ?? '',
      verseTheme: selectedVerse['theme'],
      hadith: selectedHadith['text'] ?? '',
      hadithSource: selectedHadith['source'] ?? '',
      hadithTheme: selectedHadith['theme'],
    );
  }



  /// إعادة تعيين الكاش
  void clearCache() {
    _cachedData = null;
    _isDataLoaded = false;
    _logger.info(message: '[DailyQuoteService] تم مسح الكاش');
  }

  /// التحقق من حالة التحميل
  bool get isDataLoaded => _isDataLoaded;
  
  /// التحقق من وجود البيانات
  bool get hasData => _cachedData != null;
}