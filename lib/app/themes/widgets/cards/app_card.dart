// lib/app/themes/widgets/cards/app_card.dart - الملف الرئيسي المُبسط
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import 'card_types.dart';
import 'card_styles.dart';
import 'card_contents.dart';
import 'card_factory.dart';

// ===== تصدير جميع الملفات المطلوبة =====
export 'card_types.dart';
export 'card_factory.dart';

/// بطاقة موحدة لجميع الاستخدامات - مُبسطة ومُحسنة
class AppCard extends StatefulWidget {
  /// خصائص البطاقة
  final CardProperties properties;

  /// إنشاء بطاقة من خصائص محددة
  const AppCard({
    super.key,
    required this.properties,
  });

  /// إنشاء بطاقة مخصصة
  AppCard.custom({
    super.key,
    CardType type = CardType.normal,
    CardStyle style = CardStyle.normal,
    String? title,
    String? subtitle,
    String? content,
    Widget? child,
    IconData? icon,
    Widget? leading,
    Widget? trailing,
    String? imageUrl,
    Color? primaryColor,
    Color? backgroundColor,
    List<Color>? gradientColors,
    double? elevation,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    List<CardAction>? actions,
    String? badge,
    Color? badgeColor,
    bool isSelected = false,
    bool showShadow = true,
    int? currentCount,
    int? totalCount,
    bool? isFavorite,
    String? source,
    String? fadl,
    VoidCallback? onFavoriteToggle,
    String? value,
    String? unit,
    double? progress,
  }) : properties = CardProperties(
          type: type,
          style: style,
          title: title,
          subtitle: subtitle,
          content: content,
          child: child,
          icon: icon,
          leading: leading,
          trailing: trailing,
          imageUrl: imageUrl,
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
          gradientColors: gradientColors,
          elevation: elevation,
          borderRadius: borderRadius,
          padding: padding,
          margin: margin,
          onTap: onTap,
          onLongPress: onLongPress,
          actions: actions,
          badge: badge,
          badgeColor: badgeColor,
          isSelected: isSelected,
          showShadow: showShadow,
          currentCount: currentCount,
          totalCount: totalCount,
          isFavorite: isFavorite,
          source: source,
          fadl: fadl,
          onFavoriteToggle: onFavoriteToggle,
          value: value,
          unit: unit,
          progress: progress,
        );

  @override
  State<AppCard> createState() => _AppCardState();

  // ===== Factory Constructors السريعة =====

