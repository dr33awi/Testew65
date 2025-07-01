// lib/app/themes/widgets/core/app_text_field.dart - النسخة القصوى (نوعين فقط)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';

/// أنواع حقول النص - النسخة القصوى
enum TextFieldType {
  normal,     // حقل عادي
  search,     // بحث
}

/// حقل نص موحد للتطبيق - النسخة القصوى والأبسط
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final TextFieldType type;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final FocusNode? focusNode;
  final bool filled;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.type = TextFieldType.normal,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusNode,
    this.filled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();

  // Factory constructors - النسخة القصوى

  /// حقل بحث (الأكثر استخداماً)
  factory AppTextField.search({
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool enabled = true,
    bool autofocus = false,
  }) {
    return AppTextField(
      hint: hint ?? 'بحث...',
      controller: controller,
      type: TextFieldType.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
    );
  }

  /// حقل متعدد الأسطر
  factory AppTextField.multiline({
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    int maxLines = 5,
    int minLines = 3,
    bool enabled = true,
  }) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      type: TextFieldType.normal,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      textInputAction: TextInputAction.newline,
    );
  }

  /// حقل للإضافة السريعة (عند الحاجة لاحقاً)
  /// 
  /// يمكن استخدامه للحقول الخاصة مثل:
  /// - البريد الإلكتروني (مع keyboardType)
  /// - كلمة المرور (مع obscureText)
  /// - رقم الهاتف (مع inputFormatters)
  factory AppTextField.custom({
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    TextInputType? keyboardType,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputAction? textInputAction,
  }) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      inputFormatters: inputFormatters,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      textInputAction: textInputAction,
    );
  }
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction ?? _getTextInputAction(),
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      style: AppTextStyles.body1.copyWith(
        color: widget.enabled ? theme.textTheme.bodyLarge?.color : theme.disabledColor,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        helperText: widget.helperText,
        errorMaxLines: 2,
        filled: widget.filled,
        fillColor: widget.fillColor ?? (widget.enabled 
            ? theme.inputDecorationTheme.fillColor 
            : theme.disabledColor.withValues(alpha: 0.05)),
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space3,
        ),
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
        border: _buildBorder(theme),
        enabledBorder: _buildBorder(theme),
        focusedBorder: _buildFocusedBorder(theme),
        errorBorder: _buildErrorBorder(theme),
        focusedErrorBorder: _buildErrorBorder(theme),
        disabledBorder: _buildDisabledBorder(theme),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    
    // أيقونة البحث تلقائياً للبحث
    if (widget.type == TextFieldType.search) {
      return const Icon(Icons.search, size: ThemeConstants.iconMd);
    }
    
    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) return widget.suffixIcon;
    
    // زر مسح للبحث عندما يكون هناك نص
    if (widget.type == TextFieldType.search && 
        widget.controller?.text.isNotEmpty == true) {
      return IconButton(
        icon: const Icon(Icons.clear, size: ThemeConstants.iconSm),
        onPressed: () {
          widget.controller?.clear();
          widget.onChanged?.call('');
        },
        tooltip: 'مسح',
      );
    }
    
    return null;
  }

  TextInputType _getKeyboardType() {
    // نوع واحد فقط للبساطة
    return TextInputType.text;
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case TextFieldType.search:
        return TextInputAction.search;
      default:
        return TextInputAction.done;
    }
  }

  InputBorder _buildBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? ThemeConstants.radiusMd),
      borderSide: BorderSide(
        color: widget.borderColor ?? theme.dividerColor,
        width: ThemeConstants.borderLight,
      ),
    );
  }

  InputBorder _buildFocusedBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? ThemeConstants.radiusMd),
      borderSide: BorderSide(
        color: widget.focusedBorderColor ?? theme.primaryColor,
        width: ThemeConstants.borderMedium,
      ),
    );
  }

  InputBorder _buildErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? ThemeConstants.radiusMd),
      borderSide: BorderSide(
        color: widget.errorBorderColor ?? theme.colorScheme.error,
        width: ThemeConstants.borderMedium,
      ),
    );
  }

  InputBorder _buildDisabledBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? ThemeConstants.radiusMd),
      borderSide: BorderSide(
        color: theme.disabledColor.withValues(alpha: 0.2),
        width: ThemeConstants.borderLight,
      ),
    );
  }
}
