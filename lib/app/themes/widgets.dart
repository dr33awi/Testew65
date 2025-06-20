// lib/app/themes/widgets.dart
import 'package:flutter/material.dart';
import 'theme_constants.dart';
import 'typography.dart';

// ==================== مساحات سريعة ====================

/// مساحة عمودية
class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {super.key});
  
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

/// مساحة أفقية
class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {super.key});
  
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

/// مساحات ثابتة سريعة الاستخدام
class Spaces {
  static const xs = VSpace(ThemeConstants.spaceXs);
  static const small = VSpace(ThemeConstants.spaceSm);
  static const medium = VSpace(ThemeConstants.spaceMd);
  static const large = VSpace(ThemeConstants.spaceLg);
  static const extraLarge = VSpace(ThemeConstants.spaceXl);
  
  // مساحات أفقية
  static const xsH = HSpace(ThemeConstants.spaceXs);
  static const smallH = HSpace(ThemeConstants.spaceSm);
  static const mediumH = HSpace(ThemeConstants.spaceMd);
  static const largeH = HSpace(ThemeConstants.spaceLg);
  static const extraLargeH = HSpace(ThemeConstants.spaceXl);
}

// ==================== بطاقة إسلامية ====================

/// بطاقة التطبيق الأساسية - مرنة وقابلة للتخصيص
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
  final double? width;
  final double? height;
  
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
    this.width,
    this.height,
  });
  
  /// بطاقة بسيطة - الأكثر استخداماً
  factory IslamicCard.simple({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin, required Color color,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      child: child,
    );
  }
  
  /// بطاقة بتدرج لوني
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
  
  /// بطاقة صلاة مع لون مخصص
  factory IslamicCard.prayer({
    required Widget child,
    required String prayerName,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      gradient: ThemeConstants.getPrayerGradient(prayerName),
      child: child,
    );
  }
  
  /// بطاقة مرفوعة مع ظل قوي
  factory IslamicCard.elevated({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
      margin: margin,
      color: color,
      boxShadow: ThemeConstants.shadowLg,
      child: child,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = ThemeConstants.getCardColor(context);
    
    Widget cardContent = Container(
      width: width,
      height: height,
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
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ThemeConstants.radiusLg,
          ),
          child: cardContent,
        ),
      );
    }
    
    return cardContent;
  }
}

// ==================== زر إسلامي ====================

/// زر التطبيق الأساسي - مرن وقابل للتخصيص
class IslamicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isOutlined;
  final Color? color;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double? iconSize;
  
  const IslamicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isOutlined = false,
    this.color,
    this.gradient,
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
    this.borderRadius,
    this.textStyle,
    this.iconSize,
  });
  
  /// زر أساسي
  factory IslamicButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool isLoading = false,
    LinearGradient? gradient,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      width: width,
      isLoading: isLoading,
      gradient: gradient,
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
  
  /// زر محدود بإطار
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
  
  /// زر بتدرج لوني
  factory IslamicButton.gradient({
    required String text,
    required LinearGradient gradient,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
    bool isLoading = false,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      gradient: gradient,
      width: width,
      isLoading: isLoading,
    );
  }
  
  /// زر صغير مضغوط
  factory IslamicButton.small({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isOutlined = false,
    Color? color,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isOutlined: isOutlined,
      color: color,
      height: ThemeConstants.buttonHeightSm,
      textStyle: AppTypography.caption.semiBold,
      iconSize: ThemeConstants.iconSm,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? 
        (isSecondary ? ThemeConstants.secondary : ThemeConstants.primary);
    
    final effectiveOnPressed = isLoading ? null : onPressed;
    final effectiveHeight = height ?? ThemeConstants.buttonHeightMd;
    final effectiveTextStyle = textStyle ?? AppTypography.button;
    final effectiveIconSize = iconSize ?? ThemeConstants.iconSm;
    
    Widget buttonChild = isLoading 
        ? SizedBox(
            width: effectiveIconSize,
            height: effectiveIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutlined ? buttonColor : Colors.white,
            ),
          )
        : Text(text, style: effectiveTextStyle);
    
    if (icon != null && !isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: effectiveIconSize),
          const SizedBox(width: ThemeConstants.spaceSm),
          Text(text, style: effectiveTextStyle),
        ],
      );
    }
    
    // إذا كان هناك تدرج لوني، استخدم Container مخصص
    if (gradient != null && !isOutlined) {
      return Container(
        width: width,
        height: effectiveHeight,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ThemeConstants.radiusMd,
          ),
          boxShadow: ThemeConstants.shadowSm,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: effectiveOnPressed,
            borderRadius: BorderRadius.circular(
              borderRadius ?? ThemeConstants.radiusMd,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: padding ?? const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spaceMd,
              ),
              child: buttonChild,
            ),
          ),
        ),
      );
    }
    
    // الأزرار العادية
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor, width: 2),
            minimumSize: Size(width ?? 0, effectiveHeight),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? ThemeConstants.radiusMd,
              ),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            minimumSize: Size(width ?? 0, effectiveHeight),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? ThemeConstants.radiusMd,
              ),
            ),
            elevation: 2,
          );
    
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

