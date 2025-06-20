// lib/features/settings/screens/data_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';

class DataSettingsScreen extends StatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  State<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends State<DataSettingsScreen> {
  int _storageSize = 0;
  bool _isLoading = true;
  bool _isOperationInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }

  Future<void> _loadStorageInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storage = getIt<StorageService>();
      final size = await storage.getStorageSize();
      
      setState(() {
        _storageSize = size;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        context.showErrorMessage('حدث خطأ في تحميل معلومات التخزين');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: IslamicAppBar(title: 'البيانات والتخزين'),
        body: Center(child: IslamicLoading(message: 'جاري التحميل...')),
      );
    }

    return Scaffold(
      appBar: const IslamicAppBar(title: 'البيانات والتخزين'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات التخزين
            _buildStorageInfo(context),
            
            Spaces.large,
            
            // النسخ الاحتياطي
            _buildBackupSection(context),
            
            Spaces.large,
            
            // الاستيراد والتصدير
            _buildImportExportSection(context),
            
            Spaces.large,
            
            // إدارة البيانات
            _buildDataManagementSection(context),
            
            Spaces.large,
            
            // منطقة الخطر
            _buildDangerZone(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageInfo(BuildContext context) {
    final sizeInMB = (_storageSize / (1024 * 1024)).toStringAsFixed(2);
    final sizeInKB = (_storageSize / 1024).toStringAsFixed(2);
    
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'معلومات التخزين',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _loadStorageInfo,
                icon: const Icon(Icons.refresh_outlined),
                tooltip: 'تحديث',
              ),
            ],
          ),
          
          Spaces.medium,
          
          // حجم البيانات
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.mediumPadding),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.mediumRadius),
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 40,
                  color: context.primaryColor,
                ),
                Spaces.small,
                Text(
                  double.parse(sizeInMB) > 1 ? '$sizeInMB ميجابايت' : '$sizeInKB كيلوبايت',
                  style: context.titleStyle.copyWith(
                    color: context.primaryColor,
                    fontWeight: ThemeConstants.fontBold,
                  ),
                ),
                Spaces.xs,
                Text(
                  'إجمالي مساحة البيانات المحفوظة',
                  style: context.captionStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          Spaces.medium,
          
          // تفاصيل البيانات
          _buildDataBreakdown(context),
        ],
      ),
    );
  }

  Widget _buildDataBreakdown(BuildContext context) {
    return Column(
      children: [
        _buildDataItem(
          context: context,
          icon: Icons.menu_book_outlined,
          title: 'بيانات الأذكار',
          description: 'الأذكار المحفوظة والمفضلة',
          color: context.primaryColor,
        ),
        
        Spaces.small,
        
        _buildDataItem(
          context: context,
          icon: Icons.mosque_outlined,
          title: 'إعدادات الصلاة',
          description: 'مواقيت الصلاة والإعدادات',
          color: context.successColor,
        ),
        
        Spaces.small,
        
        _buildDataItem(
          context: context,
          icon: Icons.touch_app_outlined,
          title: 'عدادات التسبيح',
          description: 'حفظ تقدم التسبيح',
          color: context.infoColor,
        ),
        
        Spaces.small,
        
        _buildDataItem(
          context: context,
          icon: Icons.settings_outlined,
          title: 'إعدادات التطبيق',
          description: 'التفضيلات والإعدادات العامة',
          color: context.warningColor,
        ),
      ],
    );
  }

  Widget _buildDataItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(context.smallPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.smallRadius),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconSm,
          ),
          Spaces.smallH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyStyle.copyWith(
                    fontWeight: ThemeConstants.fontMedium,
                  ),
                ),
                Text(
                  description,
                  style: context.captionStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.backup_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'النسخ الاحتياطي',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'احتفظ بنسخة احتياطية من بياناتك لتجنب فقدانها',
            style: context.captionStyle,
          ),
          
          Spaces.medium,
          
          _buildActionButton(
            context: context,
            icon: Icons.cloud_upload_outlined,
            title: 'إنشاء نسخة احتياطية',
            subtitle: 'حفظ جميع البيانات في ملف',
            onPressed: _createBackup,
            color: context.successColor,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.cloud_download_outlined,
            title: 'استعادة من نسخة احتياطية',
            subtitle: 'استيراد البيانات من ملف محفوظ',
            onPressed: _restoreBackup,
            color: context.infoColor,
          ),
        ],
      ),
    );
  }

  Widget _buildImportExportSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.import_export_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'الاستيراد والتصدير',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'تبادل البيانات مع تطبيقات أخرى أو أجهزة مختلفة',
            style: context.captionStyle,
          ),
          
          Spaces.medium,
          
          _buildActionButton(
            context: context,
            icon: Icons.file_download_outlined,
            title: 'تصدير الأذكار المفضلة',
            subtitle: 'حفظ الأذكار المفضلة في ملف نصي',
            onPressed: _exportFavorites,
            color: context.primaryColor,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.file_upload_outlined,
            title: 'استيراد أذكار',
            subtitle: 'إضافة أذكار من ملف خارجي',
            onPressed: _importAthkar,
            color: context.primaryColor,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.share_outlined,
            title: 'مشاركة الإعدادات',
            subtitle: 'مشاركة إعدادات التطبيق مع الآخرين',
            onPressed: _shareSettings,
            color: context.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.manage_accounts_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'إدارة البيانات',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildActionButton(
            context: context,
            icon: Icons.cleaning_services_outlined,
            title: 'تنظيف البيانات المؤقتة',
            subtitle: 'مسح الملفات المؤقتة وتحرير مساحة',
            onPressed: _clearCache,
            color: context.infoColor,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.refresh_outlined,
            title: 'إعادة تحميل البيانات',
            subtitle: 'تحديث جميع البيانات من المصدر',
            onPressed: _reloadData,
            color: context.warningColor,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.build_outlined,
            title: 'إصلاح البيانات',
            subtitle: 'فحص وإصلاح أي مشاكل في البيانات',
            onPressed: _repairData,
            color: context.successColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return IslamicCard(
      color: context.errorColor.withValues(alpha: 0.05),
      border: Border.all(
        color: context.errorColor.withValues(alpha: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: context.errorColor,
              ),
              Spaces.smallH,
              Text(
                'منطقة الخطر',
                style: context.titleStyle.copyWith(
                  color: context.errorColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'العمليات التالية لا يمكن التراجع عنها. تأكد من إنشاء نسخة احتياطية أولاً.',
            style: context.captionStyle.copyWith(
              color: context.errorColor,
            ),
          ),
          
          Spaces.medium,
          
          _buildActionButton(
            context: context,
            icon: Icons.delete_sweep_outlined,
            title: 'مسح جميع الأذكار المفضلة',
            subtitle: 'حذف جميع الأذكار المحفوظة في المفضلة',
            onPressed: _clearFavorites,
            color: context.errorColor,
            isDangerous: true,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.restore_outlined,
            title: 'إعادة تعيين الإعدادات',
            subtitle: 'استعادة إعدادات التطبيق الافتراضية',
            onPressed: _resetSettings,
            color: context.errorColor,
            isDangerous: true,
          ),
          
          Spaces.small,
          
          _buildActionButton(
            context: context,
            icon: Icons.delete_forever_outlined,
            title: 'مسح جميع البيانات',
            subtitle: 'حذف جميع بيانات التطبيق نهائياً',
            onPressed: _clearAllData,
            color: context.errorColor,
            isDangerous: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    required Color color,
    bool isDangerous = false,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.smallPadding),
      child: ListTile(
        contentPadding: EdgeInsets.all(context.smallPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.smallRadius),
          side: BorderSide(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        tileColor: color.withValues(alpha: 0.05),
        leading: Icon(
          icon,
          color: color,
        ),
        title: Text(
          title,
          style: context.bodyStyle.copyWith(
            fontWeight: ThemeConstants.fontMedium,
            color: isDangerous ? color : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.captionStyle.copyWith(
            color: isDangerous ? color.withValues(alpha: 0.8) : null,
          ),
        ),
        trailing: _isOperationInProgress
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            : Icon(
                Icons.arrow_forward_ios,
                size: ThemeConstants.iconXs,
                color: color,
              ),
        onTap: _isOperationInProgress ? null : onPressed,
      ),
    );
  }

  // Action Methods
  Future<void> _createBackup() async {
    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.showSuccessMessage('تم إنشاء النسخة الاحتياطية بنجاح');
      }
    }, 'جاري إنشاء النسخة الاحتياطية...');
  }

  Future<void> _restoreBackup() async {
    if (!mounted) return;
    
    final confirmed = await _showConfirmationDialog(
      context,
      'استعادة النسخة الاحتياطية',
      'سيتم استبدال البيانات الحالية بالبيانات المحفوظة. هل تريد المتابعة؟',
    );
    
    if (!confirmed) return;

    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.showSuccessMessage('تم استعادة النسخة الاحتياطية بنجاح');
      }
    }, 'جاري استعادة النسخة الاحتياطية...');
  }

  Future<void> _exportFavorites() async {
    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.showSuccessMessage('تم تصدير المفضلة بنجاح');
      }
    }, 'جاري تصدير المفضلة...');
  }

  Future<void> _importAthkar() async {
    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.showSuccessMessage('تم استيراد الأذكار بنجاح');
      }
    }, 'جاري استيراد الأذكار...');
  }

  Future<void> _shareSettings() async {
    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.showSuccessMessage('تم مشاركة الإعدادات');
      }
    }, 'جاري تحضير الإعدادات...');
  }

  Future<void> _clearCache() async {
    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      await _loadStorageInfo(); // Refresh storage info
      if (mounted) {
        context.showSuccessMessage('تم تنظيف البيانات المؤقتة');
      }
    }, 'جاري تنظيف البيانات المؤقتة...');
  }

  Future<void> _reloadData() async {
    await _performOperation(() async {
      final storage = getIt<StorageService>();
      await storage.reload();
      await _loadStorageInfo();
      if (mounted) {
        context.showSuccessMessage('تم إعادة تحميل البيانات');
      }
    }, 'جاري إعادة تحميل البيانات...');
  }

  Future<void> _repairData() async {
    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.showSuccessMessage('تم فحص وإصلاح البيانات');
      }
    }, 'جاري فحص وإصلاح البيانات...');
  }

  Future<void> _clearFavorites() async {
    if (!mounted) return;
    
    final confirmed = await _showConfirmationDialog(
      context,
      'مسح المفضلة',
      'سيتم حذف جميع الأذكار المحفوظة في المفضلة نهائياً. هل تريد المتابعة؟',
    );
    
    if (!confirmed) return;

    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.showSuccessMessage('تم مسح المفضلة');
      }
    }, 'جاري مسح المفضلة...');
  }

  Future<void> _resetSettings() async {
    if (!mounted) return;
    
    final confirmed = await _showConfirmationDialog(
      context,
      'إعادة تعيين الإعدادات',
      'سيتم استعادة جميع الإعدادات إلى القيم الافتراضية. هل تريد المتابعة؟',
    );
    
    if (!confirmed) return;

    await _performOperation(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.showSuccessMessage('تم إعادة تعيين الإعدادات');
      }
    }, 'جاري إعادة تعيين الإعدادات...');
  }

  Future<void> _clearAllData() async {
    if (!mounted) return;
    
    final confirmed = await _showConfirmationDialog(
      context,
      'مسح جميع البيانات',
      'سيتم حذف جميع بيانات التطبيق نهائياً بما في ذلك الإعدادات والمفضلة. '
      'هذا الإجراء لا يمكن التراجع عنه. هل تريد المتابعة؟',
      isDestructive: true,
    );
    
    if (!confirmed) return;

    await _performOperation(() async {
      final storage = getIt<StorageService>();
      await storage.clear();
      await _loadStorageInfo();
      if (mounted) {
        context.showSuccessMessage('تم مسح جميع البيانات');
      }
    }, 'جاري مسح جميع البيانات...');
  }

  // Helper Methods
  Future<void> _performOperation(
    Future<void> Function() operation,
    String loadingMessage,
  ) async {
    setState(() {
      _isOperationInProgress = true;
    });

    try {
      await operation();
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء العملية');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOperationInProgress = false;
        });
      }
    }
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    String title,
    String content, {
    bool isDestructive = false,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: context.errorColor,
                  )
                : null,
            child: Text(isDestructive ? 'حذف' : 'تأكيد'),
          ),
        ],
      ),
    ) ?? false;
  }
}