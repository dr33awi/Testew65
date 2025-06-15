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

class _DailyQuotesCardState extends State<DailyQuotesCard>
    with TickerProviderStateMixin {
  Map<String, dynamic>? _todayVerse;
  Map<String, dynamic>? _todayHadith;
  bool _isLoading = true;
  String? _error;
  PageController? _pageController;
  int _currentPage = 0;
  
  late AnimationController _fadeController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // Setup animations
    _fadeController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
    );
    
    _floatingAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _loadDailyQuotes();
    _fadeController.forward();
  }
  
  @override
  void dispose() {
    _pageController?.dispose();
    _fadeController.dispose();
    _floatingController.dispose();
    super.dispose();
  }
  
  Future<void> _loadDailyQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      String jsonString;
      try {
        jsonString = await rootBundle.loadString('assets/data/daily_quotes.json');
      } catch (e) {
        throw Exception('لا يمكن العثور على ملف daily_quotes.json');
      }
      
      Map<String, dynamic> data;
      try {
        data = json.decode(jsonString);
      } catch (e) {
        throw Exception('خطأ في تنسيق ملف JSON');
      }
      
      final List<dynamic>? quranVerses = data['quran_verses'];
      final List<dynamic>? hadiths = data['hadiths'];
      
      if (quranVerses == null || hadiths == null || quranVerses.isEmpty || hadiths.isEmpty) {
        throw Exception('البيانات غير مكتملة');
      }
      
      final int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final int verseIndex = dayOfYear % quranVerses.length;
      final int hadithIndex = dayOfYear % hadiths.length;
      
      _todayVerse = {
        'type': 'verse',
        'content': quranVerses[verseIndex]['text'] ?? '',
        'source': quranVerses[verseIndex]['source'] ?? '',
      };
      
      _todayHadith = {
        'type': 'hadith',
        'content': hadiths[hadithIndex]['text'] ?? '',
        'source': hadiths[hadithIndex]['source'] ?? '',
      };
      
      setState(() {
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard(context);
    }
    
    if (_error != null) {
      return _buildErrorCard(context);
    }
    
    if (_todayVerse == null || _todayHadith == null) {
      return const SizedBox.shrink();
    }
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildQuoteCard(
                    context: context,
                    quote: _todayVerse!,
                    title: 'آية اليوم',
                    gradient: ThemeConstants.primaryGradient,
                    icon: Icons.menu_book,
                  ),
                  _buildQuoteCard(
                    context: context,
                    quote: _todayHadith!,
                    title: 'حديث اليوم',
                    gradient: ThemeConstants.secondaryGradient,
                    icon: Icons.auto_stories,
                  ),
                ],
              ),
            ),
            
            ThemeConstants.space3.h,
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuoteCard({
    required BuildContext context,
    required Map<String, dynamic> quote,
    required String title,
    required List<Color> gradient,
    required IconData icon,
  }) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: ThemeConstants.opacity25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showQuoteActions(context, quote['content'], quote['source']),
                    borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            gradient[0].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity80 : ThemeConstants.opacity90),
                            gradient[1].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity70 : ThemeConstants.opacity80),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                          width: ThemeConstants.borderLight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // نمط زخرفي إسلامي
                          Positioned.fill(
                            child: CustomPaint(
                              painter: IslamicPatternPainter(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity5),
                              ),
                            ),
                          ),
                          
                          // المحتوى
                          Padding(
                            padding: const EdgeInsets.all(ThemeConstants.space5),
                            child: Column(
                              children: [
                                // الهيدر
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(ThemeConstants.space3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                      ),
                                      child: Icon(
                                        icon,
                                        color: Colors.white,
                                        size: ThemeConstants.iconMd,
                                      ),
                                    ),
                                    Text(
                                      title,
                                      style: context.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: ThemeConstants.bold,
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: ThemeConstants.opacity10),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.format_quote,
                                        color: Colors.white.withValues(alpha: ThemeConstants.opacity50),
                                        size: ThemeConstants.iconSm,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // المحتوى
                                Expanded(
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            quote['content'],
                                            style: context.bodyLarge?.copyWith(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1.8,
                                              fontWeight: ThemeConstants.medium,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // المصدر
                                if (quote['source'].isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ThemeConstants.space4,
                                      vertical: ThemeConstants.space2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                                        width: ThemeConstants.borderLight,
                                      ),
                                    ),
                                    child: Text(
                                      quote['source'],
                                      style: context.bodySmall?.copyWith(
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
        );
      },
    );
  }
  
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (index) => AnimatedContainer(
          duration: ThemeConstants.durationFast,
          width: _currentPage == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentPage == index
                ? context.primaryColor
                : context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.surfaceVariant,
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
      ),
      child: Center(
        child: AppLoading.circular(size: LoadingSize.large),
      ),
    );
  }
  
  Widget _buildErrorCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: ThemeConstants.error.withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: ThemeConstants.error.withValues(alpha: ThemeConstants.opacity30),
          width: ThemeConstants.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: ThemeConstants.error,
            size: ThemeConstants.iconXl,
          ),
          ThemeConstants.space2.h,
          Text(
            'خطأ في تحميل الاقتباسات',
            style: context.titleMedium?.copyWith(
              color: ThemeConstants.error,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          ThemeConstants.space2.h,
          Text(
            _error ?? 'حدث خطأ غير معروف',
            style: context.bodySmall?.copyWith(
              color: ThemeConstants.error.darken(0.2),
            ),
            textAlign: TextAlign.center,
          ),
          ThemeConstants.space3.h,
          AppButton.primary(
            text: 'إعادة المحاولة',
            onPressed: _loadDailyQuotes,
            icon: Icons.refresh,
            size: ButtonSize.small,
            backgroundColor: ThemeConstants.error,
          ),
        ],
      ),
    );
  }
  
  void _showQuoteActions(BuildContext context, String content, String source) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.backgroundColor,
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
              leading: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  color: context.primaryColor,
                ),
              ),
              title: const Text('نسخ النص'),
              onTap: () {
                final fullText = '$content\n\n$source';
                Clipboard.setData(ClipboardData(text: fullText));
                Navigator.pop(context);
                
                context.showSuccessSnackBar('تم نسخ النص');
              },
            ),
            
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.secondaryColor.withValues(alpha: ThemeConstants.opacity10),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.share_rounded,
                  color: context.secondaryColor,
                ),
              ),
              title: const Text('مشاركة'),
              onTap: () {
                Navigator.pop(context);
                // يمكن إضافة وظيفة المشاركة هنا
              },
            ),
            
            ThemeConstants.space2.h,
          ],
        ),
      ),
    );
  }
}

// رسام النمط الإسلامي
class IslamicPatternPainter extends CustomPainter {
  final Color color;

  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // رسم نمط هندسي إسلامي بسيط
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) / 3;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final x1 = centerX + radius * math.cos(angle);
      final y1 = centerY + radius * math.sin(angle);
      final x2 = centerX + radius * math.cos(angle + math.pi);
      final y2 = centerY + radius * math.sin(angle + math.pi);
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // رسم دائرة مركزية
    canvas.drawCircle(Offset(centerX, centerY), radius / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}