/// نص متخصص للمحتوى الإسلامي
class IslamicText extends StatelessWidget {
  final String text;
  final IslamicTextType type;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final EdgeInsetsGeometry? padding;
  
  const IslamicText({
    super.key,
    required this.text,
    required this.type,
    this.textAlign,
    this.color,
    this.fontSize,
    this.maxLines,
    this.overflow,
    this.padding,
  });
  
  /// آية قرآنية
  factory IslamicText.quran({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
    EdgeInsetsGeometry? padding,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.quran,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
      padding: padding,
    );
  }
  
  /// حديث شريف
  factory IslamicText.hadith({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
    EdgeInsetsGeometry? padding,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.hadith,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
      padding: padding,
    );
  }
  
  /// دعاء أو ذكر
  factory IslamicText.dua({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    int? maxLines,
    EdgeInsetsGeometry? padding,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.dua,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      maxLines: maxLines,
      padding: padding,
    );
  }
  
  /// تسبيح
  factory IslamicText.tasbih({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    EdgeInsetsGeometry? padding,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.tasbih,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
      padding: padding,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? ThemeConstants.getTextColor(context);
    
    TextStyle style = switch (type) {
      IslamicTextType.quran => AppTypography.quran,
      IslamicTextType.hadith => AppTypography.hadith,
      IslamicTextType.dua => AppTypography.dua,
      IslamicTextType.tasbih => AppTypography.tasbih,
    };
    
    if (fontSize != null) {
      style = style.copyWith(fontSize: fontSize);
    }
    
    Widget textWidget = Text(
      text,
      style: style.copyWith(color: defaultColor),
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      overflow: overflow,
    );
    
    if (padding != null) {
      textWidget = Padding(
        padding: padding!,
        child: textWidget,
      );
    }
    
    return textWidget;
  }
}

/// أنواع النصوص الإسلامية
enum IslamicTextType { quran, hadith, dua, tasbih }

// ==================== شريط تطبيق إسلامي ====================

/// شريط تطبيق موحد ومتسق
class IslamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final LinearGradient? gradient;
  
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
    this.gradient,
  });
  
  /// شريط تطبيق بتدرج لوني
  factory IslamicAppBar.gradient({
    required String title,
    required LinearGradient gradient,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    PreferredSizeWidget? bottom,
  }) {
    return IslamicAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      bottom: bottom,
      gradient: gradient,
      foregroundColor: Colors.white,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = ThemeConstants.getSurfaceColor(context);
    final defaultForegroundColor = ThemeConstants.getTextColor(context);
    
    final appBar = AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      foregroundColor: foregroundColor ?? defaultForegroundColor,
      elevation: elevation ?? 0,
      bottom: bottom,
      titleTextStyle: AppTypography.title.copyWith(
        color: foregroundColor ?? defaultForegroundColor,
      ),
    );
    
    // إذا كان هناك تدرج لوني
    if (gradient != null) {
      return Container(
        decoration: BoxDecoration(gradient: gradient),
        child: appBar,
      );
    }
    
    return appBar;
  }
  
  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

