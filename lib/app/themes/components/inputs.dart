// lib/app/themes/components/inputs.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/spacing.dart';
import '../core/typography.dart';
import '../extensions/theme_extensions.dart';

/// نظام حقول الإدخال الموحد للتطبيق الإسلامي
/// يوفر حقول إدخال مختلفة مع تصميم متسق وأنيق
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final AppTextFieldStyle style;
  final bool showCounter;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.textDirection,
    this.style = AppTextFieldStyle.outlined,
    this.showCounter = false,
  });

  /// حقل نص عادي
  factory AppTextField.standard({
    TextEditingController? controller,
    String? label,
    String? hint,
    IconData? prefixIcon,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: prefixIcon,
      onChanged: onChanged,
      validator: validator,
    );
  }

  /// حقل كلمة مرور
  factory AppTextField.password({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'كلمة المرور',
      hint: hint,
      prefixIcon: Icons.lock_outline,
      suffixIcon: Icons.visibility_outlined,
      obscureText: true,
      onChanged: onChanged,
      validator: validator,
    );
  }

  /// حقل البريد الإلكتروني
  factory AppTextField.email({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'البريد الإلكتروني',
      hint: hint,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      validator: validator,
    );
  }

  /// حقل رقم الهاتف
  factory AppTextField.phone({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'رقم الهاتف',
      hint: hint,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      validator: validator,
    );
  }

  /// حقل البحث
  factory AppTextField.search({
    TextEditingController? controller,
    String? hint,
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
  }) {
    return AppTextField(
      controller: controller,
      hint: hint ?? 'البحث...',
      prefixIcon: Icons.search,
      suffixIcon: Icons.clear,
      onSuffixIconPressed: onClear,
      style: AppTextFieldStyle.filled,
      onChanged: onChanged,
    );
  }

  /// حقل نص متعدد الأسطر
  factory AppTextField.multiline({
    TextEditingController? controller,
    String? label,
    String? hint,
    int maxLines = 4,
    int? maxLength,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      showCounter: maxLength != null,
    );
  }

  /// حقل للنصوص العربية
  factory AppTextField.arabic({
    TextEditingController? controller,
    String? label,
    String? hint,
    IconData? prefixIcon,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      prefixIcon: prefixIcon,
      textDirection: TextDirection.rtl,
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: context.labelMedium?.copyWith(
              fontWeight: AppTypography.medium,
              color: _isFocused 
                  ? context.primaryColor 
                  : context.textSecondaryColor,
            ),
          ),
          AppSpacing.heightSm,
        ],
        
        _buildTextField(context),
        
        if (widget.helperText != null || widget.errorText != null) ...[
          AppSpacing.heightSm,
          _buildHelperText(context),
        ],
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    final decoration = _buildInputDecoration(context);
    
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      textDirection: widget.textDirection,
      style: _getTextStyle(context),
      decoration: decoration,
      buildCounter: widget.showCounter ? null : (context, {required currentLength, required isFocused, maxLength}) => null,
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: _getHintStyle(context),
      prefixIcon: _buildPrefixIcon(context),
      suffixIcon: _buildSuffixIcon(context),
      errorText: widget.errorText,
      filled: widget.style == AppTextFieldStyle.filled,
      fillColor: _getFillColor(context),
      border: _getBorder(context),
      enabledBorder: _getBorder(context),
      focusedBorder: _getFocusedBorder(context),
      errorBorder: _getErrorBorder(context),
      focusedErrorBorder: _getFocusedErrorBorder(context),
      disabledBorder: _getDisabledBorder(context),
      contentPadding: _getContentPadding(),
      counterStyle: context.labelSmall?.copyWith(
        color: context.textSecondaryColor,
      ),
    );
  }

  Widget? _buildPrefixIcon(BuildContext context) {
    if (widget.prefixIcon == null) return null;
    
    return Icon(
      widget.prefixIcon,
      color: _isFocused 
          ? context.primaryColor 
          : context.textSecondaryColor,
      size: context.iconMd,
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: _isFocused 
              ? context.primaryColor 
              : context.textSecondaryColor,
          size: context.iconMd,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: _isFocused 
              ? context.primaryColor 
              : context.textSecondaryColor,
          size: context.iconMd,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }
    
    return null;
  }

  Widget _buildHelperText(BuildContext context) {
    final text = widget.errorText ?? widget.helperText;
    final isError = widget.errorText != null;
    
    return Text(
      text!,
      style: context.labelSmall?.copyWith(
        color: isError ? context.errorColor : context.textSecondaryColor,
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    return AppTypography.inputText.copyWith(
      color: widget.enabled 
          ? context.textPrimaryColor 
          : context.textSecondaryColor,
    );
  }

  TextStyle _getHintStyle(BuildContext context) {
    return AppTypography.hintText.copyWith(
      color: context.textSecondaryColor.withValues(alpha: 0.7),
    );
  }

  Color? _getFillColor(BuildContext context) {
    if (widget.style != AppTextFieldStyle.filled) return null;
    
    if (!widget.enabled) {
      return context.dividerColor.withValues(alpha: 0.1);
    }
    
    return _isFocused 
        ? context.primaryColor.withValues(alpha: 0.05)
        : context.surfaceColor;
  }

  OutlineInputBorder _getBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: context.inputBorderRadius,
      borderSide: BorderSide(
        color: widget.style == AppTextFieldStyle.filled 
            ? Colors.transparent
            : context.dividerColor.withValues(alpha: 0.5),
        width: AppSpacing.borderThin,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: context.inputBorderRadius,
      borderSide: BorderSide(
        color: context.primaryColor,
        width: AppSpacing.borderMedium,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: context.inputBorderRadius,
      borderSide: BorderSide(
        color: context.errorColor,
        width: AppSpacing.borderThin,
      ),
    );
  }

  OutlineInputBorder _getFocusedErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: context.inputBorderRadius,
      borderSide: BorderSide(
        color: context.errorColor,
        width: AppSpacing.borderMedium,
      ),
    );
  }

  OutlineInputBorder _getDisabledBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: context.inputBorderRadius,
      borderSide: BorderSide(
        color: context.dividerColor.withValues(alpha: 0.3),
        width: AppSpacing.borderThin,
      ),
    );
  }

  EdgeInsetsGeometry _getContentPadding() {
    return widget.style == AppTextFieldStyle.filled
        ? EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          )
        : AppSpacing.allLg;
  }
}

