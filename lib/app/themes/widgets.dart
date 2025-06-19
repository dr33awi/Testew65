// lib/app/themes/widgets.dart
import 'package:flutter/material.dart';
import 'theme_constants.dart';
import 'typography.dart';

// ==================== مساحات سريعة ====================

class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {super.key});
  
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {super.key});
  
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

// المساحات الثابتة
class Spaces {
  static const xs = VSpace(ThemeConstants.spaceXs);
  static const sm = VSpace(ThemeConstants.spaceSm);
  static const md = VSpace(ThemeConstants.spaceMd);
  static const lg = VSpace(ThemeConstants.spaceLg);
  static const xl = VSpace(ThemeConstants.spaceXl);
  
  static const xsH = HSpace(ThemeConstants.spaceXs);
  static const smH = HSpace(ThemeConstants.spaceSm);
  static const mdH = HSpace(ThemeConstants.spaceMd);
  static const lgH = HSpace(ThemeConstants.spaceLg);
  static const xlH = HSpace(ThemeConstants.spaceXl);
}

// ==================== بطاقة إسلامية ====================

class IslamicCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final LinearGradient? gradient;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  
  const IslamicCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.boxShadow,
    this.border,
  });
  
  /// بطاقة بسيطة
  factory IslamicCard.simple({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      child: child,
    );
  }
  
  /// بطاقة بتدرج
  factory IslamicCard.gradient({
    required Widget child,
    required LinearGradient gradient,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      gradient: gradient,
      child: child,
    );
  }
  
  /// بطاقة صلاة
  factory IslamicCard.prayer({
    required Widget child,
    required String prayerName,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    final prayerColor = ThemeConstants.getPrayerColor(prayerName);
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      gradient: LinearGradient(
        colors: [prayerColor, prayerColor.withValues(alpha: 0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark 
        ? ThemeConstants.darkCard 
        : ThemeConstants.lightCard;
    
    Widget content = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? defaultColor) : null,
        gradient: gradient,
        border: border,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ThemeConstants.radiusLg,
        ),
        boxShadow: boxShadow ?? (isDark 
            ? ThemeConstants.shadowMd.map((shadow) => 
                shadow.copyWith(color: shadow.color.withValues(alpha: 0.3))).toList()
            : ThemeConstants.shadowMd),
      ),
      child: child,
    );
    
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ThemeConstants.radiusLg,
          ),
          child: content,
        ),
      );
    }
    
    return content;
  }
}

// ==================== زر إسلامي ====================

class IslamicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isOutlined;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  
  const IslamicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isOutlined = false,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
  });
  
  /// زر أساسي
  factory IslamicButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool isLoading = false,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      width: width,
      isLoading: isLoading,
    );
  }
  
  /// زر ثانوي
  factory IslamicButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool isLoading = false,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isSecondary: true,
      width: width,
      isLoading: isLoading,
    );
  }
  
  /// زر محدود
  factory IslamicButton.outlined({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? color,
    double? width,
    bool isLoading = false,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isOutlined: true,
      color: color,
      width: width,
      isLoading: isLoading,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? 
        (isSecondary ? ThemeConstants.secondary : ThemeConstants.primary);
    
    final effectiveOnPressed = isLoading ? null : onPressed;
    
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor, width: 2),
            minimumSize: Size(width ?? 0, height ?? ThemeConstants.buttonHeightMd),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            minimumSize: Size(width ?? 0, height ?? ThemeConstants.buttonHeightMd),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            elevation: 2,
          );
    
    Widget buttonChild = isLoading 
        ? SizedBox(
            width: ThemeConstants.iconSm,
            height: ThemeConstants.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutlined ? buttonColor : Colors.white,
            ),
          )
        : Text(text);
    
    if (icon != null && !isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: ThemeConstants.iconSm),
          const SizedBox(width: ThemeConstants.spaceSm),
          Text(text),
        ],
      );
    }
    
    return isOutlined
        ? OutlinedButton(
            onPressed: effectiveOnPressed,
            style: style,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: effectiveOnPressed,
            style: style,
            child: buttonChild,
          );
  }
}

// ==================== نص إسلامي ====================

class IslamicText extends StatelessWidget {
  final String text;
  final IslamicTextType type;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const IslamicText({
    super.key,
    required this.text,
    required this.type,
    this.textAlign,
    this.color,
    this.fontSize,
    this.maxLines,
    this.overflow,
  });
  
  /// آية قرآنية
  factory IslamicText.quran({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.quran,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
    );
  }
  
  /// حديث شريف
  factory IslamicText.hadith({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.hadith,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
    );
  }
  
