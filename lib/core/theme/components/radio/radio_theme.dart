import 'package:flutter/material.dart';
import 'radio_tokens.dart';

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
