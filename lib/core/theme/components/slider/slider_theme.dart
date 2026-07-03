import 'package:flutter/material.dart';
import 'slider_tokens.dart';

class TibebSliderTheme {
  const TibebSliderTheme._();

  static SliderThemeData dark(TibebSliderThemeTokens tokens) {
    return _build(tokens);
  }

  static SliderThemeData light(TibebSliderThemeTokens tokens) {
    return _build(tokens);
  }

  static SliderThemeData _build(TibebSliderThemeTokens tokens) {
    return SliderThemeData(
      activeTrackColor: tokens.active,
      inactiveTrackColor: tokens.inactive,
      thumbColor: tokens.thumb,
      activeTickMarkColor: tokens.tick,
      inactiveTickMarkColor: tokens.tick.withValues(alpha: 0.5),
      valueIndicatorTextStyle: tokens.label,
    );
  }
}