  /// دعاء
  factory IslamicText.dua({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.dua,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
    );
  }
  
  /// تسبيح
  factory IslamicText.tasbih({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.tasbih,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ?? (isDark 
        ? ThemeConstants.darkText 
        : ThemeConstants.lightText);
    
    TextStyle style = switch (type) {
      IslamicTextType.quran => AppTypography.quran,
      IslamicTextType.hadith => AppTypography.hadith,
      IslamicTextType.dua => AppTypography.dua,
      IslamicTextType.tasbih => AppTypography.tasbih,
    };
    
    if (fontSize != null) {
      style = style.copyWith(fontSize: fontSize);
    }
    
    return Text(
      text,
      style: style.copyWith(color: defaultColor),
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

enum IslamicTextType { quran, hadith, dua, tasbih }

// ==================== مؤشر التحميل الإسلامي ====================

class IslamicLoading extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;
  
  const IslamicLoading({
    super.key,
    this.message,
    this.color,
    this.size,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              color: color ?? ThemeConstants.primary,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            Spaces.md,
            Text(
              message!,
              style: AppTypography.body.copyWith(
                color: color ?? ThemeConstants.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== مفتاح التبديل الإسلامي ====================

class IslamicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final EdgeInsetsGeometry? contentPadding;
  
  const IslamicSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.contentPadding,
  });
  
  @override
  Widget build(BuildContext context) {
    if (title == null && subtitle == null) {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor ?? ThemeConstants.primary,
      );
    }
    
    return ListTile(
      contentPadding: contentPadding,
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor ?? ThemeConstants.primary,
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}

// ==================== شريط تطبيق إسلامي ====================

class IslamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  
  const IslamicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.elevation,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? 
          (isDark ? ThemeConstants.darkSurface : ThemeConstants.lightSurface),
      foregroundColor: foregroundColor ?? 
          (isDark ? ThemeConstants.darkText : ThemeConstants.lightText),
      elevation: elevation ?? 0,
      bottom: bottom,
      titleTextStyle: AppTypography.title.copyWith(
        color: foregroundColor ?? 
            (isDark ? ThemeConstants.darkText : ThemeConstants.lightText),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

// ==================== حقل إدخال إسلامي ====================

class IslamicInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  
  const IslamicInput({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null 
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconPressed,
              )
            : null,
      ),
    );
  }
}

// ==================== حاوي مع تدرج ====================

class GradientContainer extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  
  const GradientContainer({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius!)
            : null,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

// ==================== شاشة فارغة ====================

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final Color? iconColor;
  
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? 
                  (Theme.of(context).brightness == Brightness.dark
                      ? ThemeConstants.darkTextSecondary
                      : ThemeConstants.lightTextSecondary),
            ),
            Spaces.lg,
            Text(
              title,
              style: AppTypography.title.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? ThemeConstants.darkText
                    : ThemeConstants.lightText,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              Spaces.sm,
              Text(
                subtitle!,
                style: AppTypography.body.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? ThemeConstants.darkTextSecondary
                      : ThemeConstants.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              Spaces.lg,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== فاصل مع نص ====================

class TextDivider extends StatelessWidget {
  final String text;
  final Color? color;
  final double? thickness;
  final EdgeInsetsGeometry? padding;
  
  const TextDivider({
    super.key,
    required this.text,
    this.color,
    this.thickness,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? 
        (Theme.of(context).brightness == Brightness.dark
            ? ThemeConstants.darkBorder
            : ThemeConstants.lightBorder);
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: ThemeConstants.spaceMd),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: thickness ?? 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceMd),
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? ThemeConstants.darkTextSecondary
                    : ThemeConstants.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: thickness ?? 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== عداد مع أيقونة ====================

class IconCounter extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  
  const IconCounter({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    this.iconColor,
    this.textColor,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).brightness == Brightness.dark
        ? ThemeConstants.darkText
        : ThemeConstants.lightText;
    
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor ?? ThemeConstants.primary,
          size: ThemeConstants.iconLg,
        ),
        Spaces.xs,
        Text(
          count.toString(),
          style: AppTypography.title.copyWith(
            color: textColor ?? defaultColor,
            fontWeight: ThemeConstants.fontBold,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: textColor ?? 
                (Theme.of(context).brightness == Brightness.dark
                    ? ThemeConstants.darkTextSecondary
                    : ThemeConstants.lightTextSecondary),
          ),
        ),
      ],
    );
    
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.spaceSm),
          child: content,
        ),
      );
    }
    
    return content;
  }
}