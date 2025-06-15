// lib/features/home/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> with TickerProviderStateMixin {
  Map<String, dynamic>? _todayQuote;
  bool _isLoading = true;
  String? _error;
  
  late AnimationController _floatController;
  late AnimationController _pageController;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;
  
  final PageController _quotesPageController = PageController();
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _pageController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    
    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: ThemeConstants.curveOvershoot,
    ));
    
    _loadDailyQuotes();
    _pageController.forward();
  }
  
  @override
  void dispose() {
    _floatController.dispose();
    _pageController.dispose();
    _quotesPageController.dispose();
    super.dispose();
  }
  
  Future<void> _loadDailyQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final String jsonString = await rootBundle.loadString('assets/data/daily_quotes.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      final int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final List<dynamic> quotes = data['quotes'] ?? [];
      
      if (quotes.isNotEmpty) {
        final int index = dayOfYear % quotes.length;
        _todayQuote = quotes[index];
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'حدث خطأ في تحميل البيانات';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard(context);
    }
    
    if (_error != null || _todayQuote == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        children: [
          // العنوان
          _buildSectionHeader(context),
          
          ThemeConstants.space3.h,
          
          // بطاقات الاقتباسات
          SizedBox(
            height: 220,
            child: PageView(
              controller: _quotesPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildQuoteCard(
                  context: context,
                  title: 'آية اليوم',
                  content: _todayQuote!['verse'] ?? '',
                  source: _todayQuote!['verse_source'] ?? '',
                  icon: Icons.menu_book_rounded,
                  gradient: [
                    ThemeConstants.primary,
                    ThemeConstants.primaryLight,
                  ],
                  pattern: QuotePattern.quran,
                ),
                _buildQuoteCard(
                  context: context,
                  title: 'حديث اليوم',
                  content: _todayQuote!['hadith'] ?? '',
                  source: _todayQuote!['hadith_source'] ?? '',
                  icon: Icons.auto_stories_rounded,
                  gradient: [
                    ThemeConstants.tertiary,
                    ThemeConstants.tertiaryLight,
                  ],
                  pattern: QuotePattern.hadith,
                ),
              ],
            ),
          ),
          
          ThemeConstants.space3.h,
          
          // مؤشر الصفحات
          _buildPageIndicator(),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: ThemeConstants.accentGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ThemeConstants.space3.w,
            Text(
              'رسالة اليوم',
              style: context.titleLarge?.copyWith(
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ],
        ),
        
        IconButton(
          onPressed: () => _showQuoteActions(context),
          icon: Icon(
            Icons.more_vert,
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuoteCard({
    required BuildContext context,
    required String title,
    required String content,
    required String source,
    required IconData icon,
    required List<Color> gradient,
    required QuotePattern pattern,
  }) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                    spreadRadius: -5,
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
                      onTap: () => _showQuoteDetails(context, title, content, source),
                      borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: gradient.map((c) => c.withOpacity(0.9)).toList(),
                          ),
                          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // نمط هندسي إسلامي
                            Positioned.fill(
                              child: CustomPaint(
                                painter: IslamicPatternPainter(
                                  color: Colors.white.withOpacity(0.05),
                                  pattern: pattern,
                                ),
                              ),
                            ),
                            
                            // تأثير الإضاءة
                            Positioned(
                              top: -50,
                              right: -50,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            // المحتوى
                            Padding(
                              padding: const EdgeInsets.all(ThemeConstants.space5),
                              child: Column(
                                children: [
                                  // الرأس
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(ThemeConstants.space2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                        ),
                                        child: Icon(
                                          icon,
                                          color: Colors.white,
                                          size: ThemeConstants.iconMd,
                                        ),
                                      ),
                                      ThemeConstants.space3.w,
                                      Text(
                                        title,
                                        style: context.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: ThemeConstants.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () => _shareQuote(context, content, source),
                                        icon: Icon(
                                          Icons.share_outlined,
                                          color: Colors.white.withOpacity(0.8),
                                          size: ThemeConstants.iconSm,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const Spacer(),
                                  
                                  // النص الرئيسي
                                  Container(
                                    padding: const EdgeInsets.all(ThemeConstants.space4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      content,
                                      style: context.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        height: 1.6,
                                        fontWeight: ThemeConstants.medium,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  
                                  const Spacer(),
                                  
                                  // المصدر
                                  if (source.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: ThemeConstants.space3,
                                        vertical: ThemeConstants.space1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                                      ),
                                      child: Text(
                                        source,
                                        style: context.labelMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: ThemeConstants.semiBold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? context.primaryColor
                : context.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
  
  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 220,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
      ),
      child: Center(
        child: AppLoading.circular(),
      ),
    );
  }
  
  void _showQuoteActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ThemeConstants.radius2xl),
          ),
        ),
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            ThemeConstants.space4.h,
            
            ListTile(
              leading: Icon(
                Icons.refresh,
                color: context.primaryColor,
              ),
              title: const Text('تحديث الاقتباسات'),
              onTap: () {
                Navigator.pop(context);
                _loadDailyQuotes();
              },
            ),
            
            ListTile(
              leading: Icon(
                Icons.favorite_outline,
                color: context.primaryColor,
              ),
              title: const Text('حفظ في المفضلة'),
              onTap: () {
                Navigator.pop(context);
                context.showSuccessSnackBar('تم الحفظ في المفضلة');
              },
            ),
            
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: context.primaryColor,
              ),
              title: const Text('إعدادات الاقتباسات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings/quotes');
              },
            ),
            
            ThemeConstants.space2.h,
          ],
        ),
      ),
    );
  }
  
  void _showQuoteDetails(BuildContext context, String title, String content, String source) {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          ),
          padding: const EdgeInsets.all(ThemeConstants.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.space3),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      title.contains('آية') ? Icons.menu_book_rounded : Icons.auto_stories_rounded,
                      color: context.primaryColor,
                    ),
                  ),
                  ThemeConstants.space3.w,
                  Text(
                    title,
                    style: context.titleLarge?.semiBold,
                  ),
                ],
              ),
              
              ThemeConstants.space4.h,
              
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                ),
                child: Text(
                  content,
                  style: context.bodyLarge?.copyWith(
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              if (source.isNotEmpty) ...[
                ThemeConstants.space3.h,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Text(
                    source,
                    style: context.labelLarge?.copyWith(
                      color: context.primaryColor,
                      fontWeight: ThemeConstants.semiBold,
                    ),
                  ),
                ),
              ],
              
              ThemeConstants.space5.h,
              
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'نسخ',
                      icon: Icons.copy_rounded,
                      onPressed: () {
                        _copyQuote(context, content, source);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ThemeConstants.space3.w,
                  Expanded(
                    child: AppButton.primary(
                      text: 'مشاركة',
                      icon: Icons.share_rounded,
                      onPressed: () {
                        _shareQuote(context, content, source);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _copyQuote(BuildContext context, String content, String source) {
    final fullText = '$content\n\n$source';
    Clipboard.setData(ClipboardData(text: fullText));
    context.showSuccessSnackBar('تم نسخ النص');
  }
  
  void _shareQuote(BuildContext context, String content, String source) {
    HapticFeedback.lightImpact();
    // يمكن إضافة وظيفة المشاركة هنا باستخدام share package
    context.showInfoSnackBar('ميزة المشاركة قيد التطوير');
  }
}

// أنواع الأنماط للاقتباسات
enum QuotePattern {
  quran,
  hadith,
}

// رسام الأنماط الإسلامية
class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final QuotePattern pattern;

  IslamicPatternPainter({
    required this.color,
    required this.pattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    switch (pattern) {
      case QuotePattern.quran:
        _drawQuranPattern(canvas, size, paint);
        break;
      case QuotePattern.hadith:
        _drawHadithPattern(canvas, size, paint);
        break;
    }
  }

  void _drawQuranPattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط هندسي للقرآن
    final spacing = 40.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawIslamicStar(canvas, paint, Offset(x, y), 15);
      }
    }
  }

  void _drawHadithPattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط زخرفي للحديث
    final spacing = 50.0;
    for (double x = spacing / 2; x < size.width + spacing; x += spacing) {
      for (double y = spacing / 2; y < size.height + spacing; y += spacing) {
        _drawArabesque(canvas, paint, Offset(x, y), 20);
      }
    }
  }

  void _drawIslamicStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    final angle = math.pi / 4;
    
    for (int i = 0; i < 8; i++) {
      final x = center.dx + radius * math.cos(i * angle);
      final y = center.dy + radius * math.sin(i * angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(center, radius / 3, paint);
  }

  void _drawArabesque(Canvas canvas, Paint paint, Offset center, double radius) {
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final circleCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(circleCenter, radius / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}