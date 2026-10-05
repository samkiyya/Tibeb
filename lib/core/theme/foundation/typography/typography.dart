import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter show TextTheme;
import 'package:google_fonts/google_fonts.dart';

/// Tibeb Design System — Typography Scale
///
/// Uses Inter as the primary UI font (clean, geometric, excellent readability).
/// Merriweather is used only in the reader engine for book content.
abstract final class TibebTypography {
  static flutter.TextTheme get textTheme {
    final interTheme = GoogleFonts.interTextTheme();
    final base = flutter.TextTheme(
      displayLarge: interTheme.displayLarge,
      displayMedium: interTheme.displayMedium,
      displaySmall: interTheme.displaySmall,
      headlineLarge: interTheme.headlineLarge,
      headlineMedium: interTheme.headlineMedium,
      headlineSmall: interTheme.headlineSmall,
      titleLarge: interTheme.titleLarge,
      titleMedium: interTheme.titleMedium,
      titleSmall: interTheme.titleSmall,
      bodyLarge: interTheme.bodyLarge,
      bodyMedium: interTheme.bodyMedium,
      bodySmall: interTheme.bodySmall,
      labelLarge: interTheme.labelLarge,
      labelMedium: interTheme.labelMedium,
      labelSmall: interTheme.labelSmall,
    );
    return base.copyWith(
      // Display — hero numbers, splash screens
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),

      // Headline — section titles, card headers
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),

      // Title — list items, nav bars
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.5,
      ),

      // Body — primary reading, descriptions
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),

      // Label — buttons, badges, chips
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
