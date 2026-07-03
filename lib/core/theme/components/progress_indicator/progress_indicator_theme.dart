import 'package:flutter/material.dart';
import 'progress_indicator_tokens.dart';

class TibebProgressTheme {
  const TibebProgressTheme._();

  static ProgressIndicatorThemeData dark(
    TibebProgressIndicatorsThemeTokens tokens,
    Color surfaceColor,
  ) {
    return _build(tokens, surfaceColor);
  }

  static ProgressIndicatorThemeData light(
    TibebProgressIndicatorsThemeTokens tokens,
    Color surfaceColor,
  ) {
    return _build(tokens, surfaceColor);
  }

  static ProgressIndicatorThemeData _build(
    TibebProgressIndicatorsThemeTokens tokens,
    Color surfaceColor,
  ) {
    return ProgressIndicatorThemeData(
      color: tokens.linear.color,
      linearTrackColor: surfaceColor,
      circularTrackColor: surfaceColor,
    );
  }
}
