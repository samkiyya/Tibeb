import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebScrollbarThemeTokens {
  final Color thumb;
  final Color track;
  final double thickness;
  final Radius radius;

  const TibebScrollbarThemeTokens({
    required this.thumb,
    required this.track,
    required this.thickness,
    required this.radius,
  });

  factory TibebScrollbarThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebScrollbarThemeTokens(
      thumb: colors.textSecondary.withValues(alpha: 0.3),
      track: Colors.transparent,
      thickness: 8.0,
      radius: const Radius.circular(4.0),
    );
  }

  factory TibebScrollbarThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebScrollbarThemeTokens(
      thumb: colors.textSecondary.withValues(alpha: 0.3),
      track: Colors.transparent,
      thickness: 8.0,
      radius: const Radius.circular(4.0),
    );
  }
}
