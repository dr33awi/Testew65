// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // تحميل الاقتباس اليومي
      final dailyQuote = await _quoteService.getDailyQuote();
      
      // تحميل دعاء عشوائي من JSON
      final allDuas = await _quoteService.getAllDuas();
      String duaText = 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ';
      String duaSource = 'سورة البقرة - آية 201';
      
      if (allDuas.isNotEmpty) {
        final randomDua = allDuas[DateTime.now().day % allDuas.length];
        duaText = randomDua['text'] ?? duaText;
        duaSource = randomDua['source'] ?? duaSource;
      }
      
      // تحويل البيانات إلى QuoteData
      quotes = [
        QuoteData(
          type: QuoteType.verse,
          content: dailyQuote.verse,
          source: dailyQuote.verseSource,
          gradient: ColorHelper.getContentGradient('verse').colors,
        ),
        QuoteData(
          type: QuoteType.hadith,
          content: dailyQuote.hadith,
          source: dailyQuote.hadithSource,
          gradient: ColorHelper.getContentGradient('hadith').colors,
        ),
        QuoteData(
          type: QuoteType.dua,
          content: duaText,
          source: duaSource,
          gradient: ColorHelper.getContentGradient('dua').colors,
        ),
      ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل الاقتباسات';
      });
      
      // في حالة الخطأ، استخدم بيانات افتراضية
      quotes = [
        QuoteData(
          type: QuoteType.verse,
          content: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
          source: 'سورة الطلاق - آية 2-3',
          gradient: ColorHelper.getContentGradient('verse').colors,
        ),
        QuoteData(
          type: QuoteType.hadith,
          content: 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
          source: 'صحيح البخاري',
          gradient: ColorHelper.getContentGradient('hadith').colors,
        ),
        QuoteData(
          type: QuoteType.dua,
          content: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          source: 'سورة البقرة - آية 201',
          gradient: ColorHelper.getContentGradient('dua').colors,
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

    if (_errorMessage != null && quotes.isEmpty) {
      return _buildErrorState();
    }

    return Column(
      children: [
        // عنوان القسم البسيط
        _buildSimpleSectionHeader(context),
        
        ThemeConstants.space4.h,
        
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
              return _buildSimpleQuoteCard(context, quotes[index]);
            },
          ),
        ),
        
        ThemeConstants.space4.h,
        
        // مؤشر الصفحات
        _buildPageIndicator(context),
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
            ThemeConstants.space3.h,
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

  Widget _buildErrorState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: context.errorColor,
            ),
            ThemeConstants.space3.h,
            Text(
              _errorMessage ?? 'خطأ في تحميل الاقتباسات',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            ThemeConstants.space3.h,
            ElevatedButton(
              onPressed: _loadQuotes,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleSectionHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.dividerColor.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              ),
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: Row(
                  children: [
                    // أيقونة ثابتة
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
                    
                    ThemeConstants.space4.w,
                    
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
                            'آية وحديث وادعية مختارة',
                            style: context.labelMedium?.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // زر إعادة التحديث
                    if (!_isLoading)
                      IconButton(
                        onPressed: _loadQuotes,
                        icon: Icon(
                          Icons.refresh,
                          color: context.textSecondaryColor,
                        ),
                        tooltip: 'تحديث الاقتباسات',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleQuoteCard(BuildContext context, QuoteData quote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: quote.gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showQuoteDetails(context, quote),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Stack(
                  children: [
                    // زخرفات إسلامية
                    _buildIslamicQuoteBackground(quote),
                    
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space5),
                      child: _buildQuoteContent(context, quote),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIslamicQuoteBackground(QuoteData quote) {
    return Positioned.fill(
      child: CustomPaint(
        painter: IslamicQuotePainter(
          color: Colors.white.withValues(alpha: 0.1),
          quoteType: quote.type,
        ),
      ),
    );
  }

  Widget _buildQuoteContent(BuildContext context, QuoteData quote) {
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
                _getQuoteIcon(quote.type),
                color: Colors.white,
                size: ThemeConstants.iconMd,
              ),
            ),
            
            ThemeConstants.space3.w,
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getQuoteTitle(quote.type),
                    style: context.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  Text(
                    _getQuoteSubtitle(quote.type),
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
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.format_quote,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 20,
                ),
              ),
              
              ThemeConstants.space2.h,
              
              // النص
              Text(
                quote.content,
                textAlign: TextAlign.center,
                style: context.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: ThemeConstants.medium,
                  fontFamily: quote.type == QuoteType.verse 
                      ? ThemeConstants.fontFamilyQuran 
                      : ThemeConstants.fontFamily,
                ),
              ),
              
              ThemeConstants.space2.h,
              
              // علامة اقتباس ختامية
              Align(
                alignment: Alignment.bottomLeft,
                child: Transform.rotate(
                  angle: math.pi,
                  child: Icon(
                    Icons.format_quote,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 20,
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

  Widget _buildPageIndicator(BuildContext context) {
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

  // دوال مساعدة
  IconData _getQuoteIcon(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return Icons.menu_book_rounded;
      case QuoteType.hadith:
        return Icons.auto_stories_rounded;
      case QuoteType.dua:
        return Icons.pan_tool_rounded;
    }
  }

  String _getQuoteTitle(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return 'آية اليوم';
      case QuoteType.hadith:
        return 'حديث اليوم';
      case QuoteType.dua:
        return 'دعاء اليوم';
    }
  }

  String _getQuoteSubtitle(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return 'من القرآن الكريم';
      case QuoteType.hadith:
        return 'من السنة النبوية';
      case QuoteType.dua:
        return 'دعاء مأثور';
    }
  }

  void _showQuoteDetails(BuildContext context, QuoteData quote) {
    HapticFeedback.lightImpact();
    // عرض تفاصيل الاقتباس في modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuoteDetailsModal(quote: quote),
    );
  }
}

/// نموذج بيانات الاقتباس
class QuoteData {
  final QuoteType type;
  final String content;
  final String source;
  final List<Color> gradient;

  const QuoteData({
    required this.type,
    required this.content,
    required this.source,
    required this.gradient,
  });
}

/// أنواع الاقتباسات
enum QuoteType {
  verse,   // آية
  hadith,  // حديث
  dua,     // دعاء
}

/// نافذة تفاصيل الاقتباس
class QuoteDetailsModal extends StatelessWidget {
  final QuoteData quote;

  const QuoteDetailsModal({super.key, required this.quote});

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
                    _getQuoteTitle(quote.type),
                    style: context.headlineSmall?.semiBold,
                  ),
                  
                  ThemeConstants.space4.h,
                  
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
                        fontFamily: quote.type == QuoteType.verse 
                            ? ThemeConstants.fontFamilyQuran 
                            : ThemeConstants.fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  ThemeConstants.space4.h,
                  
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
                  
                  ThemeConstants.space6.h,
                  
                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          text: 'نسخ النص',
                          icon: Icons.copy_rounded,
                          onPressed: () => _copyQuote(context),
                        ),
                      ),
                      
                      ThemeConstants.space3.w,
                      
                      Expanded(
                        child: AppButton.primary(
                          text: 'مشاركة',
                          icon: Icons.share_rounded,
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
    );
  }

  String _getQuoteTitle(QuoteType type) {
    switch (type) {
      case QuoteType.verse:
        return 'آية من القرآن الكريم';
      case QuoteType.hadith:
        return 'حديث شريف';
      case QuoteType.dua:
        return 'دعاء مأثور';
    }
  }

  void _copyQuote(BuildContext context) {
    final fullText = '${quote.content}\n\n${quote.source}';
    Clipboard.setData(ClipboardData(text: fullText));
    context.showSuccessSnackBar('تم نسخ النص بنجاح');
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) {
    HapticFeedback.lightImpact();
    context.showInfoSnackBar('سيتم إضافة ميزة المشاركة قريباً');
  }
}

