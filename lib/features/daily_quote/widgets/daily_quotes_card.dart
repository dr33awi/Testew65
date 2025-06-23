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
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withValues(alpha: 0.1),
            context.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
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
}

class _QuoteCard extends StatelessWidget {
  final QuoteData quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    final gradient = _getQuoteGradient(quote.type, context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
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
              // تخصيص لون الضغط ليكون نفس لون الكارد
              splashColor: gradient.first.withValues(alpha: 0.3),
              highlightColor: gradient.first.withValues(alpha: 0.2),
              hoverColor: gradient.first.withValues(alpha: 0.1),
              focusColor: gradient.first.withValues(alpha: 0.2),
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

  List<Color> _getQuoteGradient(String type, BuildContext context) {
    switch (type) {
      case 'verse':
        return [
          ThemeConstants.success.withValues(alpha: 0.9),
          ThemeConstants.successLight.withValues(alpha: 0.7),
        ];
      case 'hadith':
        return [
          ThemeConstants.accent.withValues(alpha: 0.9),
          ThemeConstants.accentLight.withValues(alpha: 0.7),
        ];
      case 'dua':
        return [
          ThemeConstants.tertiary.withValues(alpha: 0.9),
          ThemeConstants.tertiaryLight.withValues(alpha: 0.7),
        ];
      default:
        return [
          ThemeConstants.primary.withValues(alpha: 0.9),
          ThemeConstants.primaryLight.withValues(alpha: 0.7),
        ];
    }
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // رأس البطاقة
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                _getQuoteIcon(),
                color: Colors.white,
                size: ThemeConstants.iconLg,
              ),
            ),
            
            const SizedBox(width: ThemeConstants.space4),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getQuoteTitle(),
                    style: context.titleLarge?.copyWith(
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
        
        const SizedBox(height: ThemeConstants.space4),
        
        // النص الرئيسي
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // النص
                Text(
                  quote.content,
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.8,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        // المصدر
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.book_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: ThemeConstants.iconSm,
              ),
              const SizedBox(width: ThemeConstants.space1),
              Text(
                quote.source,
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ],
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
    final gradient = _getQuoteGradient(quote.type, context);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradient.first.withValues(alpha: 0.95),
            gradient.last.withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.4),
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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(ThemeConstants.radius2xl),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // مقبض السحب
                Container(
                  margin: const EdgeInsets.only(top: ThemeConstants.space3),
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
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
                            fontWeight: ThemeConstants.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space4),
                        
                        // عرض الموضوع إذا كان متوفراً
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
                        
                        // النص الكامل
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
                        
                        // أزرار الإجراءات
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _copyQuote(context),
                                icon: const Icon(Icons.copy_rounded),
                                label: const Text('نسخ النص'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
                                  backgroundColor: Colors.white,
                                  foregroundColor: gradient.first,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
          ),
        ),
      ),
    );
  }

  List<Color> _getQuoteGradient(String type, BuildContext context) {
    switch (type) {
      case 'verse':
        return [
          ThemeConstants.success.withValues(alpha: 0.9),
          ThemeConstants.successLight.withValues(alpha: 0.7),
        ];
      case 'hadith':
        return [
          ThemeConstants.accent.withValues(alpha: 0.9),
          ThemeConstants.accentLight.withValues(alpha: 0.7),
        ];
      case 'dua':
        return [
          ThemeConstants.tertiary.withValues(alpha: 0.9),
          ThemeConstants.tertiaryLight.withValues(alpha: 0.7),
        ];
      default:
        return [
          ThemeConstants.primary.withValues(alpha: 0.9),
          ThemeConstants.primaryLight.withValues(alpha: 0.7),
        ];
    }
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
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
          ),
        );
      }
    }
  }
}