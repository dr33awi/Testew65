// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
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
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: ThemeConstants.space3),
            Text('جاري تحميل الاقتباسات...'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            ),
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Row(
              children: [
                // الأيقونة
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
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
}

class _QuoteCard extends StatelessWidget {
  final QuoteData quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final gradient = ColorHelper.getContentGradient(quote.type);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient.colors.map((c) => c.withValues(alpha: 0.9)).toList(),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showQuoteDetails(context),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
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

  Widget _buildContent(BuildContext context) {
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
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  '"',
                  style: TextStyle(
                    fontSize: 24,
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
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: ThemeConstants.medium,
                  fontFamily: quote.type == 'verse' 
                      ? ThemeConstants.fontFamilyQuran 
                      : ThemeConstants.fontFamily,
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space2),
              
              // علامة اقتباس ختامية
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '"',
                  style: TextStyle(
                    fontSize: 24,
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
                    _getQuoteTitle(),
                    style: context.headlineSmall?.copyWith(
                      fontWeight: ThemeConstants.semiBold,
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
                          color: context.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                          border: Border.all(
                            color: context.primaryColor.withValues(alpha: 0.3),
                            width: 1,
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
                        fontFamily: quote.type == 'verse' 
                            ? ThemeConstants.fontFamilyQuran 
                            : ThemeConstants.fontFamily,
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
                  
                  const SizedBox(height: ThemeConstants.space6),
                  
                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyQuote(context),
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('نسخ النص'),
                        ),
                      ),
                      
                      const SizedBox(width: ThemeConstants.space3),
                      
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareQuote(context),
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('مشاركة'),
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
      context.showSuccessSnackBar('تم نسخ النص بنجاح');
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
        context.showErrorSnackBar('فشل في مشاركة النص');
      }
    }
  }
}