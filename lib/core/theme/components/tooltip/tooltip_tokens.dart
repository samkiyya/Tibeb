import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebTooltipThemeTokens {
  final Color background;
  final TextStyle foreground;
  final BorderRadius radius;
  final EdgeInsets padding;

  const TibebTooltipThemeTokens({
    required this.background,
    required this.foreground,
    required this.radius,
    required this.padding,
  });

  factory TibebTooltipThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTooltipThemeTokens(
      background: colors.inverseSurface,
      foreground: TextStyle(color: colors.surface),
      radius: radius.xs,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  factory TibebTooltipThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTooltipThemeTokens(
      background: colors.inverseSurface,
      foreground: TextStyle(color: colors.surface),
      radius: radius.xs,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
