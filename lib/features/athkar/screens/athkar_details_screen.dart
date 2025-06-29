// lib/features/athkar/screens/athkar_details_screen.dart - محدث بالثيم الإسلامي الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AthkarService _service;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  AthkarCategory? _category;
  final Map<int, int> _counts = {};
  final Set<int> _completedItems = {};
  final Set<int> _favoriteItems = {};
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
      duration: AppTheme.durationNormal,
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
      final savedFavorites = _loadSavedFavorites();
      
      setState(() {
        _category = cat;
        if (cat != null) {
          _counts.clear();
          _completedItems.clear();
          _favoriteItems.clear();
          
          for (var i = 0; i < cat.athkar.length; i++) {
            final item = cat.athkar[i];
            _counts[item.id] = savedProgress[item.id] ?? 0;
            if (_counts[item.id]! >= item.count) {
              _completedItems.add(item.id);
            }
            if (savedFavorites.contains(item.id)) {
              _favoriteItems.add(item.id);
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

  Set<int> _loadSavedFavorites() {
    final key = 'athkar_favorites_${widget.categoryId}';
    final data = _storage.getStringList(key) ?? [];
    return data.map((id) => int.parse(id)).toSet();
  }

  Future<void> _saveProgress() async {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _counts.map((k, v) => MapEntry(k.toString(), v));
    await _storage.setMap(key, data);
  }

  Future<void> _saveFavorites() async {
    final key = 'athkar_favorites_${widget.categoryId}';
    final data = _favoriteItems.map((id) => id.toString()).toList();
    await _storage.setStringList(key, data);
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

  void _toggleFavorite(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    setState(() {
      if (_favoriteItems.contains(item.id)) {
        _favoriteItems.remove(item.id);
      } else {
        _favoriteItems.add(item.id);
      }
    });
    
    _saveFavorites();
    
    // إظهار رسالة للمستخدم
    final message = _favoriteItems.contains(item.id) 
        ? 'تمت إضافة الذكر للمفضلة'
        : 'تمت إزالة الذكر من المفضلة';
        
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }

  void _copyToClipboard(AthkarItem item) {
    final text = '''${item.text}

${item.source != null ? 'المصدر: ${item.source}' : ''}''';
    
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ النص بنجاح'),
        backgroundColor: AppTheme.success,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: AppLoading.page(
          message: 'جاري تحميل الأذكار...',
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        // ✅ استخدام AppAppBar الموحد
        appBar: AppAppBar.basic(title: 'الأذكار'),
        body: AppEmptyState.noData(
          message: 'تعذر تحميل الأذكار المطلوبة',
          onRetry: _load,
        ),
      );
    }

    final category = _category!;
    final totalAthkar = category.athkar.length;
    final completedAthkar = _completedItems.length;
    final remainingAthkar = totalAthkar - completedAthkar;
    
    return WillPopScope(
      onWillPop: () async {
        await _resetAndReload();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        // ✅ استخدام AppAppBar الموحد
        appBar: AppAppBar.basic(
          title: category.title,
          onBackPressed: () async {
            await _resetAndReload();
            Navigator.of(context).pop();
          },
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppTheme.textSecondary,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AthkarNotificationSettingsScreen(),
                ),
              ),
              tooltip: 'إعدادات الإشعارات',
            ),
          ],
        ),
        body: Column(
          children: [
            // شريط التقدم العلوي
            _buildProgressSection(totalAthkar, completedAthkar, remainingAthkar),
            
            // المحتوى الرئيسي
            Expanded(
              child: _buildContent(category),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(int totalAthkar, int completedAthkar, int remainingAthkar) {
    return Container(
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.divider.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$remainingAthkar متبقي',
                style: AppTheme.bodyMedium.copyWith(
                  color: remainingAthkar > 0 
                      ? AppTheme.textSecondary 
                      : AppTheme.success,
                  fontWeight: remainingAthkar == 0 
                      ? AppTheme.bold 
                      : AppTheme.regular,
                ),
              ),
              if (completedAthkar > 0) ...[
                Text(
                  ' • ',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  size: AppTheme.iconSm,
                  color: AppTheme.success,
                ),
                AppTheme.space1.w,
                Text(
                  '$completedAthkar مكتمل',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.success,
                    fontWeight: AppTheme.medium,
                  ),
                ),
              ],
            ],
          ),
          
          AppTheme.space3.h,
          
          // شريط التقدم
          if (totalAthkar > 0)
            Container(
              height: AppTheme.space2,
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                border: Border.all(
                  color: AppTheme.divider.withValues(alpha: 0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                child: LinearProgressIndicator(
                  value: completedAthkar / totalAthkar,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.success,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(AthkarCategory category) {
    return RefreshIndicator(
      onRefresh: () async {
        await _resetAndReload();
      },
      color: AppTheme.primary,
      child: _visibleItems.isEmpty 
          ? _buildEmptyState()
          : ListView.builder(
              padding: AppTheme.space4.padding,
              itemCount: _visibleItems.length,
              itemBuilder: (context, index) {
                final item = _visibleItems[index];
                final currentCount = _counts[item.id] ?? 0;
                final isFavorite = _favoriteItems.contains(item.id);
                
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _visibleItems.length - 1
                        ? AppTheme.space4
                        : 0,
                  ),
                  // ✅ استخدام AppCard.athkar الموحد
                  child: AppCard.athkar(
                    content: item.text,
                    source: item.source,
                    fadl: item.fadl,
                    currentCount: currentCount,
                    totalCount: item.count,
                    primaryColor: AppTheme.getCategoryColor(widget.categoryId),
                    isCompleted: _completedItems.contains(item.id),
                    onTap: () => _onItemTap(item),
                    actions: [
                      CardAction(
                        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: '',
                        onPressed: () => _toggleFavorite(item),
                        color: isFavorite ? AppTheme.error : AppTheme.textSecondary,
                      ),
                      CardAction(
                        icon: Icons.share,
                        label: '',
                        onPressed: () => _shareItem(item),
                        color: AppTheme.info,
                      ),
                      CardAction(
                        icon: Icons.copy,
                        label: '',
                        onPressed: () => _copyToClipboard(item),
                        color: AppTheme.warning,
                      ),
                      if (currentCount > 0)
                        CardAction(
                          icon: Icons.refresh,
                          label: '',
                          onPressed: () => _onItemLongPress(item),
                          color: AppTheme.textTertiary,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    // ✅ استخدام AppCard للحالة المكتملة
    return Center(
      child: Padding(
        padding: AppTheme.space6.padding,
        child: AppCard(
          useGradient: true,
          color: AppTheme.success,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppTheme.iconXl * 2,
                height: AppTheme.iconXl * 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: AppTheme.iconXl + AppTheme.space3,
                  color: Colors.white,
                ),
              ),
              
              AppTheme.space4.h,
              
              Text(
                'أكملت جميع الأذكار! 🎉',
                style: AppTheme.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              AppTheme.space2.h,
              
              Text(
                'بارك الله فيك',
                style: AppTheme.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              
              AppTheme.space1.h,
              
              Text(
                'جعلها الله في ميزان حسناتك',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              
              AppTheme.space6.h,
              
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'إعادة القراءة',
                      onPressed: _rereadAthkar,
                      borderColor: Colors.white,
                    ),
                  ),
                  
                  AppTheme.space3.w,
                  
                  Expanded(
                    child: AppButton.primary(
                      text: 'مشاركة',
                      onPressed: _shareProgress,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}