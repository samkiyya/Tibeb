import 'package:flutter/material.dart';
import '../tokens/colors.dart';

// ==========================================
// 1. TibebColorSystem (Foundation Color System)
// ==========================================
class TibebColorSystem {
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color secondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color background;
  final Color surface;
  final Color surfaceBright;
  final Color surfaceDim;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color error;
  final Color errorContainer;
  final Color outline;
  final Color outlineVariant;
  final Color inverseSurface;
  final Color inversePrimary;
  final Color shadow;
  final Color scrim;
  final Color transparent;
  final Color success;
  final Color warning;
  final Color info;
  final Color danger;
  final Color disabled;
  final Color placeholder;
  final Color divider;
  final Color overlay;

  const TibebColorSystem({
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.background,
    required this.surface,
    required this.surfaceBright,
    required this.surfaceDim,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.error,
    required this.errorContainer,
    required this.outline,
    required this.outlineVariant,
    required this.inverseSurface,
    required this.inversePrimary,
    required this.shadow,
    required this.scrim,
    required this.transparent,
    required this.success,
    required this.warning,
    required this.info,
    required this.danger,
    required this.disabled,
    required this.placeholder,
    required this.divider,
    required this.overlay,
  });

  static TibebColorSystem dark() {
    return TibebColorSystem(
      primary: TibebPalette.wisdom,
      primaryContainer: TibebPalette.wisdomDark,
      secondary: TibebPalette.blue,
      secondaryContainer: TibebPalette.blueDark,
      tertiary: Colors.tealAccent,
      tertiaryContainer: Colors.teal,
      background: TibebPalette.ink,
      surface: TibebPalette.charcoal,
      surfaceBright: TibebPalette.graphite,
      surfaceDim: TibebPalette.charcoal,
      surfaceContainerLowest: Colors.black,
      surfaceContainerLow: TibebPalette.ink,
      surfaceContainer: TibebPalette.charcoal,
      surfaceContainerHigh: TibebPalette.graphite,
      surfaceContainerHighest: TibebPalette.slate,
      error: TibebPalette.error,
      errorContainer: TibebPalette.error.withValues(alpha: 0.2),
      outline: TibebPalette.slate,
      outlineVariant: TibebPalette.charcoal,
      inverseSurface: Colors.white,
      inversePrimary: TibebPalette.wisdomDark,
      shadow: Colors.black54,
      scrim: Colors.black87,
      transparent: Colors.transparent,
      success: TibebPalette.success,
      warning: TibebPalette.warning,
      info: TibebPalette.blue,
      danger: TibebPalette.error,
      disabled: TibebPalette.steel.withValues(alpha: 0.5),
      placeholder: TibebPalette.ash.withValues(alpha: 0.3),
      divider: TibebPalette.slate.withValues(alpha: 0.5),
      overlay: Colors.black38,
    );
  }

