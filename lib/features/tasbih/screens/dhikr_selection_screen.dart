// lib/features/tasbih/screens/dhikr_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/themes/app_theme.dart';
import '../models/dhikr_model.dart';
import '../services/tasbih_service.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/add_custom_dhikr_dialog.dart';

class DhikrSelectionScreen extends StatefulWidget {
  final DhikrItem? currentDhikr;
  final Function(DhikrItem) onDhikrSelected;

  const DhikrSelectionScreen({
    super.key,
    this.currentDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<DhikrSelectionScreen> createState() => _DhikrSelectionScreenState();
}

class _DhikrSelectionScreenState extends State<DhikrSelectionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  List<DhikrItem> _allAdhkar = [];
  List<DhikrItem> _filteredAdhkar = [];
  List<DhikrItem> _customAdhkar = [];
  List<DhikrItem> _favoriteAdhkar = [];
  DhikrCategory _selectedCategory = DhikrCategory.tasbih;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAdhkar();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadAdhkar() {
    _allAdhkar = DefaultAdhkar.getAll();
    _filteredAdhkar = List.from(_allAdhkar);
    // تحميل الأذكار المخصصة والمفضلة من الخدمة
    _loadCustomAdhkar();
    _loadFavoriteAdhkar();
  }

  void _loadCustomAdhkar() {
    // تحميل الأذكار المخصصة من TasbihService إذا كان متوفراً
    try {
      final tasbihService = context.read<TasbihService>();
      _customAdhkar = tasbihService.customAdhkar;
      // إضافة الأذكار المخصصة للقائمة الرئيسية
      for (final customDhikr in _customAdhkar) {
        if (!_allAdhkar.any((dhikr) => dhikr.id == customDhikr.id)) {
          _allAdhkar.add(customDhikr);
        }
      }
    } catch (e) {
      // إذا لم تكن الخدمة متوفرة، نبدأ بقائمة فارغة
      _customAdhkar = [];
    }
  }

  void _loadFavoriteAdhkar() {
    // تحميل الأذكار المفضلة من التخزين
    // مؤقتاً بعض الأذكار الشائعة
    _favoriteAdhkar = DefaultAdhkar.getPopular();
  }

  void _onTabChanged() {
    setState(() {
      _filterAdhkar();
    });
  }

  void _filterAdhkar() {
    List<DhikrItem> sourceList;
    
    switch (_tabController.index) {
      case 0: // الكل
        sourceList = _allAdhkar;
        break;
      case 1: // المفضلة
        sourceList = _favoriteAdhkar;
        break;
      case 2: // حسب التصنيف
        sourceList = DefaultAdhkar.getByCategory(_selectedCategory);
        break;
      case 3: // المخصصة
        sourceList = _customAdhkar;
        break;
      default:
        sourceList = _allAdhkar;
    }

    if (_searchQuery.isEmpty) {
      _filteredAdhkar = List.from(sourceList);
    } else {
      _filteredAdhkar = sourceList
          .where((dhikr) =>
              dhikr.text.contains(_searchQuery) ||
              (dhikr.translation?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterAdhkar();
    });
  }

  void _onCategoryChanged(DhikrCategory category) {
    setState(() {
      _selectedCategory = category;
      _filterAdhkar();
    });
  }

  void _onDhikrTap(DhikrItem dhikr) {
    HapticFeedback.lightImpact();
    widget.onDhikrSelected(dhikr);
    Navigator.pop(context);
  }

  void _showAddCustomDhikr() {
    showDialog(
      context: context,
      builder: (context) => AddCustomDhikrDialog(
        onDhikrAdded: (dhikr) async {
          try {
            // إضافة الذكر للخدمة
            final tasbihService = context.read<TasbihService>();
            await tasbihService.addCustomDhikr(dhikr);
            
            // تحديث القوائم المحلية
            setState(() {
              _customAdhkar.add(dhikr);
              _allAdhkar.add(dhikr);
              _filterAdhkar();
            });
            
            context.showSuccessSnackBar('تم إضافة الذكر المخصص بنجاح');
          } catch (e) {
            context.showErrorSnackBar('حدث خطأ أثناء حفظ الذكر المخصص');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: context.backgroundColor,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeConstants.primary,
                      ThemeConstants.primaryLight,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // نمط زخرفي
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SelectionScreenPainter(),
                      ),
                    ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 20,
                        top: 100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختر الذكر',
                            style: context.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          ThemeConstants.space1.h,
                          Text(
                            'اختر الذكر الذي تريد تسبيحه',
                            style: context.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: widget.currentDhikr != null
                ? Text(
                    'الحالي: ${widget.currentDhikr!.text.length > 20 ? widget.currentDhikr!.text.substring(0, 20) + '...' : widget.currentDhikr!.text}',
                    style: context.titleMedium?.copyWith(color: Colors.white),
                  )
                : null,
            leading: AppBackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _showAddCustomDhikr,
                tooltip: 'إضافة ذكر مخصص',
              ),
            ],
          ),

          // شريط البحث
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'ابحث في الأذكار...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: context.cardColor,
                ),
              ),
            ),
          ),

