// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../services/daily_quote_service.dart';
import '../models/daily_quote_model.dart';
import '../../home/widgets/color_helper.dart';

/// بطاقة الاقتباسات اليومية المحسنة
class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> {
  late PageController _pageController;
  late DailyQuoteService _quoteService;
  
  int _currentPage = 0;
  List<_QuoteData> _quotes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _quoteService = getIt<DailyQuoteService>();
    _loadQuotes();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // تحميل الاقتباس اليومي
      final dailyQuote = await _quoteService.getDailyQuote();
      
      // تحميل دعاء عشوائي
      final allDuas = await _quoteService.getAllDuas();
      final randomDua = allDuas.isNotEmpty 
          ? allDuas[DateTime.now().day % allDuas.length]
          : _getDefaultDua();

      // إنشاء قائمة الاقتباسات
      _quotes = [
        _QuoteData(
          type: _QuoteType.verse,
          content: dailyQuote.verse,
          source: dailyQuote.verseSource,
          gradient: ColorHelper.getContentGradient('verse').colors,
        ),
        _QuoteData(
          type: _QuoteType.hadith,
          content: dailyQuote.hadith,
          source: dailyQuote.hadithSource,
          gradient: ColorHelper.getContentGradient('hadith').colors,
        ),
        _QuoteData(
          type: _QuoteType.dua,
          content: randomDua['text'] ?? 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          source: randomDua['source'] ?? 'سورة البقرة - آية 201',
          gradient: ColorHelper.getContentGradient('dua').colors,
        ),
      ];

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل الاقتباسات';
      });
      
      // استخدام بيانات افتراضية
      _quotes = _getDefaultQuotes();
    }
  }

  Map<String, String> _getDefaultDua() {
    return {
      'text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      'source': 'سورة البقرة - آية 201',
    };
  }

  List<_QuoteData> _getDefaultQuotes() {
    return [
      _QuoteData(
        type: _QuoteType.verse,
        content: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ',
        source: 'سورة الطلاق - آية 2-3',
        gradient: ColorHelper.getContentGradient('verse').colors,
      ),
      _QuoteData(
        type: _QuoteType.hadith,
        content: 'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ، حُطَّتْ خَطَايَاهُ وَلَوْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
        source: 'صحيح البخاري',
        gradient: ColorHelper.getContentGradient('hadith').colors,
      ),
      _QuoteData(
        type: _QuoteType.dua,
        content: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        source: 'سورة البقرة - آية 201',
        gradient: ColorHelper.getContentGradient('dua').colors,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // عنوان القسم
        _buildSectionHeader(context),
        
        ThemeConstants.space4.h,
        
        // محتوى البطاقة
        if (_isLoading)
          _buildLoadingState()
        else if (_errorMessage != null && _quotes.isEmpty)
          _buildErrorState()
        else
          _buildQuotesSection(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return AppCard(
      type: CardType.info,
      style: CardStyle.glassmorphism,
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
                  'آية وحديث وأدعية مختارة',
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
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 280,
      child: AppCard(
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
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 280,
      child: AppCard(
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
      ),
    );
  }

  Widget _buildQuotesSection() {
    return Column(
      children: [
        // بطاقات الاقتباسات
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              HapticFeedback.selectionClick();
            },
            itemCount: _quotes.length,
            itemBuilder: (context, index) {
              return _QuoteCard(quote: _quotes[index]);
            },
          ),
        ),
        
        ThemeConstants.space4.h,
        
        // مؤشر الصفحات
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_quotes.length, (index) {
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
}

/// بطاقة الاقتباس المحسنة
class _QuoteCard extends StatelessWidget {
  final _QuoteData quote;

  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
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
            blurRadius: 25,
            offset: const Offset(0, 15),
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
              onTap: () => _showQuoteDetails(context),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space5),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // رأس البطاقة
        _buildHeader(),
        
        const Spacer(),
        
        // النص الرئيسي
        _buildQuoteText(),
        
        const Spacer(),
        
        // المصدر
        _buildSource(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            quote.icon,
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
                quote.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: ThemeConstants.textSizeLg,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                quote.subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: ThemeConstants.textSizeSm,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteText() {
    return Container(
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
      child: Stack(
        children: [
          // علامة اقتباس افتتاحية
          const Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.format_quote,
              color: Colors.white60,
              size: 20,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
            child: Text(
              quote.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.8,
                fontWeight: ThemeConstants.medium,
                fontFamily: ThemeConstants.fontFamily,
              ),
            ),
          ),
          
          // علامة اقتباس ختامية
          Positioned(
            bottom: 0,
            left: 0,
            child: Transform.rotate(
              angle: math.pi,
              child: const Icon(
                Icons.format_quote,
                color: Colors.white60,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSource() {
    return Container(
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: ThemeConstants.textSizeSm,
          fontWeight: ThemeConstants.semiBold,
        ),
      ),
    );
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

/// نافذة تفاصيل الاقتباس
class _QuoteDetailsModal extends StatelessWidget {
  final _QuoteData quote;

  const _QuoteDetailsModal({required this.quote});

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
                    quote.title,
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
                        fontFamily: quote.type == _QuoteType.verse 
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

/// نموذج بيانات الاقتباس المحسن
class _QuoteData {
  final _QuoteType type;
  final String content;
  final String source;
  final List<Color> gradient;

  const _QuoteData({
    required this.type,
    required this.content,
    required this.source,
    required this.gradient,
  });

  IconData get icon {
    switch (type) {
      case _QuoteType.verse:
        return Icons.menu_book_rounded;
      case _QuoteType.hadith:
        return Icons.auto_stories_rounded;
      case _QuoteType.dua:
        return Icons.pan_tool_rounded;
    }
  }

  String get title {
    switch (type) {
      case _QuoteType.verse:
        return 'آية اليوم';
      case _QuoteType.hadith:
        return 'حديث اليوم';
      case _QuoteType.dua:
        return 'دعاء اليوم';
    }
  }

  String get subtitle {
    switch (type) {
      case _QuoteType.verse:
        return 'من القرآن الكريم';
      case _QuoteType.hadith:
        return 'من السنة النبوية';
      case _QuoteType.dua:
        return 'دعاء مأثور';
    }
  }
}

/// أنواع الاقتباسات
enum _QuoteType {
  verse,   // آية
  hadith,  // حديث
  dua,     // دعاء
}