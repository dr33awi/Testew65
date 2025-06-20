// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;

// ✅ استيراد النظام المبسط الجديد فقط
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../services/daily_quote_service.dart';
import '../models/daily_quote_model.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> {
  late PageController _pageController;
  late DailyQuoteService _quoteService;
  
  int _currentPage = 0;
  List<QuoteData> quotes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // تحميل الاقتباس اليومي
      final dailyQuote = await _quoteService.getDailyQuote();
      
      // تحميل دعاء عشوائي من JSON
      final allDuas = await _quoteService.getAllDuas();
      String duaText = 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ';
      String duaSource = 'سورة البقرة - آية 201';
      
      if (allDuas.isNotEmpty) {
        final randomDua = allDuas[DateTime.now().day % allDuas.length];
        duaText = randomDua['text'] ?? duaText;
        duaSource = randomDua['source'] ?? duaSource;
      }
      
      // تحويل البيانات إلى QuoteData
      quotes = [
        QuoteData(
          type: QuoteType.verse,
          content: dailyQuote.verse,
          source: dailyQuote.verseSource,
          gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
        ),
        QuoteData(
          type: QuoteType.hadith,
          content: dailyQuote.hadith,
          source: dailyQuote.hadithSource,
          gradient: [ThemeConstants.success, ThemeConstants.primaryLight],
        ),
        QuoteData(
          type: QuoteType.dua,
          content: duaText,
          source: duaSource,
          gradient: [ThemeConstants.secondary, ThemeConstants.secondaryLight],
        ),
      ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل الاقتباسات';
      });
      
      // في حالة الخطأ، استخدم بيانات افتراضية
      quotes = [
        QuoteData(
          type: QuoteType.verse,
          content: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
          source: 'سورة الطلاق - آية 2-3',
          gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
        ),
        QuoteData(
          type: QuoteType.hadith,
          content: 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
          source: 'صحيح البخاري',
          gradient: [ThemeConstants.success, ThemeConstants.primaryLight],
        ),
        QuoteData(
          type: QuoteType.dua,
          content: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          source: 'سورة البقرة - آية 201',
          gradient: [ThemeConstants.secondary, ThemeConstants.secondaryLight],
        ),
      ];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null && quotes.isEmpty) {
      return _buildErrorState();
    }

    return Column(
      children: [
        // عنوان القسم البسيط
        _buildSimpleSectionHeader(context),
        
        Spaces.large,
        
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
              return _buildSimpleQuoteCard(context, quotes[index]);
            },
          ),
        ),
        
        Spaces.large,
        
        // مؤشر الصفحات
        _buildPageIndicator(context),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
            Spaces.medium,
            Text(
              'جاري تحميل الاقتباسات...',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: context.errorColor,
            ),
            Spaces.medium,
            Text(
              _errorMessage ?? 'خطأ في تحميل الاقتباسات',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            Spaces.medium,
            IslamicButton.outlined(
              text: 'إعادة المحاولة',
              onPressed: _loadQuotes,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleSectionHeader(BuildContext context) {
    return IslamicCard.simple(
      child: Row(
        children: [
          // أيقونة ثابتة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          Spaces.mediumH,
          
          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الاقتباس اليومي',
                  style: context.titleStyle,
                ),
                Text(
                  'آية وحديث وأدعية مختارة',
                  style: context.captionStyle,
                ),
              ],
            ),
          ),
          
          // زر إعادة التحديث
          if (!_isLoading)
            IconButton(
              onPressed: _loadQuotes,
              icon: Icon(
                Icons.refresh,
                color: context.secondaryTextColor,
              ),
              tooltip: 'تحديث الاقتباسات',
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleQuoteCard(BuildContext context, QuoteData quote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceSm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: quote.gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showQuoteDetails(context, quote),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.spaceLg),
                  child: _buildQuoteContent(context, quote),
                ),
              ),
            ),
          ),
        ),
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
              padding: const EdgeInsets.all(ThemeConstants.spaceMd),
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
            
            Spaces.mediumH,
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getQuoteTitle(quote.type),
                    style: context.titleStyle.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.fontBold,
                    ),
                  ),
                  Text(
                    _getQuoteSubtitle(quote.type),
                    style: context.captionStyle.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // النص الرئيسي
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ThemeConstants.spaceLg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
              
              Spaces.small,
              
              // النص
              Text(
                quote.content,
                textAlign: TextAlign.center,
                style: context.bodyStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: ThemeConstants.fontMedium,
                  fontFamily: quote.type == QuoteType.verse 
                      ? ThemeConstants.fontQuran 
                      : ThemeConstants.fontPrimary,
                ),
              ),
              
              Spaces.small,
              
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
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spaceLg,
            vertical: ThemeConstants.spaceMd,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          ),
          child: Text(
            quote.source,
            style: context.captionStyle.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.fontSemiBold,
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
        return AnimatedContainer(
          duration: ThemeConstants.durationNormal,
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
  final List<Color> gradient;

  const QuoteData({
    required this.type,
    required this.content,
    required this.source,
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
          top: Radius.circular(ThemeConstants.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب
          Container(
            margin: const EdgeInsets.only(top: ThemeConstants.spaceMd),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // المحتوى
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ThemeConstants.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    _getQuoteTitle(quote.type),
                    style: context.headingStyle,
                  ),
                  
                  Spaces.large,
                  
                  // النص الكامل
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ThemeConstants.spaceLg),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                      border: Border.all(
                        color: context.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      quote.content,
                      style: context.bodyStyle.copyWith(
                        height: 2.0,
                        fontSize: 18,
                        fontFamily: quote.type == QuoteType.verse 
                            ? ThemeConstants.fontQuran 
                            : ThemeConstants.fontPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  Spaces.large,
                  
                  // المصدر
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spaceLg,
                        vertical: ThemeConstants.spaceMd,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                      ),
                      child: Text(
                        quote.source,
                        style: context.subtitleStyle.copyWith(
                          color: context.primaryColor,
                          fontWeight: ThemeConstants.fontSemiBold,
                        ),
                      ),
                    ),
                  ),
                  
                  Spaces.extraLarge,
                  
                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: IslamicButton.outlined(
                          text: 'نسخ النص',
                          icon: Icons.copy_rounded,
                          onPressed: () => _copyQuote(context),
                        ),
                      ),
                      
                      Spaces.mediumH,
                      
                      Expanded(
                        child: IslamicButton.primary(
                          text: 'مشاركة',
                          icon: Icons.share_rounded,
                          onPressed: () => _shareQuote(context),
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
    context.showSuccessMessage('تم نسخ النص بنجاح');
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) {
    HapticFeedback.lightImpact();
    context.showInfoMessage('سيتم إضافة ميزة المشاركة قريباً');
  }
}