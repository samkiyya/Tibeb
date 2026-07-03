import 'package:flutter/material.dart';
import 'checkbox_tokens.dart';

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