/// رسام الزخارف الإسلامية للاقتباسات
class IslamicQuotePainter extends CustomPainter {
  final Color color;
  final QuoteType quoteType;

  IslamicQuotePainter({
    required this.color,
    required this.quoteType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    switch (quoteType) {
      case QuoteType.verse:
        _drawQuranPattern(canvas, size, paint);
        break;
      case QuoteType.hadith:
        _drawHadithPattern(canvas, size, paint);
        break;
      case QuoteType.dua:
        _drawDuaPattern(canvas, size, paint);
        break;
    }
  }

  void _drawQuranPattern(Canvas canvas, Size size, Paint paint) {
    // زخرفة مناسبة للقرآن - خطوط عربية متدفقة
    final path = Path();
    
    // خطوط منحنية تشبه الخط العربي
    path.moveTo(size.width * 0.1, size.height * 0.15);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.05,
      size.width * 0.6, size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3,
      size.width * 0.9, size.height * 0.15,
    );
    
    // خط ثاني
    path.moveTo(size.width * 0.1, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * 0.95,
      size.width * 0.7, size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.85, size.height * 0.7,
      size.width * 0.9, size.height * 0.85,
    );
    
    canvas.drawPath(path, paint);
    
    // نقاط زخرفية
    final dots = [
      Offset(size.width * 0.15, size.height * 0.25),
      Offset(size.width * 0.85, size.height * 0.25),
      Offset(size.width * 0.15, size.height * 0.75),
      Offset(size.width * 0.85, size.height * 0.75),
    ];
    
    for (final dot in dots) {
      canvas.drawCircle(dot, 2, paint);
    }
  }

