import 'package:flutter/material.dart';
import 'divider_tokens.dart';

class TibebDividerTheme {
  const TibebDividerTheme._();

  static DividerThemeData dark(TibebDividerThemeTokens tokens) {
    return _build(tokens);
  }

  static DividerThemeData light(TibebDividerThemeTokens tokens) {
    return _build(tokens);
  }

  static DividerThemeData _build(TibebDividerThemeTokens tokens) {
    return DividerThemeData(
      color: tokens.color,
      thickness: tokens.thickness,
      indent: tokens.indent,
    );
  }
}
