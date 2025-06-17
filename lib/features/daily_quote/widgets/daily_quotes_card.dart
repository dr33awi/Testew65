// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../models/daily_quote_model.dart';

class DailyQuotesCard extends StatefulWidget {
  final DailyQuoteModel? dailyQuote;
  final VoidCallback? onRefresh;

  const DailyQuotesCard({
    super.key,
    this.dailyQuote,
    this.onRefresh,
  });

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> {
  late PageController _pageController;
  
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<QuoteData> _buildQuotesFromModel() {
    if (widget.dailyQuote == null) {
      return [];
    }

    final quotes = <QuoteData>[];
    final model = widget.dailyQuote!;

    // إضافة الآية إذا كانت متوفرة
    if (model.verse.isNotEmpty) {
      quotes.add(QuoteData(
        type: QuoteType.verse,
        content: model.verse,
        source: model.verseSource.isEmpty ? 'القرآن الكريم' : model.verseSource,
        gradient: _getContentGradient('verse'),
      ));
    }

    // إضافة الحديث إذا كان متوفراً
    if (model.hadith.isNotEmpty) {
      quotes.add(QuoteData(
        type: QuoteType.hadith,
        content: model.hadith,
        source: model.hadithSource.isEmpty ? 'السنة النبوية' : model.hadithSource,
        gradient: _getContentGradient('hadith'),
      ));
    }

    // إضافة دعاء افتراضي إذا لم تكن هناك بيانات كافية
    if (quotes.isEmpty) {
      quotes.add(QuoteData(
        type: QuoteType.dua,
        content: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        source: 'سورة البقرة - آية 201',
        gradient: _getContentGradient('dua'),
      ));
    }

    return quotes;
  }

  List<Color> _getContentGradient(String type) {
    switch (type) {
      case 'verse':
        return [const Color(0xFF667eea), const Color(0xFF764ba2)];
      case 'hadith':
        return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
      case 'dua':
        return [const Color(0xFFfa709a), const Color(0xFFfee140)];
      default:
        return [const Color(0xFF667eea), const Color(0xFF764ba2)];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dailyQuote == null) {
      return _buildLoadingCard(context);
    }

    final quotes = _buildQuotesFromModel();

    if (quotes.isEmpty) {
      return _buildEmptyCard(context);
    }

    return Column(
      children: [
        // عنوان القسم البسيط
        _buildSimpleSectionHeader(context),
        
        const SizedBox(height: 16),
        
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
        
        const SizedBox(height: 16),
        
        // مؤشر الصفحات (فقط إذا كان هناك أكثر من اقتباس)
        if (quotes.length > 1) _buildPageIndicator(context, quotes.length),
      ],
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Column(
      children: [
        _buildSimpleSectionHeader(context),
        const SizedBox(height: 16),
        Container(
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 12),
                Text(
                  'جاري تحميل الاقتباسات...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Column(
      children: [
        _buildSimpleSectionHeader(context),
        const SizedBox(height: 16),
        Container(
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: 48,
                  color: Theme.of(context).hintColor,
                ),
                const SizedBox(height: 12),
                Text(
                  'لا توجد اقتباسات متاحة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: widget.onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleSectionHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // أيقونة ثابتة
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // النصوص
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الاقتباس اليومي',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'آية وحديث وادعية مختارة',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // زر التحديث
                    if (widget.onRefresh != null)
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onRefresh!();
                        },
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: Theme.of(context).hintColor,
                        ),
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
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: quote.gradient.map((c) => c.withOpacity(0.9)).toList(),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showQuoteDetails(context, quote),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // زخرفات إسلامية
                    _buildIslamicQuoteBackground(quote),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
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
          color: Colors.white.withOpacity(0.1),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getQuoteIcon(quote.type),
                color: Colors.white,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getQuoteTitle(quote.type),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getQuoteSubtitle(quote.type),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
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
                  color: Colors.white.withOpacity(0.6),
                  size: 20,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // النص
              Text(
                quote.content,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.8,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // علامة اقتباس ختامية
              Align(
                alignment: Alignment.bottomLeft,
                child: Transform.rotate(
                  angle: math.pi,
                  child: Icon(
                    Icons.format_quote,
                    color: Colors.white.withOpacity(0.6),
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
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            quote.source,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(BuildContext context, int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive 
                ? Theme.of(context).primaryColor 
                : Theme.of(context).primaryColor.withOpacity(0.3),
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
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // المحتوى
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(
                    _getQuoteTitle(quote.type),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // النص الكامل
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      quote.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 2.0,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // المصدر
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        quote.source,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyQuote(context),
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('نسخ النص'),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareQuote(context),
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('مشاركة'),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ النص بنجاح')),
    );
    HapticFeedback.mediumImpact();
  }

  void _shareQuote(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة ميزة المشاركة قريباً')),
    );
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
    final path = Path();
    
    path.moveTo(size.width * 0.1, size.height * 0.15);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.05,
      size.width * 0.6, size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3,
      size.width * 0.9, size.height * 0.15,
    );
    
    path.moveTo(size.width * 0.1, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.4, size.height * 0.95,
      size.width * 0.7, size.height * 0.8,
    );
    
    canvas.drawPath(path, paint);
    
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
    _drawEightPointedStar(canvas, Offset(size.width * 0.15, size.height * 0.15), 12, paint);
    _drawEightPointedStar(canvas, Offset(size.width * 0.85, size.height * 0.85), 10, paint);
  }

  void _drawDuaPattern(Canvas canvas, Size size, Paint paint) {
    final center1 = Offset(size.width * 0.2, size.height * 0.2);
    final center2 = Offset(size.width * 0.8, size.height * 0.8);
    
    canvas.drawCircle(center1, 15, paint);
    canvas.drawCircle(center1, 10, paint);
    canvas.drawCircle(center2, 12, paint);
    canvas.drawCircle(center2, 8, paint);
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