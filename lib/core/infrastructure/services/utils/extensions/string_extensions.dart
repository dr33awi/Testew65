// lib/core/utils/extensions/string_extensions.dart

extension StringExtensions on String {
  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;
  
  /// Check if string is not null or empty
  bool get isNotNullOrEmpty => isNotEmpty;
  
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Remove all whitespace
  String get removeAllWhitespace => replaceAll(RegExp(r'\s+'), '');
  
  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }
  
  /// Check if string is a valid phone number
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s-()]+$');
    return phoneRegex.hasMatch(this) && length >= 10;
  }
  
  /// Check if string contains only numbers
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);
  
  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  
  /// Check if string contains only letters and numbers
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  
  /// Convert string to int safely
  int? toIntOrNull() => int.tryParse(this);
  
  /// Convert string to double safely
  double? toDoubleOrNull() => double.tryParse(this);
  
  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  /// Remove diacritics from Arabic text
  String get removeArabicDiacritics {
    return replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  }
  
  /// Check if string contains Arabic text
  bool get containsArabic {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(this);
  }
  
  /// Reverse string (useful for RTL languages)
  String get reversed {
    return split('').reversed.join('');
  }
  
  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }
  
  /// Convert to camelCase
  String get toCamelCase {
    final words = split(RegExp(r'[_\s-]'));
    if (words.isEmpty) return this;
    
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join('');
  }
}