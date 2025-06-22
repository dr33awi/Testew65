// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
      });

      // تحميل الاقتباس اليومي
      final dailyQuote = await _quoteService.getDailyQuote();
      
      // تحميل دعاء عشوائي من JSON
      final randomDua = _quoteService.getRandomDua();
      
      // تحويل البيانات إلى QuoteData
      quotes = [
        QuoteData(
          type: 'verse',
          content: dailyQuote.verse,
          source: dailyQuote.verseSource,
          theme: dailyQuote.verseTheme,
        ),
        QuoteData(
          type: 'hadith',
          content: dailyQuote.hadith,
          source: dailyQuote.hadithSource,
          theme: dailyQuote.hadithTheme,
        ),
        QuoteData(
          type: 'dua',
          content: randomDua['text'] ?? 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          source: randomDua['source'] ?? 'سورة البقرة - آية 201',
          theme: randomDua['theme'],
        ),
      ];

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      
      // في حالة الخطأ، استخدم بيانات افتراضية
      quotes = [
        const QuoteData(
          type: 'verse',
          content: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
          source: 'سورة الطلاق - آية 2-3',
          theme: 'التقوى والرزق',
        ),
        const QuoteData(
          type: 'hadith',
          content: 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
          source: 'صحيح البخاري',
          theme: 'التسبيح ومغفرة الذنوب',
        ),
        const QuoteData(
          type: 'dua',
          content: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          source: 'سورة البقرة - آية 201',
          theme: 'دعاء شامل',
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

    return Column(
      children: [
        // عنوان القسم
        _buildSectionHeader(),
        
        const SizedBox(height: ThemeConstants.space4),
        
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
              return _QuoteCard(quote: quotes[index]);
            },
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // مؤشر الصفحات
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: ThemeConstants.space3),
          Text(
            'جاري تحميل الاقتباسات...',
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.dividerColor.withValues(alpha: ThemeConstants.opacity20),
                width: ThemeConstants.borderThin,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Row(
              children: [
                // الأيقونة - استخدام ألوان الثيم
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    gradient: ThemeConstants.primaryGradient,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    boxShadow: ThemeConstants.shadowSm,
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: ThemeConstants.iconLg,
                  ),
                ),
                
                const SizedBox(width: ThemeConstants.space4),
                
                // النصوص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الاقتباس اليومي',
                        style: context.titleLarge?.copyWith(
                          fontWeight: ThemeConstants.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      Text(
                        'آية وحديث وأدعية مختارة',
                        style: context.labelMedium?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(quotes.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive 
                ? context.primaryColor 
                : context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
          ),
        );
      }),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final QuoteData quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final gradient = _getQuoteGradient(quote.type);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient.map((c) => c.withValues(alpha: ThemeConstants.opacity90)).toList(),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: ThemeConstants.opacity30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showQuoteDetails(context),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    width: ThemeConstants.borderThin,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                ),
                padding: const EdgeInsets.all(ThemeConstants.space5),
                child: _buildContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getQuoteGradient(String type) {
    switch (type) {
      case 'verse':
        return [ThemeConstants.primary, ThemeConstants.primaryLight];
      case 'hadith':
        return [ThemeConstants.success, ThemeConstants.successLight];
      case 'dua':
        return [ThemeConstants.accent, ThemeConstants.accentLight];
      default:
        return [ThemeConstants.primary, ThemeConstants.primaryLight];
    }
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // رأس البطاقة
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                border: Border.all(
                  color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                  width: ThemeConstants.borderThin,
                ),
              ),
              child: Icon(
                _getQuoteIcon(),
                color: Colors.white,
                size: ThemeConstants.iconMd,
              ),
            ),
            
            const SizedBox(width: ThemeConstants.space3),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getQuoteTitle(),
                    style: context.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  Text(
                    _getQuoteSubtitle(),
                    style: context.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity80),
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
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
              width: ThemeConstants.borderThin,
            ),
          ),
          child: Column(
            children: [
              // علامة اقتباس افتتاحية
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  '"',
                  style: TextStyle(
                    fontSize: ThemeConstants.textSize2xl,
                    color: Colors.white60,
                    height: 0.8,
                  ),
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space2),
              
              // النص
              Text(
                quote.content,
                textAlign: TextAlign.center,
                style: context.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: ThemeConstants.textSizeLg,
                  height: 1.8,
                  fontWeight: ThemeConstants.medium,
                  fontFamily: quote.type == 'verse' 
                      ? ThemeConstants.fontFamilyQuran 
                      : ThemeConstants.fontFamilyArabic,
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space2),
              
              // علامة اقتباس ختامية
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '"',
                  style: TextStyle(
                    fontSize: ThemeConstants.textSize2xl,
                    color: Colors.white60,
                    height: 0.8,
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
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: ThemeConstants.opacity20),
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
      ],
    );
  }

  // دوال مساعدة
  IconData _getQuoteIcon() {
    switch (quote.type) {
      case 'verse':
        return Icons.menu_book_rounded;
      case 'hadith':
        return Icons.auto_stories_rounded;
      case 'dua':
        return Icons.pan_tool_rounded;
      default:
        return Icons.auto_stories_rounded;
    }
  }

  String _getQuoteTitle() {
    switch (quote.type) {
      case 'verse':
        return 'آية اليوم';
      case 'hadith':
        return 'حديث اليوم';
      case 'dua':
        return 'دعاء اليوم';
      default:
        return 'اقتباس اليوم';
    }
  }

  String _getQuoteSubtitle() {
    switch (quote.type) {
      case 'verse':
        return 'من القرآن الكريم';
      case 'hadith':
        return 'من السنة النبوية';
      case 'dua':
        return 'دعاء مأثور';
      default:
        return 'اقتباس مختار';
    }
  }

  void _showQuoteDetails(BuildContext context) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuoteDetailsModal(quote: quote),
    );
  }
}

