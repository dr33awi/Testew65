// lib/features/daily_quote/widgets/daily_quotes_card.dart - محسن ومضغوط
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
          height: 220,
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
              return _buildQuoteCard(quotes[index]);
            },
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 220,
      child: AppCard(
        style: CardStyle.glassmorphism,
        primaryColor: context.primaryColor,
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
        borderRadius: ThemeConstants.radiusLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoading.circular(
              size: LoadingSize.medium,
              color: context.primaryColor,
            ),
            const SizedBox(height: ThemeConstants.space3),
            Text(
              'جاري التحميل...',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard(QuoteData quote) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      child: AppCard(
        type: CardType.quote,
        style: CardStyle.gradient,
        primaryColor: QuoteHelper.getQuotePrimaryColor(context, quote.type),
        gradientColors: QuoteHelper.getQuoteColors(context, quote.type),
        onTap: () => _showQuoteDetails(quote),
        borderRadius: ThemeConstants.radiusLg,
        margin: EdgeInsets.zero,
        child: _buildQuoteContent(quote),
      ),
    );
  }

  Widget _buildQuoteContent(QuoteData quote) {
    final isShortText = quote.content.length < 80;
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisAlignment: isShortText 
            ? MainAxisAlignment.center    
            : MainAxisAlignment.start,    
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (quote.theme != null && !isShortText) ...[
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Text(
                  quote.theme!,
                  style: context.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: ThemeConstants.space2),
          ],
          
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.space3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Center(
                child: Text(
                  quote.content,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: isShortText ? 16 : 14,
                    height: 1.6,
                    fontWeight: ThemeConstants.medium,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space2),
          
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space3,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              ),
              child: Text(
                quote.source,
                style: context.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(quotes.length, (index) {
        final isActive = index == _currentPage;
        final color = isActive 
            ? QuoteHelper.getQuotePrimaryColor(context, quotes[_currentPage].type)
            : context.textSecondaryColor.withValues(alpha: 0.3);
            
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
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
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusLg),
        ),
        gradient: QuoteHelper.getModalGradient(context, quote.type),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusLg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: ThemeConstants.space2),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ThemeConstants.space2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                          ),
                          child: Icon(
                            QuoteHelper.getQuoteIcon(quote.type),
                            color: Colors.white,
                            size: ThemeConstants.iconMd,
                          ),
                        ),
                        const SizedBox(width: ThemeConstants.space3),
                        Expanded(
                          child: Text(
                            QuoteHelper.getQuoteDetailTitle(quote.type),
                            style: context.titleLarge?.copyWith(
                              fontWeight: ThemeConstants.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: ThemeConstants.space4),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(ThemeConstants.space4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Text(
                        quote.content,
                        style: context.bodyLarge?.copyWith(
                          height: 1.8,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: ThemeConstants.space3),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
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
                    
                    const SizedBox(height: ThemeConstants.space5),
                    
                    Row(
                      children: [
                        Expanded(
                          child: AppButton.outline(
                            text: 'نسخ',
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
        context.showErrorSnackBar('فشل في مشاركة النص');
      }
    }
  }
}