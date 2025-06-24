// lib/features/daily_quote/widgets/daily_quotes_card.dart - مُحدث بالـ widgets الموحدة
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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      
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
              // ✅ استخدام AppCard الموحد بدلاً من _QuoteCard
              return _buildQuoteCard(quotes[index]);
            },
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildLoadingState() {
    // ✅ استخدام AppCard للتحميل
    return SizedBox(
      height: 280,
      child: AppCard(
        style: CardStyle.glassmorphism,
        primaryColor: context.primaryColor,
        child: AppLoading.circular(
          size: LoadingSize.large,
          color: context.primaryColor,
        ),
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
        borderRadius: ThemeConstants.radius2xl,
      ),
    );
  }

  Widget _buildQuoteCard(QuoteData quote) {
    // ✅ استخدام AppCard.quote الموحد
    return AppCard.quote(
      quote: quote.content,
      author: quote.source,
      category: quote.theme ?? QuoteHelper.getQuoteSubtitle(quote.type),
      primaryColor: QuoteHelper.getQuotePrimaryColor(context, quote.type),
      gradientColors: QuoteHelper.getQuoteColors(context, quote.type),
    ).inkWell(
      onTap: () => _showQuoteDetails(quote),
      borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
    ).padded(
      const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(quotes.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive 
                ? context.primaryColor 
                : context.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  void _showQuoteDetails(QuoteData quote) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuoteDetailsModal(quote: quote),
    );
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
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
        gradient: QuoteHelper.getModalGradient(context, quote.type),
        boxShadow: [
          BoxShadow(
            color: QuoteHelper.getQuotePrimaryColor(context, quote.type).withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // المقبض العلوي
            Container(
              margin: const EdgeInsets.only(top: ThemeConstants.space3),
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(ThemeConstants.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    Text(
                      QuoteHelper.getQuoteDetailTitle(quote.type),
                      style: context.headlineSmall?.copyWith(
                        fontWeight: ThemeConstants.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: ThemeConstants.space4),
                    
                    // الموضوع إذا وُجد
                    if (quote.theme != null) ...[
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space4,
                            vertical: ThemeConstants.space2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            quote.theme!,
                            style: context.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.medium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: ThemeConstants.space5),
                    ],
                    
                    // المحتوى الرئيسي
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(ThemeConstants.space5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        quote.content,
                        style: context.bodyLarge?.copyWith(
                          height: 2.0,
                          fontSize: 18,
                          color: Colors.white,
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
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        ),
                        child: Text(
                          quote.source,
                          style: context.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.semiBold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: ThemeConstants.space6),
                    
                    // ✅ استخدام AppButton الموحد بدلاً من الأزرار المخصصة
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            text: 'نسخ النص',
                            onPressed: () => _copyQuote(context),
                            icon: Icons.copy_rounded,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(width: ThemeConstants.space3),
                        
                        Expanded(
                          child: AppButton.custom(
                            text: 'مشاركة',
                            onPressed: () => _shareQuote(context),
                            icon: Icons.share_rounded,
                            backgroundColor: Colors.white,
                            textColor: QuoteHelper.getQuotePrimaryColor(context, quote.type),
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
      ),
    );
  }

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    
    if (context.mounted) {
      // ✅ استخدام AppSnackBar الموحد
      context.showSuccessSnackBar('تم نسخ النص بنجاح');
    }
    
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) async {
    try {
      final shareText = QuoteHelper.getShareText(quote.type, quote.content, quote.source);
      await Share.share(
        shareText,
        subject: QuoteHelper.getQuoteDetailTitle(quote.type),
      );
      HapticFeedback.lightImpact();
    } catch (e) {
      if (context.mounted) {
        // ✅ استخدام AppSnackBar الموحد
        context.showErrorSnackBar('فشل في مشاركة النص');
      }
    }
  }
}