/// نموذج بيانات الاقتباس المبسط
class QuoteData {
  final String type;
  final String content;
  final String source;
  final String? theme;

  const QuoteData({
    required this.type,
    required this.content,
    required this.source,
    this.theme,
  });
}

/// نافذة تفاصيل الاقتباس
class _QuoteDetailsModal extends StatelessWidget {
  final QuoteData quote;

  const _QuoteDetailsModal({required this.quote});

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
        boxShadow: ThemeConstants.shadowXl,
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
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
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
                    _getQuoteTitle(),
                    style: context.headlineSmall?.copyWith(
                      fontWeight: ThemeConstants.semiBold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: ThemeConstants.space4),
                  
                  // عرض الموضوع إذا كان متوفراً
                  if (quote.theme != null) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space3,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                          border: Border.all(
                            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
                            width: ThemeConstants.borderThin,
                          ),
                        ),
                        child: Text(
                          quote.theme!,
                          style: context.labelSmall?.copyWith(
                            color: context.primaryColor,
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space4),
                  ],
                  
                  // النص الكامل
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ThemeConstants.space5),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      border: Border.all(
                        color: context.dividerColor.withValues(alpha: ThemeConstants.opacity50),
                        width: ThemeConstants.borderThin,
                      ),
                      boxShadow: ThemeConstants.shadowSm,
                    ),
                    child: Text(
                      quote.content,
                      style: context.bodyLarge?.copyWith(
                        height: 2.0,
                        fontSize: ThemeConstants.textSizeXl,
                        fontFamily: quote.type == 'verse' 
                            ? ThemeConstants.fontFamilyQuran 
                            : ThemeConstants.fontFamilyArabic,
                        color: context.textPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: ThemeConstants.space4),
                  
                  // المصدر
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space4,
                        vertical: ThemeConstants.space2,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
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
                  
                  const SizedBox(height: ThemeConstants.space6),
                  
                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyQuote(context),
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('نسخ النص'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.primaryColor,
                            side: BorderSide(
                              color: context.primaryColor,
                              width: ThemeConstants.borderMedium,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: ThemeConstants.space3),
                      
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareQuote(context),
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('مشاركة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                            ),
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

  String _getQuoteTitle() {
    switch (quote.type) {
      case 'verse':
        return 'آية من القرآن الكريم';
      case 'hadith':
        return 'حديث شريف';
      case 'dua':
        return 'دعاء مأثور';
      default:
        return 'اقتباس مختار';
    }
  }

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    
    // إظهار رسالة النجاح
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم نسخ النص بنجاح'),
          backgroundColor: ThemeConstants.success,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
        ),
      );
    }
    
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) async {
    try {
      final fullText = '${quote.content}\n\n${quote.source}\n\n📱 مشارك من تطبيق الأذكار';
      await Share.share(
        fullText,
        subject: _getQuoteTitle(),
      );
      HapticFeedback.lightImpact();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('فشل في مشاركة النص'),
            backgroundColor: ThemeConstants.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          ),
        );
      }
    }
  }
}