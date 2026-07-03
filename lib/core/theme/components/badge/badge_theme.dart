import 'package:flutter/material.dart';
import 'badge_tokens.dart';

class TibebBadgeTheme {
  const TibebBadgeTheme._();

  static BadgeThemeData dark(TibebBadgeThemeTokens tokens) {
    return _build(tokens);
  }

  static BadgeThemeData light(TibebBadgeThemeTokens tokens) {
    return _build(tokens);
  }

  static BadgeThemeData _build(TibebBadgeThemeTokens tokens) {
    return BadgeThemeData(
      backgroundColor: tokens.background,
      textStyle: tokens.text,
    );
  }
}
