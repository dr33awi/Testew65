// lib/app/themes/components/dialogs.dart
import 'package:flutter/material.dart';
import 'dart:ui';

import '../core/colors.dart';
import '../core/spacing.dart';
import '../core/typography.dart';
import '../core/gradients.dart';
import '../extensions/theme_extensions.dart';
import 'buttons.dart';

/// نظام الحوارات والنوافذ المنبثقة الموحد
/// يوفر أنواع مختلفة من الحوارات مع تصميم إسلامي أنيق
class AppDialog {
  AppDialog._();

  /// حوار معلومات بسيط
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String content,
    IconData? icon,
    Color? accentColor,
    String confirmText = 'موافق',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => _InfoDialog(
        title: title,
        content: content,
        icon: icon,
        accentColor: accentColor,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  /// حوار تأكيد
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    IconData? icon,
    Color? confirmButtonColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        confirmButtonColor: confirmButtonColor,
        isDestructive: isDestructive,
      ),
    );
  }

  /// حوار مع خيارات متعددة
  static Future<T?> showChoice<T>({
    required BuildContext context,
    required String title,
    String? content,
    required List<AppDialogChoice<T>> choices,
    IconData? icon,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => _ChoiceDialog<T>(
        title: title,
        content: content,
        choices: choices,
        icon: icon,
      ),
    );
  }

  /// حوار إدخال نص
  static Future<String?> showTextInput({
    required BuildContext context,
    required String title,
    String? content,
    String? hintText,
    String? initialValue,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => _TextInputDialog(
        title: title,
        content: content,
        hintText: hintText,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  /// حوار تحميل
  static void showLoading({
    required BuildContext context,
    String? message,
    bool dismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => _LoadingDialog(message: message),
    );
  }

  /// إخفاء حوار التحميل
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// حوار آية أو حديث
  static Future<void> showIslamicText({
    required BuildContext context,
    required String text,
    required String title,
    String? source,
    AppIslamicTextType type = AppIslamicTextType.quran,
    VoidCallback? onShare,
    VoidCallback? onBookmark,
    bool isBookmarked = false,
  }) {
    return showDialog(
      context: context,
      builder: (context) => _IslamicTextDialog(
        text: text,
        title: title,
        source: source,
        type: type,
        onShare: onShare,
        onBookmark: onBookmark,
        isBookmarked: isBookmarked,
      ),
    );
  }

  /// ورقة سفلية (Bottom Sheet)
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? Colors.transparent,
      builder: (context) => _BottomSheetWrapper(child: child),
    );
  }

  /// ورقة سفلية للقوائم
  static Future<T?> showListBottomSheet<T>({
    required BuildContext context,
    required String title,
    required List<AppBottomSheetItem<T>> items,
    IconData? icon,
  }) {
    return showBottomSheet<T>(
      context: context,
      child: _ListBottomSheet<T>(
        title: title,
        items: items,
        icon: icon,
      ),
    );
  }
}

/// خيار في حوار الاختيار
class AppDialogChoice<T> {
  final String text;
  final T value;
  final IconData? icon;
  final Color? color;
  final bool isDefault;

  const AppDialogChoice({
    required this.text,
    required this.value,
    this.icon,
    this.color,
    this.isDefault = false,
  });
}

/// عنصر في الورقة السفلية
class AppBottomSheetItem<T> {
  final String text;
  final T value;
  final IconData? icon;
  final Color? color;
  final bool isDestructive;

  const AppBottomSheetItem({
    required this.text,
    required this.value,
    this.icon,
    this.color,
    this.isDestructive = false,
  });
}

/// نوع النص الإسلامي
enum AppIslamicTextType {
  quran,    // قرآن
  hadith,   // حديث
  dua,      // دعاء
}

// ==================== الحوارات الداخلية ====================

