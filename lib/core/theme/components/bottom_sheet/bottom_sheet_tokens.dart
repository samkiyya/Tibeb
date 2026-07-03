import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebBottomSheetThemeTokens {
  final Color background;
  final Color dragHandle;
  final double elevation;
  final BorderRadius radius;
  final Color barrier;
  final EdgeInsets padding;

  const TibebBottomSheetThemeTokens({
    required this.background,
    required this.dragHandle,
    required this.elevation,
    required this.radius,
    required this.barrier,
    required this.padding,
  });

  factory TibebBottomSheetThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebBottomSheetThemeTokens(
      background: colors.surface,
      dragHandle: colors.outline,
      elevation: 16.0,
      radius: radius.xl,
      barrier: Colors.black54,
      padding: const EdgeInsets.all(24),
    );
  }

  factory TibebBottomSheetThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebBottomSheetThemeTokens(
      background: colors.surface,
      dragHandle: colors.outline,
      elevation: 16.0,
      radius: radius.xl,
      barrier: Colors.black54,
      padding: const EdgeInsets.all(24),
    );
  }
}