  /// بطاقة بسيطة
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: CardFactory.simple(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        primaryColor: primaryColor,
      ),
    );
  }

  /// بطاقة أذكار
  factory AppCard.athkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? primaryColor,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: CardFactory.athkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        isFavorite: isFavorite,
        primaryColor: primaryColor,
        onTap: onTap,
        onFavoriteToggle: onFavoriteToggle,
        actions: actions,
      ),
    );
  }

  /// بطاقة اقتباس
  factory AppCard.quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
  }) {
    return AppCard(
      properties: CardFactory.quote(
        quote: quote,
        author: author,
        category: category,
        primaryColor: primaryColor,
        gradientColors: gradientColors,
      ),
    );
  }

  /// بطاقة إكمال
  factory AppCard.completion({
    required String title,
    required String message,
    String? subMessage,
    IconData icon = Icons.check_circle_outline,
    Color? primaryColor,
    List<CardAction> actions = const [],
  }) {
    return AppCard(
      properties: CardFactory.completion(
        title: title,
        message: message,
        subMessage: subMessage,
        icon: icon,
        primaryColor: primaryColor,
        actions: actions,
      ),
    );
  }

  /// بطاقة معلومات
  factory AppCard.info({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return AppCard(
      properties: CardFactory.info(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        iconColor: iconColor,
        trailing: trailing,
      ),
    );
  }

  /// بطاقة إحصائيات
  factory AppCard.stat({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
    double? progress,
  }) {
    return AppCard(
      properties: CardFactory.stat(
        title: title,
        value: value,
        icon: icon,
        color: color,
        onTap: onTap,
        progress: progress,
      ),
    );
  }

  /// بطاقة ترحيب زجاجية
  factory AppCard.glassWelcome({
    required String title,
    String? subtitle,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      properties: CardFactory.glassWelcome(
        title: title,
        subtitle: subtitle,
        primaryColor: primaryColor,
        onTap: onTap,
        margin: margin,
        padding: padding,
      ),
    );
  }

  /// بطاقة فئة زجاجية
  factory AppCard.glassCategory({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      properties: CardFactory.glassCategory(
        title: title,
        icon: icon,
        primaryColor: primaryColor,
        onTap: onTap,
        margin: margin,
        padding: padding,
      ),
    );
  }

  // ===== Factory Constructors للأذكار المتخصصة =====

  /// ذكر الصباح
  factory AppCard.morningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: AthkarCardFactory.morningAthkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        onTap: onTap,
        actions: actions,
      ),
    );
  }

  /// ذكر المساء
  factory AppCard.eveningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: AthkarCardFactory.eveningAthkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        onTap: onTap,
        actions: actions,
      ),
    );
  }

  /// ذكر النوم
  factory AppCard.sleepAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: AthkarCardFactory.sleepAthkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        onTap: onTap,
        actions: actions,
      ),
    );
  }

  // ===== Factory Constructors للاقتباسات المتخصصة =====

  /// آية قرآنية
  factory AppCard.verse({
    required String verse,
    String? surah,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: QuoteCardFactory.verse(
        verse: verse,
        surah: surah,
        primaryColor: primaryColor,
      ),
    );
  }

  /// حديث نبوي
  factory AppCard.hadith({
    required String hadith,
    String? narrator,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: QuoteCardFactory.hadith(
        hadith: hadith,
        narrator: narrator,
        primaryColor: primaryColor,
      ),
    );
  }

  /// دعاء مأثور
  factory AppCard.dua({
    required String dua,
    String? source,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: QuoteCardFactory.dua(
        dua: dua,
        source: source,
        primaryColor: primaryColor,
      ),
    );
  }

  // ===== Factory Constructors للبطاقات المتخصصة =====

  /// بطاقة إنجاز
  factory AppCard.achievement({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onShare,
    required VoidCallback onRestart,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: SpecializedCardFactory.achievement(
        title: title,
        description: description,
        icon: icon,
        onShare: onShare,
        onRestart: onRestart,
        primaryColor: primaryColor,
      ),
    );
  }

  /// بطاقة إحصائية للتقدم
  factory AppCard.progressStat({
    required String title,
    required int completed,
    required int total,
    required IconData icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: SpecializedCardFactory.progressStat(
        title: title,
        completed: completed,
        total: total,
        icon: icon,
        onTap: onTap,
        primaryColor: primaryColor,
      ),
    );
  }

  /// بطاقة تفاعلية مع عداد
  factory AppCard.interactiveCounter({
    required String title,
    required String content,
    required int currentCount,
    required int targetCount,
    required VoidCallback onIncrement,
    required VoidCallback onReset,
    Color? primaryColor,
    String? source,
  }) {
    return AppCard(
      properties: InteractiveCardFactory.interactiveCounter(
        title: title,
        content: content,
        currentCount: currentCount,
        targetCount: targetCount,
        onIncrement: onIncrement,
        onReset: onReset,
        primaryColor: primaryColor,
        source: source,
      ),
    );
  }
}

/// حالة البطاقة الرئيسية
class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.properties.margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: _buildCard(),
    );
  }

  /// بناء البطاقة
  Widget _buildCard() {
    // التحقق من صحة البطاقة
    if (!widget.properties.isValid) {
      return CardContentBuilder.buildFallbackContent(
        context, 
        'بيانات البطاقة غير صحيحة',
      );
    }

    // بناء المحتوى
    final content = CardContentBuilder.buildContent(
      properties: widget.properties,
      context: context,
    );

    // تطبيق النمط
    return CardStyleBuilder.buildStyled(
      properties: widget.properties,
      content: content,
      context: context,
    );
  }
}