/// حوار المعلومات
class _InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? accentColor;
  final String confirmText;
  final VoidCallback? onConfirm;

  const _InfoDialog({
    required this.title,
    required this.content,
    this.icon,
    this.accentColor,
    required this.confirmText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccentColor = accentColor ?? context.primaryColor;

    return _BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان مع الأيقونة
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: AppSpacing.allMd,
                  decoration: BoxDecoration(
                    color: effectiveAccentColor.withValues(alpha: 0.1),
                    borderRadius: context.radiusLg,
                  ),
                  child: Icon(
                    icon,
                    color: effectiveAccentColor,
                    size: context.iconLg,
                  ),
                ),
                AppSpacing.widthMd,
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.heightLg,

          // المحتوى
          Text(
            content,
            style: context.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),

          AppSpacing.heightXl,

          // زر التأكيد
          AppButton.primary(
            text: confirmText,
            isFullWidth: true,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// حوار التأكيد
class _ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final Color? confirmButtonColor;
  final bool isDestructive;

  const _ConfirmationDialog({
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    this.icon,
    this.confirmButtonColor,
    required this.isDestructive,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = isDestructive 
        ? context.errorColor 
        : (confirmButtonColor ?? context.primaryColor);

    return _BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان مع الأيقونة
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: AppSpacing.allMd,
                  decoration: BoxDecoration(
                    color: buttonColor.withValues(alpha: 0.1),
                    borderRadius: context.radiusLg,
                  ),
                  child: Icon(
                    icon,
                    color: buttonColor,
                    size: context.iconLg,
                  ),
                ),
                AppSpacing.widthMd,
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.heightLg,

          // المحتوى
          Text(
            content,
            style: context.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),

          AppSpacing.heightXl,

          // الأزرار
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: cancelText,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              AppSpacing.widthMd,
              Expanded(
                child: AppButton.primary(
                  text: confirmText,
                  customColor: buttonColor,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// حوار الاختيار
class _ChoiceDialog<T> extends StatelessWidget {
  final String title;
  final String? content;
  final List<AppDialogChoice<T>> choices;
  final IconData? icon;

  const _ChoiceDialog({
    required this.title,
    required this.content,
    required this.choices,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: AppSpacing.allMd,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: context.radiusLg,
                  ),
                  child: Icon(
                    icon,
                    color: context.primaryColor,
                    size: context.iconLg,
                  ),
                ),
                AppSpacing.widthMd,
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
            ],
          ),

          if (content != null) ...[
            AppSpacing.heightMd,
            Text(
              content!,
              style: context.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ],

          AppSpacing.heightLg,

          // الخيارات
          ...choices.map((choice) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppButton(
              text: choice.text,
              icon: choice.icon,
              isFullWidth: true,
              type: choice.isDefault 
                  ? AppButtonType.primary 
                  : AppButtonType.outlined,
              customColor: choice.color,
              onPressed: () => Navigator.of(context).pop(choice.value),
            ),
          )),
        ],
      ),
    );
  }
}

/// حوار إدخال النص
class _TextInputDialog extends StatefulWidget {
  final String title;
  final String? content;
  final String? hintText;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _TextInputDialog({
    required this.title,
    this.content,
    this.hintText,
    this.initialValue,
    required this.confirmText,
    required this.cancelText,
    required this.maxLines,
    required this.keyboardType,
    this.validator,
  });

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Text(
              widget.title,
              style: context.titleLarge?.copyWith(
                fontWeight: AppTypography.bold,
              ),
            ),

            if (widget.content != null) ...[
              AppSpacing.heightMd,
              Text(
                widget.content!,
                style: context.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),
            ],

            AppSpacing.heightLg,

