import 'package:flutter/material.dart';
import '../semantics/theme_extension.dart';

class TibebProgressTheme {
  TibebProgressTheme._();

  static ProgressIndicatorThemeData theme(TibebThemeExtension ext) {
    return ProgressIndicatorThemeData(
      color: ext.primary,
      linearTrackColor: ext.surface,
      circularTrackColor: ext.surface,
    );
  }
}