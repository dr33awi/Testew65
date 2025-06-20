// lib/features/daily_quote/widgets/daily_quotes_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/index.dart';
import '../services/daily_quote_service.dart';
import '../models/daily_quote_model.dart';

/// بطاقة الاقتباسات اليومية المحسّنة
class DailyQuotesCard extends StatefulWidget {
  /// إذا كان true، سيتم عرض البطاقة بشكل مضغوط
  final bool isCompact;
  
  /// دالة callback عند الضغط على البطاقة
  final VoidCallback? onTap;
  
  /// هل تظهر أزرار التحكم
  final bool showControls;
  
  /// هل تظهر معلومات إضافية
  final bool showMetadata;

  const DailyQuotesCard({
    super.key,
    this.isCompact = false,
    this.onTap,
    this.showControls = true,
    this.showMetadata = true,
  });

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard>
    with TickerProviderStateMixin {
  late final DailyQuoteService _quoteService;
  late AnimationController _fadeController;
  late AnimationController _refreshController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _refreshAnimation;

  DailyQuoteModel? _currentQuote;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;
  int _currentView = 0; // 0 = آية، 1 = حديث

  @override
  void initState() {
    super.initState();
    _quoteService = getService<DailyQuoteService>();
    _initializeAnimations();
    _loadDailyQuote();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _loadDailyQuote() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final quote = await _quoteService.getDailyQuote();

      setState(() {
        _currentQuote = quote;
        _isLoading = false;
      });

      _fadeController.forward();
    } catch (e) {
      setState(() {
        _error = 'فشل في تحميل الاقتباس اليومي';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshQuote() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();
    HapticFeedback.lightImpact();

    try {
      final newQuote = await _quoteService.refreshQuote();
      
      setState(() {
        _currentQuote = newQuote;
        _isRefreshing = false;
      });

      _fadeController.reset();
      _fadeController.forward();
      
      context.showSuccessMessage('تم تحديث الاقتباس');
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });
      context.showErrorMessage('فشل في تحديث الاقتباس');
    } finally {
      _refreshController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard();
    }

    if (_error != null || _currentQuote == null) {
      return _buildErrorCard();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.isCompact ? _buildCompactCard() : _buildFullCard(),
    );
  }

  Widget _buildLoadingCard() {
    return IslamicCard.gradient(
      gradient: ThemeConstants.primaryGradient,
      onTap: widget.onTap,
      child: SizedBox(
        height: widget.isCompact ? 120 : 200,
        child: const Center(
          child: IslamicLoading(
            message: 'جاري تحميل الاقتباس اليومي...',
            showMessage: false,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return IslamicCard(
      color: ThemeConstants.error.withValues(alpha: 0.1),
      onTap: widget.onTap,
      child: SizedBox(
        height: widget.isCompact ? 120 : 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: ThemeConstants.error,
              size: widget.isCompact ? 32 : 48,
            ),
            Spaces.small,
            Text(
              _error ?? 'حدث خطأ',
              style: (widget.isCompact ? AppTypography.caption : AppTypography.body)
                  .copyWith(color: ThemeConstants.error),
              textAlign: TextAlign.center,
            ),
            if (widget.showControls) ...[
              Spaces.small,
              IslamicButton.small(
                text: 'إعادة المحاولة',
                icon: Icons.refresh,
                onPressed: _loadDailyQuote,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard() {
    return IslamicCard.gradient(
      gradient: _getGradientForView(),
      onTap: widget.onTap ?? () => _toggleView(),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                  ),
                  child: Icon(
                    _currentView == 0 ? Icons.book : Icons.format_quote,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                ),
                Spaces.smallH,
                Expanded(
                  child: Text(
                    _currentView == 0 ? 'آية اليوم' : 'حديث اليوم',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: ThemeConstants.fontMedium,
                    ),
                  ),
                ),
                if (widget.showControls) ...[
                  AnimatedBuilder(
                    animation: _refreshAnimation,
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      color: Colors.white.withValues(alpha: 0.8),
                      iconSize: ThemeConstants.iconSm,
                      onPressed: _isRefreshing ? null : _refreshQuote,
                    ),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _refreshAnimation.value * 2 * 3.14159,
                        child: child,
                      );
                    },
                  ),
                ],
              ],
            ),
            
            Spaces.small,
            
            // Content
            Expanded(
              child: IslamicText(
                text: _getCurrentText(),
                type: _currentView == 0 ? IslamicTextType.quran : IslamicTextType.hadith,
                fontSize: ThemeConstants.fontSizeSm,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
            
            // Source
            if (widget.showMetadata) ...[
              Spaces.xs,
              Text(
                _getCurrentSource(),
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: ThemeConstants.fontSizeXs,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard() {
    return IslamicCard.gradient(
      gradient: _getGradientForView(),
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with controls
          _buildCardHeader(),
          
          Spaces.medium,
          
          // Content tabs
          _buildContentTabs(),
          
          Spaces.medium,
          
          // Main content
          _buildMainContent(),
          
          Spaces.medium,
          
          // Source and actions
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.spaceSm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: ThemeConstants.iconMd,
          ),
        ),
        Spaces.mediumH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الاقتباس اليومي',
                style: AppTypography.title.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              Text(
                _formatDate(DateTime.now()),
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        if (widget.showControls) ...[
          AnimatedBuilder(
            animation: _refreshAnimation,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              color: Colors.white,
              onPressed: _isRefreshing ? null : _refreshQuote,
              tooltip: 'تحديث الاقتباس',
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: _refreshAnimation.value * 2 * 3.14159,
                child: child,
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildContentTabs() {
    return Row(
      children: [
        _buildTab('آية كريمة', Icons.book, 0),
        Spaces.smallH,
        _buildTab('حديث شريف', Icons.format_quote, 1),
      ],
    );
  }

  Widget _buildTab(String title, IconData icon, int index) {
    final isSelected = _currentView == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchView(index),
        child: AnimatedContainer(
          duration: ThemeConstants.durationFast,
          padding: const EdgeInsets.symmetric(
            vertical: ThemeConstants.spaceSm,
            horizontal: ThemeConstants.spaceMd,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: isSelected 
                ? Border.all(color: Colors.white.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: ThemeConstants.iconSm,
              ),
              Spaces.smallH,
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: isSelected 
                      ? ThemeConstants.fontSemiBold 
                      : ThemeConstants.fontRegular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          IslamicText(
            text: _getCurrentText(),
            type: _currentView == 0 ? IslamicTextType.quran : IslamicTextType.hadith,
            fontSize: ThemeConstants.fontSizeLg,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
          
          if (widget.showMetadata) ...[
            Spaces.medium,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spaceMd,
                vertical: ThemeConstants.spaceSm,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Text(
                _getCurrentSource(),
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: ThemeConstants.fontMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    if (!widget.showControls) return const SizedBox.shrink();
    
    return Row(
      children: [
        Expanded(
          child: IslamicButton.outlined(
            text: 'نسخ',
            icon: Icons.copy,
            color: Colors.white,
            onPressed: _copyCurrentText,
          ),
        ),
        Spaces.mediumH,
        Expanded(
          child: IslamicButton.outlined(
            text: 'مشاركة',
            icon: Icons.share,
            color: Colors.white,
            onPressed: _shareCurrentText,
          ),
        ),
      ],
    );
  }

  // Helper methods
  LinearGradient _getGradientForView() {
    return _currentView == 0 
        ? LinearGradient(
            colors: [
              ThemeConstants.primary,
              ThemeConstants.primary.lighten(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [
              ThemeConstants.secondary,
              ThemeConstants.secondary.lighten(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  String _getCurrentText() {
    if (_currentQuote == null) return '';
    return _currentView == 0 ? _currentQuote!.verse : _currentQuote!.hadith;
  }

  String _getCurrentSource() {
    if (_currentQuote == null) return '';
    return _currentView == 0 ? _currentQuote!.verseSource : _currentQuote!.hadithSource;
  }

  void _switchView(int index) {
    if (_currentView != index) {
      setState(() {
        _currentView = index;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _toggleView() {
    _switchView(_currentView == 0 ? 1 : 0);
  }

  void _copyCurrentText() {
    final text = '${_getCurrentText()}\n\n${_getCurrentSource()}';
    Clipboard.setData(ClipboardData(text: text));
    context.showMessage('تم نسخ النص');
    HapticFeedback.lightImpact();
  }

  void _shareCurrentText() {
    final text = '${_getCurrentText()}\n\n${_getCurrentSource()}\n\n#تطبيق_الأذكار';
    // يمكن إضافة مكتبة المشاركة هنا
    context.showMessage('مشاركة النص - قريباً');
  }

  String _formatDate(DateTime date) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    const weekdays = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 
      'الجمعة', 'السبت', 'الأحد'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    
    return '$weekday، $day $month $year';
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _refreshController.dispose();
    super.dispose();
  }
}