// ==================== مؤشر التحميل الإسلامي ====================

/// مؤشر تحميل مخصص للتطبيق
class IslamicLoading extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;
  final bool showMessage;
  
  const IslamicLoading({
    super.key,
    this.message,
    this.color,
    this.size,
    this.showMessage = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? ThemeConstants.primary;
    final effectiveSize = size ?? 40.0;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: effectiveSize,
            height: effectiveSize,
            child: CircularProgressIndicator(
              color: effectiveColor,
              strokeWidth: 3,
            ),
          ),
          if (showMessage && message != null) ...[
            Spaces.medium,
            Text(
              message!,
              style: AppTypography.body.copyWith(color: effectiveColor),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== حقل إدخال إسلامي ====================

/// حقل إدخال موحد ومتسق
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
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final Color? fillColor;
  
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
    this.contentPadding,
    this.filled = true,
    this.fillColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultFillColor = fillColor ?? ThemeConstants.getCardColor(context);
    
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
        filled: filled,
        fillColor: defaultFillColor,
        contentPadding: contentPadding ?? const EdgeInsets.all(ThemeConstants.spaceMd),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null 
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: BorderSide(
            color: ThemeConstants.getBorderColor(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: BorderSide(
            color: ThemeConstants.getBorderColor(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: const BorderSide(
            color: ThemeConstants.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: const BorderSide(
            color: ThemeConstants.error,
          ),
        ),
      ),
    );
  }
}

// ==================== مفتاح التبديل الإسلامي ====================

/// مفتاح تبديل مع تسمية اختيارية
class IslamicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool showAsListTile;
  
  const IslamicSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.contentPadding,
    this.showAsListTile = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: (activeColor ?? ThemeConstants.primary).withValues(alpha: 0.3),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return activeColor ?? ThemeConstants.primary;
        }
        return null;
      }),
    );
    
    if (!showAsListTile || (title == null && subtitle == null)) {
      return switchWidget;
    }
    
    return ListTile(
      contentPadding: contentPadding,
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: switchWidget,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}

// ==================== حاوي مع تدرج ====================

/// حاوي بتدرج لوني - مفيد للخلفيات والبطاقات الخاصة
class GradientContainer extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final Border? border;
  
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
    this.border,
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
        border: border,
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius!)
            : null,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

// ==================== عداد مع أيقونة ====================

/// عداد بسيط مع أيقونة وتسمية
class IconCounter extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? iconSize;
  final MainAxisAlignment mainAxisAlignment;
  
  const IconCounter({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    this.iconColor,
    this.textColor,
    this.onTap,
    this.iconSize,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ?? ThemeConstants.getTextColor(context);
    final defaultIconColor = iconColor ?? ThemeConstants.primary;
    final effectiveIconSize = iconSize ?? ThemeConstants.iconLg;
    
    Widget content = Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: defaultIconColor,
          size: effectiveIconSize,
        ),
        Spaces.xs,
        Text(
          count.toString(),
          style: AppTypography.title.copyWith(
            color: defaultTextColor,
            fontWeight: ThemeConstants.fontBold,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: ThemeConstants.getSecondaryTextColor(context),
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

// ==================== شاشة فارغة ====================

/// عرض حالة فارغة مع رسالة وإجراء اختياري
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final Color? iconColor;
  final double? iconSize;
  
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
    this.iconSize,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? 
        ThemeConstants.getSecondaryTextColor(context);
    final effectiveIconSize = iconSize ?? 64.0;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: effectiveIconSize,
              color: effectiveIconColor,
            ),
            Spaces.large,
            Text(
              title,
              style: AppTypography.title.copyWith(
                color: ThemeConstants.getTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              Spaces.small,
              Text(
                subtitle!,
                style: AppTypography.body.copyWith(
                  color: ThemeConstants.getSecondaryTextColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              Spaces.large,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}