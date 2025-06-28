// lib/features/daily_quote/widgets/daily_quotes_card.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

// ✅ استيراد النظام الموحد الإسلامي - إجباري
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';

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
      duration: AppTheme.durationSlow,
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
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.space1),
                child: _buildQuoteCard(quotes[index]),
              );
            },
          ),
        ),
        
        AppTheme.space3.h,
        
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.space1),
        decoration: BoxDecoration(
          borderRadius: AppTheme.radius2xl.radius,
          boxShadow: AppTheme.shadowLg,
        ),
        child: ClipRRect(
          borderRadius: AppTheme.radius2xl.radius,
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.8),
                      AppTheme.primary.darken(0.2).withValues(alpha: 0.8),
                    ],
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
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),
                    AppTheme.space3.h,
                    Text(
                      'جاري تحميل الاقتباسات...',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: AppTheme.medium,
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
    final gradientColors = _getQuoteColors(quote.type);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        return AnimatedPress(
          onTap: () => _showQuoteDetails(quote),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: AppTheme.radius2xl.radius,
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
              borderRadius: AppTheme.radius2xl.radius,
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
                      isTablet ? AppTheme.space6 : AppTheme.space4,
                    ),
                    child: _buildQuoteContent(context, quote, isTablet),
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
              horizontal: AppTheme.space3,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Text(
              _getQuoteTitle(quote.type),
              style: AppTheme.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.medium,
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
              horizontal: isTablet ? AppTheme.space3 : AppTheme.space2,
              vertical: isTablet ? AppTheme.space2 : AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppTheme.radiusFull.radius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.library_books_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: isTablet ? 16 : 14,
                ),
                
                SizedBox(width: isTablet ? AppTheme.space2 : AppTheme.space1),
                
                Text(
                  quote.source,
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: AppTheme.medium,
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
            padding: EdgeInsets.all(isTablet ? AppTheme.space4 : AppTheme.space3),
            margin: EdgeInsets.symmetric(
              horizontal: isTablet ? AppTheme.space6 : AppTheme.space4,
              vertical: isTablet ? AppTheme.space5 : AppTheme.space4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: AppTheme.radiusLg.radius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              quote.content,
              style: AppTheme.quranStyle.copyWith(
                color: Colors.white,
                height: 1.7,
                fontWeight: AppTheme.semiBold,
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
            ? _getQuotePrimaryColor(quotes[_currentPage].type)
            : AppTheme.textSecondary.withValues(alpha: 0.3);
            
        return AnimatedContainer(
          duration: AppTheme.durationNormal,
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
    switch (type) {
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

  void _showQuoteDetails(QuoteData quote) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuoteDetailsModal(quote: quote, getTitle: _getQuoteTitle),
    );
  }

  // ✅ دوال مساعدة للألوان حسب النوع
  List<Color> _getQuoteColors(String type) {
    switch (type) {
      case 'verse':
        return [AppTheme.primary, AppTheme.primaryDark];
      case 'hadith':
        return [AppTheme.secondary, AppTheme.secondaryDark];
      case 'dua':
        return [AppTheme.accent, AppTheme.accent.darken(0.2)];
      default:
        return [AppTheme.primary, AppTheme.primaryDark];
    }
  }

  Color _getQuotePrimaryColor(String type) {
    switch (type) {
      case 'verse':
        return AppTheme.primary;
      case 'hadith':
        return AppTheme.secondary;
      case 'dua':
        return AppTheme.accent;
      default:
        return AppTheme.primary;
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

class _QuoteDetailsModal extends StatelessWidget {
  final QuoteData quote;
  final String Function(String) getTitle;

  const _QuoteDetailsModal({required this.quote, required this.getTitle});

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getQuoteColors(quote.type);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radius2xl),
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
          top: Radius.circular(AppTheme.radius2xl),
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
                  margin: const EdgeInsets.only(top: AppTheme.space3),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                
                Flexible(
                  child: SingleChildScrollView(
                    padding: AppTheme.space5.padding,
                    child: Column(
                      children: [
                        // عنوان مع أيقونة
                        Container(
                          width: double.infinity,
                          padding: AppTheme.space4.padding,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: AppTheme.radiusLg.radius,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            getTitle(quote.type),
                            style: AppTheme.headlineMedium.copyWith(
                              fontWeight: AppTheme.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        AppTheme.space5.h,
                        
                        // النص الرئيسي
                        Container(
                          width: double.infinity,
                          padding: AppTheme.space5.padding,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: AppTheme.radiusLg.radius,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            quote.content,
                            style: AppTheme.quranStyle.copyWith(
                              height: 1.8,
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: AppTheme.medium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        AppTheme.space4.h,
                        
                        // المصدر
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space4,
                            vertical: AppTheme.space3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: AppTheme.radiusFull.radius,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            quote.source,
                            style: AppTheme.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.semiBold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        AppTheme.space6.h,
                        
                        // أزرار العمليات
                        Row(
                          children: [
                            Expanded(
                              child: AppButton.outline(
                                text: 'نسخ',
                                onPressed: () => _copyQuote(context),
                                borderColor: Colors.white,
                              ),
                            ),
                            
                            AppTheme.space3.w,
                            
                            Expanded(
                              child: AppButton.secondary(
                                text: 'مشاركة',
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
          ],
        ),
      ),
    );
  }

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم نسخ النص بنجاح'),
          backgroundColor: AppTheme.success,
          duration: AppTheme.durationNormal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusMd.radius,
          ),
        ),
      );
      Navigator.of(context).pop();
    }
    
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) async {
    try {
      final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق ${getTitle(quote.type)}';
      await Share.share(
        shareText,
        subject: getTitle(quote.type),
      );
      HapticFeedback.lightImpact();
      
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('فشل في مشاركة النص'),
            backgroundColor: AppTheme.error,
            duration: AppTheme.durationNormal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.radiusMd.radius,
            ),
          ),
        );
      }
    }
  }

  // ✅ دوال مساعدة للألوان
  List<Color> _getQuoteColors(String type) {
    switch (type) {
      case 'verse':
        return [AppTheme.primary, AppTheme.primaryDark];
      case 'hadith':
        return [AppTheme.secondary, AppTheme.secondaryDark];
      case 'dua':
        return [AppTheme.accent, AppTheme.accent.darken(0.2)];
      default:
        return [AppTheme.primary, AppTheme.primaryDark];
    }
  }
}