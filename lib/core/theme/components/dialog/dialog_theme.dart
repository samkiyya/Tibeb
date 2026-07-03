import 'package:flutter/material.dart';
import 'dialog_tokens.dart';

class TibebDialogTheme {
  const TibebDialogTheme._();

  static DialogThemeData dark(TibebDialogThemeTokens tokens) {
    return _build(tokens);
  }

  static DialogThemeData light(TibebDialogThemeTokens tokens) {
    return _build(tokens);
  }

  static DialogThemeData _build(TibebDialogThemeTokens tokens) {
    return DialogThemeData(
      backgroundColor: tokens.background,
      titleTextStyle: tokens.title,
      contentTextStyle: tokens.content,
      shape: RoundedRectangleBorder(borderRadius: tokens.radius),
      elevation: tokens.elevation,
    );
  }
}
