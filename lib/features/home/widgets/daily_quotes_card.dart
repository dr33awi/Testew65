// lib/features/home/widgets/daily_quotes_card.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:athkar_app/features/home/widgets/islamic_pattern_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:convert';
import '../../../app/themes/app_theme.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> {
  late PageController _pageController;
  
  int _currentPage = 0;
  List<QuoteData> quotes = [];
  Map<String, dynamic> quotesData = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuotesData();
  }

  void _loadQuotesData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // تحميل البيانات من ملف JSON
      final String jsonString = await rootBundle.loadString('assets/data/daily_quotes.json');
      quotesData = jsonDecode(jsonString);
      
      await _generateDailyQuotes();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'خطأ في تحميل الاقتباسات: ${e.toString()}';
      });
      
      // استخدام بيانات افتراضية في حالة الخطأ
      _loadFallbackData();
    }
  }

  void _loadFallbackData() {
    // بيانات احتياطية في حالة فشل تحميل الملف
    quotesData = {
      "verses": [
        {
          "text": "وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ",
          "source": "سورة الطلاق - آية 2-3",
          "theme": "التقوى والرزق",
          "reference": "القرآن الكريم"
        },
        {
          "text": "إِنَّ مَعَ الْعُسْرِ يُسْرًا",
          "source": "سورة الشرح - آية 6",
          "theme": "الأمل والفرج",
          "reference": "القرآن الكريم"
        }
      ],
      "hadiths": [
        {
          "text": "مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ",
          "source": "صحيح البخاري",
          "narrator": "أبو هريرة",
          "theme": "التسبيح ومغفرة الذنوب",
          "reference": "السنة النبوية"
        }
      ],
      "duas": [
        {
          "text": "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
          "source": "سورة البقرة - آية 201",
          "theme": "دعاء شامل",
          "reference": "القرآن الكريم"
        }
      ]
    };
    
    _generateDailyQuotes();
  }

  Future<void> _generateDailyQuotes() async {
    quotes.clear();

    try {
      // الحصول على التاريخ الحالي
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
      
      // إنشاء seed فريد لكل يوم
      final dailySeed = now.year * 1000 + dayOfYear;
      final random = math.Random(dailySeed);

      // اختيار آية ثابتة لليوم
      final verses = quotesData['verses'] as List;
      if (verses.isNotEmpty) {
        final verseIndex = random.nextInt(verses.length);
        final selectedVerse = verses[verseIndex];
        quotes.add(QuoteData(
          type: QuoteType.verse,
          content: selectedVerse['text'],
          source: selectedVerse['source'],
          theme: selectedVerse['theme'],
          gradient: ColorHelper.getContentGradient('verse').colors,
        ));
      }

      // اختيار حديث ثابت لليوم
      final hadiths = quotesData['hadiths'] as List;
      if (hadiths.isNotEmpty) {
        final hadithIndex = random.nextInt(hadiths.length);
        final selectedHadith = hadiths[hadithIndex];
        quotes.add(QuoteData(
          type: QuoteType.hadith,
          content: selectedHadith['text'],
          source: selectedHadith['source'],
          theme: selectedHadith['theme'],
          gradient: ColorHelper.getContentGradient('hadith').colors,
        ));
      }

      // اختيار دعاء ثابت لليوم
      final duas = quotesData['duas'] as List;
      if (duas.isNotEmpty) {
        final duaIndex = random.nextInt(duas.length);
        final selectedDua = duas[duaIndex];
        quotes.add(QuoteData(
          type: QuoteType.dua,
          content: selectedDua['text'],
          source: selectedDua['source'],
          theme: selectedDua['theme'],
          gradient: ColorHelper.getContentGradient('dua').colors,
        ));
      }

      setState(() {});
    } catch (e) {
      print('خطأ في توليد الاقتباسات: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // في حالة التحميل
    if (_isLoading) {
      return _buildLoadingCard(context);
    }

    // في حالة الخطأ
    if (_errorMessage != null) {
      return _buildErrorCard(context);
    }

    // في حالة عدم وجود اقتباسات
    if (quotes.isEmpty) {
      return _buildEmptyCard(context);
    }

    return Column(
      children: [
        // عنوان القسم
        _buildSectionHeader(context),
        
        ThemeConstants.space4.h,
        
        // بطاقة الاقتباسات
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              HapticFeedback.selectionClick();
            },
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return _buildQuoteCard(context, quotes[index]);
            },
          ),
        ),
        
        ThemeConstants.space4.h,
        
        // مؤشر الصفحات
        _buildPageIndicator(context),
      ],
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.primaryColor,
            strokeWidth: 2,
          ),
          const SizedBox(height: ThemeConstants.space3),
          Text(
            'جاري تحميل الاقتباسات...',
            style: context.labelMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: context.errorColor,
            size: ThemeConstants.iconLg,
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            'خطأ في تحميل الاقتباسات',
            style: context.titleMedium?.copyWith(
              color: context.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ThemeConstants.space2),
          ElevatedButton(
            onPressed: _loadQuotesData,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            color: context.textSecondaryColor,
            size: ThemeConstants.iconLg,
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            'لا توجد اقتباسات متاحة',
            style: context.titleMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space2),
          ElevatedButton(
            onPressed: _loadQuotesData,
            child: const Text('إعادة التحميل'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space3,
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة مدمجة
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          // النصوص
          Expanded(
            child: Text(
              'الاقتباس اليومي',
              style: context.titleMedium?.copyWith(
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ),
          
          // زر التحديث مدمج
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              child: InkWell(
                onTap: _refreshQuotes,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: context.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context, QuoteData quote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: quote.gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showQuoteDetails(context, quote),
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            child: Stack(
              children: [
                // تحسين: خلفية مبسطة
                _buildSimpleQuoteBackground(quote),
                
                // المحتوى
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space5),
                  child: _buildQuoteContent(context, quote),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleQuoteBackground(QuoteData quote) {
    return Positioned.fill(
      child: Stack(
        children: [
          // تحسين: تأثير ضوئي ثابت
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteContent(BuildContext context, QuoteData quote) {
    return Column(
      children: [
        // رأس البطاقة
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                _getQuoteIcon(quote.type),
                color: Colors.white,
                size: ThemeConstants.iconMd,
              ),
            ),
            
            ThemeConstants.space3.w,
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getQuoteTitle(quote.type),
                    style: context.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  if (quote.theme != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.label_outline,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            quote.theme!,
                            style: context.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: ThemeConstants.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // زر النسخ
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              child: InkWell(
                onTap: () => _copyQuote(context, quote),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  child: Icon(
                    Icons.copy_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: ThemeConstants.iconSm,
                  ),
                ),
              ),
            ),
            
            // زر المشاركة
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              child: InkWell(
                onTap: () => _shareQuote(context, quote),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  child: Icon(
                    Icons.share_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: ThemeConstants.iconSm,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // النص الرئيسي
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // علامة اقتباس افتتاحية
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.format_quote,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
              
              ThemeConstants.space2.h,
              
              // النص
              Text(
                quote.content,
                textAlign: TextAlign.center,
                style: context.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: ThemeConstants.medium,
                  fontFamily: quote.type == QuoteType.verse 
                      ? ThemeConstants.fontFamilyQuran 
                      : ThemeConstants.fontFamily,
                ),
              ),
              
              ThemeConstants.space2.h,
              
              // علامة اقتباس ختامية
              Align(
                alignment: Alignment.bottomLeft,
                child: Transform.rotate(
                  angle: math.pi,
                  child: Icon(
                    Icons.format_quote,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const Spacer(),
        
        // المصدر
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space2,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Text(
              quote.source,
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(quotes.length, (index) {
        final isActive = index == _currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive 
                ? context.primaryColor 
                : context.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // دوال مساعدة
  IconData _getQuoteIcon(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return Icons.menu_book_rounded;
      case QuoteType.hadith:
        return Icons.auto_stories_rounded;
      case QuoteType.dua:
        return Icons.pan_tool_rounded;
    }
  }

  String _getQuoteTitle(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return 'آية اليوم';
      case QuoteType.hadith:
        return 'حديث اليوم';
      case QuoteType.dua:
        return 'دعاء اليوم';
    }
  }

  String _getQuoteSubtitle(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return 'من القرآن الكريم';
      case QuoteType.hadith:
        return 'من السنة النبوية';
      case QuoteType.dua:
        return 'دعاء مأثور';
    }
  }

  void _refreshQuotes() {
    HapticFeedback.mediumImpact();
    
    // إعادة توليد الاقتباسات بـ seed جديد (للتحديث اليدوي)
    final random = math.Random();
    quotes.clear();

    try {
      // اختيار آية عشوائية عند التحديث اليدوي
      final verses = quotesData['verses'] as List;
      if (verses.isNotEmpty) {
        final selectedVerse = verses[random.nextInt(verses.length)];
        quotes.add(QuoteData(
          type: QuoteType.verse,
          content: selectedVerse['text'],
          source: selectedVerse['source'],
          theme: selectedVerse['theme'],
          gradient: ColorHelper.getContentGradient('verse').colors,
        ));
      }

      // اختيار حديث عشوائي عند التحديث اليدوي
      final hadiths = quotesData['hadiths'] as List;
      if (hadiths.isNotEmpty) {
        final selectedHadith = hadiths[random.nextInt(hadiths.length)];
        quotes.add(QuoteData(
          type: QuoteType.hadith,
          content: selectedHadith['text'],
          source: selectedHadith['source'],
          theme: selectedHadith['theme'],
          gradient: ColorHelper.getContentGradient('hadith').colors,
        ));
      }

      // اختيار دعاء عشوائي عند التحديث اليدوي
      final duas = quotesData['duas'] as List;
      if (duas.isNotEmpty) {
        final selectedDua = duas[random.nextInt(duas.length)];
        quotes.add(QuoteData(
          type: QuoteType.dua,
          content: selectedDua['text'],
          source: selectedDua['source'],
          theme: selectedDua['theme'],
          gradient: ColorHelper.getContentGradient('dua').colors,
        ));
      }

      setState(() {});
    } catch (e) {
      print('خطأ في تحديث الاقتباسات: $e');
    }
  }

  void _copyQuote(BuildContext context, QuoteData quote) {
    final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق الأذكار';
    Clipboard.setData(ClipboardData(text: shareText));
    context.showSuccessSnackBar('تم نسخ النص بنجاح');
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context, QuoteData quote) {
    HapticFeedback.lightImpact();
    final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق الأذكار';
    Share.share(shareText);
  }

  void _showQuoteDetails(BuildContext context, QuoteData quote) {
    HapticFeedback.lightImpact();
    // عرض تفاصيل الاقتباس في modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuoteDetailsModal(quote: quote),
    );
  }
}

/// نموذج بيانات الاقتباس
class QuoteData {
  final QuoteType type;
  final String content;
  final String source;
  final String? theme;
  final List<Color> gradient;

  const QuoteData({
    required this.type,
    required this.content,
    required this.source,
    this.theme,
    required this.gradient,
  });
}

/// أنواع الاقتباسات
enum QuoteType {
  verse,   // آية
  hadith,  // حديث
  dua,     // دعاء
}

/// نافذة تفاصيل الاقتباس
class QuoteDetailsModal extends StatelessWidget {
  final QuoteData quote;

  const QuoteDetailsModal({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب
          Container(
            margin: const EdgeInsets.only(top: ThemeConstants.space2),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // المحتوى
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeConstants.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    _getQuoteTitle(quote.type),
                    style: context.headlineSmall?.semiBold,
                  ),
                  
                  ThemeConstants.space4.h,
                  
                  // النص الكامل
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ThemeConstants.space5),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                      border: Border.all(
                        color: context.dividerColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      quote.content,
                      style: context.bodyLarge?.copyWith(
                        height: 2.0,
                        fontSize: 18,
                        fontFamily: quote.type == QuoteType.verse 
                            ? ThemeConstants.fontFamilyQuran 
                            : ThemeConstants.fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  ThemeConstants.space4.h,
                  
                  // المصدر والموضوع
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // المصدر على اليسار
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space4,
                            vertical: ThemeConstants.space2,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                          ),
                          child: Text(
                            quote.source,
                            style: context.titleSmall?.copyWith(
                              color: context.primaryColor,
                              fontWeight: ThemeConstants.semiBold,
                            ),
                          ),
                        ),
                      ),
                      
                      // الموضوع على اليمين
                      if (quote.theme != null) 
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space3,
                              vertical: ThemeConstants.space1,
                            ),
                            decoration: BoxDecoration(
                              color: context.surfaceColor,
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                              border: Border.all(
                                color: context.dividerColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.label_outline,
                                  color: context.textSecondaryColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    quote.theme!,
                                    style: context.labelSmall?.copyWith(
                                      color: context.textSecondaryColor,
                                      fontWeight: ThemeConstants.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  ThemeConstants.space6.h,
                  
                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _copyQuote(context),
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('نسخ النص'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.surfaceColor,
                            foregroundColor: context.textPrimaryColor,
                            side: BorderSide(
                              color: context.dividerColor,
                            ),
                          ),
                        ),
                      ),
                      
                      ThemeConstants.space3.w,
                      
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareQuote(context),
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('مشاركة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getQuoteTitle(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return 'آية من القرآن الكريم';
      case QuoteType.hadith:
        return 'حديث شريف';
      case QuoteType.dua:
        return 'دعاء مأثور';
    }
  }

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    context.showSuccessSnackBar('تم نسخ النص بنجاح');
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) {
    HapticFeedback.lightImpact();
    final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق الأذكار';
    Share.share(shareText);
  }
}