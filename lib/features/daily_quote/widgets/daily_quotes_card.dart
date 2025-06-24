// lib/features/daily_quote/widgets/daily_quotes_card.dart - محسن ومراجع
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
      
      // بيانات احتياطية في حالة الخطأ
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
    // ✅ استخدام AppCard للتحميل مع تصميم محسن
    return SizedBox(
      height: 280,
      child: AppCard(
        style: CardStyle.glassmorphism,
        primaryColor: context.primaryColor,
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
        borderRadius: ThemeConstants.radius2xl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoading.circular(
              size: LoadingSize.large,
              color: context.primaryColor,
            ),
            const SizedBox(height: ThemeConstants.space4),
            Text(
              'جاري تحميل الاقتباسات...',
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
    // ✅ استخدام AppCard مخصص للتحكم في توسيط النص
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      child: AppCard(
        type: CardType.quote,
        style: CardStyle.gradient,
        primaryColor: QuoteHelper.getQuotePrimaryColor(context, quote.type),
        gradientColors: QuoteHelper.getQuoteColors(context, quote.type),
        onTap: () => _showQuoteDetails(quote),
        borderRadius: ThemeConstants.radius2xl,
        margin: EdgeInsets.zero,
        child: _buildQuoteContent(quote),
      ),
    );
  }

  Widget _buildQuoteContent(QuoteData quote) {
    // تحديد إذا كان النص قصير (أقل من 80 حرف للتأكد من عدم overflow)
    final isShortText = quote.content.length < 80;
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisAlignment: isShortText 
            ? MainAxisAlignment.center    // توسيط للنص القصير
            : MainAxisAlignment.start,    // بداية للنص الطويل
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // الموضوع/الفئة في الأعلى للنص الطويل فقط
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
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  quote.theme!,
                  style: context.labelMedium?.textColor(Colors.white).semiBold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: ThemeConstants.space3),
          ],
          
          // المحتوى الرئيسي مع حماية من overflow
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isShortText ? ThemeConstants.space3 : ThemeConstants.space4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // النص الرئيسي مع حماية من overflow (بدون علامات اقتباس)
                      Flexible(
                        child: Text(
                          quote.content,
                          textAlign: TextAlign.center,
                          style: context.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: isShortText ? 18 : 16,  // تقليل الحجم قليلاً
                            height: isShortText ? 1.5 : 1.7,  // تقليل التباعد
                            fontWeight: isShortText 
                                ? ThemeConstants.medium 
                                : ThemeConstants.regular,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          overflow: TextOverflow.visible, // السماح بالتقطع الطبيعي
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // المصدر في الأسفل مع حماية من overflow
          const SizedBox(height: ThemeConstants.space3),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280), // تحديد عرض أقصى
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
                style: context.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // الموضوع للنص القصير في الأسفل مع حماية من overflow
          if (quote.theme != null && isShortText) ...[
            const SizedBox(height: ThemeConstants.space2),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  quote.theme!,
                  style: context.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: ThemeConstants.medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
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
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
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
                    // العنوان مع الأيقونة
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
                            style: context.headlineSmall?.copyWith(
                              fontWeight: ThemeConstants.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                    
                    // ✅ استخدام AppButton الموحد
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