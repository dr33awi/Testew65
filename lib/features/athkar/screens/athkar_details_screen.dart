import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';

class AthkarDetailsScreen extends StatefulWidget {
  final String categoryId;
  const AthkarDetailsScreen({super.key, required this.categoryId});

  @override
  State<AthkarDetailsScreen> createState() => _AthkarDetailsScreenState();
}

class _AthkarDetailsScreenState extends State<AthkarDetailsScreen> {
  late final AthkarService _service;
  AthkarCategory? _category;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _load();
  }

  Future<void> _load() async {
    try {
      final cat = await _service.getCategoryById(widget.categoryId);
      if (!mounted) return;
      setState(() {
        _category = cat;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      context.showErrorSnackBar('تعذر تحميل بيانات الأذكار');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: AppLoading.circular()),
      );
    }
    if (_category == null) {
      return Scaffold(
        appBar: CustomAppBar.simple(title: 'الأذكار'),
        body: const Center(child: Text('تعذر تحميل الأذكار')),
      );
    }
    final cat = _category!;
    return Scaffold(
      appBar: CustomAppBar.simple(title: cat.title),
      body: ListView.separated(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        itemCount: cat.athkar.length,
        separatorBuilder: (_, __) => const SizedBox(height: ThemeConstants.space3),
        itemBuilder: (context, index) {
          final item = cat.athkar[index];
          return _buildItem(context, item, index + 1);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, AthkarItem item, int number) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowForElevation(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: context.primaryColor.withOpacity(0.2),
                foregroundColor: context.primaryColor,
                child: Text('$number'),
              ),
              ThemeConstants.space3.w,
              Expanded(
                child: Text(
                  item.text,
                  style: context.bodyLarge,
                ),
              ),
            ],
          ),
          if (item.fadl != null) ...[
            ThemeConstants.space2.h,
            Text(
              item.fadl!,
              style: context.bodySmall?.copyWith(color: context.textSecondaryColor),
            ),
          ],
          if (item.source != null) ...[
            ThemeConstants.space2.h,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                item.source!,
                style: context.labelSmall?.copyWith(color: context.textSecondaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