          // التصنيفات التبويبية
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: ThemeConstants.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.white,
                unselectedLabelColor: context.textSecondaryColor,
                tabs: const [
                  Tab(text: 'الكل'),
                  Tab(text: 'المفضلة'),
                  Tab(text: 'التصنيف'),
                  Tab(text: 'المخصصة'),
                ],
              ),
            ),
          ),

          // محدد التصنيف (يظهر فقط في تبويب التصنيف)
          if (_tabController.index == 2)
            SliverToBoxAdapter(
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: DhikrCategory.values.length - 1, // استثناء المخصص
                  itemBuilder: (context, index) {
                    final category = DhikrCategory.values[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(category.title),
                        avatar: Icon(category.icon, size: 18),
                        onSelected: (_) => _onCategoryChanged(category),
                        selectedColor: ThemeConstants.primary.withValues(alpha: 0.2),
                        checkmarkColor: ThemeConstants.primary,
                      ),
                    );
                  },
                ),
              ),
            ),

          // قائمة الأذكار
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _filteredAdhkar.isEmpty
                ? SliverToBoxAdapter(
                    child: _buildEmptyState(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dhikr = _filteredAdhkar[index];
                        final isSelected = widget.currentDhikr?.id == dhikr.id;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DhikrCard(
                            dhikr: dhikr,
                            isSelected: isSelected,
                            onTap: () => _onDhikrTap(dhikr),
                            onFavoriteToggle: () => _toggleFavorite(dhikr),
                            onDelete: dhikr.isCustom ? () => _deleteCustomDhikr(dhikr) : null,
                          ),
                        );
                      },
                      childCount: _filteredAdhkar.length,
                    ),
                  ),
          ),

          // مساحة في الأسفل
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: context.textSecondaryColor.withValues(alpha: 0.5),
            ),
            ThemeConstants.space3.h,
            Text(
              'لا توجد أذكار',
              style: context.titleMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            ThemeConstants.space1.h,
            Text(
              _searchQuery.isNotEmpty
                  ? 'لم يتم العثور على أذكار تطابق البحث'
                  : 'لا توجد أذكار في هذا التصنيف',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (_tabController.index == 3) ...[
              ThemeConstants.space4.h,
              AppButton.outline(
                text: 'إضافة ذكر مخصص',
                icon: Icons.add,
                onPressed: _showAddCustomDhikr,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(DhikrItem dhikr) {
    setState(() {
      if (_favoriteAdhkar.any((d) => d.id == dhikr.id)) {
        _favoriteAdhkar.removeWhere((d) => d.id == dhikr.id);
      } else {
        _favoriteAdhkar.add(dhikr);
      }
      _filterAdhkar();
    });
    
    // هنا يجب حفظ المفضلة في التخزين
    HapticFeedback.lightImpact();
  }

  void _deleteCustomDhikr(DhikrItem dhikr) {
    AppInfoDialog.showConfirmation(
      context: context,
      title: 'حذف الذكر المخصص',
      content: 'هل أنت متأكد من أنك تريد حذف هذا الذكر المخصص؟\n\n"${dhikr.text}"',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      icon: Icons.delete_outline,
      destructive: true,
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          // حذف الذكر من الخدمة
          final tasbihService = context.read<TasbihService>();
          await tasbihService.removeCustomDhikr(dhikr.id);
          
          // تحديث القوائم المحلية
          setState(() {
            _customAdhkar.removeWhere((d) => d.id == dhikr.id);
            _allAdhkar.removeWhere((d) => d.id == dhikr.id);
            _filteredAdhkar.removeWhere((d) => d.id == dhikr.id);
            _favoriteAdhkar.removeWhere((d) => d.id == dhikr.id);
          });
          
          HapticFeedback.mediumImpact();
          context.showSuccessSnackBar('تم حذف الذكر المخصص');
        } catch (e) {
          context.showErrorSnackBar('حدث خطأ أثناء حذف الذكر');
        }
      }
    });
  }
}

/// رسام نمط الخلفية
class _SelectionScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // رسم دوائر متداخلة
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3),
        20.0 * i,
        paint,
      );
    }

    // رسم خطوط قطرية
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * (0.2 + i * 0.15)),
        Offset(size.width * 0.5, size.height * (0.4 + i * 0.15)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}