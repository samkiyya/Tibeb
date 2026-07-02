import 'package:flutter/material.dart';

import 'semantics/color_scheme.dart';
import 'tokens/typography.dart';
import 'components/button_theme.dart';
import 'components/card_theme.dart';
import 'components/progress_theme.dart';

class TibebTheme {
  static ThemeData dark() {
    final scheme = TibebColorScheme.dark();

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: TibebTypography.textTheme,

      scaffoldBackgroundColor: scheme.surface,

      elevatedButtonTheme: TibebButtonTheme.theme,
      cardTheme: TibebCardTheme.theme,
      progressIndicatorTheme: TibebProgressTheme.theme,
    );
  }

  static ThemeData light() {
    final scheme = TibebColorScheme.light();

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: TibebTypography.textTheme,
    );
  }
}

// MaterialApp(
//   theme: TibebTheme.light(),
//   darkTheme: TibebTheme.dark(),
//   themeMode: ThemeMode.system,
// )