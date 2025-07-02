// lib/app/themes/widgets/core/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';

/// أنواع حقول النص
enum TextFieldType {
  normal,
  email,
  password,
  phone,
  number,
  multiline,
  search,
}

/// حقل نص موحد للتطبيق
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
  final bool obscureText;
  final bool showPasswordToggle;
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
  final String? prefixText;
  final String? suffixText;
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
    this.obscureText = false,
    this.showPasswordToggle = false,
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
    this.prefixText,
    this.suffixText,
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

  // Factory constructors
  factory AppTextField.email({
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
  }) {
    return AppTextField(
      label: label ?? 'البريد الإلكتروني',
      hint: hint ?? 'example@email.com',
      controller: controller,
      type: TextFieldType.email,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      textInputAction: TextInputAction.next,
    );
  }

  factory AppTextField.password({
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    bool showToggle = true,
  }) {
    return AppTextField(
      label: label ?? 'كلمة المرور',
      hint: hint ?? '••••••••',
      controller: controller,
      type: TextFieldType.password,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      showPasswordToggle: showToggle,
      textInputAction: TextInputAction.done,
    );
  }

  factory AppTextField.phone({
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
  }) {
    return AppTextField(
      label: label ?? 'رقم الهاتف',
      hint: hint ?? '05xxxxxxxx',
      controller: controller,
      type: TextFieldType.phone,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      textInputAction: TextInputAction.next,
    );
  }

  factory AppTextField.search({
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool enabled = true,
  }) {
    return AppTextField(
      hint: hint ?? 'بحث...',
      controller: controller,
      type: TextFieldType.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      textInputAction: TextInputAction.search,
    );
  }

  factory AppTextField.multiline({
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    int? maxLines = 5,
    int? minLines = 3,
    bool enabled = true,
  }) {
    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      type: TextFieldType.multiline,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
    );
  }
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText || widget.type == TextFieldType.password;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
    HapticFeedback.lightImpact();
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
      obscureText: _obscureText,
      maxLines: widget.type == TextFieldType.multiline ? widget.maxLines : 1,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction ?? _getTextInputAction(),
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
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
        contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: widget.type == TextFieldType.multiline 
              ? ThemeConstants.space4 
              : ThemeConstants.space3,
        ),
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
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
    
    IconData? icon;
    switch (widget.type) {
      case TextFieldType.email:
        icon = Icons.email_outlined;
        break;
      case TextFieldType.phone:
        icon = Icons.phone_outlined;
        break;
      case TextFieldType.search:
        icon = Icons.search;
        break;
      default:
        return null;
    }
    
    return Icon(icon, size: ThemeConstants.iconMd);
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) return widget.suffixIcon;
    
    if (widget.type == TextFieldType.password && widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: ThemeConstants.iconMd,
        ),
        onPressed: _togglePasswordVisibility,
        tooltip: _obscureText ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
      );
    }
    
    if (widget.type == TextFieldType.search && widget.controller?.text.isNotEmpty == true) {
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
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case TextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    if (widget.type == TextFieldType.multiline) {
      return TextInputAction.newline;
    }
    return TextInputAction.done;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case TextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case TextFieldType.number:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ];
      default:
        return null;
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