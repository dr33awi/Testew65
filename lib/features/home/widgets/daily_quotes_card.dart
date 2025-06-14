// lib/features/home/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import '../../../app/themes/app_theme.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> {
  Map<String, dynamic>? _todayVerse;
  Map<String, dynamic>? _todayHadith;
  bool _isLoading = true;
  String? _error;
  PageController? _pageController;
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadDailyQuotes();
  }
  
  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
  
  Future<void> _loadDailyQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // محاولة تحميل الملف
      print('محاولة تحميل الملف من: assets/data/daily_quotes.json');
      
      String jsonString;
      try {
        jsonString = await rootBundle.loadString('assets/data/daily_quotes.json');
        print('تم تحميل الملف بنجاح. حجم المحتوى: ${jsonString.length} حرف');
      } catch (e) {
        print('خطأ في تحميل الملف: $e');
        throw Exception('لا يمكن العثور على ملف daily_quotes.json. تأكد من إضافته في pubspec.yaml');
      }
      
      // محاولة تحليل JSON
      Map<String, dynamic> data;
      try {
        data = json.decode(jsonString);
        print('تم تحليل JSON بنجاح');
      } catch (e) {
        print('خطأ في تحليل JSON: $e');
        print('أول 100 حرف من المحتوى: ${jsonString.substring(0, min(100, jsonString.length))}');
        throw Exception('خطأ في تنسيق ملف JSON. تأكد من صحة التنسيق');
      }
      
      // التحقق من وجود البيانات المطلوبة
      final List<dynamic>? quranVerses = data['quran_verses'];
      final List<dynamic>? hadiths = data['hadiths'];
      
      if (quranVerses == null || hadiths == null) {
        throw Exception('لا يحتوي الملف على البيانات المطلوبة (quran_verses أو hadiths)');
      }
      
      if (quranVerses.isEmpty || hadiths.isEmpty) {
        throw Exception('مصفوفة الآيات أو الأحاديث فارغة');
      }
      
      print('عدد الآيات: ${quranVerses.length}');
      print('عدد الأحاديث: ${hadiths.length}');
      
      // الحصول على آية وحديث اليوم بناءً على تاريخ اليوم
      final int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final int verseIndex = dayOfYear % quranVerses.length;
      final int hadithIndex = dayOfYear % hadiths.length;
      
      // تحديد آية اليوم
      _todayVerse = {
        'type': 'verse',
        'content': quranVerses[verseIndex]['text'] ?? '',
        'source': quranVerses[verseIndex]['source'] ?? '',
      };
      
      // تحديد حديث اليوم
      _todayHadith = {
        'type': 'hadith',
        'content': hadiths[hadithIndex]['text'] ?? '',
        'source': hadiths[hadithIndex]['source'] ?? '',
      };
      
      print('تم اختيار الآية رقم: $verseIndex');
      print('تم اختيار الحديث رقم: $hadithIndex');
      
      setState(() {
        _isLoading = false;
      });
      
      print('تم تحميل الاقتباسات بنجاح');
      
    } catch (e) {
      print('خطأ نهائي: $e');
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
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // آية اليوم
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
                  child: _buildQuoteCard(
                    context: context,
                    quote: _todayVerse!,
                    title: 'آية اليوم',
                  ),
                ),
                // حديث اليوم
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
                  child: _buildQuoteCard(
                    context: context,
                    quote: _todayHadith!,
                    title: 'حديث اليوم',
                  ),
                ),
              ],
            ),
          ),
          
          // مؤشر الصفحات
          ThemeConstants.space3.h,
          _buildPageIndicator(),
        ],
      ),
    );
  }
  
  Widget _buildQuoteCard({
    required BuildContext context,
    required Map<String, dynamic> quote,
    required String title,
  }) {
    final bool isVerse = quote['type'] == 'verse';
    final gradient = isVerse
        ? [
            context.primaryColor,
            context.primaryColor.withOpacity(0.8),
          ]
        : [
            const Color(0xFF6B46C1),
            const Color(0xFF9333EA),
          ];
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: InkWell(
          onTap: () {
            _showQuoteActions(context, quote['content'], quote['source']);
          },
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.space3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        isVerse ? Icons.menu_book_rounded : Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: ThemeConstants.iconLg,
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Text(
                      title,
                      style: context.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                ThemeConstants.space4.h,
                
                // Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(ThemeConstants.space4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: ThemeConstants.borderThin,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // علامة اقتباس البداية
                        Row(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: Colors.white.withOpacity(0.5),
                              size: ThemeConstants.iconSm,
                            ),
                          ],
                        ),
                        
                        const Spacer(),
                        
                        // النص
                        SingleChildScrollView(
                          child: Text(
                            quote['content'],
                            style: context.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // علامة اقتباس النهاية
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Transform.rotate(
                              angle: pi,
                              child: Icon(
                                Icons.format_quote,
                                color: Colors.white.withOpacity(0.5),
                                size: ThemeConstants.iconSm,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Source
                if (quote['source'].isNotEmpty) ...[
                  ThemeConstants.space3.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                          quote['source'],
                          style: context.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
      children: List.generate(
        2,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? context.primaryColor
                : context.primaryColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: _buildShimmerCard(),
    );
  }
  
  Widget _buildShimmerCard() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Widget _buildErrorCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: ThemeConstants.borderThin,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: ThemeConstants.iconXl,
            ),
            ThemeConstants.space2.h,
            Text(
              'خطأ في تحميل الاقتباسات',
              style: context.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            ThemeConstants.space2.h,
            Text(
              _error ?? 'حدث خطأ غير معروف',
              style: context.bodySmall?.copyWith(
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            ThemeConstants.space3.h,
            ElevatedButton.icon(
              onPressed: _loadDailyQuotes,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
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
            top: Radius.circular(ThemeConstants.radiusXl),
          ),
        ),
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              ),
            ),
            
            ThemeConstants.space4.h,
            
            // Actions
            ListTile(
              leading: Icon(
                Icons.copy_rounded,
                color: context.primaryColor,
              ),
              title: const Text('نسخ النص'),
              onTap: () {
                final fullText = '$content\n\n$source';
                Clipboard.setData(ClipboardData(text: fullText));
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم نسخ النص'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: context.primaryColor,
                  ),
                );
              },
            ),
            
            ListTile(
              leading: Icon(
                Icons.share_rounded,
                color: context.primaryColor,
              ),
              title: const Text('مشاركة'),
              onTap: () {
                Navigator.pop(context);
                // يمكن إضافة وظيفة المشاركة هنا باستخدام share package
              },
            ),
            
            ThemeConstants.space2.h,
          ],
        ),
      ),
    );
  }
}