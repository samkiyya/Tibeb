import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

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