            // حقل الإدخال
            TextFormField(
              controller: _controller,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: context.inputBorderRadius,
                ),
              ),
              autofocus: true,
            ),

            AppSpacing.heightXl,

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    text: widget.cancelText,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                AppSpacing.widthMd,
                Expanded(
                  child: AppButton.primary(
                    text: widget.confirmText,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? true) {
                        Navigator.of(context).pop(_controller.text);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// حوار التحميل
class _LoadingDialog extends StatelessWidget {
  final String? message;

  const _LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: AppSpacing.allXl,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: context.radiusXxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            ),
            if (message != null) ...[
              AppSpacing.heightLg,
              Text(
                message!,
                style: context.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// حوار النص الإسلامي
class _IslamicTextDialog extends StatelessWidget {
  final String text;
  final String title;
  final String? source;
  final AppIslamicTextType type;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final bool isBookmarked;

  const _IslamicTextDialog({
    required this.text,
    required this.title,
    this.source,
    required this.type,
    this.onShare,
    this.onBookmark,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle(context);
    final gradient = _getGradient(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: AppSpacing.allLg,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: context.radiusXxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Container(
              width: double.infinity,
              padding: AppSpacing.allLg,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.radiusXxl.topLeft.x),
                  topRight: Radius.circular(context.radiusXxl.topRight.x),
                ),
              ),
              child: Text(
                title,
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: AppTypography.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // النص الرئيسي
            Flexible(
              child: Container(
                width: double.infinity,
                margin: AppSpacing.allLg,
                padding: AppSpacing.allXl,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.radiusXl,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: textStyle,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            // المصدر
            if (source != null) ...[
              Padding(
                padding: AppSpacing.horizontalLg,
                child: Text(
                  source!,
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.heightMd,
            ],

            // الأزرار
            Padding(
              padding: AppSpacing.allLg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onShare != null)
                    _buildActionButton(
                      context: context,
                      icon: Icons.share,
                      label: 'مشاركة',
                      onTap: onShare!,
                    ),

                  if (onBookmark != null)
                    _buildActionButton(
                      context: context,
                      icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      label: isBookmarked ? 'محفوظ' : 'حفظ',
                      onTap: onBookmark!,
                      isActive: isBookmarked,
                    ),

                  _buildActionButton(
                    context: context,
                    icon: Icons.close,
                    label: 'إغلاق',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    return switch (type) {
      AppIslamicTextType.quran => context.quranTextStyle,
      AppIslamicTextType.hadith => context.hadithTextStyle,
      AppIslamicTextType.dua => context.duaTextStyle,
    };
  }

  LinearGradient _getGradient(BuildContext context) {
    return switch (type) {
      AppIslamicTextType.quran => context.tertiaryGradient,
      AppIslamicTextType.hadith => context.secondaryGradient,
      AppIslamicTextType.dua => context.primaryGradient,
    };
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: context.radiusLg,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
              size: context.iconMd,
            ),
            onPressed: onTap,
          ),
        ),
        AppSpacing.heightXs,
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

/// الحاوية الأساسية للحوارات
class _BaseDialog extends StatelessWidget {
  final Widget child;

  const _BaseDialog({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: AppSpacing.allLg,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: AppSpacing.allXl,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: context.radiusXxl,
          border: Border.all(
            color: context.dividerColor.withValues(alpha: 0.2),
            width: AppSpacing.borderThin,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 5,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// حاوية الورقة السفلية
class _BottomSheetWrapper extends StatelessWidget {
  final Widget child;

  const _BottomSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مؤشر السحب
          Container(
            margin: AppSpacing.verticalMd,
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // المحتوى
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// ورقة سفلية للقوائم
class _ListBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<AppBottomSheetItem<T>> items;
  final IconData? icon;

  const _ListBottomSheet({
    required this.title,
    required this.items,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.allLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: context.primaryColor,
                  size: context.iconMd,
                ),
                AppSpacing.widthMd,
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.heightLg,

          // العناصر
          ...items.map((item) => _buildListItem(context, item)),

          // مساحة إضافية للأمان
          AppSpacing.heightMd,
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, AppBottomSheetItem<T> item) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: item.icon != null
            ? Icon(
                item.icon,
                color: item.isDestructive 
                    ? context.errorColor 
                    : (item.color ?? context.textSecondaryColor),
              )
            : null,
        title: Text(
          item.text,
          style: context.bodyMedium?.copyWith(
            color: item.isDestructive 
                ? context.errorColor 
                : (item.color ?? context.textPrimaryColor),
          ),
        ),
        onTap: () => Navigator.of(context).pop(item.value),
        shape: RoundedRectangleBorder(
          borderRadius: context.radiusLg,
        ),
        contentPadding: AppSpacing.horizontalMd,
      ),
    );
  }
}

/// مساعدات إضافية للحوارات
extension DialogExtensions on BuildContext {
  /// إظهار رسالة نجاح سريعة
  Future<void> showSuccessDialog(String message, {String? title}) {
    return AppDialog.showInfo(
      context: this,
      title: title ?? 'نجح',
      content: message,
      icon: Icons.check_circle,
      accentColor: successColor,
    );
  }

  /// إظهار رسالة خطأ سريعة
  Future<void> showErrorDialog(String message, {String? title}) {
    return AppDialog.showInfo(
      context: this,
      title: title ?? 'خطأ',
      content: message,
      icon: Icons.error,
      accentColor: errorColor,
    );
  }

  /// إظهار تأكيد حذف
  Future<bool?> showDeleteConfirmation({
    String? title,
    String? content,
  }) {
    return AppDialog.showConfirmation(
      context: this,
      title: title ?? 'تأكيد الحذف',
      content: content ?? 'هل أنت متأكد من رغبتك في الحذف؟ لا يمكن التراجع عن هذا الإجراء.',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      icon: Icons.delete,
      isDestructive: true,
    );
  }

  /// إظهار تحميل مع رسالة
  void showLoadingDialog([String? message]) {
    AppDialog.showLoading(
      context: this,
      message: message ?? 'جارٍ التحميل...',
    );
  }

  /// إخفاء تحميل
  void hideLoadingDialog() {
    AppDialog.hideLoading(this);
  }

  /// إظهار آية قرآنية
  Future<void> showQuranVerse(String verse, {String? source}) {
    return AppDialog.showIslamicText(
      context: this,
      text: verse,
      title: 'آية كريمة',
      source: source,
      type: AppIslamicTextType.quran,
    );
  }

  /// إظهار حديث شريف
  Future<void> showHadith(String hadith, {String? source}) {
    return AppDialog.showIslamicText(
      context: this,
      text: hadith,
      title: 'حديث شريف',
      source: source,
      type: AppIslamicTextType.hadith,
    );
  }

  /// إظهار دعاء
  Future<void> showDua(String dua, {String? source}) {
    return AppDialog.showIslamicText(
      context: this,
      text: dua,
      title: 'دعاء مبارك',
      source: source,
      type: AppIslamicTextType.dua,
    );
  }
}