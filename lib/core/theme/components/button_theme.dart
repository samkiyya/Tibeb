import 'package:flutter/material.dart';
import '../semantics/theme_extension.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';

class TibebButtonTheme {
  TibebButtonTheme._();

  static ElevatedButtonThemeData elevated(TibebThemeExtension ext) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ext.primary,
        foregroundColor: ext.textOnPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: TibebSpacing.base,
          vertical: TibebSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: TibebRadius.borderMd,
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}