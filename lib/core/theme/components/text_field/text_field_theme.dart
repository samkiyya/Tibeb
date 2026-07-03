import 'package:flutter/material.dart';
import 'text_field_tokens.dart';

class TibebInputDecorationTheme {
  const TibebInputDecorationTheme._();

  static InputDecorationTheme dark(TibebTextFieldThemeTokens tokens) {
    return _build(tokens);
  }

  static InputDecorationTheme light(TibebTextFieldThemeTokens tokens) {
    return _build(tokens);
  }

  static InputDecorationTheme _build(TibebTextFieldThemeTokens tokens) {
    return InputDecorationTheme(
      filled: true,
      fillColor: tokens.background,
      contentPadding: tokens.padding,
      border: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.border,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.border,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.focusedBorder,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.errorBorder,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.disabledBorder,
      ),
      labelStyle: tokens.label,
      hintStyle: tokens.hint,
      helperStyle: tokens.helper,
      counterStyle: tokens.counter,
    );
  }
}
