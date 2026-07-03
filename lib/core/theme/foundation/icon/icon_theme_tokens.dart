import 'package:flutter/material.dart';

// ==========================================
// 7. TibebIconThemeTokens
// ==========================================
class TibebIconThemeTokens {
  final double sizeXs;
  final double sizeSmall;
  final double sizeMedium;
  final double sizeLarge;
  final Color primary;
  final Color secondary;
  final Color disabled;
  final Color selected;
  final Color danger;
  final Color success;

  const TibebIconThemeTokens({
    this.sizeXs = 16.0,
    this.sizeSmall = 20.0,
    this.sizeMedium = 24.0,
    this.sizeLarge = 32.0,
    required this.primary,
    required this.secondary,
    required this.disabled,
    required this.selected,
    required this.danger,
    required this.success,
  });

  static TibebIconThemeTokens dark(
    Color primaryCol,
    Color secondaryCol,
    Color disabledCol,
    Color selectCol,
    Color errorCol,
    Color successCol,
  ) {
    return TibebIconThemeTokens(
      primary: primaryCol,
      secondary: secondaryCol,
      disabled: disabledCol,
      selected: selectCol,
      danger: errorCol,
      success: successCol,
    );
  }

  static TibebIconThemeTokens light(
    Color primaryCol,
    Color secondaryCol,
    Color disabledCol,
    Color selectCol,
    Color errorCol,
    Color successCol,
  ) {
    return TibebIconThemeTokens(
      primary: primaryCol,
      secondary: secondaryCol,
      disabled: disabledCol,
      selected: selectCol,
      danger: errorCol,
      success: successCol,
    );
  }

  TibebIconThemeTokens lerp(TibebIconThemeTokens? other, double t) {
    if (other == null) return this;
    return TibebIconThemeTokens(
      sizeXs: sizeXs,
      sizeSmall: sizeSmall,
      sizeMedium: sizeMedium,
      sizeLarge: sizeLarge,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      selected: Color.lerp(selected, other.selected, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}
