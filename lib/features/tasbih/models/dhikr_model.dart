// lib/features/tasbih/models/dhikr_model.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

/// نموذج بيانات الذكر
class DhikrItem {
  final String id;
  final String text;
  final String? translation;
  final String? virtue; // الفضل
  final int recommendedCount;
  final DhikrCategory category;
  final List<Color> gradient;
  final Color primaryColor;
  final bool isCustom;

  const DhikrItem({
    required this.id,
    required this.text,
    this.translation,
    this.virtue,
    required this.recommendedCount,
    required this.category,
    required this.gradient,
    required this.primaryColor,
    this.isCustom = false,
  });

  factory DhikrItem.fromMap(Map<String, dynamic> map) {
    return DhikrItem(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      translation: map['translation'],
      virtue: map['virtue'],
      recommendedCount: map['recommendedCount'] ?? 33,
      category: DhikrCategory.values.firstWhere(
        (cat) => cat.name == map['category'],
        orElse: () => DhikrCategory.tasbih,
      ),
      gradient: _parseGradient(map['gradient']),
      primaryColor: Color(map['primaryColor'] ?? 0xFF4CAF50),
      isCustom: map['isCustom'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'translation': translation,
      'virtue': virtue,
      'recommendedCount': recommendedCount,
      'category': category.name,
      'gradient': gradient.map((c) => c.value).toList(),
      'primaryColor': primaryColor.value,
      'isCustom': isCustom,
    };
  }

  static List<Color> _parseGradient(dynamic gradientData) {
    if (gradientData is List) {
      return gradientData.map((color) => Color(color as int)).toList();
    }
    return [ThemeConstants.primary, ThemeConstants.primaryLight];
  }

  DhikrItem copyWith({
    String? id,
    String? text,
    String? translation,
    String? virtue,
    int? recommendedCount,
    DhikrCategory? category,
    List<Color>? gradient,
    Color? primaryColor,
    bool? isCustom,
  }) {
    return DhikrItem(
      id: id ?? this.id,
      text: text ?? this.text,
      translation: translation ?? this.translation,
      virtue: virtue ?? this.virtue,
      recommendedCount: recommendedCount ?? this.recommendedCount,
      category: category ?? this.category,
      gradient: gradient ?? this.gradient,
      primaryColor: primaryColor ?? this.primaryColor,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

/// تصنيفات الأذكار
enum DhikrCategory {
  tasbih('التسبيح', Icons.radio_button_checked),
  tahmid('التحميد', Icons.favorite),
  takbir('التكبير', Icons.star),
  tahlil('التهليل', Icons.brightness_high),
  istighfar('الاستغفار', Icons.healing),
  salawat('الصلاة على النبي', Icons.mosque),
  dua('الدعاء', Icons.pan_tool),
  quran('القرآن الكريم', Icons.menu_book),
  general('عام', Icons.circle),
  custom('مخصص', Icons.edit);

  const DhikrCategory(this.title, this.icon);
  
  final String title;
  final IconData icon;
}

/// مجموعة الأذكار الافتراضية
class DefaultAdhkar {
  static List<DhikrItem> getAll() {
    return [
      // التسبيح
      DhikrItem(
        id: 'subhan_allah',
        text: 'سُبْحَانَ اللهِ',
        translation: 'Glory be to Allah',
        virtue: 'من قال سبحان الله مائة مرة حطت خطاياه وإن كانت مثل زبد البحر',
        recommendedCount: 33,
        category: DhikrCategory.tasbih,
        gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
        primaryColor: ThemeConstants.primary,
      ),
      
      DhikrItem(
        id: 'subhan_allah_wa_bihamdihi',
        text: 'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
        translation: 'Glory be to Allah and praise be to Him',
        virtue: 'من قال سبحان الله وبحمده في يوم مائة مرة حطت خطاياه',
        recommendedCount: 100,
        category: DhikrCategory.tasbih,
        gradient: [ThemeConstants.primary.lighten(0.1), ThemeConstants.primary],
        primaryColor: ThemeConstants.primary,
      ),
      
      DhikrItem(
        id: 'subhan_allah_azeem',
        text: 'سُبْحَانَ اللهِ الْعَظِيمِ',
        translation: 'Glory be to Allah, the Great',
        virtue: 'كلمة خفيفة على اللسان ثقيلة في الميزان حبيبة إلى الرحمن',
        recommendedCount: 33,
        category: DhikrCategory.tasbih,
        gradient: [ThemeConstants.primary.darken(0.1), ThemeConstants.primary],
        primaryColor: ThemeConstants.primary,
      ),

      // التحميد
      DhikrItem(
        id: 'alhamdulillah',
        text: 'الْحَمْدُ لِلّهِ',
        translation: 'Praise be to Allah',
        virtue: 'الحمد لله تملأ الميزان',
        recommendedCount: 33,
        category: DhikrCategory.tahmid,
        gradient: [ThemeConstants.accent, ThemeConstants.accentLight],
        primaryColor: ThemeConstants.accent,
      ),
      
      DhikrItem(
        id: 'alhamdulillah_rabbil_alameen',
        text: 'الْحَمْدُ لِلّهِ رَبِّ الْعَالَمِينَ',
        translation: 'Praise be to Allah, Lord of the worlds',
        virtue: 'فاتحة الكتاب وأم القرآن',
        recommendedCount: 25,
        category: DhikrCategory.tahmid,
        gradient: [ThemeConstants.accent.lighten(0.1), ThemeConstants.accent],
        primaryColor: ThemeConstants.accent,
      ),

      // التكبير
      DhikrItem(
        id: 'allahu_akbar',
        text: 'اللهُ أَكْبَرُ',
        translation: 'Allah is the Greatest',
        virtue: 'التكبير يملأ ما بين السماء والأرض',
        recommendedCount: 34,
        category: DhikrCategory.takbir,
        gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
        primaryColor: ThemeConstants.tertiary,
      ),
      
      DhikrItem(
        id: 'allahu_akbar_kabiran',
        text: 'اللهُ أَكْبَرُ كَبِيرًا',
        translation: 'Allah is the Greatest, greatly',
        virtue: 'من التكبيرات المستحبة في الصلاة',
        recommendedCount: 10,
        category: DhikrCategory.takbir,
        gradient: [ThemeConstants.tertiary.lighten(0.1), ThemeConstants.tertiary],
        primaryColor: ThemeConstants.tertiary,
      ),

      // التهليل
      DhikrItem(
        id: 'la_ilaha_illa_allah',
        text: 'لاَ إِلَهَ إِلاَّ اللهُ',
        translation: 'There is no god but Allah',
        virtue: 'أفضل الذكر لا إله إلا الله',
        recommendedCount: 100,
        category: DhikrCategory.tahlil,
        gradient: [ThemeConstants.success, ThemeConstants.success.lighten(0.2)],
        primaryColor: ThemeConstants.success,
      ),
      
      DhikrItem(
        id: 'la_ilaha_illa_allah_wahdahu',
        text: 'لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ',
        translation: 'There is no god but Allah alone, with no partner',
        virtue: 'من قالها عشر مرات كان كمن أعتق أربعة أنفس من ولد إسماعيل',
        recommendedCount: 10,
        category: DhikrCategory.tahlil,
        gradient: [ThemeConstants.success.darken(0.1), ThemeConstants.success],
        primaryColor: ThemeConstants.success,
      ),

      // الاستغفار
      DhikrItem(
        id: 'astaghfirullah',
        text: 'أَسْتَغْفِرُ اللهَ',
        translation: 'I seek forgiveness from Allah',
        virtue: 'الاستغفار يمحو الذنوب ويجلب الرزق',
        recommendedCount: 100,
        category: DhikrCategory.istighfar,
        gradient: [ThemeConstants.primaryDark, ThemeConstants.primary],
        primaryColor: ThemeConstants.primaryDark,
      ),
      
      DhikrItem(
        id: 'astaghfirullah_azeem',
        text: 'أَسْتَغْفِرُ اللهَ الْعَظِيمَ',
        translation: 'I seek forgiveness from Allah, the Great',
        virtue: 'من قالها ثلاثاً غفر له وإن كان فارّاً من الزحف',
        recommendedCount: 3,
        category: DhikrCategory.istighfar,
        gradient: [ThemeConstants.primaryDark.lighten(0.1), ThemeConstants.primaryDark],
        primaryColor: ThemeConstants.primaryDark,
      ),

      // الصلاة على النبي
      DhikrItem(
        id: 'salallahu_alayhi_wasallam',
        text: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
        translation: 'O Allah, send prayers and peace upon our Prophet Muhammad',
        virtue: 'من صلى علي صلاة صلى الله عليه بها عشراً',
        recommendedCount: 10,
        category: DhikrCategory.salawat,
        gradient: [ThemeConstants.accentDark, ThemeConstants.accent],
        primaryColor: ThemeConstants.accentDark,
      ),

      // دعاء
      DhikrItem(
        id: 'rabbana_atina',
        text: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        translation: 'Our Lord, give us good in this world and good in the next world, and save us from the punishment of the Fire',
        virtue: 'دعاء جامع لخير الدنيا والآخرة',
        recommendedCount: 7,
        category: DhikrCategory.dua,
        gradient: [ThemeConstants.tertiaryDark, ThemeConstants.tertiary],
        primaryColor: ThemeConstants.tertiaryDark,
      ),

      // القرآن الكريم
      DhikrItem(
        id: 'qul_huwa_allah_ahad',
        text: 'قُلْ هُوَ اللَّهُ أَحَدٌ * اللَّهُ الصَّمَدُ * لَمْ يَلِدْ وَلَمْ يُولَدْ * وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        translation: 'Say: He is Allah, the One! Allah, the Eternal, Absolute; He begets not, nor is He begotten; And there is none like unto Him.',
        virtue: 'تعدل ثلث القرآن',
        recommendedCount: 3,
        category: DhikrCategory.quran,
        gradient: [ThemeConstants.info, ThemeConstants.info.lighten(0.2)],
        primaryColor: ThemeConstants.info,
      ),

      // عام
      DhikrItem(
        id: 'hasbi_allah',
        text: 'حَسْبِيَ اللهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
        translation: 'Allah is sufficient for me; there is no god but He. In Him I put my trust, and He is the Lord of the Great Throne',
        virtue: 'من قالها سبع مرات كفاه الله ما أهمه',
        recommendedCount: 7,
        category: DhikrCategory.general,
        gradient: [ThemeConstants.warning, ThemeConstants.warning.lighten(0.2)],
        primaryColor: ThemeConstants.warning,
      ),
    ];
  }

  static List<DhikrItem> getByCategory(DhikrCategory category) {
    return getAll().where((dhikr) => dhikr.category == category).toList();
  }

  static List<DhikrItem> getPopular() {
    return [
      getAll().firstWhere((d) => d.id == 'subhan_allah'),
      getAll().firstWhere((d) => d.id == 'alhamdulillah'),
      getAll().firstWhere((d) => d.id == 'allahu_akbar'),
      getAll().firstWhere((d) => d.id == 'la_ilaha_illa_allah'),
      getAll().firstWhere((d) => d.id == 'astaghfirullah'),
    ];
  }
}