import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

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
