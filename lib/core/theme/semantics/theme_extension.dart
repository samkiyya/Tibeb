import 'package:flutter/material.dart';

extension TibebThemeX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;

  Color get wisdom => colors.primary;
  Color get surface => colors.surface;
}