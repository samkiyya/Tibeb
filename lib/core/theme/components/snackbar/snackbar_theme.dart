import 'package:flutter/material.dart';
import 'snackbar_tokens.dart';

class TibebSnackBarTheme {
  const TibebSnackBarTheme._();

  static SnackBarThemeData dark(
    TibebSnackBarThemeTokens tokens,
    BorderRadius radius,
  ) {
    return _build(tokens, radius);
  }

  static SnackBarThemeData light(
    TibebSnackBarThemeTokens tokens,
    BorderRadius radius,
  ) {
    return _build(tokens, radius);
  }

  static SnackBarThemeData _build(
    TibebSnackBarThemeTokens tokens,
    BorderRadius radius,
  ) {
    return SnackBarThemeData(
      backgroundColor: tokens.background,
      contentTextStyle: tokens.text,
      actionTextColor: tokens.action.color,
      shape: RoundedRectangleBorder(borderRadius: radius),
      behavior: SnackBarBehavior.floating,
    );
  }
}
