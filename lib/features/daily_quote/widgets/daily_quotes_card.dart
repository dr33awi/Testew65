// lib/features/daily_quote/widgets/daily_quotes_card.dart - محدث للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
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
    final gradientColors = [
      AppColorSystem.primary.withValues(alpha: 0.9),
      AppColorSystem.primary.darken(0.2).withValues(alpha: 0.9),
    ];
    
    return SizedBox(
      height: 200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: AppColorSystem.primary.withValues(alpha: 0.2),
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
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
              
              // محتوى التحميل
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLoading.circular(
                      color: Colors.white,
                    ),
                    const SizedBox(height: ThemeConstants.space3),
                    Text(
                      'جاري تحميل الاقتباسات...',
                      style: AppTextStyles.body2.copyWith(
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
    final gradientColors = [
      AppColorSystem.getCategoryColor(quote.type),
      AppColorSystem.getCategoryDarkColor(quote.type),
    ];
    
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
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
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
              _getQuoteTitle(quote.type),
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
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
              color: Colors.white.withValues(alpha: 0.15),
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
                  AppIconsSystem.getCategoryIcon(quote.type),
                  color: Colors.white.withValues(alpha: 0.9),
                  size: isTablet ? 16 : 14,
                ),
                
                SizedBox(width: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
                
                Text(
                  quote.source,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
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
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              quote.content,
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                height: 1.7,
                fontWeight: ThemeConstants.semiBold,
                fontSize: isShortText ? (isTablet ? 22 : 18) : (isTablet ? 20 : 16),
                letterSpacing: 0.5,
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
            ? AppColorSystem.getCategoryColor(quotes[_currentPage].type)
            : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5);
            
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
    final gradientColors = [
      AppColorSystem.getCategoryColor(quote.type),
      AppColorSystem.getCategoryDarkColor(quote.type),
    ];
    
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
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
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
                            _getQuoteTitle(quote.type),
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: ThemeConstants.bold,
                              color: Colors.white,
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
                            style: AppTextStyles.body1.copyWith(
                              height: 1.8,
                              fontSize: 17,
                              color: Colors.white,
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
                            style: AppTextStyles.label1.copyWith(
                              color: Colors.white,
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
                              child: AppButton.outline(
                                text: 'نسخ',
                                onPressed: () => _copyQuote(context),
                                color: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(width: ThemeConstants.space3),
                            
                            Expanded(
                              child: AppButton.primary(
                                text: 'مشاركة',
                                onPressed: () => _shareQuote(context),
                                backgroundColor: Colors.white,
                                textColor: AppColorSystem.getCategoryColor(quote.type),
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

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    
    if (context.mounted) {
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
        AppSnackBar.showError(
          context: context,
          message: 'فشل في مشاركة النص',
        );
      }
    }
  }
}