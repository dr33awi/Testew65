// lib/features/athkar/screens/athkar_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/app/themes/app_theme.dart';
import '../models/athkar_model.dart';
import '../models/athkar_progress.dart';
import '../services/athkar_service.dart';

/// شاشة تفاصيل فئة أذكار معينة
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
  late final AnimationController _animationController;
  late final AnimationController _progressAnimationController;
  
  AthkarCategory? _category;
  AthkarProgress? _progress;
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;
  
  // للتحكم في الأصوات والاهتزاز
  bool _soundEnabled = false;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _athkarService = getService<AthkarService>();
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // تحميل الفئة والتقدم
      final category = await _athkarService.getCategoryById(widget.categoryId);
      final progress = await _athkarService.getCategoryProgress(widget.categoryId);

      if (mounted && category != null) {
        setState(() {
          _category = category;
          _progress = progress;
          _isLoading = false;
        });
        _animationController.forward();
        _progressAnimationController.forward();
      } else if (mounted) {
        setState(() {
          _error = 'الفئة غير موجودة';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateCount(int itemId, int newCount) async {
    try {
      await _athkarService.updateItemProgress(
        categoryId: widget.categoryId,
        itemId: itemId,
        count: newCount,
      );

      // تحديث التقدم محلياً
      if (_progress != null) {
        setState(() {
          _progress!.itemProgress[itemId] = newCount;
          _progress!.lastUpdated = DateTime.now();
        });
      }

      // إضافة ردود فعل حسية
      if (_vibrationEnabled) {
        HapticFeedback.lightImpact();
      }

      // إشعار بإكمال الذكر
      final item = _category!.athkar.firstWhere((a) => a.id == itemId);
      if (newCount >= item.count) {
        _showCompletionFeedback(item);
      }
    } catch (e) {
      context.showErrorSnackBar('خطأ في حفظ التقدم');
    }
  }

  void _showCompletionFeedback(AthkarItem item) {
    HapticFeedback.mediumImpact();
    context.showSuccessSnackBar('تم إكمال الذكر بنجاح ✨');
  }

  Future<void> _toggleFavorite(AthkarItem item) async {
    try {
      final isFav = _athkarService.isFavorite(widget.categoryId, item.id);
      
      if (isFav) {
        await _athkarService.removeFromFavorites(
          categoryId: widget.categoryId,
          itemId: item.id,
        );
        context.showInfoSnackBar('تم إزالة من المفضلة');
      } else {
        await _athkarService.addToFavorites(
          categoryId: widget.categoryId,
          itemId: item.id,
        );
        context.showSuccessSnackBar('تم إضافة للمفضلة ❤️');
      }
      
      setState(() {}); // لتحديث أيقونة المفضلة
    } catch (e) {
      context.showErrorSnackBar('خطأ في تحديث المفضلة');
    }
  }

  void _shareAthkar(AthkarItem item) {
    // يمكن إضافة مشاركة لاحقاً
    context.showInfoSnackBar('ميزة المشاركة قيد التطوير');
  }

  void _copyToClipboard(AthkarItem item) {
    Clipboard.setData(ClipboardData(text: item.text));
    HapticFeedback.selectionClick();
    context.showSuccessSnackBar('تم نسخ الذكر');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: _category != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: AppLoading.page(
          message: 'جاري تحميل الأذكار...',
        ),
      );
    }

    if (_error != null || _category == null) {
      return Scaffold(
        appBar: CustomAppBar.simple(title: 'خطأ'),
        body: AppEmptyState.error(
          message: _error ?? 'حدث خطأ غير متوقع',
          onRetry: _loadData,
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildSliverContent(),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: _category!.color,
      leading: AppBackButton(
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        AppBarAction(
          icon: Icons.refresh,
          onPressed: () async {
            await _athkarService.resetCategoryProgress(widget.categoryId);
            await _loadData();
            context.showSuccessSnackBar('تم إعادة تعيين التقدم');
          },
          tooltip: 'إعادة تعيين',
          color: Colors.white,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _category!.title,
          style: AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _category!.color,
                _category!.color.darken(0.2),
              ],
            ),
          ),
          child: _buildHeaderOverlay(),
        ),
      ),
    );
  }

  Widget _buildHeaderOverlay() {
    final completedCount = _getCompletedItemsCount();
    final totalCount = _category!.athkar.length;
    final percentage = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: kToolbarHeight + 20),
          
          // أيقونة الفئة
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 3,
              ),
            ),
            child: Icon(
              _category!.icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // التقدم الإجمالي
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space2,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Text(
              '$completedCount من $totalCount مكتمل ($percentage%)',
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverContent() {
    return SliverPadding(
      padding: context.appResponsivePadding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = _category!.athkar[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: ThemeConstants.durationNormal,
              child: SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(
                  child: _buildAthkarCard(item, index),
                ),
              ),
            );
          },
          childCount: _category!.athkar.length,
        ),
      ),
    );
  }

  Widget _buildAthkarCard(AthkarItem item, int index) {
    final currentCount = _progress?.itemProgress[item.id] ?? 0;
    final isCompleted = currentCount >= item.count;
    final isFavorite = _athkarService.isFavorite(widget.categoryId, item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
      child: AppCard.athkar(
        content: item.text,
        source: item.source,
        fadl: item.fadl,
        currentCount: currentCount,
        totalCount: item.count,
        isFavorite: isFavorite,
        primaryColor: _category!.color,
        onTap: isCompleted ? null : () => _incrementCount(item),
        onFavoriteToggle: () => _toggleFavorite(item),
        actions: [
          CardAction(
            icon: Icons.copy,
            label: 'نسخ',
            onPressed: () => _copyToClipboard(item),
          ),
          CardAction(
            icon: Icons.share,
            label: 'مشاركة',
            onPressed: () => _shareAthkar(item),
          ),
          if (currentCount > 0)
            CardAction(
              icon: Icons.refresh,
              label: 'إعادة تعيين',
              onPressed: () => _updateCount(item.id, 0),
            ),
        ],
      ),
    ).animatedPress(
      onTap: isCompleted ? null : () => _incrementCount(item),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: ThemeConstants.space4,
        right: ThemeConstants.space4,
        top: ThemeConstants.space3,
        bottom: ThemeConstants.space3 + context.safeBottom,
      ),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: AppShadowSystem.strong,
      ),
      child: Row(
        children: [
          // التقدم الإجمالي
          Expanded(
            child: _buildProgressInfo(),
          ),
          
          const SizedBox(width: ThemeConstants.space4),
          
          // أزرار الإجراءات
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressInfo() {
    final completedCount = _getCompletedItemsCount();
    final totalCount = _category!.athkar.length;
    final percentage = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقدم: $completedCount من $totalCount',
          style: AppTextStyles.label1.copyWith(
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
        const SizedBox(height: ThemeConstants.space1),
        ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: context.dividerColor,
            valueColor: AlwaysStoppedAnimation<Color>(_category!.color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // زر التنقل السابق
        IconButton(
          onPressed: _currentIndex > 0 ? _goToPrevious : null,
          icon: const Icon(Icons.keyboard_arrow_up),
          tooltip: 'السابق',
        ),
        
        // زر التنقل التالي
        IconButton(
          onPressed: _currentIndex < _category!.athkar.length - 1 ? _goToNext : null,
          icon: const Icon(Icons.keyboard_arrow_down),
          tooltip: 'التالي',
        ),
      ],
    );
  }

  // دوال مساعدة
  void _incrementCount(AthkarItem item) {
    final currentCount = _progress?.itemProgress[item.id] ?? 0;
    if (currentCount < item.count) {
      _updateCount(item.id, currentCount + 1);
    }
  }

  int _getCompletedItemsCount() {
    if (_progress == null || _category == null) return 0;
    
    int completed = 0;
    for (final item in _category!.athkar) {
      final currentCount = _progress!.itemProgress[item.id] ?? 0;
      if (currentCount >= item.count) {
        completed++;
      }
    }
    return completed;
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      // يمكن إضافة تمرير تلقائي للبطاقة
    }
  }

  void _goToNext() {
    if (_currentIndex < _category!.athkar.length - 1) {
      setState(() {
        _currentIndex++;
      });
      // يمكن إضافة تمرير تلقائي للبطاقة
    }
  }
}