  static TibebColorSystem light() {
    return TibebColorSystem(
      primary: TibebPalette.wisdomDark,
      primaryContainer: TibebPalette.wisdom,
      secondary: TibebPalette.blueDark,
      secondaryContainer: TibebPalette.blue,
      tertiary: Colors.teal,
      tertiaryContainer: Colors.teal.shade100,
      background: TibebPalette.lightBackground,
      surface: TibebPalette.lightSurface,
      surfaceBright: Colors.white,
      surfaceDim: const Color(0xFFF1F5F9),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF8FAFC),
      surfaceContainer: const Color(0xFFF1F5F9),
      surfaceContainerHigh: const Color(0xFFE2E8F0),
      surfaceContainerHighest: const Color(0xFFCBD5E1),
      error: const Color(0xFFDC2626),
      errorContainer: const Color(0xFFFEE2E2),
      outline: const Color(0xFFCBD5E1),
      outlineVariant: const Color(0xFFE2E8F0),
      inverseSurface: TibebPalette.ink,
      inversePrimary: TibebPalette.wisdom,
      shadow: const Color(0x1F000000),
      scrim: const Color(0x66000000),
      transparent: Colors.transparent,
      success: const Color(0xFF16A34A),
      warning: const Color(0xFFD97706),
      info: const Color(0xFF2563EB),
      danger: const Color(0xFFDC2626),
      disabled: const Color(0xFF94A3B8),
      placeholder: const Color(0xFFCBD5E1),
      divider: const Color(0xFFE2E8F0),
      overlay: const Color(0x33000000),
    );
  }

  TibebColorSystem lerp(TibebColorSystem? other, double t) {
    if (other == null) return this;
    return TibebColorSystem(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer: Color.lerp(
        tertiaryContainer,
        other.tertiaryContainer,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      transparent: other.transparent,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

extension ColorProperties on TibebColorSystem {
  Color get textPrimary => primary == TibebPalette.wisdom
      ? TibebPalette.paper
      : TibebPalette.lightTextPrimary;
  Color get textSecondary => primary == TibebPalette.wisdom
      ? TibebPalette.ash
      : TibebPalette.lightTextSecondary;
  Color get textTertiary =>
      primary == TibebPalette.wisdom ? TibebPalette.steel : TibebPalette.ash;
}

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

// ==========================================
// 3. TibebSpacingTokens
// ==========================================
class TibebSpacingTokens {
  final double s0;
  final double s2;
  final double s4;
  final double s6;
  final double s8;
  final double s10;
  final double s12;
  final double s16;
  final double s20;
  final double s24;
  final double s28;
  final double s32;
  final double s40;
  final double s48;
  final double s56;
  final double s64;
  final double s80;
  final double s96;

  const TibebSpacingTokens({
    this.s0 = 0.0,
    this.s2 = 2.0,
    this.s4 = 4.0,
    this.s6 = 6.0,
    this.s8 = 8.0,
    this.s10 = 10.0,
    this.s12 = 12.0,
    this.s16 = 16.0,
    this.s20 = 20.0,
    this.s24 = 24.0,
    this.s28 = 28.0,
    this.s32 = 32.0,
    this.s40 = 40.0,
    this.s48 = 48.0,
    this.s56 = 56.0,
    this.s64 = 64.0,
    this.s80 = 80.0,
    this.s96 = 96.0,
  });

  static const defaultInstance = TibebSpacingTokens();

  TibebSpacingTokens lerp(TibebSpacingTokens? other, double t) {
    return this;
  }
}

// ==========================================
// 4. TibebRadiusTokens
// ==========================================
class TibebRadiusTokens {
  final BorderRadius none;
  final BorderRadius xs;
  final BorderRadius sm;
  final BorderRadius md;
  final BorderRadius lg;
  final BorderRadius xl;
  final BorderRadius xxl;
  final BorderRadius pill;
  final BorderRadius circle;

  const TibebRadiusTokens({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.pill,
    required this.circle,
  });

  static TibebRadiusTokens create() {
    return TibebRadiusTokens(
      none: BorderRadius.zero,
      xs: BorderRadius.circular(4.0),
      sm: BorderRadius.circular(8.0),
      md: BorderRadius.circular(12.0),
      lg: BorderRadius.circular(16.0),
      xl: BorderRadius.circular(20.0),
      xxl: BorderRadius.circular(24.0),
      pill: BorderRadius.circular(999.0),
      circle: BorderRadius.circular(9999.0),
    );
  }

  TibebRadiusTokens lerp(TibebRadiusTokens? other, double t) {
    if (other == null) return this;
    return TibebRadiusTokens(
      none: BorderRadius.lerp(none, other.none, t)!,
      xs: BorderRadius.lerp(xs, other.xs, t)!,
      sm: BorderRadius.lerp(sm, other.sm, t)!,
      md: BorderRadius.lerp(md, other.md, t)!,
      lg: BorderRadius.lerp(lg, other.lg, t)!,
      xl: BorderRadius.lerp(xl, other.xl, t)!,
      xxl: BorderRadius.lerp(xxl, other.xxl, t)!,
      pill: BorderRadius.lerp(pill, other.pill, t)!,
      circle: BorderRadius.lerp(circle, other.circle, t)!,
    );
  }
}

// ==========================================
// 5. TibebElevationTokens
// ==========================================
class TibebElevationTokens {
  final List<BoxShadow> level0;
  final List<BoxShadow> level1;
  final List<BoxShadow> level2;
  final List<BoxShadow> level3;
  final List<BoxShadow> level4;
  final List<BoxShadow> level5;

  const TibebElevationTokens({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static TibebElevationTokens dark() {
    return const TibebElevationTokens(
      level0: [],
      level1: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 3),
      ],
      level2: [
        BoxShadow(color: Colors.black38, offset: Offset(0, 2), blurRadius: 6),
      ],
      level3: [
        BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 10),
      ],
      level4: [
        BoxShadow(color: Colors.black54, offset: Offset(0, 8), blurRadius: 16),
      ],
      level5: [
        BoxShadow(color: Colors.black54, offset: Offset(0, 12), blurRadius: 24),
      ],
    );
  }

  static TibebElevationTokens light() {
    return const TibebElevationTokens(
      level0: [],
      level1: [
        BoxShadow(
          color: Color(0x1F000000),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
      level2: [
        BoxShadow(
          color: Color(0x24000000),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
      level3: [
        BoxShadow(
          color: Color(0x29000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      level4: [
        BoxShadow(
          color: Color(0x2E000000),
          offset: Offset(0, 8),
          blurRadius: 16,
        ),
      ],
      level5: [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 12),
          blurRadius: 24,
        ),
      ],
    );
  }

  TibebElevationTokens lerp(TibebElevationTokens? other, double t) {
    return this;
  }
}

// ==========================================
// 6. TibebBorderTokens
// ==========================================
class TibebBorderTokens {
  final BorderSide thin;
  final BorderSide normal;
  final BorderSide thick;
  final BorderSide focused;
  final BorderSide selected;
  final BorderSide disabled;
  final BorderSide error;

  const TibebBorderTokens({
    required this.thin,
    required this.normal,
    required this.thick,
    required this.focused,
    required this.selected,
    required this.disabled,
    required this.error,
  });

  static TibebBorderTokens dark(
    Color primary,
    Color targetError,
    Color outlineCol,
    Color disabledCol,
  ) {
    return TibebBorderTokens(
      thin: BorderSide(color: outlineCol, width: 0.5),
      normal: BorderSide(color: outlineCol, width: 1.0),
      thick: BorderSide(color: outlineCol, width: 2.0),
      focused: BorderSide(color: primary, width: 2.0),
      selected: BorderSide(color: primary, width: 1.5),
      disabled: BorderSide(color: disabledCol, width: 1.0),
      error: BorderSide(color: targetError, width: 1.5),
    );
  }

  static TibebBorderTokens light(
    Color primary,
    Color targetError,
    Color outlineCol,
    Color disabledCol,
  ) {
    return TibebBorderTokens(
      thin: BorderSide(color: outlineCol, width: 0.5),
      normal: BorderSide(color: outlineCol, width: 1.0),
      thick: BorderSide(color: outlineCol, width: 2.0),
      focused: BorderSide(color: primary, width: 2.0),
      selected: BorderSide(color: primary, width: 1.5),
      disabled: BorderSide(color: disabledCol, width: 1.0),
      error: BorderSide(color: targetError, width: 1.5),
    );
  }

  TibebBorderTokens lerp(TibebBorderTokens? other, double t) {
    if (other == null) return this;
    return TibebBorderTokens(
      thin: BorderSide.lerp(thin, other.thin, t),
      normal: BorderSide.lerp(normal, other.normal, t),
      thick: BorderSide.lerp(thick, other.thick, t),
      focused: BorderSide.lerp(focused, other.focused, t),
      selected: BorderSide.lerp(selected, other.selected, t),
      disabled: BorderSide.lerp(disabled, other.disabled, t),
      error: BorderSide.lerp(error, other.error, t),
    );
  }
}

// ==========================================
// 7. TibebIconThemeTokens
// ==========================================
class TibebIconThemeTokens {
  final double sizeXs;
  final double sizeSmall;
  final double sizeMedium;
  final double sizeLarge;
  final Color primary;
  final Color secondary;
  final Color disabled;
  final Color selected;
  final Color danger;
  final Color success;

  const TibebIconThemeTokens({
    this.sizeXs = 16.0,
    this.sizeSmall = 20.0,
    this.sizeMedium = 24.0,
    this.sizeLarge = 32.0,
    required this.primary,
    required this.secondary,
    required this.disabled,
    required this.selected,
    required this.danger,
    required this.success,
  });

  static TibebIconThemeTokens dark(
    Color primaryCol,
    Color secondaryCol,
    Color disabledCol,
    Color selectCol,
    Color errorCol,
    Color successCol,
  ) {
    return TibebIconThemeTokens(
      primary: primaryCol,
      secondary: secondaryCol,
      disabled: disabledCol,
      selected: selectCol,
      danger: errorCol,
      success: successCol,
    );
  }

  static TibebIconThemeTokens light(
    Color primaryCol,
    Color secondaryCol,
    Color disabledCol,
    Color selectCol,
    Color errorCol,
    Color successCol,
  ) {
    return TibebIconThemeTokens(
      primary: primaryCol,
      secondary: secondaryCol,
      disabled: disabledCol,
      selected: selectCol,
      danger: errorCol,
      success: successCol,
    );
  }

  TibebIconThemeTokens lerp(TibebIconThemeTokens? other, double t) {
    if (other == null) return this;
    return TibebIconThemeTokens(
      sizeXs: sizeXs,
      sizeSmall: sizeSmall,
      sizeMedium: sizeMedium,
      sizeLarge: sizeLarge,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}
