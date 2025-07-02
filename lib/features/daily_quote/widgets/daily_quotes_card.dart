// lib/features/daily_quote/widgets/daily_quotes_card.dart - النسخة المُصححة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../services/daily_quote_service.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> 
    with TickerProviderStateMixin {
  
  late PageController _pageController;
  late DailyQuoteService _quoteService;
  late AnimationController _fadeController;
  
  int _currentPage = 0;
  List<QuoteData> quotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _fadeController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
      });

      final dailyQuote = await _quoteService.getDailyQuote();
      final randomDua = _quoteService.getRandomDua();
      
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
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.showErrorSnackBar('فشل في تحميل الاقتباسات');
      }
      
      // بيانات احتياطية
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
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        children: [
          SizedBox(
            height: _getCardHeight(context),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
                  child: _buildQuoteCard(quotes[index]),
                );
              },
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          _buildPageIndicator(),
        ],
      ),
    );
  }

  double _getCardHeight(BuildContext context) {
    // استخدام AppSizeSystem بدلاً من extension متعارض
    final size = AppSizeSystem.getResponsiveSize(context);
    switch (size) {
      case ComponentSize.lg:
      case ComponentSize.xl:
        return 220;
      default:
        return 200;
    }
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200,
      child: AppCard.quote(
        quote: 'جاري التحميل...',
        author: '',
        category: 'الاقتباسات اليومية',
        primaryColor: context.primaryColor,
      ),
    );
  }

  Widget _buildQuoteCard(QuoteData quote) {
    return AppCard.quote(
      quote: quote.content,
      author: quote.source,
      category: _getQuoteTitle(quote.type),
      primaryColor: quote.type.themeColor,
      gradientColors: [
        quote.type.themeColor,
        quote.type.themeDarkColor,
      ],
    ).onTap(() => _showQuoteDetails(quote))
     .animatedPress();
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(quotes.length, (index) {
        final isActive = index == _currentPage;
        final color = isActive 
            ? quotes[_currentPage].type.themeColor
            : context.textSecondaryColor.withOpacitySafe(0.5);
            
        return AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive ? [
              BoxShadow(
                color: color.withOpacitySafe(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
        );
      }),
    );
  }

  String _getQuoteTitle(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'آية قرآنية';
      case 'hadith':
      case 'حديث':
        return 'حديث شريف';
      case 'dua':
      case 'دعاء':
        return 'دعاء مأثور';
      default:
        return 'نص ديني';
    }
  }

  void _showQuoteDetails(QuoteData quote) {
    HapticFeedback.lightImpact();
    
    AppInfoDialog.show(
      context: context,
      title: _getQuoteTitle(quote.type),
      content: '${quote.content}\n\n${quote.source}',
      icon: quote.type.themeCategoryIcon,
      accentColor: quote.type.themeColor,
      actions: [
        DialogAction(
          label: 'نسخ',
          onPressed: () => _copyQuote(context, quote),
        ),
        DialogAction(
          label: 'مشاركة',
          onPressed: () => _shareQuote(context, quote),
          isPrimary: true,
        ),
      ],
    );
  }

  void _copyQuote(BuildContext context, QuoteData quote) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    
    if (context.mounted) {
      context.showSuccessSnackBar('تم نسخ النص بنجاح');
      Navigator.of(context).pop();
    }
    
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context, QuoteData quote) async {
    try {
      final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق ${_getQuoteTitle(quote.type)}';
      await Share.share(
        shareText,
        subject: _getQuoteTitle(quote.type),
      );
      HapticFeedback.lightImpact();
      
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar('فشل في مشاركة النص');
      }
    }
  }
}

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