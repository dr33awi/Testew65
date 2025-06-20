// lib/features/daily_quote/screens/daily_quotes_screen.dart
import 'package:flutter/material.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/index.dart';
import '../services/daily_quote_service.dart';
import '../models/daily_quote_model.dart';
import '../widgets/daily_quotes_card.dart';

/// شاشة الاقتباسات اليومية المتقدمة
class DailyQuotesScreen extends StatefulWidget {
  const DailyQuotesScreen({super.key});

  @override
  State<DailyQuotesScreen> createState() => _DailyQuotesScreenState();
}

class _DailyQuotesScreenState extends State<DailyQuotesScreen>
    with TickerProviderStateMixin {
  late final DailyQuoteService _quoteService;
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  DailyQuoteModel? _currentQuote;
  List<Map<String, dynamic>> _allVerses = [];
  List<Map<String, dynamic>> _allHadiths = [];
  List<Map<String, dynamic>> _allDuas = [];
  
  bool _isLoading = true;
  String? _error;
  Map<String, int> _dataStats = {};

  @override
  void initState() {
    super.initState();
    _quoteService = getService<DailyQuoteService>();
    _tabController = TabController(length: 4, vsync: this);
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // تحميل البيانات بالتوازي
      final results = await Future.wait([
        _quoteService.getDailyQuote(),
        _quoteService.getAllVerses(),
        _quoteService.getAllHadiths(),
        _quoteService.getAllDuas(),
      ]);

      setState(() {
        _currentQuote = results[0] as DailyQuoteModel;
        _allVerses = results[1] as List<Map<String, dynamic>>;
        _allHadiths = results[2] as List<Map<String, dynamic>>;
        _allDuas = results[3] as List<Map<String, dynamic>>;
        _dataStats = _quoteService.getDataStats();
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = 'فشل في تحميل البيانات';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return IslamicAppBar(
      title: 'الاقتباسات اليومية',
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: _showInfoDialog,
          tooltip: 'معلومات',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
          tooltip: 'تحديث',
        ),
      ],
      bottom: _isLoading ? null : TabBar(
        controller: _tabController,
        labelColor: context.primaryColor,
        unselectedLabelColor: context.secondaryTextColor,
        indicatorColor: context.primaryColor,
        tabs: const [
          Tab(text: 'اليوم', icon: Icon(Icons.today)),
          Tab(text: 'آيات', icon: Icon(Icons.book)),
          Tab(text: 'أحاديث', icon: Icon(Icons.format_quote)),
          Tab(text: 'أدعية', icon: Icon(Icons.pan_tool)),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const IslamicLoading(
        message: 'جاري تحميل الاقتباسات...',
      );
    }

    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'حدث خطأ',
        subtitle: _error,
        action: IslamicButton.primary(
          text: 'إعادة المحاولة',
          icon: Icons.refresh,
          onPressed: _loadData,
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildVersesTab(),
          _buildHadithsTab(),
          _buildDuasTab(),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: Column(
        children: [
          // البطاقة الرئيسية
          const DailyQuotesCard(
            isCompact: false,
            showControls: true,
            showMetadata: true,
          ),
          
          Spaces.large,
          
          // إحصائيات سريعة
          _buildStatsSection(),
          
          Spaces.large,
          
          // نصائح وإرشادات
          _buildTipsSection(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics),
              Spaces.mediumH,
              Text(
                'إحصائيات المحتوى',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.book,
                  label: 'آيات قرآنية',
                  value: '${_dataStats['verses'] ?? 0}',
                  color: ThemeConstants.primary,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildStatCard(
                  icon: Icons.format_quote,
                  label: 'أحاديث شريفة',
                  value: '${_dataStats['hadiths'] ?? 0}',
                  color: ThemeConstants.secondary,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildStatCard(
                  icon: Icons.pan_tool,
                  label: 'أدعية مختارة',
                  value: '${_dataStats['duas'] ?? 0}',
                  color: ThemeConstants.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconLg,
          ),
          Spaces.small,
          Text(
            value,
            style: AppTypography.title.copyWith(
              color: color,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          Text(
            label,
            style: context.captionStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return IslamicCard.gradient(
      gradient: LinearGradient(
        colors: [
          ThemeConstants.info,
          ThemeConstants.info.lighten(0.2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb,
                color: Colors.white,
              ),
              Spaces.mediumH,
              Text(
                'نصائح للاستفادة',
                style: AppTypography.title.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          ..._getTips().map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: ThemeConstants.spaceSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                Spaces.smallH,
                Expanded(
                  child: Text(
                    tip,
                    style: AppTypography.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildVersesTab() {
    return _buildContentList(
      items: _allVerses,
      type: ContentType.verse,
      emptyMessage: 'لا توجد آيات متاحة',
    );
  }

  Widget _buildHadithsTab() {
    return _buildContentList(
      items: _allHadiths,
      type: ContentType.hadith,
      emptyMessage: 'لا توجد أحاديث متاحة',
    );
  }

  Widget _buildDuasTab() {
    return _buildContentList(
      items: _allDuas,
      type: ContentType.dua,
      emptyMessage: 'لا توجد أدعية متاحة',
    );
  }

  Widget _buildContentList({
    required List<Map<String, dynamic>> items,
    required ContentType type,
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
      return EmptyState(
        icon: _getContentIcon(type),
        title: emptyMessage,
        subtitle: 'تحقق من اتصال الإنترنت وحاول مرة أخرى',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildContentCard(item, type, index);
      },
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item, ContentType type, int index) {
    final text = item['text'] ?? '';
    final source = item['source'] ?? '';
    final narrator = item['narrator'];

    return IslamicCard(
      margin: const EdgeInsets.only(bottom: ThemeConstants.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                decoration: BoxDecoration(
                  color: _getContentColor(type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                ),
                child: Icon(
                  _getContentIcon(type),
                  color: _getContentColor(type),
                  size: ThemeConstants.iconSm,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Text(
                  _getContentTypeLabel(type),
                  style: context.captionStyle.copyWith(
                    color: _getContentColor(type),
                    fontWeight: ThemeConstants.fontMedium,
                  ),
                ),
              ),
              Text(
                '#${index + 1}',
                style: context.captionStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          // Content
          IslamicText(
            text: text,
            type: _getIslamicTextType(type),
            textAlign: TextAlign.center,
          ),
          
          Spaces.medium,
          
          // Source
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ThemeConstants.spaceSm),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  source,
                  style: context.captionStyle.copyWith(
                    fontWeight: ThemeConstants.fontMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (narrator != null) ...[
                  Spaces.xs,
                  Text(
                    'راوي الحديث: $narrator',
                    style: context.captionStyle.copyWith(
                      fontSize: ThemeConstants.fontSizeXs,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<String> _getTips() {
    return [
      'اقرأ الاقتباس اليومي في بداية يومك للحصول على الإلهام',
      'تأمل في معاني الآيات والأحاديث واربطها بحياتك اليومية',
      'شارك الاقتباسات المفيدة مع أصدقائك وعائلتك',
      'احفظ الأدعية المختارة واستخدمها في صلواتك',
      'اجعل قراءة الاقتباس جزءاً من روتينك اليومي',
    ];
  }

  IconData _getContentIcon(ContentType type) {
    switch (type) {
      case ContentType.verse:
        return Icons.book;
      case ContentType.hadith:
        return Icons.format_quote;
      case ContentType.dua:
        return Icons.pan_tool;
    }
  }

  Color _getContentColor(ContentType type) {
    switch (type) {
      case ContentType.verse:
        return ThemeConstants.primary;
      case ContentType.hadith:
        return ThemeConstants.secondary;
      case ContentType.dua:
        return ThemeConstants.info;
    }
  }

  String _getContentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.verse:
        return 'آية كريمة';
      case ContentType.hadith:
        return 'حديث شريف';
      case ContentType.dua:
        return 'دعاء مبارك';
    }
  }

  IslamicTextType _getIslamicTextType(ContentType type) {
    switch (type) {
      case ContentType.verse:
        return IslamicTextType.quran;
      case ContentType.hadith:
        return IslamicTextType.hadith;
      case ContentType.dua:
        return IslamicTextType.dua;
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول الاقتباسات اليومية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تطبيق الاقتباسات اليومية يوفر لك مجموعة مختارة من الآيات القرآنية والأحاديث النبوية والأدعية المباركة.',
            ),
            Spaces.medium,
            Text(
              'الإحصائيات:',
              style: context.bodyStyle.copyWith(
                fontWeight: ThemeConstants.fontBold,
              ),
            ),
            Spaces.small,
            Text('• ${_dataStats['verses'] ?? 0} آية قرآنية'),
            Text('• ${_dataStats['hadiths'] ?? 0} حديث شريف'),
            Text('• ${_dataStats['duas'] ?? 0} دعاء مبارك'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    await _loadData();
    context.showSuccessMessage('تم تحديث البيانات');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

enum ContentType { verse, hadith, dua }