// lib/features/athkar/screens/athkar_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/index.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../models/athkar_progress.dart';

/// شاشة تفاصيل فئة الأذكار
class AthkarDetailsScreen extends StatefulWidget {
  final String categoryId;

  const AthkarDetailsScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<AthkarDetailsScreen> createState() => _AthkarDetailsScreenState();
}

class _AthkarDetailsScreenState extends State<AthkarDetailsScreen>
    with TickerProviderStateMixin {
  late final AthkarService _athkarService;
  late AnimationController _progressAnimationController;
  late AnimationController _counterAnimationController;

  AthkarCategory? _category;
  AthkarProgress? _progress;
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;
  bool _autoMode = false;

  // للعداد
  final Map<int, int> _currentCounts = {};
  final Map<int, Animation<double>> _counterAnimations = {};

  @override
  void initState() {
    super.initState();
    _athkarService = getService<AthkarService>();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _counterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final category = await _athkarService.getCategoryById(widget.categoryId);
      if (category == null) {
        setState(() {
          _error = 'الفئة غير موجودة';
          _isLoading = false;
        });
        return;
      }

      final progress = await _athkarService.getCategoryProgress(widget.categoryId);

      // تهيئة العدادات
      for (final item in category.athkar) {
        _currentCounts[item.id] = progress.itemProgress[item.id] ?? 0;
        _counterAnimations[item.id] = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _counterAnimationController,
          curve: Curves.elasticOut,
        ));
      }

      setState(() {
        _category = category;
        _progress = progress;
        _isLoading = false;
      });

      _progressAnimationController.forward();
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ في تحميل البيانات';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return IslamicAppBar(
      title: _category?.title ?? 'تحميل...',
      actions: [
        if (_category != null) ...[
          IconButton(
            icon: Icon(_autoMode ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleAutoMode,
            tooltip: _autoMode ? 'إيقاف التلقائي' : 'وضع تلقائي',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('إعادة تعيين التقدم'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('مشاركة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const IslamicLoading(
        message: 'جاري تحميل الأذكار...',
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

    if (_category == null || _category!.athkar.isEmpty) {
      return const EmptyState(
        icon: Icons.menu_book,
        title: 'لا توجد أذكار',
        subtitle: 'هذه الفئة لا تحتوي على أذكار',
      );
    }

    return Column(
      children: [
        _buildProgressHeader(),
        Expanded(child: _buildAthkarList()),
      ],
    );
  }

  Widget _buildProgressHeader() {
    final completedCount = _currentCounts.values.fold<int>(0, (sum, count) => sum + count);
    final totalCount = _category!.athkar.fold<int>(0, (sum, item) => sum + item.count);
    final percentage = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

    return IslamicCard.gradient(
      gradient: ThemeConstants.primaryGradient,
      margin: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  _category!.icon,
                  color: Colors.white,
                  size: ThemeConstants.iconLg,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _category!.title,
                      style: AppTypography.title.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.fontBold,
                      ),
                    ),
                    if (_category!.description != null) ...[
                      Spaces.xs,
                      Text(
                        _category!.description!,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Spaces.medium,
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  icon: Icons.check_circle,
                  label: 'مكتمل',
                  value: '$completedCount',
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildStatsCard(
                  icon: Icons.trending_up,
                  label: 'التقدم',
                  value: '$percentage%',
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildStatsCard(
                  icon: Icons.menu_book,
                  label: 'المجموع',
                  value: '$totalCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceSm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: ThemeConstants.iconMd,
          ),
          Spaces.xs,
          Text(
            value,
            style: AppTypography.button.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthkarList() {
    return PageView.builder(
      controller: PageController(initialPage: _currentIndex),
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: _category!.athkar.length,
      itemBuilder: (context, index) {
        final item = _category!.athkar[index];
        return _buildAthkarCard(item, index);
      },
    );
  }

  Widget _buildAthkarCard(AthkarItem item, int index) {
    final currentCount = _currentCounts[item.id] ?? 0;
    final isCompleted = currentCount >= item.count;
    final animation = _counterAnimations[item.id]!;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: IslamicCard(
        padding: const EdgeInsets.all(ThemeConstants.spaceLg),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Counter section
              AnimatedBuilder(
                animation: animation,
                child: _buildCounter(item, currentCount, isCompleted),
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (animation.value * 0.1),
                    child: child,
                  );
                },
              ),

              Spaces.large,

              // Text section
              IslamicText.dua(
                text: item.text,
                textAlign: TextAlign.center,
                padding: const EdgeInsets.symmetric(
                  vertical: ThemeConstants.spaceMd,
                ),
              ),

              Spaces.large,

              // Action buttons
              _buildActionButtons(item, currentCount, isCompleted),

              // Additional info
              if (item.fadl != null || item.source != null) ...[
                Spaces.large,
                _buildAdditionalInfo(item),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(AthkarItem item, int currentCount, bool isCompleted) {
    return GestureDetector(
      onTap: () => _incrementCounter(item),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isCompleted
              ? LinearGradient(
                  colors: [ThemeConstants.success, ThemeConstants.success.lighten(0.2)],
                )
              : LinearGradient(
                  colors: [context.primaryColor, context.primaryColor.lighten(0.2)],
                ),
          boxShadow: ThemeConstants.shadowMd,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCompleted) ...[
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 36,
              ),
              Spaces.xs,
              Text(
                'مكتمل',
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ] else ...[
              Text(
                '$currentCount',
                style: AppTypography.counter.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              Text(
                'من ${item.count}',
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AthkarItem item, int currentCount, bool isCompleted) {
    return Row(
      children: [
        Expanded(
          child: IslamicButton.outlined(
          text: 'نسخ',
          icon: Icons.copy,
          onPressed: () => _copyText(item.text),
          ),
        ),
        Spaces.mediumH,
        Expanded(
          child: IslamicButton.outlined(
            text: _athkarService.isFavorite(widget.categoryId, item.id)
                ? 'إزالة من المفضلة'
                : 'إضافة للمفضلة',
            icon: _athkarService.isFavorite(widget.categoryId, item.id)
                ? Icons.favorite
                : Icons.favorite_border,
            onPressed: () => _toggleFavorite(item),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(AthkarItem item) {
    return Column(
      children: [
        if (item.fadl != null) ...[
          ExpansionTile(
            title: const Text(
              'الفضل',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: const Icon(Icons.star),
            children: [
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                child: Text(
                  item.fadl!,
                  style: context.bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
        if (item.source != null) ...[
          ExpansionTile(
            title: const Text(
              'المصدر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: const Icon(Icons.source),
            children: [
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                child: Text(
                  item.source!,
                  style: context.bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar() {
    if (_category == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          IconButton(
            onPressed: _currentIndex > 0 ? _previousItem : null,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: 'السابق',
          ),
          
          // Page indicator
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _category!.athkar.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex
                        ? context.primaryColor
                        : context.borderColor,
                  ),
                ),
              ),
            ),
          ),
          
          // Next button
          IconButton(
            onPressed: _currentIndex < _category!.athkar.length - 1 ? _nextItem : null,
            icon: const Icon(Icons.arrow_forward_ios),
            tooltip: 'التالي',
          ),
        ],
      ),
    );
  }

  // Actions
  void _incrementCounter(AthkarItem item) {
    final currentCount = _currentCounts[item.id] ?? 0;
    if (currentCount < item.count) {
      setState(() {
        _currentCounts[item.id] = currentCount + 1;
      });

      // حفظ التقدم
      _athkarService.updateItemProgress(
        categoryId: widget.categoryId,
        itemId: item.id,
        count: _currentCounts[item.id]!,
      );

      // تشغيل الأنيميشن
      _counterAnimationController.reset();
      _counterAnimationController.forward();

      // اهتزاز
      HapticFeedback.lightImpact();

      // إذا اكتمل العدد
      if (_currentCounts[item.id] == item.count) {
        HapticFeedback.mediumImpact();
        context.showSuccessMessage('تم إكمال هذا الذكر ✨');
        
        // الانتقال للتالي في الوضع التلقائي
        if (_autoMode && _currentIndex < _category!.athkar.length - 1) {
          Future.delayed(const Duration(seconds: 2), _nextItem);
        }
      }
    }
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    context.showMessage('تم نسخ النص');
  }

  void _toggleFavorite(AthkarItem item) async {
    final isFavorite = _athkarService.isFavorite(widget.categoryId, item.id);
    
    if (isFavorite) {
      await _athkarService.removeFromFavorites(
        categoryId: widget.categoryId,
        itemId: item.id,
      );
      context.showMessage('تم إزالة الذكر من المفضلة');
    } else {
      await _athkarService.addToFavorites(
        categoryId: widget.categoryId,
        itemId: item.id,
      );
      context.showSuccessMessage('تم إضافة الذكر للمفضلة');
    }
    
    setState(() {});
  }

  void _previousItem() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextItem() {
    if (_currentIndex < _category!.athkar.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _toggleAutoMode() {
    setState(() {
      _autoMode = !_autoMode;
    });
    
    if (_autoMode) {
      context.showMessage('تم تفعيل الوضع التلقائي');
    } else {
      context.showMessage('تم إيقاف الوضع التلقائي');
    }
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'reset':
        _showResetDialog();
        break;
      case 'share':
        _shareCategory();
        break;
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين التقدم'),
        content: const Text('هل تريد إعادة تعيين تقدم هذه الفئة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _athkarService.resetCategoryProgress(widget.categoryId);
              await _loadData();
              context.showMessage('تم إعادة تعيين التقدم');
            },
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  void _shareCategory() {
    final text = '${_category!.title}\n\n${_category!.athkar.map((item) => item.text).join('\n\n')}';
    // يمكن إضافة مكتبة المشاركة هنا
    context.showMessage('مشاركة النص - قريباً');
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _counterAnimationController.dispose();
    super.dispose();
  }
}