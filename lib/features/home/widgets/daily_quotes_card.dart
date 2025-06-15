// lib/features/home/widgets/daily_quotes_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
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

  final PageController _quotesPageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadDailyQuotes();
  }

  @override
  void dispose() {
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

      final List<dynamic> verses = data['quran_verses'] ?? [];
      final List<dynamic> hadiths = data['hadiths'] ?? [];

      if (verses.isEmpty || hadiths.isEmpty) {
        throw Exception('قوائم الآيات أو الأحاديث فارغة');
      }

      final int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      final int verseIndex = dayOfYear % verses.length;
      final int hadithIndex = dayOfYear % hadiths.length;

      _todayQuote = {
        'verse': verses[verseIndex]['text'] ?? '',
        'verse_source': verses[verseIndex]['source'] ?? '',
        'hadith': hadiths[hadithIndex]['text'] ?? '',
        'hadith_source': hadiths[hadithIndex]['source'] ?? '',
      };

      setState(() {
        _isLoading = false;
      });
    } catch (e, stack) {
      print('خطأ أثناء تحميل الاقتباسات: $e');
      print(stack);
      setState(() {
        _isLoading = false;
        _error = 'تعذر تحميل بيانات الاقتباسات.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingCard(context);
    if (_error != null || _todayQuote == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PageView(
              controller: _quotesPageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _buildQuoteCard(
                  context: context,
                  title: 'آية اليوم',
                  content: _todayQuote!['verse'] ?? '',
                  source: _todayQuote!['verse_source'] ?? '',
                  icon: Icons.menu_book_rounded,
                  gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
                ),
                _buildQuoteCard(
                  context: context,
                  title: 'حديث اليوم',
                  content: _todayQuote!['hadith'] ?? '',
                  source: _todayQuote!['hadith_source'] ?? '',
                  icon: Icons.auto_stories_rounded,
                  gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
                ),
              ],
            ),
          ),
          ThemeConstants.space3.h,
          _buildPageIndicator(),
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
    // تحديد إذا كان النص طويل
    final isLongText = content.length > 150;
    final displayText = isLongText ? '${content.substring(0, 150)}...' : content;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient.map((c) => c.withOpacity(0.9)).toList(),
        ),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showQuoteDetails(context, title, content, source),
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
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
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // النص الرئيسي
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.space3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayText,
                          style: context.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: ThemeConstants.medium,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isLongText) ...[
                          ThemeConstants.space2.h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app,
                                color: Colors.white.withOpacity(0.7),
                                size: 16,
                              ),
                              ThemeConstants.space1.w,
                              Text(
                                'اضغط لقراءة المزيد',
                                style: context.labelSmall?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  void _showQuoteDetails(BuildContext context, String title, String content, String source) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            
            // Header
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.space2),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      title.contains('آية') ? Icons.menu_book_rounded : Icons.auto_stories_rounded,
                      color: context.primaryColor,
                      size: ThemeConstants.iconLg,
                    ),
                  ),
                  ThemeConstants.space3.w,
                  Expanded(
                    child: Text(
                      title,
                      style: context.headlineSmall?.semiBold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            Divider(color: context.dividerColor),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(ThemeConstants.space5),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                        border: Border.all(
                          color: context.dividerColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        content,
                        style: context.bodyLarge?.copyWith(
                          height: 1.8,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    if (source.isNotEmpty) ...[
                      ThemeConstants.space3.h,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space4,
                          vertical: ThemeConstants.space2,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        ),
                        child: Text(
                          source,
                          style: context.titleSmall?.copyWith(
                            color: context.primaryColor,
                            fontWeight: ThemeConstants.semiBold,
                          ),
                        ),
                      ),
                    ],
                    
                    ThemeConstants.space4.h,
                  ],
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: context.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'نسخ النص',
                      icon: Icons.copy_rounded,
                      onPressed: () {
                        _copyQuote(context, content, source);
                      },
                      size: ButtonSize.large,
                    ),
                  ),
                  ThemeConstants.space3.w,
                  Expanded(
                    child: AppButton.primary(
                      text: 'مشاركة',
                      icon: Icons.share_rounded,
                      onPressed: () {
                        _shareQuote(context, content, source);
                      },
                      backgroundColor: context.primaryColor,
                      size: ButtonSize.large,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyQuote(BuildContext context, String content, String source) {
    final fullText = '$content\n\n$source';
    Clipboard.setData(ClipboardData(text: fullText));
    
    context.showSuccessSnackBar('تم نسخ النص بنجاح');
    HapticFeedback.mediumImpact();
  }

  Future<void> _shareQuote(BuildContext context, String content, String source) async {
    HapticFeedback.lightImpact();
    
    final fullText = '$content\n\n$source\n\nمن تطبيق الأذكار';
    
    try {
      await Share.share(
        fullText,
        subject: source,
      );
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar('حدث خطأ أثناء المشاركة');
      }
    }
  }
}