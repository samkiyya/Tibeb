import 'package:flutter/material.dart';

// Helper class for Button states
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
}

// 24. TibebSliderTheme
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
}

// 25. TibebSwitchTheme
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
}

// 26. TibebCheckboxTheme
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
}

// 27. TibebRadioButtonTheme
class TibebRadioButtonThemeTokens {
  final Color selected;
  final Color unselected;
  final Color disabled;

  const TibebRadioButtonThemeTokens({
    required this.selected,
    required this.unselected,
    required this.disabled,
  });
}
