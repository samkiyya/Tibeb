import 'package:flutter/material.dart';
import 'switch_tokens.dart';

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
