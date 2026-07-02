import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/tokens/colors.dart';

class TibebColorScheme {
  static ColorScheme dark() {
    return ColorScheme(
      brightness: Brightness.dark,
      surface: TibebColors.surface,

      primary: TibebColors.wisdom,
      onPrimary: Colors.black,

      secondary: TibebColors.blue,
      onSecondary: Colors.white,

      error: TibebColors.error,
      onError: Colors.white,
      onSurface: TibebColors.paper,

      outline: Colors.white12,
    );
  }

  static ColorScheme light() {
    return ColorScheme.fromSeed(
      seedColor: TibebColors.wisdom,
      brightness: Brightness.light,
    );
  }
}