/// أنماط حقول النص
enum AppTextFieldStyle {
  outlined,  // محدود
  filled,    // معبأ
}

/// قائمة منسدلة مخصصة
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final bool enabled;

  const AppDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.labelMedium?.copyWith(
              fontWeight: AppTypography.medium,
              color: context.textSecondaryColor,
            ),
          ),
          AppSpacing.heightSm,
        ],
        
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) => DropdownMenuItem<T>(
            value: item.value,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: context.iconSm,
                    color: context.textSecondaryColor,
                  ),
                  AppSpacing.widthSm,
                ],
                Expanded(child: Text(item.text)),
              ],
            ),
          )).toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: context.inputBorderRadius,
            ),
            contentPadding: AppSpacing.allLg,
          ),
          style: AppTypography.inputText.copyWith(
            color: context.textPrimaryColor,
          ),
        ),
        
        if (errorText != null) ...[
          AppSpacing.heightSm,
          Text(
            errorText!,
            style: context.labelSmall?.copyWith(
              color: context.errorColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// عنصر في القائمة المنسدلة
class AppDropdownItem<T> {
  final T value;
  final String text;
  final IconData? icon;

  const AppDropdownItem({
    required this.value,
    required this.text,
    this.icon,
  });
}

/// مربع اختيار مخصص
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final bool enabled;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      borderRadius: context.radiusMd,
      child: Padding(
        padding: AppSpacing.allSm,
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: activeColor ?? context.primaryColor,
            ),
            
            if (title != null) ...[
              AppSpacing.widthSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: context.bodyMedium?.copyWith(
                        color: enabled 
                            ? context.textPrimaryColor 
                            : context.textSecondaryColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      AppSpacing.heightXs,
                      Text(
                        subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// زر راديو مخصص
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final bool enabled;

  const AppRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: enabled ? () => onChanged?.call(value) : null,
      borderRadius: context.radiusMd,
      child: Padding(
        padding: AppSpacing.allSm,
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: enabled ? onChanged : null,
              activeColor: activeColor ?? context.primaryColor,
            ),
            
            if (title != null) ...[
              AppSpacing.widthSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: context.bodyMedium?.copyWith(
                        color: enabled 
                            ? context.textPrimaryColor 
                            : context.textSecondaryColor,
                        fontWeight: isSelected 
                            ? AppTypography.medium 
                            : AppTypography.regular,
                      ),
                    ),
                    if (subtitle != null) ...[
                      AppSpacing.heightXs,
                      Text(
                        subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// مفتاح تبديل مخصص
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final bool enabled;

  const AppSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      borderRadius: context.radiusMd,
      child: Padding(
        padding: AppSpacing.allSm,
        child: Row(
          children: [
            if (title != null) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: context.bodyMedium?.copyWith(
                        color: enabled 
                            ? context.textPrimaryColor 
                            : context.textSecondaryColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      AppSpacing.heightXs,
                      Text(
                        subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.widthMd,
            ],
            
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: activeColor ?? context.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// مجموعة حقول إدخال
class AppFormGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const AppFormGroup({
    super.key,
    this.title,
    required this.children,
    this.padding,
    this.spacing = AppSpacing.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.allLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: context.titleMedium?.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
            ),
            AppSpacing.heightLg,
          ],
          
          ...children.expand((child) => [
            child,
            AppSpacing.height(spacing),
          ]).take(children.length * 2 - 1),
        ],
      ),
    );
  }
}