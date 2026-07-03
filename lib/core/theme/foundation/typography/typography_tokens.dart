import 'package:flutter/material.dart';
import '../color/color_tokens.dart';

// ==========================================
// 2. TibebTypographyTokens
// ==========================================
class TibebTypographyTokens {
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle caption;
  final TextStyle quote;
  final TextStyle code;
  final TextStyle footnote;
  final TextStyle readerText;
  final TextStyle readerHeading;
  final TextStyle readerChapter;
  final TextStyle readerPageNumber;
  final TextStyle annotationText;
  final TextStyle dictionaryEntry;

  const TibebTypographyTokens({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.caption,
    required this.quote,
    required this.code,
    required this.footnote,
    required this.readerText,
    required this.readerHeading,
    required this.readerChapter,
    required this.readerPageNumber,
    required this.annotationText,
    required this.dictionaryEntry,
  });

  static TibebTypographyTokens create(TibebColorSystem colorSystem) {
    const baseStyle = TextStyle(fontFamily: 'Inter');
    return TibebTypographyTokens(
      displayLarge: baseStyle.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      displayMedium: baseStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      displaySmall: baseStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      headlineLarge: baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      headlineMedium: baseStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      headlineSmall: baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      titleLarge: baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colorSystem.textPrimary,
      ),
      titleMedium: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorSystem.textPrimary,
      ),
      titleSmall: baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorSystem.textPrimary,
      ),
      bodyLarge: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorSystem.textPrimary,
      ),
      bodyMedium: baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorSystem.textSecondary,
      ),
      bodySmall: baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorSystem.textTertiary,
      ),
      labelLarge: baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorSystem.textPrimary,
      ),
      labelMedium: baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorSystem.textSecondary,
      ),
      labelSmall: baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorSystem.textTertiary,
      ),
      caption: baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: colorSystem.textTertiary,
      ),
      quote: baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: colorSystem.primary,
      ),
      code: const TextStyle(
        fontFamily: 'Courier',
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      footnote: baseStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: colorSystem.textTertiary,
      ),
      readerText: const TextStyle(fontSize: 18, height: 1.6),
      readerHeading: baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colorSystem.textPrimary,
      ),
      readerChapter: baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorSystem.textSecondary,
      ),
      readerPageNumber: baseStyle.copyWith(
        fontSize: 12,
        color: colorSystem.textTertiary,
      ),
      annotationText: baseStyle.copyWith(
        fontSize: 13,
        color: colorSystem.textSecondary,
      ),
      dictionaryEntry: baseStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  TibebTypographyTokens lerp(TibebTypographyTokens? other, double t) {
    if (other == null) return this;
    return TibebTypographyTokens(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      quote: TextStyle.lerp(quote, other.quote, t)!,
      code: TextStyle.lerp(code, other.code, t)!,
      footnote: TextStyle.lerp(footnote, other.footnote, t)!,
      readerText: TextStyle.lerp(readerText, other.readerText, t)!,
      readerHeading: TextStyle.lerp(readerHeading, other.readerHeading, t)!,
      readerChapter: TextStyle.lerp(readerChapter, other.readerChapter, t)!,
      readerPageNumber: TextStyle.lerp(
        readerPageNumber,
        other.readerPageNumber,
        t,
      )!,
      annotationText: TextStyle.lerp(annotationText, other.annotationText, t)!,
      dictionaryEntry: TextStyle.lerp(
        dictionaryEntry,
        other.dictionaryEntry,
        t,
      )!,
    );
  }
}
