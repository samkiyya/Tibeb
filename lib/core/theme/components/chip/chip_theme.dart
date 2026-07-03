import 'package:flutter/material.dart';
import 'chip_tokens.dart';

class TibebChipTheme {
  const TibebChipTheme._();

  static ChipThemeData dark(TibebChipThemeTokens tokens) {
    return _build(tokens);
  }

  static ChipThemeData light(TibebChipThemeTokens tokens) {
    return _build(tokens);
  }

  static ChipThemeData _build(TibebChipThemeTokens tokens) {
    return ChipThemeData(
      backgroundColor: tokens.assist.backgroundColor,
      selectedColor: tokens.selected,
      disabledColor: tokens.disabled,
      labelStyle: tokens.assist.labelStyle,
      shape: tokens.assist.shape,
    );
  }
}
