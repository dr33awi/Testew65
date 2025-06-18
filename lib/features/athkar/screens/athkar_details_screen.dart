// lib/features/athkar/screens/athkar_details_screen.dart
import 'package:athkar_app/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../widgets/athkar_item_card.dart';
import '../widgets/athkar_progress_bar.dart';
import '../widgets/athkar_completion_dialog.dart';
import '../utils/category_utils.dart';
import 'notification_settings_screen.dart';

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
    with SingleTickerProviderStateMixin {
  late final AthkarService _service;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  AthkarCategory? _category;
  final Map<int, int> _counts = {};
  final Set<int> _completedItems = {};
  List<AthkarItem> _visibleItems = [];
  int _totalProgress = 0;
  bool _loading = true;
  bool _allCompleted = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    _load();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cat = await _service.getCategoryById(widget.categoryId);
      if (!mounted) return;
      
      final savedProgress = _loadSavedProgress();
      
      setState(() {
        _category = cat;
        if (cat != null) {
          for (var i = 0; i < cat.athkar.length; i++) {
            final item = cat.athkar[i];
            _counts[item.id] = savedProgress[item.id] ?? 0;
            if (_counts[item.id]! >= item.count) {
              _completedItems.add(item.id);
            }
          }
          _updateVisibleItems();
          _calculateProgress();
        }
        _loading = false;
      });
      
      _animationController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      context.showErrorSnackBar('حدث خطأ في تحميل الأذكار');
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

  void _calculateProgress() {
    if (_category == null) return;
    
    int completed = 0;
    int total = 0;
    
    for (final item in _category!.athkar) {
      final count = _counts[item.id] ?? 0;
      completed += count.clamp(0, item.count);
      total += item.count;
    }
    
    setState(() {
      _totalProgress = total > 0 ? ((completed / total) * 100).round() : 0;
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
      _calculateProgress();
    });
    
    _saveProgress();
    
    if (_allCompleted && !_loading) {
      _showCompletionDialog();
    }
  }

  void _onItemLongPress(AthkarItem item) {
    HapticFeedback.mediumImpact();
    
    setState(() {
      _counts[item.id] = 0;
      _completedItems.remove(item.id);
      _updateVisibleItems();
      _calculateProgress();
    });
    
    _saveProgress();
    context.showInfoSnackBar('تم إعادة تعيين العداد');
  }

  Future<void> _showCompletionDialog() async {
    final result = await AthkarCompletionDialog.show(
      context: context,
      categoryName: _category!.title,
      onShare: _shareProgress,
      onReset: _resetAll,
    );
    
    if (result == true) {
      _resetAll();
    }
  }

  Future<void> _shareProgress() async {
    final text = '''
✨ أكملت ${_category!.title} ✨
${_category!.athkar.map((item) => '✓ ${item.text.truncate(50)}').join('\n')}

تطبيق الأذكار
    ''';
    
    await Share.share(text);
  }

  void _resetAll() {
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
      _totalProgress = 0;
      _updateVisibleItems();
    });
    _saveProgress();
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
          child: AppLoading.page(
            message: 'جاري تحميل الأذكار...',
          ),
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.simple(title: 'الأذكار'),
        body: AppEmptyState.error(
          message: 'تعذر تحميل الأذكار المطلوبة',
          onRetry: _load,
        ),
      );
    }

    final category = _category!;
    
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // شريط التنقل العلوي
            _buildAppBar(context, category),
            
            // شريط التقدم
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: ThemeConstants.curveDefault,
                    )),
                    child: AthkarProgressBar(
                      progress: _totalProgress,
                      color: CategoryUtils.getCategoryThemeColor(category.id),
                      completedCount: _completedItems.length,
                      totalCount: category.athkar.length,
                    ),
                  ),
                );
              },
            ),
            
            // المحتوى
            Expanded(
              child: _buildContent(category),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AthkarCategory category) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
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
              onPressed: () => Navigator.of(context).pop(),
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
                  ),
                ),
                Text(
                  '${category.athkar.length} ذكر',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // الإجراءات
          Row(
            children: [
              // زر المفضلة
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
              
              // زر المشاركة
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
    );
  }

  Widget _buildContent(AthkarCategory category) {
    if (_visibleItems.isEmpty && _completedItems.isNotEmpty) {
      return _buildCompletionState();
    }
    
    return RefreshIndicator(
      onRefresh: _load,
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
                        ? ThemeConstants.space3
                        : 0,
                  ),
                  child: AthkarItemCard(
                    item: item,
                    currentCount: currentCount,
                    isCompleted: isCompleted,
                    number: number,
                    color: CategoryUtils.getCategoryThemeColor(category.id),
                    onTap: () => _onItemTap(item),
                    onLongPress: () => _onItemLongPress(item),
                    onFavoriteToggle: () => _toggleFavorite(item),
                    onShare: () => _shareItem(item),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletionState() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // بطاقة الإكمال
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.success.withValues(alpha: 0.9),
                  ThemeConstants.success.darken(0.1).withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      ThemeConstants.space4.h,
                      
                      Text(
                        'أحسنت! أكملت جميع الأذكار',
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      ThemeConstants.space2.h,
                      
                      Text(
                        'جعله الله في ميزان حسناتك',
                        style: context.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      ThemeConstants.space6.h,
                      
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.outline(
                              text: 'مشاركة الإنجاز',
                              icon: Icons.share_rounded,
                              onPressed: _shareProgress,
                              color: Colors.white,
                            ),
                          ),
                          
                          ThemeConstants.space3.w,
                          
                          Expanded(
                            child: AppButton.primary(
                              text: 'البدء من جديد',
                              icon: Icons.refresh_rounded,
                              onPressed: _resetAll,
                              backgroundColor: Colors.white,
                              textColor: ThemeConstants.success,
                            ),
                          ),
                        ],
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
    context.showInfoSnackBar('سيتم إضافة ميزة المفضلة قريباً');
  }
}