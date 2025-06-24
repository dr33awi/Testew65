// lib/features/athkar/screens/athkar_details_screen.dart (مُصحح)
import 'package:athkar_app/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/themes/app_theme.dart'; // ✅ يحتوي على جميع widgets المطلوبة
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../utils/category_utils.dart';

class AthkarDetailsScreen extends StatefulWidget {
  String categoryId;
  
  AthkarDetailsScreen({
    super.key,
    String? categoryId,
  }) : categoryId = categoryId ?? '';

  @override
  State<AthkarDetailsScreen> createState() => _AthkarDetailsScreenState();
}

class _AthkarDetailsScreenState extends State<AthkarDetailsScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AthkarService _service;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  AthkarCategory? _category;
  final Map<int, int> _counts = {};
  final Set<int> _completedItems = {};
  List<AthkarItem> _visibleItems = [];
  bool _loading = true;
  bool _allCompleted = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_isFirstLoad) {
      _resetAndReload();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cat = await _service.getCategoryById(widget.categoryId);
      if (!mounted) return;
      
      final savedProgress = _isFirstLoad ? _loadSavedProgress() : <int, int>{};
      
      setState(() {
        _category = cat;
        if (cat != null) {
          _counts.clear();
          _completedItems.clear();
          
          for (var i = 0; i < cat.athkar.length; i++) {
            final item = cat.athkar[i];
            _counts[item.id] = savedProgress[item.id] ?? 0;
            if (_counts[item.id]! >= item.count) {
              _completedItems.add(item.id);
            }
          }
          _updateVisibleItems();
          _calculateCompletion();
        }
        _loading = false;
      });
      
      _animationController.forward();
      _isFirstLoad = false;
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _resetAndReload() async {
    if (!mounted || _loading) return;
    
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
    });
    
    await _saveProgress();
    
    if (_category != null) {
      setState(() {
        _updateVisibleItems();
        _calculateCompletion();
      });
    }
  }

  void _updateVisibleItems() {
    if (_category == null) return;
    
    _visibleItems = _category!.athkar
        .where((item) => !_completedItems.contains(item.id))
        .toList();
  }

  Map<int, int> _loadSavedProgress() {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _storage.getMap(key);
    if (data == null) return {};
    
    return data.map((k, v) => MapEntry(int.parse(k), v as int));
  }

  Future<void> _saveProgress() async {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _counts.map((k, v) => MapEntry(k.toString(), v));
    await _storage.setMap(key, data);
  }

  void _calculateCompletion() {
    if (_category == null) return;
    
    int completed = 0;
    int total = 0;
    
    for (final item in _category!.athkar) {
      final count = _counts[item.id] ?? 0;
      completed += count.clamp(0, item.count);
      total += item.count;
    }
    
    setState(() {
      _allCompleted = completed >= total && total > 0;
    });
  }

  void _onItemTap(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    setState(() {
      final currentCount = _counts[item.id] ?? 0;
      if (currentCount < item.count) {
        _counts[item.id] = currentCount + 1;
        
        if (_counts[item.id]! >= item.count) {
          _completedItems.add(item.id);
          HapticFeedback.mediumImpact();
          _updateVisibleItems();
        }
      }
      _calculateCompletion();
    });
    
    _saveProgress();
  }

  void _onItemLongPress(AthkarItem item) {
    HapticFeedback.mediumImpact();
    
    setState(() {
      final wasCompleted = _completedItems.contains(item.id);
      
      _counts[item.id] = 0;
      _completedItems.remove(item.id);
      
      if (wasCompleted) {
        _updateVisibleItems();
      }
      
      _calculateCompletion();
    });
    
    _saveProgress();
  }

  void _rereadAthkar() {
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
      _updateVisibleItems();
    });
    _saveProgress();
  }

  Future<void> _shareProgress() async {
    final text = '''
✨ أكملت ${_category!.title} ✨
${_category!.athkar.map((item) => '✓ ${item.text.truncate(50)}').join('\n')}

تطبيق الأذكار
    ''';
    
    await Share.share(text);
  }

  Future<void> _shareItem(AthkarItem item) async {
    final text = '''
${item.text}

${item.fadl != null ? 'الفضل: ${item.fadl}\n' : ''}
${item.source != null ? 'المصدر: ${item.source}' : ''}

تطبيق الأذكار
''';
    
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: Center(
          // ✅ استخدام AppLoading من app_theme.dart
          child: AppLoading.page(
            message: 'جاري تحميل الأذكار...',
          ),
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        // ✅ استخدام CustomAppBar من app_theme.dart
        appBar: CustomAppBar.simple(title: 'الأذكار'),
        body: AppEmptyState.error(
          message: 'تعذر تحميل الأذكار المطلوبة',
          onRetry: _load,
        ),
      );
    }

    final category = _category!;
    
    return WillPopScope(
      onWillPop: () async {
        await _resetAndReload();
        return true;
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, category),
              Expanded(
                child: _buildContent(category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AthkarCategory category) {
    final totalAthkar = category.athkar.length;
    final completedAthkar = _completedItems.length;
    final remainingAthkar = totalAthkar - completedAthkar;
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          Row(
            children: [
              // زر العودة
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: () async {
                    await _resetAndReload();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
              
              ThemeConstants.space3.w,
              
              // العنوان
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: context.titleLarge?.copyWith(
                        fontWeight: ThemeConstants.bold,
                        fontSize: 22,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$remainingAthkar متبقي',
                          style: context.bodyMedium?.copyWith(
                            color: remainingAthkar > 0 
                                ? context.textSecondaryColor 
                                : ThemeConstants.success,
                            fontWeight: remainingAthkar == 0 
                                ? ThemeConstants.bold 
                                : ThemeConstants.regular,
                          ),
                        ),
                        if (completedAthkar > 0) ...[
                          Text(
                            ' • ',
                            style: context.bodySmall?.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: ThemeConstants.success,
                          ),
                          ThemeConstants.space1.w,
                          Text(
                            '$completedAthkar مكتمل',
                            style: context.bodyMedium?.copyWith(
                              color: ThemeConstants.success,
                              fontWeight: ThemeConstants.medium,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // الإجراءات
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      border: Border.all(
                        color: context.dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.favorites);
                      },
                      icon: Icon(
                        Icons.favorite_outline,
                        color: context.textSecondaryColor,
                      ),
                      tooltip: 'المفضلة',
                    ),
                  ),
                  
                  ThemeConstants.space2.w,
                  
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      border: Border.all(
                        color: context.dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _shareProgress,
                      icon: Icon(
                        Icons.share_outlined,
                        color: context.textSecondaryColor,
                      ),
                      tooltip: 'مشاركة',
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // شريط التقدم
          if (totalAthkar > 0) ...[
            ThemeConstants.space3.h,
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: context.dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completedAthkar / totalAthkar,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completedAthkar == totalAthkar 
                        ? ThemeConstants.success 
                        : CategoryUtils.getCategoryThemeColor(category.id),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(AthkarCategory category) {
    return RefreshIndicator(
      onRefresh: () async {
        await _resetAndReload();
      },
      child: _visibleItems.isEmpty 
          ? _buildEmptyState()
          : AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                itemCount: _visibleItems.length,
                itemBuilder: (context, index) {
                  final item = _visibleItems[index];
                  final currentCount = _counts[item.id] ?? 0;
                  final isCompleted = _completedItems.contains(item.id);
                  
                  final originalIndex = category.athkar.indexOf(item);
                  final number = originalIndex + 1;
                  
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: ThemeConstants.durationNormal,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _visibleItems.length - 1
                                ? ThemeConstants.space4
                                : 0,
                          ),
                          child: _buildEnhancedAthkarCard(
                            item: item,
                            currentCount: currentCount,
                            isCompleted: isCompleted,
                            number: number,
                            category: category,
                            onTap: () => _onItemTap(item),
                            onLongPress: () => _onItemLongPress(item),
                            onShare: () => _shareItem(item),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEnhancedAthkarCard({
    required AthkarItem item,
    required int currentCount,
    required bool isCompleted,
    required int number,
    required AthkarCategory category,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
    required VoidCallback onShare,
  }) {
    final effectiveColor = CategoryUtils.getCategoryThemeColor(category.id);
    final progress = currentCount / item.count;
    
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الرأس - رقم الذكر والحالة
                Row(
                  children: [
                    // رقم الذكر
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: effectiveColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: effectiveColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: context.titleLarge?.copyWith(
                            color: effectiveColor,
                            fontWeight: ThemeConstants.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // العداد والتقدم
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$currentCount / ${item.count}',
                          style: context.titleMedium?.copyWith(
                            color: context.textPrimaryColor,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        ThemeConstants.space1.h,
                        Container(
                          width: 80,
                          height: 6,
                          decoration: BoxDecoration(
                            color: context.dividerColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: effectiveColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                ThemeConstants.space5.h,
                
                // النص الرئيسي بتحسينات للقراءة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(ThemeConstants.space5),
                  decoration: BoxDecoration(
                    color: context.isDarkMode 
                        ? effectiveColor.withValues(alpha: 0.05)
                        : effectiveColor.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                    border: Border.all(
                      color: effectiveColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 20, // خط أكبر للوضوح
                      height: 2.2, // مسافة أكبر بين السطور
                      fontFamily: 'Amiri', // خط عربي واضح
                      color: context.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5, // مسافة بين الحروف
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // الفضل إذا وُجد
                if (item.fadl != null) ...[
                  ThemeConstants.space4.h,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ThemeConstants.space4),
                    decoration: BoxDecoration(
                      color: ThemeConstants.accent.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      border: Border.all(
                        color: ThemeConstants.accent.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: ThemeConstants.iconSm,
                              color: ThemeConstants.accent,
                            ),
                            ThemeConstants.space2.w,
                            Text(
                              'الفضل',
                              style: context.titleSmall?.copyWith(
                                color: ThemeConstants.accent,
                                fontWeight: ThemeConstants.bold,
                              ),
                            ),
                          ],
                        ),
                        ThemeConstants.space2.h,
                        Text(
                          item.fadl!,
                          style: context.bodyMedium?.copyWith(
                            color: context.textSecondaryColor,
                            height: 1.6,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                ThemeConstants.space4.h,
                
                // الفوتر
                Row(
                  children: [
                    // المصدر
                    if (item.source != null) ...[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space3,
                            vertical: ThemeConstants.space2,
                          ),
                          decoration: BoxDecoration(
                            color: context.textSecondaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: ThemeConstants.iconXs,
                                color: context.textSecondaryColor,
                              ),
                              ThemeConstants.space1.w,
                              Flexible(
                                child: Text(
                                  item.source!,
                                  style: context.labelMedium?.copyWith(
                                    color: context.textSecondaryColor,
                                    fontWeight: ThemeConstants.medium,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ThemeConstants.space3.w,
                    ] else
                      const Spacer(),
                    
                    // زر المشاركة
                    Container(
                      decoration: BoxDecoration(
                        color: context.textSecondaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onShare();
                        },
                        icon: Icon(
                          Icons.share_rounded,
                          size: ThemeConstants.iconSm,
                          color: context.textSecondaryColor,
                        ),
                        tooltip: 'مشاركة',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.success.withValues(alpha: 0.8),
                  ThemeConstants.success.darken(0.1).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.success.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
          
          ThemeConstants.space4.h,
          
          Text(
            'أكملت جميع الأذكار! 🎉',
            style: context.headlineSmall?.copyWith(
              color: ThemeConstants.success,
              fontWeight: ThemeConstants.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          ThemeConstants.space2.h,
          
          Text(
            'بارك الله فيك\nجعلها الله في ميزان حسناتك',
            style: context.bodyLarge?.copyWith(
              color: context.textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          ThemeConstants.space4.h,
          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.success.withValues(alpha: 0.9),
                  ThemeConstants.success.darken(0.1).withValues(alpha: 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.success.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _rereadAthkar,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: ThemeConstants.space4,
                    horizontal: ThemeConstants.space6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      ThemeConstants.space3.w,
                      Text(
                        'إعادة القراءة',
                        style: context.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(AthkarItem item) {
    // إدارة المفضلة
  }
}