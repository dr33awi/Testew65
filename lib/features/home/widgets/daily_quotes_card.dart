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
  Map<String, dynamic>? _todayQuote;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadDailyQuotes();
  }
  
  Future<void> _loadDailyQuotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // تحميل ملف الاقتباسات اليومية
      final String jsonString = await rootBundle.loadString('assets/data/daily_quotes.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      // الحصول على اقتباس اليوم بناءً على تاريخ اليوم
      final int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final List<dynamic> quotes = data['quotes'] ?? [];
      
      if (quotes.isNotEmpty) {
        // اختيار اقتباس بناءً على يوم السنة للحصول على اقتباس مختلف كل يوم
        final int index = dayOfYear % quotes.length;
        _todayQuote = quotes[index];
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading daily quotes: $e'); // للتشخيص
      setState(() {
        _isLoading = false;
        _error = 'حدث خطأ في تحميل البيانات: $e';
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
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        children: [
          // كارد الآية
          _buildQuoteCard(
            context: context,
            title: 'آية اليوم',
            content: _todayQuote!['verse'] ?? '',
            source: _todayQuote!['verse_source'] ?? '',
            icon: Icons.menu_book_rounded,
            gradient: [
              context.primaryColor,
              context.primaryColor.withOpacity(0.8),
            ],
          ),
          
          ThemeConstants.space4.h,
          
          // كارد الحديث
          _buildQuoteCard(
            context: context,
            title: 'حديث اليوم',
            content: _todayQuote!['hadith'] ?? '',
            source: _todayQuote!['hadith_source'] ?? '',
            icon: Icons.auto_stories_rounded,
            gradient: [
              const Color(0xFF6B46C1),
              const Color(0xFF9333EA),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuoteCard({
    required BuildContext context,
    required String title,
    required String content,
    required String source,
    required IconData icon,
    required List<Color> gradient,
  }) {
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
            // يمكن إضافة وظيفة النسخ أو المشاركة هنا
            _showQuoteActions(context, content, source);
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
                        icon,
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
                    const Spacer(),
                    Icon(
                      Icons.share_outlined,
                      color: Colors.white.withOpacity(0.8),
                      size: ThemeConstants.iconMd,
                    ),
                  ],
                ),
                
                ThemeConstants.space4.h,
                
                // Content
                Container(
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
                      
                      // النص
                      Text(
                        content,
                        style: context.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
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
                
                // Source
                if (source.isNotEmpty) ...[
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
                          source,
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
  
  Widget _buildLoadingCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        children: [
          _buildShimmerCard(),
          ThemeConstants.space4.h,
          _buildShimmerCard(),
        ],
      ),
    );
  }
  
  Widget _buildShimmerCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
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