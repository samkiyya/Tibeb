import 'package:flutter/material.dart';
import 'list_tile_tokens.dart';

class TibebListTileTheme {
  const TibebListTileTheme._();

  static ListTileThemeData dark(TibebListTileThemeTokens tokens) {
    return _build(tokens);
  }

  static ListTileThemeData light(TibebListTileThemeTokens tokens) {
    return _build(tokens);
  }

  static ListTileThemeData _build(TibebListTileThemeTokens tokens) {
    return ListTileThemeData(
      titleTextStyle: tokens.title,
      subtitleTextStyle: tokens.subtitle,
      iconColor: tokens.leading.color,
      selectedColor: tokens.selected,
    );
  }
}
