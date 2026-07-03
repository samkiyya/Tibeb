import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebButtonStateStyles {
  final Color background;
  final Color foreground;
  final Color disabled;
  final Color pressed;
  final Color hovered;
  final Color focused;
  final BorderSide? border;
  final double elevation;
  final BorderRadius radius;
  final EdgeInsets padding;

  const TibebButtonStateStyles({
    required this.background,
    required this.foreground,
    required this.disabled,
    required this.pressed,
    required this.hovered,
    required this.focused,
    this.border,
    required this.elevation,
    required this.radius,
    required this.padding,
  });

  static TibebButtonStateStyles createDefault(
    Color bg,
    Color fg,
    Color dis,
    BorderRadius rad,
  ) {
    return TibebButtonStateStyles(
      background: bg,
      foreground: fg,
      disabled: dis,
      pressed: bg.withValues(alpha: 0.8),
      hovered: bg.withValues(alpha: 0.9),
      focused: bg,
      elevation: 0.0,
      radius: rad,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class TibebButtonsThemeTokens {
  final TibebButtonStateStyles filled;
  final TibebButtonStateStyles outlined;
  final TibebButtonStateStyles text;
  final TibebButtonStateStyles elevated;
  final TibebButtonStateStyles icon;
  final TibebButtonStateStyles fab;
  final TibebButtonStateStyles segmented;
  final TibebButtonStateStyles toggle;
  final TibebButtonStateStyles readerFloating;

  const TibebButtonsThemeTokens({
    required this.filled,
    required this.outlined,
    required this.text,
    required this.elevated,
    required this.icon,
    required this.fab,
    required this.segmented,
    required this.toggle,
    required this.readerFloating,
  });

  factory TibebButtonsThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebButtonsThemeTokens(
      filled: TibebButtonStateStyles.createDefault(
        colors.primary,
        Colors.white,
        colors.disabled,
        radius.md,
      ),
      outlined: TibebButtonStateStyles(
        background: Colors.transparent,
        foreground: colors.primary,
        disabled: colors.disabled,
        pressed: colors.primary.withValues(alpha: 0.1),
        hovered: colors.primary.withValues(alpha: 0.05),
        focused: colors.primary,
        border: BorderSide(color: colors.primary),
        elevation: 0.0,
        radius: radius.md,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      text: TibebButtonStateStyles.createDefault(
        Colors.transparent,
        colors.primary,
        colors.disabled,
        radius.md,
      ),
      elevated: TibebButtonStateStyles.createDefault(
        colors.surfaceBright,
        colors.primary,
        colors.disabled,
        radius.md,
      ),
      icon: TibebButtonStateStyles.createDefault(
        Colors.transparent,
        colors.textPrimary,
        colors.disabled,
        radius.circle,
      ),
      fab: TibebButtonStateStyles.createDefault(
        colors.primary,
        Colors.white,
        colors.disabled,
        radius.circle,
      ),
      segmented: TibebButtonStateStyles.createDefault(
        colors.surfaceContainerLow,
        colors.textPrimary,
        colors.disabled,
        radius.md,
      ),
      toggle: TibebButtonStateStyles.createDefault(
        colors.surface,
        colors.primary,
        colors.disabled,
        radius.md,
      ),
      readerFloating: TibebButtonStateStyles.createDefault(
        colors.surfaceBright,
        colors.textPrimary,
        colors.disabled,
        radius.circle,
      ),
    );
  }

  factory TibebButtonsThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebButtonsThemeTokens(
      filled: TibebButtonStateStyles.createDefault(
        colors.primary,
        colors.background,
        colors.disabled,
        radius.md,
      ),
      outlined: TibebButtonStateStyles(
        background: Colors.transparent,
        foreground: colors.primary,
        disabled: colors.disabled,
        pressed: colors.primary.withValues(alpha: 0.1),
        hovered: colors.primary.withValues(alpha: 0.05),
        focused: colors.primary,
        border: BorderSide(color: colors.outline),
        elevation: 0.0,
        radius: radius.md,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      text: TibebButtonStateStyles.createDefault(
        Colors.transparent,
        colors.primary,
        colors.disabled,
        radius.md,
      ),
      elevated: TibebButtonStateStyles.createDefault(
        colors.surfaceBright,
        colors.primary,
        colors.disabled,
        radius.md,
      ),
      icon: TibebButtonStateStyles.createDefault(
        Colors.transparent,
        colors.textPrimary,
        colors.disabled,
        radius.circle,
      ),
      fab: TibebButtonStateStyles.createDefault(
        colors.primary,
        colors.background,
        colors.disabled,
        radius.circle,
      ),
      segmented: TibebButtonStateStyles.createDefault(
        colors.surfaceContainerLow,
        colors.textPrimary,
        colors.disabled,
        radius.md,
      ),
      toggle: TibebButtonStateStyles.createDefault(
        colors.surface,
        colors.primary,
        colors.disabled,
        radius.md,
      ),
      readerFloating: TibebButtonStateStyles.createDefault(
        colors.surfaceBright,
        colors.textPrimary,
        colors.disabled,
        radius.circle,
      ),
    );
  }
}
