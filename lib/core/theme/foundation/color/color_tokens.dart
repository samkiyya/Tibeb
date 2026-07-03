import 'package:flutter/material.dart';
import 'colors.dart';

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
