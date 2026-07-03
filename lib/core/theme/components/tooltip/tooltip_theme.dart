import 'package:flutter/material.dart';
import 'tooltip_tokens.dart';

class TibebTooltipTheme {
  const TibebTooltipTheme._();

  static TooltipThemeData dark(TibebTooltipThemeTokens tokens) {
    return _build(tokens);
  }

  static TooltipThemeData light(TibebTooltipThemeTokens tokens) {
    return _build(tokens);
  }

  static TooltipThemeData _build(TibebTooltipThemeTokens tokens) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: tokens.radius,
      ),
      textStyle: tokens.foreground,
      padding: tokens.padding,
    );
  }
}
