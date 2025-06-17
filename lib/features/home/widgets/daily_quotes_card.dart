// lib/features/home/widgets/enhanced_daily_quotes_card.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:athkar_app/features/home/widgets/islamic_pattern_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  int _currentPage = 0;
  
  // بيانات وهمية - يجب استبدالها ببيانات حقيقية
  final List<QuoteData> quotes = [
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

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
  }

  void _setupControllers() {
    _pageController = PageController();
    
    _animationController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  void _setupAnimations() {
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                // عنوان القسم
                _buildSectionHeader(context),
                
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
                      return _buildQuoteCard(context, quotes[index]);
                    },
                  ),
                ),
                
                ThemeConstants.space4.h,
                
                // مؤشر الصفحات
                _buildPageIndicator(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة متحركة
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _backgroundController.value * 2 * math.pi,
                child: Container(
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
              );
            },
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
          
          // زر التحديث
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            child: InkWell(
              onTap: _refreshQuotes,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  size: ThemeConstants.iconMd,
                  color: context.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context, QuoteData quote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: quote.gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
        ),
        boxShadow: [
          BoxShadow(
            color: quote.gradient[0].withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
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
              onTap: () => _showQuoteDetails(context, quote),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Stack(
                children: [
                  // خلفية زخرفية
                  _buildQuoteBackground(quote),
                  
                  // المحتوى
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
    );
  }

  Widget _buildQuoteBackground(QuoteData quote) {
    return Positioned.fill(
      child: Stack(
        children: [
          // نمط إسلامي زخرفي
          Positioned.fill(
            child: CustomPaint(
              painter: IslamicPatternPainter(
                color: Colors.white.withValues(alpha: 0.1),
                animation: _backgroundController.value,
              ),
            ),
          ),
          
          // دوائر متحركة
          ...List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                final offset = _backgroundController.value * 2 * math.pi + (index * math.pi / 2.5);
                return Positioned(
                  top: 20 + (index * 30) + (math.sin(offset) * 15),
                  right: 20 + (index * 25) + (math.cos(offset) * 20),
                  child: Container(
                    width: 8 + (math.sin(offset) * 4),
                    height: 8 + (math.sin(offset) * 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.3 + (math.sin(offset) * 0.2)),
                    ),
                  ),
                );
              },
            );
          }),
          
          // تأثير ضوئي
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
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
            
            // زر المشاركة
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              child: InkWell(
                onTap: () => _shareQuote(context, quote),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  child: Icon(
                    Icons.share_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: ThemeConstants.iconSm,
                  ),
                ),
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

  void _refreshQuotes() {
    HapticFeedback.mediumImpact();
    // إعادة تحميل الاقتباسات
    context.showInfoSnackBar('جاري تحديث الاقتباسات...');
  }

  void _shareQuote(BuildContext context, QuoteData quote) {
    HapticFeedback.lightImpact();
    final shareText = '${quote.content}\n\n${quote.source}\n\nمن تطبيق الأذكار';
    // استخدام share_plus package
    context.showInfoSnackBar('سيتم إضافة ميزة المشاركة قريباً');
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