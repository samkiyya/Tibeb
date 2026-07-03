import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';
import 'button_tokens.dart';

class TibebButtonTheme {
  const TibebButtonTheme._();

  static ElevatedButtonThemeData elevated(TibebButtonsThemeTokens tokens) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: tokens.filled.background,
        foregroundColor: tokens.filled.foreground,
        padding: const EdgeInsets.symmetric(
          horizontal: TibebSpacing.base,
          vertical: TibebSpacing.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: TibebRadius.borderMd),
        elevation: tokens.filled.elevation,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
