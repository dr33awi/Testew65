// lib/features/daily_quote/widgets/daily_quotes_card.dart - محدث بالنظام الموحد الإسلامي الكامل
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

// ✅ استيراد النظام الموحد الإسلامي - محدث
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';
import 'package:athkar_app/app/themes/widgets/extended_cards.dart';
import 'package:athkar_app/app/themes/utils/category_utils.dart';

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
  late AnimationController _cardController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _slideAnimation;
  
  int _currentPage = 0;
  List<QuoteData> quotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _setupAnimations();
    _loadQuotes();
  }

  void _setupAnimations() {
    _shimmerController = AnimationController(
      duration: AppTheme.durationSlow,
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOut,
    ));
    
    _cardController.forward();
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
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = context.isTablet;
        
        return FadeTransition(
          opacity: _slideAnimation,
          child: Column(
            children: [
              SizedBox(
                height: isTablet ? 220 : 200,
                child: _isLoading ? _buildLoadingState() : _buildQuotesView(),
              ),
              
              AppTheme.space3.h,
              
              _buildPageIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return AppCard(
      useGradient: true,
      color: AppTheme.primary,
      child: AppLoading.page(message: 'جاري تحميل الاقتباسات...'),
    );
  }

  Widget _buildQuotesView() {
    return PageView.builder(
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
          padding: AppTheme.space1.paddingH,
          child: _buildQuoteCard(quotes[index]),
        );
      },
    );
  }

  Widget _buildQuoteCard(QuoteData quote) {
    final gradientColors = _getQuoteColors(quote.type);
    
    return AnimatedPress(
      onTap: () => _showQuoteDetails(quote),
      child: AppCard(
        useGradient: true,
        color: gradientColors.first,
        child: Stack(
          children: [
            // عنوان الفئة في الزاوية اليمنى العلوية
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: AppTheme.space2.paddingH.add(AppTheme.space1.paddingV),
                decoration: CardHelper.getCardDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppTheme.radiusMd,
                ),
                child: Text(
                  _getQuoteTitle(quote.type),
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ),
            ),
            
            // المصدر في الزاوية اليسرى السفلية
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: AppTheme.space2.paddingH.add(AppTheme.space1.paddingV),
                decoration: CardHelper.getCardDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppTheme.radiusFull,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CategoryUtils.getCategoryIcon('quran'),
                      color: Colors.white.withValues(alpha: 0.9),
                      size: AppTheme.iconSm,
                    ),
                    
                    AppTheme.space1.w,
                    
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
            
            // النص الرئيسي في المنتصف
            Center(
              child: Container(
                padding: AppTheme.space4.padding,
                margin: AppTheme.space4.paddingH.add(AppTheme.space3.paddingV),
                decoration: CardHelper.getCardDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: AppTheme.radiusLg,
                ),
                child: Text(
                  quote.content,
                  style: CardHelper.getTextStyle('quran').copyWith(
                    color: Colors.white,
                    height: 1.7,
                    fontWeight: AppTheme.semiBold,
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
        ),
      ),
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
          margin: AppTheme.space1.paddingH,
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

  // ✅ دوال مساعدة للألوان حسب النوع - محدثة
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
        maxHeight: context.screenHeight * 0.8,
      ),
      child: AppCard(
        useGradient: true,
        color: gradientColors.first,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض السحب
            Container(
              margin: AppTheme.space3.paddingV.copyWith(top: AppTheme.space3),
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
                    AppCard(
                      color: Colors.white.withValues(alpha: 0.15),
                      child: Text(
                        getTitle(quote.type),
                        style: context.headlineMedium.copyWith(
                          fontWeight: AppTheme.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    AppTheme.space5.h,
                    
                    // النص الرئيسي
                    AppCard(
                      color: Colors.white.withValues(alpha: 0.15),
                      child: Text(
                        quote.content,
                        style: CardHelper.getTextStyle('quran').copyWith(
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
                      padding: AppTheme.space4.paddingH.add(AppTheme.space3.paddingV),
                      decoration: CardHelper.getCardDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppTheme.radiusFull,
                      ),
                      child: Text(
                        quote.source,
                        style: context.titleMedium.copyWith(
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
                            icon: Icons.copy,
                            onPressed: () => _copyQuote(context),
                            borderColor: Colors.white,
                          ),
                        ),
                        
                        AppTheme.space3.w,
                        
                        Expanded(
                          child: AppButton.secondary(
                            text: 'مشاركة',
                            icon: Icons.share,
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