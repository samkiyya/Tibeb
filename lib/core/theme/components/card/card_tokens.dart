import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebCardThemeTokens {
  final Color background;
  final BorderSide border;
  final double elevation;
  final BorderRadius radius;
  final List<BoxShadow> shadow;
  final EdgeInsets padding;

  const TibebCardThemeTokens({
    required this.background,
    required this.border,
    required this.elevation,
    required this.radius,
    required this.shadow,
    required this.padding,
  });

  factory TibebCardThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
    TibebElevationTokens elevation,
  ) {
    return TibebCardThemeTokens(
      background: colors.surfaceBright,
      border: BorderSide(color: colors.outlineVariant),
      elevation: 2.0,
      radius: radius.md,
      shadow: elevation.level1,
      padding: const EdgeInsets.all(16),
    );
  }

  factory TibebCardThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
    TibebElevationTokens elevation,
  ) {
    return TibebCardThemeTokens(
      background: colors.surfaceBright,
      border: BorderSide(color: colors.outlineVariant),
      elevation: 2.0,
      radius: radius.md,
      shadow: elevation.level1,
      padding: const EdgeInsets.all(16),
    );
  }
}