  void _drawHadithPattern(Canvas canvas, Size size, Paint paint) {
    // زخرفة للحديث - نمط هندسي إسلامي
    final centerX = size.width * 0.15;
    final centerY = size.height * 0.15;
    
    // نجمة ثمانية صغيرة
    _drawEightPointedStar(canvas, Offset(centerX, centerY), 12, paint);
    
    // نجمة أخرى في الزاوية المقابلة
    _drawEightPointedStar(canvas, Offset(size.width * 0.85, size.height * 0.85), 10, paint);
    
    // خطوط متقاطعة زخرفية
    final lines = [
      [Offset(size.width * 0.8, size.height * 0.2), Offset(size.width * 0.9, size.height * 0.3)],
      [Offset(size.width * 0.1, size.height * 0.7), Offset(size.width * 0.2, size.height * 0.8)],
    ];
    
    for (final line in lines) {
      canvas.drawLine(line[0], line[1], paint);
    }
  }

  void _drawDuaPattern(Canvas canvas, Size size, Paint paint) {
    // زخرفة للدعاء - أنماط دائرية ومنحنية
    final center1 = Offset(size.width * 0.2, size.height * 0.2);
    final center2 = Offset(size.width * 0.8, size.height * 0.8);
    
    // دوائر متداخلة
    canvas.drawCircle(center1, 15, paint);
    canvas.drawCircle(center1, 10, paint);
    
    canvas.drawCircle(center2, 12, paint);
    canvas.drawCircle(center2, 8, paint);
    
    // منحنيات تشبه اليدين المرفوعتين
    final handsPath = Path();
    handsPath.moveTo(size.width * 0.3, size.height * 0.7);
    handsPath.quadraticBezierTo(
      size.width * 0.45, size.height * 0.5,
      size.width * 0.5, size.height * 0.6,
    );
    handsPath.quadraticBezierTo(
      size.width * 0.55, size.height * 0.5,
      size.width * 0.7, size.height * 0.7,
    );
    
    canvas.drawPath(handsPath, paint);
  }

  void _drawEightPointedStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    final double angle = 2 * math.pi / points;
    
    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = (i + 0.5) * angle - math.pi / 2;
      
      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);
      
      final innerX = center.dx + (radius * 0.6) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.6) * math.sin(innerAngle);
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      
      path.lineTo(innerX, innerY);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}