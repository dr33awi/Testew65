// lib/features/daily_quote/widgets/daily_quotes_card.dart - محسن باستخدام النظام الموحد
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
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  
  int _currentPage = 0;
  List<QuoteData> quotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _setupShimmerAnimation();
    _loadQuotes();
  }

  void _setupShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
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
    _shimmerController.dispose();
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
          height: 200,
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
    );
  }

  Widget _buildLoadingState() {
    // ✅ استخدام نظام الألوان الموحد
    final gradientColors = [
      context.primaryColor.withValues(alpha: 0.8),
      context.primaryColor.darken(0.2).withValues(alpha: 0.8),
    ];
    
    return SizedBox(
      height: 200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: context.primaryColor.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: -3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                ),
              ),
              
              // الطبقة الزجاجية
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              
              // محتوى التحميل
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space3),
                    Text(
                      'جاري تحميل الاقتباسات...',
                      style: context.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: ThemeConstants.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(QuoteData quote) {
    // ✅ استخدام QuoteHelper الموحد
    final gradientColors = QuoteHelper.getQuoteColors(context, quote.type);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        return GestureDetector(
          onTap: () => _showQuoteDetails(quote),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Stack(
                children: [
                  // الخلفية المتدرجة
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors.map((c) => 
                          c.withValues(alpha: 0.95)
                        ).toList(),
                      ),
                    ),
                  ),
                  
                  // الطبقة الزجاجية
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  
                  // المحتوى الرئيسي
                  Padding(
                    padding: EdgeInsets.all(
                      isTablet ? ThemeConstants.space6 : ThemeConstants.space4,
                    ),
                    child: _buildQuoteContent(context, quote, isTablet),
                  ),
                  
                  // تأثير الهوفر للتفاعل
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showQuoteDetails(quote),
                      borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      highlightColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuoteContent(BuildContext context, QuoteData quote, bool isTablet) {
    final isShortText = quote.content.length < 80;
    
    return Stack(
      children: [
        // عنوان الفئة في الزاوية اليمنى العلوية
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Text(
              // ✅ استخدام QuoteHelper للعنوان
              QuoteHelper.getQuoteTitle(quote.type),
              style: (isTablet ? context.labelLarge : context.labelMedium)?.copyWith(
                // ✅ استخدام QuoteHelper للألوان
                color: QuoteHelper.getQuoteTextColor(context, quote.type),
                fontWeight: ThemeConstants.medium,
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ),
        ),
        
        // المصدر في الزاوية اليسرى السفلية
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? ThemeConstants.space3 : ThemeConstants.space2,
              vertical: isTablet ? ThemeConstants.space2 : ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: QuoteHelper.getQuoteOverlayColor(context, quote.type),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: QuoteHelper.getQuoteBorderColor(context, quote.type),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.library_books_rounded,
                  color: QuoteHelper.getQuoteSecondaryTextColor(context, quote.type),
                  size: isTablet ? 16 : 14,
                ),
                
                SizedBox(width: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
                
                Text(
                  quote.source,
                  style: (isTablet ? context.labelLarge : context.labelMedium)?.copyWith(
                    color: QuoteHelper.getQuoteSecondaryTextColor(context, quote.type),
                    fontWeight: ThemeConstants.medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        
        // النص الرئيسي في المنتصف مع خلفية شفافة
        Center(
          child: Container(
            padding: EdgeInsets.all(isTablet ? ThemeConstants.space4 : ThemeConstants.space3),
            margin: EdgeInsets.symmetric(
              horizontal: isTablet ? ThemeConstants.space6 : ThemeConstants.space4,
              vertical: isTablet ? ThemeConstants.space5 : ThemeConstants.space4,
            ),
            decoration: BoxDecoration(
              color: QuoteHelper.getQuoteOverlayColor(context, quote.type),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              border: Border.all(
                color: QuoteHelper.getQuoteBorderColor(context, quote.type),
                width: 1,
              ),
            ),
            child: Text(
              quote.content,
              style: (isTablet ? context.headlineSmall : context.titleMedium)?.copyWith(
                color: QuoteHelper.getQuoteTextColor(context, quote.type),
                height: 1.7,
                fontWeight: ThemeConstants.semiBold,
                fontSize: isShortText ? (isTablet ? 22 : 18) : (isTablet ? 20 : 16),
                letterSpacing: 0.5,
                // ✅ استخدام EnhancedCategoryHelper للظلال
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(quotes.length, (index) {
        final isActive = index == _currentPage;
        final color = isActive 
            ? QuoteHelper.getQuotePrimaryColor(context, quotes[_currentPage].type)
            : QuoteHelper.getQuoteOverlayColor(context, quotes[_currentPage].type);
            
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isActive ? [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
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
    final gradientColors = QuoteHelper.getQuoteColors(context, quote.type);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
        child: Stack(
          children: [
            // الخلفية المتدرجة
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors.map((c) => 
                    c.withValues(alpha: 0.95)
                  ).toList(),
                ),
              ),
            ),
            
            // الطبقة الزجاجية
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            
            // المحتوى
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // مقبض السحب
                Container(
                  margin: const EdgeInsets.only(top: ThemeConstants.space3),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ThemeConstants.space5),
                    child: Column(
                      children: [
                        // عنوان مع أيقونة
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(ThemeConstants.space4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            // ✅ استخدام QuoteHelper للعنوان
                            QuoteHelper.getQuoteTitle(quote.type),
                            style: context.headlineSmall?.copyWith(
                              fontWeight: ThemeConstants.bold,
                              color: QuoteHelper.getQuoteTextColor(context, quote.type),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space5),
                        
                        // النص الرئيسي
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(ThemeConstants.space5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            quote.content,
                            style: context.bodyLarge?.copyWith(
                              height: 1.8,
                              fontSize: 17,
                              color: QuoteHelper.getQuoteTextColor(context, quote.type),
                              fontWeight: ThemeConstants.medium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space4),
                        
                        // المصدر
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space4,
                            vertical: ThemeConstants.space3,
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
                            quote.source,
                            style: context.titleSmall?.copyWith(
                              color: QuoteHelper.getQuoteTextColor(context, quote.type),
                              fontWeight: ThemeConstants.semiBold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space6),
                        
                        // أزرار العمليات
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                context,
                                text: 'نسخ',
                                icon: Icons.copy_rounded,
                                onPressed: () => _copyQuote(context),
                                isPrimary: false,
                              ),
                            ),
                            
                            const SizedBox(width: ThemeConstants.space3),
                            
                            Expanded(
                              child: _buildActionButton(
                                context,
                                text: 'مشاركة',
                                icon: Icons.share_rounded,
                                onPressed: () => _shareQuote(context),
                                isPrimary: true,
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
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: ThemeConstants.space4,
            horizontal: ThemeConstants.space3,
          ),
          decoration: BoxDecoration(
            color: isPrimary 
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: isPrimary ? 0.9 : 0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: context.titleSmall?.copyWith(
                  color: isPrimary 
                      ? QuoteHelper.getQuotePrimaryColor(context, quote.type)
                      : QuoteHelper.getQuoteTextColor(context, quote.type),
                  fontWeight: ThemeConstants.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    
    if (context.mounted) {
      // ✅ استخدام النظام الموحد
      AppSnackBar.showSuccess(
        context: context,
        message: 'تم نسخ النص بنجاح',
      );
      Navigator.of(context).pop();
    }
    
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) async {
    try {
      // ✅ استخدام QuoteHelper للعنوان
      final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق ${QuoteHelper.getQuoteTitle(quote.type)}';
      await Share.share(
        shareText,
        subject: QuoteHelper.getQuoteTitle(quote.type),
      );
      HapticFeedback.lightImpact();
      
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        // ✅ استخدام النظام الموحد للأخطاء
        AppSnackBar.showError(
          context: context,
          message: 'فشل في مشاركة النص',
        );
      }
    }
  }
}