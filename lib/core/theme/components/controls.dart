import 'package:flutter/material.dart';
import '../semantics/design_tokens.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';

// ==========================================
// Button Theme & Token Models
// ==========================================
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

class TibebButtonTheme {
  const TibebButtonTheme._();

  static ElevatedButtonThemeData elevated(TibebButtonsThemeTokens tokens) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: tokens.filled.background,
        foregroundColor: tokens.filled.foreground,
        padding: const EdgeInsets.symmetric(
          horizontal: TibebSpacing.base,
          vertical: TibebSpacing.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: TibebRadius.borderMd),
        elevation: tokens.filled.elevation,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ==========================================
// Slider Theme
// ==========================================
class TibebSliderThemeTokens {
  final Color track;
  final Color thumb;
  final Color active;
  final Color inactive;
  final Color tick;
  final TextStyle label;

  const TibebSliderThemeTokens({
    required this.track,
    required this.thumb,
    required this.active,
    required this.inactive,
    required this.tick,
    required this.label,
  });

  factory TibebSliderThemeTokens.light(TibebColorSystem colors) {
    return TibebSliderThemeTokens(
      track: colors.outlineVariant,
      thumb: colors.primary,
      active: colors.primary,
      inactive: colors.outlineVariant,
      tick: colors.outline,
      label: const TextStyle(fontSize: 12),
    );
  }

  factory TibebSliderThemeTokens.dark(TibebColorSystem colors) {
    return TibebSliderThemeTokens(
      track: colors.outlineVariant,
      thumb: colors.primary,
      active: colors.primary,
      inactive: colors.outlineVariant,
      tick: colors.outline,
      label: const TextStyle(fontSize: 12),
    );
  }
}

class TibebSliderTheme {
  const TibebSliderTheme._();

  static SliderThemeData dark(TibebSliderThemeTokens tokens) {
    return _build(tokens);
  }

  static SliderThemeData light(TibebSliderThemeTokens tokens) {
    return _build(tokens);
  }

  static SliderThemeData _build(TibebSliderThemeTokens tokens) {
    return SliderThemeData(
      activeTrackColor: tokens.active,
      inactiveTrackColor: tokens.inactive,
      thumbColor: tokens.thumb,
      activeTickMarkColor: tokens.tick,
      inactiveTickMarkColor: tokens.tick.withValues(alpha: 0.5),
      valueIndicatorTextStyle: tokens.label,
    );
  }
}

// ==========================================
// Checkbox Theme
// ==========================================
class TibebCheckboxThemeTokens {
  final Color checked;
  final Color unchecked;
  final Color disabled;
  final Color error;

  const TibebCheckboxThemeTokens({
    required this.checked,
    required this.unchecked,
    required this.disabled,
    required this.error,
  });

  factory TibebCheckboxThemeTokens.light(TibebColorSystem colors) {
    return TibebCheckboxThemeTokens(
      checked: colors.primary,
      unchecked: colors.outline,
      disabled: colors.disabled,
      error: colors.error,
    );
  }

  factory TibebCheckboxThemeTokens.dark(TibebColorSystem colors) {
    return TibebCheckboxThemeTokens(
      checked: colors.primary,
      unchecked: colors.outline,
      disabled: colors.disabled,
      error: colors.error,
    );
  }
}

class TibebCheckboxTheme {
  const TibebCheckboxTheme._();

  static CheckboxThemeData dark(TibebCheckboxThemeTokens tokens) {
    return _build(tokens);
  }

  static CheckboxThemeData light(TibebCheckboxThemeTokens tokens) {
    return _build(tokens);
  }

  static CheckboxThemeData _build(TibebCheckboxThemeTokens tokens) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tokens.disabled;
        }
        if (states.contains(WidgetState.selected)) {
          return tokens.checked;
        }
        if (states.contains(WidgetState.error)) {
          return tokens.error;
        }
        return tokens.unchecked;
      }),
    );
  }
}

// ==========================================
// Radio Button Theme
// ==========================================
class TibebRadioButtonThemeTokens {
  final Color selected;
  final Color unselected;
  final Color disabled;

  const TibebRadioButtonThemeTokens({
    required this.selected,
    required this.unselected,
    required this.disabled,
  });

  factory TibebRadioButtonThemeTokens.light(TibebColorSystem colors) {
    return TibebRadioButtonThemeTokens(
      selected: colors.primary,
      unselected: colors.outline,
      disabled: colors.disabled,
    );
  }

  factory TibebRadioButtonThemeTokens.dark(TibebColorSystem colors) {
    return TibebRadioButtonThemeTokens(
      selected: colors.primary,
      unselected: colors.outline,
      disabled: colors.disabled,
    );
  }
}

class TibebRadioTheme {
  const TibebRadioTheme._();

  static RadioThemeData dark(TibebRadioButtonThemeTokens tokens) {
    return _build(tokens);
  }

  static RadioThemeData light(TibebRadioButtonThemeTokens tokens) {
    return _build(tokens);
  }

  static RadioThemeData _build(TibebRadioButtonThemeTokens tokens) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tokens.disabled;
        }
        if (states.contains(WidgetState.selected)) {
          return tokens.selected;
        }
        return tokens.unselected;
      }),
    );
  }
}

// ==========================================
// Switch Theme
// ==========================================
class TibebSwitchThemeTokens {
  final Color thumb;
  final Color track;
  final Color outline;
  final Color disabled;

  const TibebSwitchThemeTokens({
    required this.thumb,
    required this.track,
    required this.outline,
    required this.disabled,
  });

  factory TibebSwitchThemeTokens.light(TibebColorSystem colors) {
    return TibebSwitchThemeTokens(
      thumb: colors.surface,
      track: colors.outline,
      outline: colors.outlineVariant,
      disabled: colors.disabled,
    );
  }

  factory TibebSwitchThemeTokens.dark(TibebColorSystem colors) {
    return TibebSwitchThemeTokens(
      thumb: colors.surface,
      track: colors.outline,
      outline: colors.outlineVariant,
      disabled: colors.disabled,
    );
  }
}

class TibebSwitchTheme {
  const TibebSwitchTheme._();

  static SwitchThemeData dark(
    TibebSwitchThemeTokens tokens,
    Color primaryColor,
  ) {
    return _build(tokens, primaryColor);
  }

  static SwitchThemeData light(
    TibebSwitchThemeTokens tokens,
    Color primaryColor,
  ) {
    return _build(tokens, primaryColor);
  }

  static SwitchThemeData _build(
    TibebSwitchThemeTokens tokens,
    Color primaryColor,
  ) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tokens.disabled;
        }
        return tokens.thumb;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tokens.disabled.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withValues(alpha: 0.5);
        }
        return tokens.track;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return tokens.outline;
      }),
    );
  }
}
