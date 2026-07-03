import 'package:flutter/material.dart';

// ==========================================
// 6. TibebBorderTokens
// ==========================================
class TibebBorderTokens {
  final BorderSide thin;
  final BorderSide normal;
  final BorderSide thick;
  final BorderSide focused;
  final BorderSide selected;
  final BorderSide disabled;
  final BorderSide error;

  const TibebBorderTokens({
    required this.thin,
    required this.normal,
    required this.thick,
    required this.focused,
    required this.selected,
    required this.disabled,
    required this.error,
  });

  static TibebBorderTokens dark(
    Color primary,
    Color targetError,
    Color outlineCol,
    Color disabledCol,
  ) {
    return TibebBorderTokens(
      thin: BorderSide(color: outlineCol, width: 0.5),
      normal: BorderSide(color: outlineCol, width: 1.0),
      thick: BorderSide(color: outlineCol, width: 2.0),
      focused: BorderSide(color: primary, width: 2.0),
      selected: BorderSide(color: primary, width: 1.5),
      disabled: BorderSide(color: disabledCol, width: 1.0),
      error: BorderSide(color: targetError, width: 1.5),
    );
  }

  static TibebBorderTokens light(
    Color primary,
    Color targetError,
    Color outlineCol,
    Color disabledCol,
  ) {
    return TibebBorderTokens(
      thin: BorderSide(color: outlineCol, width: 0.5),
      normal: BorderSide(color: outlineCol, width: 1.0),
      thick: BorderSide(color: outlineCol, width: 2.0),
      focused: BorderSide(color: primary, width: 2.0),
      selected: BorderSide(color: primary, width: 1.5),
      disabled: BorderSide(color: disabledCol, width: 1.0),
      error: BorderSide(color: targetError, width: 1.5),
    );
  }

  TibebBorderTokens lerp(TibebBorderTokens? other, double t) {
    if (other == null) return this;
    return TibebBorderTokens(
      thin: BorderSide.lerp(thin, other.thin, t),
      normal: BorderSide.lerp(normal, other.normal, t),
      thick: BorderSide.lerp(thick, other.thick, t),
      focused: BorderSide.lerp(focused, other.focused, t),
      selected: BorderSide.lerp(selected, other.selected, t),
      disabled: BorderSide.lerp(disabled, other.disabled, t),
      error: BorderSide.lerp(error, other.error, t),
    );
  }
}
